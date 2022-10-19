import 'package:mint/src/template_data_source.dart';
import 'package:mint/src/value_resolver.dart';

class FieldIsPrivate implements ValueResolver {
  final TemplateDataSource tds;

  FieldIsPrivate(this.tds);

  @override
  bool resolve() {
    assert(tds.fieldName != null);
    return tds.fieldName!.startsWith('_');
  }
}
