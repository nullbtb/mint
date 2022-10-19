import 'package:mint/src/template_data_source.dart';
import 'package:mint/src/value_resolver.dart';

class ModelMixinClassNameResolver implements ValueResolver {
  final TemplateDataSource tds;

  ModelMixinClassNameResolver(this.tds);

  @override
  String resolve() {
    return '_\$${tds.parentMint.name}';
  }
}
