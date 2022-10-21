// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuPerson _$PersonFromJson(Map<String, dynamic> json) => AuPerson(
      json['name'] as String,
      json['age'] as int,
    );

Map<String, dynamic> _$PersonToJson(AuPerson instance) => <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
    };

// **************************************************************************
// MintGenerator
// **************************************************************************

// Copy the _fromAu constructor into your base class.
// const Person._fromAu(this.age,this.name,);

abstract class __$Person extends AuMinted {
  int get age;
  String get name;
}

mixin _$Person implements __$Person {
  AuPerson asChild() {
    return this is! AuPerson
        ? AuPerson._fromAu(
            age,
            name,
          )
        : this as AuPerson;
  }

  Person copyJar(AuPersonJar jar) {
    return Person._fromAu(
      jar.age == null ? age : jar.age!,
      jar.name == null ? name : jar.name!,
    );
  }

  Person copyWith({
    AuValue<int>? age,
    AuValue<String>? name,
  }) {
    return Person._fromAu(
      age == null ? this.age : age.value,
      name == null ? this.name : name.value,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person &&
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

  Type get _effectiveRuntimeType => Person;

  Map<String, dynamic> toJson() => _$PersonToJson(asChild());
}

class AuPerson extends Person {
  const AuPerson(super.name, super.age);

  @override
  Type get _effectiveRuntimeType => Person;

  Person asModel() {
    return Person._fromAu(
      age,
      name,
    );
  }

  const AuPerson._fromAu(
    super.age,
    super.name,
  ) : super._fromAu();

  factory AuPerson.fromJson(Map<String, dynamic> json) =>
      _$PersonFromJson(json);
}

class AuPersonJar {
  final int? age;
  final String? name;

  const AuPersonJar({
    this.age,
    this.name,
  });
}
