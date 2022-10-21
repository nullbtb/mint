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

  const WithFoo._fromAu(
    this.age,
    this.name,
  );
}
