import 'grandparent.dart';

class Parent implements GrandParent {
  final String firstName;

  @override
  String get name {
    return firstName;
  }

  const Parent(this.firstName);
}
