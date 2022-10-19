import 'package:mint/src/template_data_source.dart';
import 'package:mint/src/value_resolver.dart';

class ModelChildClassNameResolver implements ValueResolver {
  final TemplateDataSource tds;

  ModelChildClassNameResolver(this.tds);

  @override
  String resolve() {
    return getChildClassName(tds.parentMint.name);
  }

  static String getChildClassName(String modelName) {
    return 'Au$modelName';
  }
}
