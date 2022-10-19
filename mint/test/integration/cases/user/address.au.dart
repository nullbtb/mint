// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuAddress _$AddressFromJson(Map<String, dynamic> json) => AuAddress._fromAu(
      json['city'] as String,
      json['street'] as String,
      json['zip'] as String,
    );

Map<String, dynamic> _$AddressToJson(AuAddress instance) => <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'zip': instance.zip,
    };

// **************************************************************************
// MintGenerator
// **************************************************************************

// Copy the _fromAu constructor into your base class.
// Address._fromAu(this.city,this.street,this.zip,);

abstract class __$Address extends AuMinted {
  String get city;
  String get street;
  String get zip;
}

mixin _$Address implements __$Address {
  AuAddress asChild() {
    return this is! AuAddress
        ? AuAddress._fromAu(
            city,
            street,
            zip,
          )
        : this as AuAddress;
  }

  Address copyJar(AuAddressJar jar) {
    return Address._fromAu(
      jar.city == null ? city : jar.city!,
      jar.street == null ? street : jar.street!,
      jar.zip == null ? zip : jar.zip!,
    );
  }

  Address copyWith({
    AuValue<String>? city,
    AuValue<String>? street,
    AuValue<String>? zip,
  }) {
    return Address._fromAu(
      city == null ? this.city : city.value,
      street == null ? this.street : street.value,
      zip == null ? this.zip : zip.value,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          _effectiveRuntimeType == other._effectiveRuntimeType &&
          equivalent(city, other.city) &&
          equivalent(street, other.street) &&
          equivalent(zip, other.zip);

  @override
  int get hashCode {
    return Object.hash(
      _effectiveRuntimeType,
      city,
      street,
      zip,
    );
  }

  Type get _effectiveRuntimeType => Address;

  Map<String, dynamic> toJson() => _$AddressToJson(asChild());
}

class AuAddress extends Address {
  @override
  Type get _effectiveRuntimeType => Address;

  Address asModel() {
    return Address._fromAu(
      city,
      street,
      zip,
    );
  }

  AuAddress._fromAu(
    super.city,
    super.street,
    super.zip,
  ) : super._fromAu();

  factory AuAddress.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

class AuAddressJar {
  final String? city;
  final String? street;
  final String? zip;

  const AuAddressJar({
    this.city,
    this.street,
    this.zip,
  });
}
