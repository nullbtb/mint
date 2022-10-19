import 'package:mint/src/template_data_source.dart';
import 'package:mint/src/value_resolver.dart';

class FieldNameCapitalizedResolver implements ValueResolver {
  final TemplateDataSource tds;

  FieldNameCapitalizedResolver(this.tds);

  @override
  String resolve() {
    assert(tds.fieldName != null,
        '${runtimeType.toString()} - fieldName cannot be null.');

    return tds.fieldName!.toCapitalized();
  }
}
