import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:au/au.dart';
import 'package:build/build.dart';
import 'package:mint/src/exception/unexpected_class_structure_exception.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

String sourceReadSubstring(
  String workingSource,
  String source,
  int start,
  int end,
) {
  final diff = (workingSource.length - source.length);
  final startOffset = start + diff;
  final endOffset = end + diff;

  return workingSource.substring(startOffset, endOffset);
}

String sourceReplaceSubstring(
  String workingSource,
  String source,
  int start,
  int end,
  String replacement,
) {
  final diff = (workingSource.length - source.length);
  final startOffset = start + diff;
  final endOffset = end + diff;
  return workingSource.replaceRange(startOffset, endOffset, replacement);
}

List<InterfaceType> getMintModelTypes(LibraryElement libraryElement) {
  final out = <InterfaceType>[];
  final classElements = getLibraryMintClassElements(libraryElement);

  for (var classElement in classElements) {
    out
      ..add(classElement.thisType)
      ..addAll(classElement.fields
          .where((f) =>
              !f.isConst &&
              !f.isSynthetic &&
              !f.isStatic &&
              isMintClassField(f))
          .map((e) => e.type as InterfaceType));
  }

  return out.toSet().toList();
}

Iterable<ClassElement> getLibraryMintClassElements(LibraryElement library) {
  return LibraryReader(library)
      .annotatedWith(const TypeChecker.fromRuntime(Au),
          throwOnUnresolved: false)
      .map((annotated) => annotated.element)
      .whereType<ClassElement>();
}

bool isMintClassField(FieldElement f) {
  if (f.type is! InterfaceType || f.type.element2 is! ClassElement) {
    return false;
  }

  final library = f.type.element2?.library;

  return library == null
      ? false
      : getLibraryMintClassElements(library).isNotEmpty;
}

ClassDeclaration getMintClassDeclaration(CompilationUnit ast) {
  return ast.declarations.firstWhere(
    (declaration) => (declaration is ClassDeclaration &&
        declaration.childEntities
            .where(
                (e) => e is Annotation && e.name.toString() == (Au).toString())
            .isNotEmpty),
    orElse: () => throw const UnexpectedClassStructureException(),
  ) as ClassDeclaration;
}

// SourceGen CombiningBuilder required utilities

/// Returns a valid buildExtensions map created from [optionsMap] or
/// returns [defaultExtensions] if no 'build_extensions' key exists.
///
/// Modifies [optionsMap] by removing the `build_extensions` key from it, if
/// present.
Map<String, List<String>> validatedBuildExtensionsFrom(
  Map<String, dynamic>? optionsMap,
  Map<String, List<String>> defaultExtensions,
) {
  final extensionsOption = optionsMap?.remove('build_extensions');
  if (extensionsOption == null) return defaultExtensions;

  if (extensionsOption is! Map) {
    throw ArgumentError(
      'Configured build_extensions should be a map from inputs to outputs.',
    );
  }

  final result = <String, List<String>>{};

  for (final entry in extensionsOption.entries) {
    final input = entry.key;
    if (input is! String || !input.endsWith('.dart')) {
      throw ArgumentError(
        'Invalid key in build_extensions option: `$input` '
        'should be a string ending with `.dart`',
      );
    }

    final output = entry.value;
    if (output is! String || !output.endsWith('.dart')) {
      throw ArgumentError(
        'Invalid output extension `$output`. It should be a '
        'string ending with `.dart`',
      );
    }

    result[input] = [output];
  }

  if (result.isEmpty) {
    throw ArgumentError('Configured build_extensions must not be empty.');
  }

  return result;
}

/// Returns a name suitable for `part of "..."` when pointing to [element].
String nameOfPartial(LibraryElement element, AssetId source, AssetId output) {
  if (element.name.isNotEmpty) {
    return element.name;
  }

  assert(source.package == output.package);
  final relativeSourceUri =
      p.url.relative(source.path, from: p.url.dirname(output.path));
  return '\'$relativeSourceUri\'';
}

/// Returns what 'part "..."' URL is needed to import [output] from [input].
///
/// For example, will return `test_lib.g.dart` for `test_lib.dart`.
String computePartUrl(AssetId input, AssetId output) => p.url.joinAll(
      p.url.split(p.url.relative(output.path, from: input.path)).skip(1),
    );

bool hasExpectedPartDirective(CompilationUnit unit, String part) =>
    unit.directives
        .whereType<PartDirective>()
        .any((e) => e.uri.stringValue == part);
