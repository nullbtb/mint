import 'package:build/build.dart';
import 'package:mint/build.dart';
import 'package:mint/src/utils.dart';
import 'package:source_gen/source_gen.dart';

const partIdRegExpLiteral = r'[A-Za-z_\d-]+';
const _outputExtensions = '.au.dart';
const _defaultExtensions = {
  '.dart': [_outputExtensions]
};

Builder mintBuilder(BuilderOptions options) => SharedPartBuilder([
      MintGenerator(
          options.config.containsKey('mixin_annotations')
              ? List<Map<String, String>>.from(
                  List<Map>.from(options.config['mixin_annotations'])
                      .map(Map<String, String>.from))
              : [],
          options.config.containsKey('child_annotations')
              ? List<Map<String, String>>.from(
                  List<Map>.from(options.config['child_annotations'])
                      .map(Map<String, String>.from))
              : [],
          options.config.containsKey('templates')
              ? Map<String, String>.from(options.config['templates'])
              : {})
    ], 'mint');

Builder mintCombiningBuilder([BuilderOptions options = BuilderOptions.empty]) {
  final optionsMap = Map<String, dynamic>.from(options.config);

  final includePartName = optionsMap.remove('include_part_name') as bool?;
  final ignoreForFile = Set<String>.from(
    optionsMap.remove('ignore_for_file') as List? ?? <String>[],
  );
  final rewireParts = Set<String>.from(
    optionsMap.remove('mint_rewire_parts') as List? ?? <String>[],
  );
  final buildExtensions =
      validatedBuildExtensionsFrom(optionsMap, _defaultExtensions);

  final builder = MintCombiningBuilder(
    rewireParts: rewireParts,
    includePartName: includePartName,
    ignoreForFile: ignoreForFile,
    buildExtensions: buildExtensions,
  );

  if (optionsMap.isNotEmpty) {
    log.warning('These options were ignored: `$optionsMap`.');
  }
  return builder;
}
