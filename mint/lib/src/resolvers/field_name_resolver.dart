import 'package:mint/src/template_data_source.dart';
import 'package:mint/src/value_resolver.dart';

class FieldNameResolver implements ValueResolver {
  final TemplateDataSource tds;

  FieldNameResolver(this.tds);

  @override
  String resolve() {
    assert(tds.fieldName != null,
        '${runtimeType.toString()} - fieldName cannot be null.');

    return tds.fieldName!;
  }
}
