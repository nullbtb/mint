import 'package:mint/src/resolvers/field_as_parameter_keyword.dart';
import 'package:mint/src/resolvers/field_is_last_resolver.dart';
import 'package:mint/src/resolvers/field_name_resolver.dart';
import 'package:mint/src/resolvers/model_class_name_resolver.dart';
import 'package:mint/src/template_data_source.dart';
import 'package:mint/src/template_parameter.dart';

class FromAuHintTemplateParameter implements TemplateParameter {
  final TemplateDataSource modelData;
  final List<TemplateDataSource> fieldsData;
  final bool hasConstConstructor;

  FromAuHintTemplateParameter({
    required this.modelData,
    required this.fieldsData,
    required this.hasConstConstructor,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'model_class_name': ModelClassNameResolver(modelData),
      'has_const_constructor': hasConstConstructor,
      'fields': fieldsData
          .map((fieldData) => {
                'field_name': FieldNameResolver(fieldData),
                'field_is_last': FieldIsLastResolver(fieldData),
                'field_as_parameter_keyword':
                    FieldAsParameterKeywordResolver(fieldData),
              })
          .toList()
    };
  }
}
