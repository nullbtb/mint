import 'package:mint/src/template_data_source.dart';
import 'package:mint/src/value_resolver.dart';

class ModelClassNameResolver implements ValueResolver {
  final TemplateDataSource tds;

  ModelClassNameResolver(this.tds);

  @override
  String resolve() {
    return tds.parentMint.name;
  }
}
