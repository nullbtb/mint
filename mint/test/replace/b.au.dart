// GENERATED CODE - DO NOT MODIFY BY HAND

part of replace;

// **************************************************************************
// MintGenerator
// **************************************************************************

// Copy the _fromAu constructor into your base class.
// B._fromAu(this.fieldWithA,this.myA,);

abstract class __$B extends AuMinted {
  String get fieldWithA;
  A get myA;
}

mixin _$B implements __$B {
  AuB asChild() {
    return this is! AuB
        ? AuB._fromAu(
            fieldWithA,
            myA,
          )
        : this as AuB;
  }

  B copyJar(AuBJar jar) {
    return B._fromAu(
      jar.fieldWithA == null ? fieldWithA : jar.fieldWithA!,
      jar.myA == null ? myA : jar.myA!,
    );
  }

  B copyWith({
    AuValue<String>? fieldWithA,
    AuValue<A>? myA,
  }) {
    return B._fromAu(
      fieldWithA == null ? this.fieldWithA : fieldWithA.value,
      myA == null ? this.myA : myA.value,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is B &&
          _effectiveRuntimeType == other._effectiveRuntimeType &&
          equivalent(fieldWithA, other.fieldWithA) &&
          equivalent(myA, other.myA);

  @override
  int get hashCode {
    return Object.hash(
      _effectiveRuntimeType,
      fieldWithA,
      myA,
    );
  }

  Type get _effectiveRuntimeType => B;
}

class AuB extends B {
  @override
  Type get _effectiveRuntimeType => B;

  B asModel() {
    return B._fromAu(
      fieldWithA,
      myA,
    );
  }

  AuB._fromAu(
    super.fieldWithA,
    super.myA,
  ) : super._fromAu();
}

class AuBJar {
  final String? fieldWithA;
  final A? myA;

  const AuBJar({
    this.fieldWithA,
    this.myA,
  });
}
