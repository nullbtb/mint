import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:mint/src/template_data_source.dart';
import 'package:mint/src/value_resolver.dart';

class FieldIsNullableResolver implements ValueResolver {
  final TemplateDataSource tds;

  FieldIsNullableResolver(this.tds);

  @override
  bool resolve() {
    assert(tds.fieldType != null);

    return tds.fieldType!.nullabilitySuffix != NullabilitySuffix.none;
  }
}
