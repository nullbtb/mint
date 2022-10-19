// GENERATED CODE - DO NOT MODIFY BY HAND

part of replace;

// **************************************************************************
// MintGenerator
// **************************************************************************

// Copy the _fromAu constructor into your base class.
// A._fromAu(this.fieldWithA,this.other,);

abstract class __$A extends AuMinted {
  String get fieldWithA;
  B get other;
}

mixin _$A implements __$A {
  AuA asChild() {
    return this is! AuA
        ? AuA._fromAu(
            fieldWithA,
            other,
          )
        : this as AuA;
  }

  A copyJar(AuAJar jar) {
    return A._fromAu(
      jar.fieldWithA == null ? fieldWithA : jar.fieldWithA!,
      jar.other == null ? other : jar.other!,
    );
  }

  A copyWith({
    AuValue<String>? fieldWithA,
    AuValue<B>? other,
  }) {
    return A._fromAu(
      fieldWithA == null ? this.fieldWithA : fieldWithA.value,
      other == null ? this.other : other.value,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is A &&
          _effectiveRuntimeType == other._effectiveRuntimeType &&
          equivalent(fieldWithA, other.fieldWithA) &&
          equivalent(other, other.other);

  @override
  int get hashCode {
    return Object.hash(
      _effectiveRuntimeType,
      fieldWithA,
      other,
    );
  }

  Type get _effectiveRuntimeType => A;
}

class AuA extends A {
  @override
  Type get _effectiveRuntimeType => A;

  A asModel() {
    return A._fromAu(
      fieldWithA,
      other,
    );
  }

  AuA._fromAu(
    super.fieldWithA,
    super.other,
  ) : super._fromAu();
}

class AuAJar {
  final String? fieldWithA;
  final B? other;

  const AuAJar({
    this.fieldWithA,
    this.other,
  });
}
