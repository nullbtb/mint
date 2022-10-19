import 'package:mint/src/template_data_source.dart';
import 'package:mint/src/value_resolver.dart';

class ModelAbstractClassNameResolver implements ValueResolver {
  final TemplateDataSource tds;

  ModelAbstractClassNameResolver(this.tds);

  @override
  String resolve() {
    return '__\$${tds.parentMint.name}';
  }
}
