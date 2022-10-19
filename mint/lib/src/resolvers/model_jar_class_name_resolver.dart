import 'package:mint/src/template_data_source.dart';
import 'package:mint/src/value_resolver.dart';

class ModelJarClassNameResolver implements ValueResolver {
  final TemplateDataSource tds;

  ModelJarClassNameResolver(this.tds);

  @override
  String resolve() {
    return 'Au${tds.parentMint.name}Jar';
  }
}
