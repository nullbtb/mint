import 'package:mint/src/template_data_source.dart';
import 'package:mint/src/value_resolver.dart';

class FieldTypeWithNullabilityResolver implements ValueResolver {
  final TemplateDataSource tds;

  FieldTypeWithNullabilityResolver(this.tds);

  @override
  String resolve() {
    assert(tds.fieldType != null);

    return tds.fieldType!.getDisplayString(withNullability: true);
  }
}
