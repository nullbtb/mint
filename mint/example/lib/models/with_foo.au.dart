// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'with_foo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuWithFoo _$WithFooFromJson(Map<String, dynamic> json) => AuWithFoo(
      json['name'] as String,
      json['age'] as int,
    );

Map<String, dynamic> _$WithFooToJson(AuWithFoo instance) => <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
    };

// **************************************************************************
// MintGenerator
// **************************************************************************

// Copy the _fromAu constructor into your base class.
// const WithFoo._fromAu(this.age,this.name,);

abstract class __$WithFoo extends AuMinted {
  int get age;
  String get name;
}

mixin _$WithFoo implements __$WithFoo {
  AuWithFoo asChild() {
    return this is! AuWithFoo
        ? AuWithFoo._fromAu(
            age,
            name,
          )
        : this as AuWithFoo;
  }

  WithFoo copyJar(AuWithFooJar jar) {
    return WithFoo._fromAu(
      jar.age == null ? age : jar.age!,
      jar.name == null ? name : jar.name!,
    );
  }

  WithFoo copyWith({
    AuValue<int>? age,
    AuValue<String>? name,
  }) {
    return WithFoo._fromAu(
      age == null ? this.age : age.value,
      name == null ? this.name : name.value,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WithFoo &&
          _effectiveRuntimeType == other._effectiveRuntimeType &&
          equivalent(age, other.age) &&
          equivalent(name, other.name);

  @override
  int get hashCode {
    return Object.hash(
      _effectiveRuntimeType,
      age,
      name,
    );
  }

  Type get _effectiveRuntimeType => WithFoo;

  Map<String, dynamic> toJson() => _$WithFooToJson(asChild());

  // Custom generated function from Foo annotation
  String foo() {
    return 'foo on WithFoo - age,name';
  }
}

class AuWithFoo extends WithFoo {
  const AuWithFoo(super.name, super.age);

  @override
  Type get _effectiveRuntimeType => WithFoo;

  WithFoo asModel() {
    return WithFoo._fromAu(
      age,
      name,
    );
  }

  const AuWithFoo._fromAu(
    super.age,
    super.name,
  ) : super._fromAu();

  factory AuWithFoo.fromJson(Map<String, dynamic> json) =>
      _$WithFooFromJson(json);
}

class AuWithFooJar {
  final int? age;
  final String? name;

  const AuWithFooJar({
    this.age,
    this.name,
  });
}
