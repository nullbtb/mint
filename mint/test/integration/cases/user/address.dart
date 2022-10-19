import 'package:au/au.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address.au.dart';

@Au()
@JsonSerializable(explicitToJson: true, constructor: '_fromAu')
// ignore: unused_element
class Address with _$Address {
  @override
  late String street;
  @override
  late String city;
  @override
  late String zip;

  Address._fromAu(
    this.city,
    this.street,
    this.zip,
  );
}
