import 'package:au/au.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:source_gen_test/source_gen_test.dart';

import 'address.dart';

part 'user.au.dart';

@ShouldGenerate(r'''
// Copy the _fromAu constructor into your base class.
// User._fromAu(this.address,super.name,this.occupation,);

abstract class __$User extends AuMinted {
  Address get address;
  String get name;
  String get occupation;
}

mixin _$User implements __$User {
  AuUser asChild() {
    return this is! AuUser
        ? AuUser._fromAu(
            address,
            name,
            occupation,
          )
        : this as AuUser;
  }

  User copyJar(AuUserJar jar) {
    return User._fromAu(
      jar.address == null ? address : jar.address!,
      jar.name == null ? name : jar.name!,
      jar.occupation == null ? occupation : jar.occupation!,
    );
  }

  User copyWith({
    AuValue<Address>? address,
    AuValue<String>? name,
    AuValue<String>? occupation,
  }) {
    return User._fromAu(
      address == null ? this.address : address.value,
      name == null ? this.name : name.value,
      occupation == null ? this.occupation : occupation.value,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          _effectiveRuntimeType == other._effectiveRuntimeType &&
          equivalent(address, other.address) &&
          equivalent(name, other.name) &&
          equivalent(occupation, other.occupation);

  @override
  int get hashCode {
    return Object.hash(
      _effectiveRuntimeType,
      address,
      name,
      occupation,
    );
  }

  Type get _effectiveRuntimeType => User;

  Map<String, dynamic> toJson() => _$UserToJson(asChild());
}

class AuUser extends User {
  AuUser(super.name, super.occupation, super.address);

  @override
  Type get _effectiveRuntimeType => User;

  User asModel() {
    return User._fromAu(
      address,
      name,
      occupation,
    );
  }

  AuUser._fromAu(
    super.address,
    super.name,
    super.occupation,
  ) : super._fromAu();

  factory AuUser.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

class AuUserJar {
  final Address? address;
  final String? name;
  final String? occupation;

  const AuUserJar({
    this.address,
    this.name,
    this.occupation,
  });
}
''')
@Au()
@JsonSerializable(explicitToJson: true)
// ignore: unused_element
class User extends UserParent with _$User {
  @override
  // ignore: overridden_fields
  late String name;
  @override
  late String occupation;
  @override
  late Address address;

  User(String name, String occupation, this.address) : super(name) {
    // ignore: prefer_initializing_formals
    this.name = name;
    // ignore: prefer_initializing_formals
    this.occupation = occupation;
  }

  User._fromAu(
    this.address,
    this.name,
    this.occupation,
  ) : super(name);
}

class UserParent {
  String name;
  UserParent(this.name);
}
