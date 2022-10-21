import 'package:au/au.dart';
import 'package:example/annotations/foo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'with_foo.au.dart';

@Au()
@Foo()
@JsonSerializable(explicitToJson: true)
class WithFoo with _$WithFoo {
  final String name;
  final int age;

  const WithFoo(this.name, this.age);

  // Copy this constructor from the generated code
  // The positional arguments represent the field names in alphabetical order
  const WithFoo._fromAu(
    this.age,
    this.name,
  );
}
