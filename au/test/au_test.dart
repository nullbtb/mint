import 'package:au/au.dart';
import 'package:test/test.dart';

void main() {
  group('Augmint', () {
    test('with options', () {
      final a = Au();
      expect(a.copyWith, isTrue);
      expect(a.equality, isTrue);
      expect(a.equality, isTrue);
      expect(a.annotations, isTrue);
    });
  });
}
