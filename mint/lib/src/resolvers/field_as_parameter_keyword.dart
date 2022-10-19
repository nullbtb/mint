import 'package:mint/src/template_data_source.dart';
import 'package:mint/src/value_resolver.dart';

class FieldAsParameterKeywordResolver implements ValueResolver {
  final TemplateDataSource tds;

  FieldAsParameterKeywordResolver(this.tds);

  @override
  String resolve() {
    assert(tds.parameterKeyword != null);

    return tds.parameterKeyword!;
  }
}
