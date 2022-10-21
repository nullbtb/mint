import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mint/src/resolvers/model_child_class_name_resolver.dart';
import 'package:mint/src/utils.dart';

class MintReplacer {
  final String source;
  final CompilationUnit libraryUnit;
  final LibraryElement libraryElement;
  final List<String> mintModelClassNames;

  MintReplacer(this.source, this.libraryUnit, this.libraryElement)
      : mintModelClassNames = getMintModelTypes(libraryElement)
            .map((e) => e.getDisplayString(withNullability: false))
            .toList();

  @override
  String toString() {
    return _replace();
  }

  String _replace() {
    var sourceUnit = parseString(
            content: source, featureSet: FeatureSet.latestLanguageVersion())
        .unit;

    return _getReplacedSource(node: sourceUnit, workingSource: source);
  }

  String _getReplacedSource(
      {required AstNode node, required String workingSource}) {
    for (var childNode in node.childEntities) {
      if (childNode is Token) {
        final value = childNode.lexeme;
        if (mintModelClassNames.contains(value)) {
          workingSource = sourceReplaceSubstring(
            workingSource,
            source,
            node.offset,
            node.end,
            ModelChildClassNameResolver.getChildClassName(value),
          );
        }
        continue;
      } else if (childNode is AstNode) {
        workingSource =
            _getReplacedSource(node: childNode, workingSource: workingSource);
      }
    }

    return workingSource;
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
}
