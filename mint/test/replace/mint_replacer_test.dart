@TestOn('vm')

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:mint/src/mint_replacer.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() async {
  final path = p.normalize(p.absolute('test/replace/a.dart'));

  final collection = AnalysisContextCollection(
    includedPaths: [path],
  );

  final analysisSession = collection.contextFor(path).currentSession;
  final libraryUnit =
      (analysisSession.getParsedUnit(path) as ParsedUnitResult).unit;
  final libraryElement = (await analysisSession
          .getLibraryByUri(Uri.file(path).toString()) as LibraryElementResult)
      .element;

  group('Replacement', () {
    test('performs a replacement of model with child', () async {
      final content = '''
// Ignore part of class name
class AB {
  // Ignore part of field name
  String? anotherAField;
}

// Ignore part of variable name
// Ignore exact string content
String ignoreA = 'A';

// Replace class type
A? foo;
B? bar;

// Replace param1, param2, param4
// Ignore param3 and function name
void testA(A param1, A? param2, AB param3, B param4) {
  // Ignore part of field name and content
  param1.fieldWithA = 'Another Value';
}

// Ignore part of class name
class _\$A {
  // Replace class field type
  // Ignore field name
  A myA;

  // Ignore part of class and field name.
  _\$A(B myB) : myA = myB.myA;
}
''';

      final replacer = MintReplacer(content, libraryUnit, libraryElement);

      expect(replacer.toString(), '''
// Ignore part of class name
class AB {
  // Ignore part of field name
  String? anotherAField;
}

// Ignore part of variable name
// Ignore exact string content
String ignoreA = 'A';

// Replace class type
AuA? foo;
AuB? bar;

// Replace param1, param2, param4
// Ignore param3 and function name
void testA(AuA param1, AuA? param2, AB param3, AuB param4) {
  // Ignore part of field name and content
  param1.fieldWithA = 'Another Value';
}

// Ignore part of class name
class _\$A {
  // Replace class field type
  // Ignore field name
  AuA myA;

  // Ignore part of class and field name.
  _\$A(AuB myB) : myA = myB.myA;
}
''');
    });
  });
}
