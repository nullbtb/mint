import 'package:au/au.dart';
import 'package:test/test.dart';

void main() {
  group('Equivalent', () {
    test('with Auminted', () {
      final a1 = AuA(1);
      final a2 = AuA(1);
      expect(equivalent(a1, a2), true);
      final a3 = AuA(2);
      expect(equivalent(a1, a3), false);
    });
    test('with iterable', () {
      final l1 = <int>[1, 2, 3];
      final l2 = <int>[1, 2, 3];
      expect(equivalent(l1, l2), true);

      final l3 = <AuA>[AuA(1), AuA(2)];
      final l4 = <AuA>[AuA(1), AuA(2)];
      expect(equivalent(l3, l4), true);

      final l5 = <AuA>[AuA(1), AuA(2)];
      final l6 = <AuA>[AuA(1), AuA(3)];
      expect(equivalent(l5, l6), false);

      final l7 = <AuA>[AuA(1)];
      expect(equivalent(l6, l7), false);
    });

    test('with Map', () {
      final m1 = {'a': 'foo', 'b': 'bar'};
      final m2 = {'a': 'foo', 'b': 'bar'};
      expect(equivalent(m1, m2), true);

      final m3 = {'a': 'foo', 'b': 'baz'};
      expect(equivalent(m1, m3), false);

      final m4 = {'a': 'foo', 'z': 'baz'};
      expect(equivalent(m3, m4), false);

      final m5 = {
        'a': [AuA(1)]
      };
      final m6 = {
        'a': [AuA(1)]
      };
      expect(equivalent(m5, m6), true);

      final m7 = {
        'a': [AuA(2)]
      };
      expect(equivalent(m6, m7), false);
    });

    test('with different runtimes', () {
      final a1 = AuA(1);
      final a2 = B(1);
      expect(equivalent(a1, a2), false);
    });

    test('with scalar values', () {
      final a1 = '1';
      final a2 = 1;
      expect(equivalent(a1, a2), false);

      final a3 = 1;
      expect(equivalent(a2, a3), true);
    });
  });
}

class AuA extends AuMinted {
  final int count;
  AuA(this.count);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuA &&
          _effectiveRuntimeType == other._effectiveRuntimeType &&
          equivalent(count, other.count);

  @override
  int get hashCode {
    return Object.hash(
      _effectiveRuntimeType,
      count,
    );
  }

  Type get _effectiveRuntimeType => AuA;
}

class B {
  final int count;
  B(this.count);
}
