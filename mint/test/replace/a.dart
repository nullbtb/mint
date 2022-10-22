library replace;

import 'package:au/au.dart';
// ignore: unused_import
import '../integration/cases/person/person.dart';
import 'b.dart';

part 'a.au.dart';

@Au()
class A with _$A {
  @override
  String fieldWithA = 'A!';
  @override
  B other;

  A._fromAu(this.fieldWithA, this.other);
}
