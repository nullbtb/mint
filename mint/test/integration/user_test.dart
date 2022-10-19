import 'package:au/au.dart';
import 'package:mint/src/mint_generator.dart';
import 'package:source_gen_test/source_gen_test.dart'
    show
        initializeLibraryReaderForDirectory,
        initializeBuildLogTracking,
        testAnnotatedElements;
import 'package:test/test.dart';

import 'cases/user/address.dart';
import 'cases/user/user.dart';

Future<void> main() async {
  final reader = await initializeLibraryReaderForDirectory(
    'test/integration/cases/user',
    'user.dart',
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
      }));

  group('Generated User', () {
    final a = User(
        'John',
        'Astronaut',
        AuAddress.fromJson({
          'street': '123 main st',
          'zip': '33165',
          'city': 'Miami',
        }));

    test('with copyWith', () {
      final b = a.copyWith(
          address: AuValue<Address>(a.address.copyWith(
        city: const AuValue<String>('Vancouver'),
      )));

      expect(a.address != b.address, true);
      expect(a.address.street, b.address.street);
      expect(a.address.city, 'Miami');
      expect(b.address.city, 'Vancouver');
    });

    test('with JsonSerializable support', () {
      expect(a == AuUser.fromJson(a.toJson()), true);
    });
  });
}
