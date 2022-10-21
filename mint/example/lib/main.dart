import 'package:au/au.dart';
import 'package:example/models/person.dart';

void main() {
  final p1 = const Person('John', 35);

  final p2 = p1.copyWith(
    age: const AuValue<int>(25),
  );

  assert(p1 != p2);

  // or just copy the jar
  final p3 = p1.copyJar(const AuPersonJar(
    age: 21,
    name: 'Joe',
  ));

  final p4 = AuPerson.fromJson(p3.toJson());

  assert(p3 == p4);

  final p5 = const AuPerson('John', 35);
  assert(p5 == p1);
}
