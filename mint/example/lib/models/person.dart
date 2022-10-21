// Import the au annotation
import 'package:au/au.dart';
// Import whatever other libraries you may need
import 'package:json_annotation/json_annotation.dart';

// Include the generated code.  Notice the extension is .au.dart and not .g.dart.
part 'person.au.dart';

// Annotate the class with Au
@Au()
// Add whatever other annotations you may need.
@JsonSerializable(explicitToJson: true)
// Include the _$Person mixin (Pattern is _$CLASS)
class Person with _$Person {
  final String name;
  final int age;

  const Person(this.name, this.age);

  // Copy this constructor from the generated code
  // The positional arguments represent the field names in alphabetical order
  const Person._fromAu(
    this.age,
    this.name,
  );
}
