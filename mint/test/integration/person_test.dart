import 'package:au/au.dart';
import 'package:mint/src/mint_generator.dart';
import 'package:source_gen_test/source_gen_test.dart'
    show
        initializeLibraryReaderForDirectory,
        initializeBuildLogTracking,
        testAnnotatedElements;
import 'package:test/test.dart';

import 'cases/person/person.dart';

Future<void> main() async {
  final reader = await initializeLibraryReaderForDirectory(
    'test/integration/cases/person',
    'person.dart',
  );

  initializeBuildLogTracking();

  testAnnotatedElements<Au>(
    reader,
    const MintGenerator([
      {
        'annotation': 'JsonSerializable',
        'template': 'to_json',
      }
    ], [
      {
        'annotation': 'JsonSerializable',
        'template': 'from_json',
      }
    ], {
      'abstract': 'package:mint/src/templates/abstract.mustache',
      'child': 'package:mint/src/templates/child.mustache',
      'from_au_hint': 'package:mint/src/templates/from_au_hint.mustache',
      'from_json': 'package:mint/src/templates/from_json.mustache',
      'jar': 'package:mint/src/templates/jar.mustache',
      'mixin': 'package:mint/src/templates/mixin.mustache',
      'to_json': 'package:mint/src/templates/to_json.mustache',
    }),
  );

  group('Generated Person', () {
    final father = const Person('John', 'Brown', Sex.male, age: 99);
    final mom = const Person('Abi', 'Brown', Sex.female, age: 99);
    final a = Person(
      'James',
      'Brown',
      Sex.male,
      age: 99,
      honorific: 'Mr',
      suffix: '.',
      parents: [
        father,
        mom,
      ],
    );

    test('with copyWith', () {
      final b = a.copyWith(
        firstName: const AuValue<String>('Jane'),
        age: const AuValue(72),
      );

      expect(b.firstName, 'Jane');
      expect(b.age, 72);
      expect(a != b, true);

      final c = b.copyWith(
        firstName: const AuValue<String>('James'),
        age: const AuValue(99),
      );

      expect(c.firstName, 'James');
      expect(c.age, 99);
      expect(a != b, true);
      expect(a == c, true);
    });

    test('with copyJar', () {
      final b = a.copyJar(const AuPersonJar(
        firstName: 'Jane',
        age: 72,
      ));

      expect(b.firstName, 'Jane');
      expect(b.age, 72);
      expect(a != b, true);

      final c = b.copyJar(const AuPersonJar(
        firstName: 'James',
        age: 99,
      ));

      expect(c.firstName, 'James');
      expect(c.age, 99);
      expect(a != b, true);
      expect(a == c, true);
    });

    test('checks for equality', () {
      expect(a == a.asChild(), true);

      final b = Person(
        'James',
        'Brown',
        Sex.male,
        age: 99,
        honorific: 'Mr',
        suffix: '.',
        parents: [
          father,
          mom,
        ],
      );

      expect(a == b, true);

      final c = AuPerson(
        'James',
        'Brown',
        Sex.male,
        age: 99,
        honorific: 'Mr',
        suffix: '.',
        parents: [
          father,
          mom,
        ],
      );
      expect(a == c && c == b, true);

      final d = b.copyJar(const AuPersonJar(lastName: 'Doe'));

      expect(d != a && d != b && d != c, true);

      final e = AuPerson(
        'James',
        'Brown',
        Sex.male,
        age: 99,
        honorific: 'Mr',
        suffix: '.',
        parents: [
          father.asChild(),
          mom,
        ],
      );

      expect(a == e, true);

      final f = const Person('John', 'Brown', Sex.male, age: 98);

      final g = Person(
        'James',
        'Brown',
        Sex.male,
        age: 99,
        honorific: 'Mr',
        suffix: '.',
        parents: [
          f,
          mom,
        ],
      );

      expect(a != g, true);
    });

    test('with JsonSerializable support', () {
      final json = {
        'firstName': 'James',
        'lastName': 'Brown',
        'age': 99,
        'sex': 'male',
        'honorific': 'Mr.',
        'parents': [
          {
            'firstName': 'John',
            'lastName': 'Brown',
            'age': 99,
            'sex': 'male',
            'honorific': null,
            'parents': []
          },
          {
            'firstName': 'Abi',
            'lastName': 'Brown',
            'age': 99,
            'sex': 'female',
            'honorific': null,
            'parents': []
          }
        ]
      };

      expect(a.toJson(), json);

      final b = AuPerson.fromJson(json);

      expect(a == b, true);
    });
  });
}
