import 'package:au/au.dart';
import 'package:test/test.dart';

void main() {
  group('Augmint', () {
    test('with value', () {
      final a = AuValue<int>(5);
      expect(a.value, 5);
    });

    test('with nullability', () {
      final b = AuValue<int?>(null);
      expect(b.value == null, true);
    });
  });
}
