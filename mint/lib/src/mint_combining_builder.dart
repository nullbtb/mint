// This is a modified version of the CombiningBuilder from SourceGen.  It is
// necessary for configuration free hookup to minted classes.
// https://github.com/dart-lang/source_gen
// Original Copyright: Copyright (c) 2018, the Dart project authors.
import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:mint/src/mint_replacer.dart';
import 'package:mint/src/utils.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

const _outputExtensions = '.au.dart';
const _partFiles = '.g.part';
const _defaultExtensions = {
  '.dart': [_outputExtensions]
};

const partIdRegExpLiteral = r'[A-Za-z_\d-]+';

class MintCombiningBuilder implements Builder {
  final Set<String> rewireParts;
  final bool _includePartName;
  final Set<String> _ignoreForFile;

  @override
  final Map<String, List<String>> buildExtensions;

  const MintCombiningBuilder({
    this.rewireParts = const <String>{},
    bool? includePartName,
    Set<String>? ignoreForFile,
    this.buildExtensions = _defaultExtensions,
  })  : _includePartName = includePartName ?? false,
        _ignoreForFile = ignoreForFile ?? const <String>{};

  @override
  Future<void> build(BuildStep buildStep) async {
    // Pattern used for `findAssets`, which must be glob-compatible
    final pattern = buildStep.inputId.changeExtension('.*$_partFiles').path;

    final inputBaseName =
        p.basenameWithoutExtension(buildStep.inputId.pathSegments.last);

    // Pattern used to ensure items are only considered if they match
    // [file name without extension].[valid part id].[part file extension]
    final restrictedPattern = RegExp(
      [
        '^', // start of string
        RegExp.escape(inputBaseName), // file name, without extension
        r'\.', // `.` character
        partIdRegExpLiteral, // A valid part ID
        RegExp.escape(_partFiles), // the ending part extension
        '\$', // end of string
      ].join(),
    );

    final assetIds = await buildStep
        .findAssets(Glob(pattern))
        .where((id) => restrictedPattern.hasMatch(id.pathSegments.last))
        .toList()
      ..sort();

    if (assetIds.isEmpty) return;

    final inputLibrary = await buildStep.inputLibrary;
    final libraryUnit =
        await buildStep.resolver.compilationUnitFor(buildStep.inputId);

    final assets = await Stream.fromIterable(assetIds)
        .asyncMap((id) async {
          var content = (await buildStep.readAsString(id)).trim();
          if (_includePartName) {
            content = '// Part: ${id.pathSegments.last}\n$content';
          }

          return rewireParts
                  .where((suffix) => id.path.endsWith(suffix))
                  .isNotEmpty
              ? MintReplacer(content, libraryUnit, inputLibrary).toString()
              : content;
        })
        .where((s) => s.isNotEmpty)
        .join('\n\n');
    if (assets.isEmpty) return;

    final outputId = buildStep.allowedOutputs.single;
    final partOf = nameOfPartial(inputLibrary, buildStep.inputId, outputId);

    // Ensure that the input has a correct `part` statement.

    final part = computePartUrl(buildStep.inputId, outputId);
    if (!hasExpectedPartDirective(libraryUnit, part)) {
      log.warning(
        '$part must be included as a part directive in '
        'the input library with:\n    part \'$part\';',
      );
      return;
    }

    final ignoreForFile = _ignoreForFile.isEmpty
        ? ''
        : '\n// ignore_for_file: ${_ignoreForFile.join(', ')}\n';
    final output = '''
$defaultFileHeader
${languageOverrideForLibrary(inputLibrary)}$ignoreForFile
part of $partOf;

$assets
''';
    await buildStep.writeAsString(outputId, output);
  }
}

String languageOverrideForLibrary(LibraryElement library) {
  final override = library.languageVersion.override;
  return override == null
      ? ''
      : '// @dart=${override.major}.${override.minor}\n';
}
