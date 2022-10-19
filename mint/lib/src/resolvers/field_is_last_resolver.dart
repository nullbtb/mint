import 'package:mint/src/template_data_source.dart';
import 'package:mint/src/value_resolver.dart';

class FieldIsLastResolver implements ValueResolver {
  final TemplateDataSource tds;

  FieldIsLastResolver(this.tds);

  @override
  bool resolve() {
    return tds.isLast;
  }
}
