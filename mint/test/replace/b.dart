library replace;

import 'package:au/au.dart';

import 'a.dart';

part 'b.au.dart';

@Au()
class B with _$B {
  @override
  String fieldWithA = 'A!';
  @override
  A myA;

  B._fromAu(this.fieldWithA, this.myA);
}
