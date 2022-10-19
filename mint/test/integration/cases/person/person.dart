// ignore_for_file: annotate_overrides

import 'package:au/au.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:source_gen_test/source_gen_test.dart';
import 'parent.dart';

part 'person.au.dart';

@ShouldGenerate(r'''
// Copy the _fromAu constructor into your base class.
// const Person._fromAu(this._private,this.age,super.firstName,this.honorific,this.lastName,this.parents,this.sex,);

abstract class __$Person extends AuMinted {
  int get _private;
  int get age;
  String get firstName;
  String? get honorific;
  String get lastName;
  List<Person> get parents;
  Sex get sex;
}

mixin _$Person implements __$Person {
  AuPerson asChild() {
    return this is! AuPerson
        ? AuPerson._fromAu(
            _private,
            age,
            firstName,
            honorific,
            lastName,
            parents,
            sex,
          )
        : this as AuPerson;
  }

  Person copyJar(AuPersonJar jar) {
    return Person._fromAu(
      _private,
      jar.age == null ? age : jar.age!,
      jar.firstName == null ? firstName : jar.firstName!,
      jar.honorific == null ? honorific : jar.honorific!,
      jar.lastName == null ? lastName : jar.lastName!,
      jar.parents == null ? parents : jar.parents!,
      jar.sex == null ? sex : jar.sex!,
    );
  }

  Person copyWith({
    AuValue<int>? age,
    AuValue<String>? firstName,
    AuValue<String?>? honorific,
    AuValue<String>? lastName,
    AuValue<List<Person>>? parents,
    AuValue<Sex>? sex,
  }) {
    return Person._fromAu(
      _private,
      age == null ? this.age : age.value,
      firstName == null ? this.firstName : firstName.value,
      honorific == null ? this.honorific : honorific.value,
      lastName == null ? this.lastName : lastName.value,
      parents == null ? this.parents : parents.value,
      sex == null ? this.sex : sex.value,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person &&
          _effectiveRuntimeType == other._effectiveRuntimeType &&
          equivalent(_private, other._private) &&
          equivalent(age, other.age) &&
          equivalent(firstName, other.firstName) &&
          equivalent(honorific, other.honorific) &&
          equivalent(lastName, other.lastName) &&
          equivalent(parents, other.parents) &&
          equivalent(sex, other.sex);

  @override
  int get hashCode {
    return Object.hash(
      _effectiveRuntimeType,
      _private,
      age,
      firstName,
      honorific,
      lastName,
      parents,
      sex,
    );
  }

  Type get _effectiveRuntimeType => Person;

  Map<String, dynamic> toJson() => _$PersonToJson(asChild());
}

class AuPerson extends Person {
  const AuPerson(super.firstName, super.lastName, super.sex,
      {required super.age,
      super.parents = const [],
      super.honorific,
      super.suffix});

  factory AuPerson.fromFullName(String fullName, Sex sex, int age) {
    return Person.fromFullName(
      fullName,
      sex,
      age,
    ).asChild();
  }

  @override
  Type get _effectiveRuntimeType => Person;

  Person asModel() {
    return Person._fromAu(
      _private,
      age,
      firstName,
      honorific,
      lastName,
      parents,
      sex,
    );
  }

  const AuPerson._fromAu(
    super._private,
    super.age,
    super.firstName,
    super.honorific,
    super.lastName,
    super.parents,
    super.sex,
  ) : super._fromAu();

  factory AuPerson.fromJson(Map<String, dynamic> json) =>
      _$PersonFromJson(json);
}

class AuPersonJar {
  final int? age;
  final String? firstName;
  final String? honorific;
  final String? lastName;
  final List<Person>? parents;
  final Sex? sex;

  const AuPersonJar({
    this.age,
    this.firstName,
    this.honorific,
    this.lastName,
    this.parents,
    this.sex,
  });
}
''')
@Au()
@JsonSerializable(explicitToJson: true)
class Person extends Parent with _$Person {
  static const String hi = 'hi';

  final String lastName;
  final int age;
  final Sex sex;
  final String? honorific;
  final List<Person> parents;
  final int _private;

  const Person(super.firstName, this.lastName, this.sex,
      {required this.age,
      this.parents = const [],
      String? honorific,
      String? suffix})
      : honorific = honorific == null ? null : honorific + (suffix ?? ''),
        _private = age + 5;

  factory Person.fromFullName(String fullName, Sex sex, int age) {
    final parts = fullName.split(' ');
    assert(parts.length == 2);
    return Person(parts[0], parts[1], sex, age: age);
  }

  const Person._fromAu(
    this._private,
    this.age,
    super.firstName,
    this.honorific,
    this.lastName,
    this.parents,
    this.sex,
  );

  String get fullName {
    return '$firstName $lastName';
  }

  String sayHi() {
    return '$hi, $fullName';
  }
}

enum Sex {
  // ignore: unused_field
  male,
  // ignore: unused_field
  female,
  // ignore: unused_field
  other,
}
