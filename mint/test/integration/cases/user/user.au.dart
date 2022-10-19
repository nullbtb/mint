// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuUser _$UserFromJson(Map<String, dynamic> json) => AuUser(
      json['name'] as String,
      json['occupation'] as String,
      AuAddress.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(AuUser instance) => <String, dynamic>{
      'name': instance.name,
      'occupation': instance.occupation,
      'address': instance.address.toJson(),
    };

// **************************************************************************
// MintGenerator
// **************************************************************************

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
