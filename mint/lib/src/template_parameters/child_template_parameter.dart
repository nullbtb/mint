import 'package:mint/src/resolvers/field_as_parameter_keyword.dart';
import 'package:mint/src/resolvers/field_is_last_resolver.dart';
import 'package:mint/src/resolvers/field_is_nullable_resolver.dart';
import 'package:mint/src/resolvers/field_is_private.dart';
import 'package:mint/src/resolvers/field_name_capitalized_resolver.dart';
import 'package:mint/src/resolvers/field_name_resolver.dart';
import 'package:mint/src/resolvers/field_type_resolver.dart';
import 'package:mint/src/resolvers/field_type_with_nullability_resolver.dart';
import 'package:mint/src/resolvers/model_abstract_class_name_resolver.dart';
import 'package:mint/src/resolvers/model_child_class_name_resolver.dart';
import 'package:mint/src/resolvers/model_class_name_resolver.dart';
import 'package:mint/src/resolvers/model_jar_class_name_resolver.dart';
import 'package:mint/src/resolvers/model_mixin_class_name_resolver.dart';
import 'package:mint/src/template_data_source.dart';
import 'package:mint/src/template_parameter.dart';

class ChildTemplateParameter implements TemplateParameter {
  final TemplateDataSource modelData;
  final List<TemplateDataSource> fieldsData;
  final String annotations;
  final String constructors;
  final bool hasConstConstructor;

  ChildTemplateParameter({
    required this.modelData,
    required this.fieldsData,
    required this.annotations,
    required this.constructors,
    required this.hasConstConstructor,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'model_class_name': ModelClassNameResolver(modelData),
      'model_abstract_class_name': ModelAbstractClassNameResolver(modelData),
      'model_child_class_name': ModelChildClassNameResolver(modelData),
      'model_jar_class_name': ModelJarClassNameResolver(modelData),
      'model_mixin_class_name': ModelMixinClassNameResolver(modelData),
      'annotations': annotations,
      'constructors': constructors,
      'has_const_constructor': hasConstConstructor,
      'fields': fieldsData
          .map((fieldData) => {
                'field_name': FieldNameResolver(fieldData),
                'field_name_capitalized':
                    FieldNameCapitalizedResolver(fieldData),
                'field_type': FieldTypeResolver(fieldData),
                'field_type_with_nullability':
                    FieldTypeWithNullabilityResolver(fieldData),
                'field_as_parameter_keyword':
                    FieldAsParameterKeywordResolver(fieldData),
                'field_is_nullable': FieldIsNullableResolver(fieldData),
                'field_is_private': FieldIsPrivate(fieldData),
                'field_is_last': FieldIsLastResolver(fieldData),
              })
          .toList()
    };
  }
}
