import 'package:collection/collection.dart';
import 'package:au/src/au_minted.dart';

bool equivalent(dynamic a, dynamic b) {
  if (a is AuMinted && b is AuMinted) {
    if (a != b) return false;
  } else if (a is Iterable || a is Map) {
    if (!DeepCollectionEquality().equals(a, b)) return false;
  } else if (a?.runtimeType != b?.runtimeType) {
    return false;
  } else if (a != b) {
    return false;
  }

  return true;
}
