import 'package:mint/src/resolvers/field_is_last_resolver.dart';
import 'package:mint/src/resolvers/field_is_private.dart';
import 'package:mint/src/resolvers/field_name_resolver.dart';
import 'package:mint/src/resolvers/field_type_resolver.dart';
import 'package:mint/src/resolvers/field_type_with_nullability_resolver.dart';
import 'package:mint/src/resolvers/model_child_class_name_resolver.dart';
import 'package:mint/src/resolvers/model_class_name_resolver.dart';
import 'package:mint/src/resolvers/model_jar_class_name_resolver.dart';
import 'package:mint/src/template_data_source.dart';
import 'package:mint/src/template_parameter.dart';

class JarTemplateParameter implements TemplateParameter {
  final TemplateDataSource modelData;
  final List<TemplateDataSource> fieldsData;

  JarTemplateParameter({required this.modelData, required this.fieldsData});

  @override
  Map<String, dynamic> toMap() {
    return {
      'model_class_name': ModelClassNameResolver(modelData),
      'model_child_class_name': ModelChildClassNameResolver(modelData),
      'model_jar_class_name': ModelJarClassNameResolver(modelData),
      'fields': fieldsData
          .map((fieldData) => {
                'field_name': FieldNameResolver(fieldData),
                'field_type': FieldTypeResolver(fieldData),
                'field_type_with_nullability':
                    FieldTypeWithNullabilityResolver(fieldData),
                'field_is_private': FieldIsPrivate(fieldData),
                'field_is_last': FieldIsLastResolver(fieldData),
              })
          .toList()
    };
  }
}
