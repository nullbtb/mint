extension StringCaseExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}

abstract class ValueResolver {
  dynamic resolve();
}
