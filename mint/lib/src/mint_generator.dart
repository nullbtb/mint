import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:au/au.dart';
import 'package:build/build.dart';
import 'package:mint/src/resolvers/model_child_class_name_resolver.dart';
import 'package:mint/src/template_data_source.dart';
import 'package:mint/src/template_parameter.dart';
import 'package:mint/src/template_parameters/child_template_parameter.dart';
import 'package:mint/src/template_parameters/default_template_parameter.dart';
import 'package:mint/src/template_parameters/from_au_hint_template_parameter.dart';
import 'package:mint/src/template_parameters/jar_template_parameter.dart';
import 'package:mint/src/template_parameters/mixin_template_parameter.dart';
import 'package:mint/src/utils.dart';
import 'package:mint/src/value_resolver.dart';
import 'package:mustache_template/mustache.dart';
import 'package:source_gen/source_gen.dart';

class MintGenerator extends GeneratorForAnnotation<Au> {
  static const optionCopyJar = 'copyJar';
  static const optionCopyWith = 'copyWith';
  static const optionAnnotations = 'annotations';
  static const optionEquality = 'equality';

  final Map<String, String> templateLocations;
  final List<Map<String, String>> mixinAnnotations;
  final List<Map<String, String>> childAnnotations;

  const MintGenerator(
      this.mixinAnnotations, this.childAnnotations, this.templateLocations);

  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    assert(element is ClassElement);

    final out = await _generateMintClass(
      element as ClassElement,
      annotation,
    );

    return out;
  }

  Future<String> _generateMintClass(
      ClassElement element, ConstantReader annotation) async {
    final ast = parseString(
            content: element.source.contents.data,
            featureSet: FeatureSet.latestLanguageVersion())
        .unit;

    final templates = await _getTemplatesWithContents();
    final fieldTypes = _getClassFieldTypes(element);

    assert(fieldTypes.isNotEmpty, 'Mint requires a class with fields.');

    final modelData = TemplateDataSource(parentMint: element);
    final fieldTDS = _getFieldTemplateDataSources(fieldTypes, modelData);

    final hasConstConstructor = _hasConstConstructor(ast);

    final jar = isBoolOptionEnabled(annotation, optionCopyJar)
        ? _jar(modelData, fieldTDS, templates)
        : null;

    return '''
    ${_fromAuHint(modelData, fieldTDS, templates, hasConstConstructor)}

    ${_abstract(modelData, fieldTDS, templates)}

    ${_mixin(modelData, fieldTDS, templates, ast, element, annotation)}

    ${_child(modelData, fieldTDS, templates, ast, element, annotation, fieldTypes, hasConstConstructor)}

    ${jar ?? '// copyJar is disabled'}
    ''';
  }

  Map<String, _ClassField> _getClassFieldTypes(ClassElement? element,
      {bool baseClass = true}) {
    var fieldTypes = <String, _ClassField>{};

    if (element == null) return fieldTypes;

    for (var field in element.fields) {
      assert(
          field.type is! DynamicType, 'Mint requires non dynamic field types.');

      if (field.isStatic ||
          field.isSynthetic ||
          field.isConst ||
          field.type is! InterfaceType) continue;

      fieldTypes.putIfAbsent(
          field.name,
          () => _ClassField(
              field.name,
              field.type as InterfaceType,
              baseClass
                  ? _ParameterAccessKeyword.self
                  : _ParameterAccessKeyword.parent,
              element));
    }

    if (element.supertype != null &&
        element.supertype?.element2 is ClassElement &&
        !(element.supertype?.isDartCoreObject ?? true)) {
      fieldTypes.addAll(_getClassFieldTypes(
          element.supertype?.element2 as ClassElement?,
          baseClass: false));
    }

    return fieldTypes;
  }

  static bool isBoolOptionEnabled(ConstantReader annotation, String option) {
    return annotation.objectValue.getField(option)?.toBoolValue() ?? false;
  }

  String _child(
    TemplateDataSource modelData,
    List<TemplateDataSource> fieldsData,
    Map<String, String> templates,
    CompilationUnit ast,
    ClassElement element,
    ConstantReader annotation,
    Map<String, _ClassField> fieldTypes,
    bool hasConstConstructor,
  ) {
    final annotationsEnabled =
        isBoolOptionEnabled(annotation, optionAnnotations);

    final annotations = annotationsEnabled
        ? _annotations(
            modelData, fieldsData, templates, element, childAnnotations)
        : '';

    final constructors = _getMintClassConstructors(ast, element, fieldTypes);

    return _processTemplate(
        templates['child']!,
        ChildTemplateParameter(
          modelData: modelData,
          fieldsData: fieldsData,
          constructors: constructors,
          hasConstConstructor: hasConstConstructor,
          annotations: annotations,
        ));
  }

  String _abstract(
    TemplateDataSource modelData,
    List<TemplateDataSource> fieldsData,
    Map<String, String> templates,
  ) {
    return _processTemplate(templates['abstract']!,
        DefaultTemplateParameter(modelData: modelData, fieldsData: fieldsData));
  }

  String _fromAuHint(
    TemplateDataSource modelData,
    List<TemplateDataSource> fieldsData,
    Map<String, String> templates,
    bool hasConstConstructor,
  ) {
    return _processTemplate(
        templates['from_au_hint']!,
        FromAuHintTemplateParameter(
          modelData: modelData,
          fieldsData: fieldsData,
          hasConstConstructor: hasConstConstructor,
        ));
  }

  String _jar(
    TemplateDataSource modelData,
    List<TemplateDataSource> fieldsData,
    Map<String, String> templates,
  ) {
    return _processTemplate(
        templates['jar']!,
        JarTemplateParameter(
          modelData: modelData,
          fieldsData: fieldsData,
        ));
  }

  String _mixin(
    TemplateDataSource modelData,
    List<TemplateDataSource> fieldsData,
    Map<String, String> templates,
    CompilationUnit ast,
    ClassElement element,
    ConstantReader annotation,
  ) {
    final annotationsEnabled =
        isBoolOptionEnabled(annotation, optionAnnotations);

    final annotations = annotationsEnabled
        ? _annotations(
            modelData,
            fieldsData,
            templates,
            element,
            mixinAnnotations,
          )
        : '';

    return _processTemplate(
        templates['mixin']!,
        MixinTemplateParameter(
          modelData: modelData,
          fieldsData: fieldsData,
          annotations: annotations,
          copyJarEnabled: isBoolOptionEnabled(annotation, optionCopyJar),
          copyWithEnabled: isBoolOptionEnabled(annotation, optionCopyWith),
          equalityEnabled: isBoolOptionEnabled(annotation, optionEquality),
        ));
  }

  String _annotations(
    TemplateDataSource modelData,
    List<TemplateDataSource> fieldsData,
    Map<String, String> templates,
    ClassElement element,
    List<Map<String, String>> annotations,
  ) {
    var buffer = StringBuffer();

    for (var annotation in annotations) {
      final annotationClass = annotation['annotation'];
      final templateKey = annotation['template'];
      assert(annotationClass != null,
          'One of the configured annotations in build.yaml has an error.');
      assert(templateKey != null,
          'The configured template key for $annotationClass can\'t be empty.');
      assert(templates.containsKey(templateKey),
          'There was no template configured for $templateKey.');

      if (!_isAnnotated(element, annotationClass!)) {
        continue;
      }

      buffer.write(_processTemplate(
          templates[templateKey]!,
          DefaultTemplateParameter(
            modelData: modelData,
            fieldsData: fieldsData,
          )));
    }

    return buffer.toString();
  }

  bool _isAnnotated(ClassElement element, String annotationClass) {
    return element.metadata
        .where((e) => e.element?.displayName == annotationClass)
        .isNotEmpty;
  }

  List<TemplateDataSource> _getFieldTemplateDataSources(
      Map<String, _ClassField> fieldTypes, TemplateDataSource modelData) {
    return (fieldTypes.values.toList()
          ..sort((a, b) => a.name.compareTo(b.name)))
        .asMap()
        .map((index, classField) => MapEntry(
            index,
            TemplateDataSource(
              parentMint: modelData.parentMint,
              parameterKeyword: classField.parameterKeyword,
              fieldName: classField.name,
              fieldType: classField.type,
              isLast: index == fieldTypes.length - 1,
            )))
        .values
        .toList();
  }

  Future<Map<String, String>> _getTemplatesWithContents() async {
    var out = <String, String>{};

    await Future.forEach<String>(templateLocations.keys, (templateKey) async {
      final contents =
          await _readTemplate(templateLocations[templateKey]!) ?? '';
      out.putIfAbsent(templateKey, () => contents);
    });

    return out;
  }

  Future<String?> _readTemplate(String path) async {
    final uri = await Isolate.resolvePackageUri(Uri.parse(path));
    return uri == null ? null : await File.fromUri(uri).readAsString();
  }

  String _processTemplate(String templateData, TemplateParameter context) {
    return Template(templateData, htmlEscapeValues: false)
        .renderString(_prepareContext(context));
  }

  Map<String, dynamic> _prepareContext(TemplateParameter context) {
    return context.toMap().map((k, v) {
      return MapEntry(k, _resolve(v));
    });
  }

  dynamic _resolve(dynamic v) {
    if (v is Map) {
      return v.map((ik, iv) => MapEntry(ik, _resolve(iv)));
    } else if (v is List) {
      return v.map(_resolve);
    }

    return (v is ValueResolver ? v.resolve() : v);
  }

  bool _hasConstConstructor(CompilationUnit ast) {
    final declaration = getMintClassDeclaration(ast);
    final constructors = List<ConstructorDeclaration>.from(
        declaration.childEntities.whereType<ConstructorDeclaration>());

    for (var constructor in constructors) {
      if (constructor.constKeyword != null) {
        return true;
      }
    }

    return false;
  }

  String _getMintClassConstructors(CompilationUnit ast, ClassElement element,
      Map<String, _ClassField> fieldTypes) {
    final declaration = getMintClassDeclaration(ast);
    final constructors = List<ConstructorDeclaration>.from(
        declaration.childEntities.whereType<ConstructorDeclaration>());
    final sourceBuffer = StringBuffer();

    for (var constructor in constructors) {
      if (constructor.name.toString() == '_fromAu') continue;
      if (constructor.factoryKeyword == null) {
        sourceBuffer
            .writeln('${_getConstructorSource(element, constructor)}\n');
        continue;
      }

      sourceBuffer
          .writeln('${_getFactoryConstructorSource(element, constructor)}\n');
    }

    return sourceBuffer.toString();
  }

  String _getConstructorSource(
    ClassElement element,
    ConstructorDeclaration constructor,
  ) {
    final className = element.name.toString();
    final elementSource = element.source.contents.data;

    var workingSource = elementSource;

    for (var constructorChildEntity in constructor.childEntities) {
      if (constructorChildEntity is SimpleIdentifier &&
          constructorChildEntity.toSource() == className) {
        workingSource = sourceReplaceSubstring(
          workingSource,
          elementSource,
          constructorChildEntity.offset,
          constructorChildEntity.end,
          ModelChildClassNameResolver.getChildClassName(className),
        );
      } else if (constructorChildEntity is FormalParameterList) {
        for (var parameterEntity in constructorChildEntity.childEntities) {
          parameterEntity = parameterEntity is DefaultFormalParameter
              ? parameterEntity.parameter
              : parameterEntity;

          workingSource = _getConstructorParameter(
              parameterEntity, elementSource, workingSource);
        }

        if (constructor.name != null) {
          workingSource = sourceReplaceSubstring(
            workingSource,
            elementSource,
            constructorChildEntity.end,
            constructorChildEntity.end,
            ' : super.${constructor.name}()',
          );
        }

        // Ignore anything after the parameter list
        workingSource = sourceReplaceSubstring(
          workingSource,
          elementSource,
          constructorChildEntity.end,
          constructor.end,
          ';',
        );

        break;
      }
    }

    final out = workingSource.substring(constructor.offset,
        constructor.end + (workingSource.length - elementSource.length));

    return out;
  }

  String _getConstructorParameter(SyntacticEntity parameterEntity,
      String elementSource, String workingSource) {
    if (parameterEntity is FieldFormalParameter) {
      for (var parameterChildEntity in parameterEntity.childEntities) {
        if (parameterChildEntity is Token &&
            parameterChildEntity.lexeme == 'this') {
          workingSource = sourceReplaceSubstring(
            workingSource,
            elementSource,
            parameterChildEntity.offset,
            parameterChildEntity.end,
            'super',
          );
          break;
        }
      }
    } else if (parameterEntity is SimpleFormalParameter) {
      for (var parameterChildEntity in parameterEntity.childEntities) {
        if (parameterChildEntity is NamedType) {
          workingSource = sourceReplaceSubstring(
            workingSource,
            elementSource,
            parameterChildEntity.offset,
            parameterChildEntity.end + 1,
            'super.',
          );
          break;
        }
      }
    }

    return workingSource;
  }

  String _getFactoryConstructorSource(
    ClassElement element,
    ConstructorDeclaration constructor,
  ) {
    final parameterSourceBuilder = StringBuffer();
    final className = element.name.toString();
    final constructorName = constructor.name.toString();
    final elementSource = element.source.contents.data;

    var workingSource = elementSource;

    for (var constructorChildEntity in constructor.childEntities) {
      if (constructorChildEntity is SimpleIdentifier &&
          constructorChildEntity.toSource() == className) {
        workingSource = sourceReplaceSubstring(
          workingSource,
          elementSource,
          constructorChildEntity.offset,
          constructorChildEntity.end,
          ModelChildClassNameResolver.getChildClassName(className),
        );
      } else if (constructorChildEntity is FormalParameterList) {
        for (var parameterEntity in constructorChildEntity.childEntities) {
          parameterEntity = parameterEntity is DefaultFormalParameter
              ? parameterEntity.parameter
              : parameterEntity;
          if (parameterEntity is SimpleFormalParameter) {
            parameterSourceBuilder.write('${parameterEntity.name.toString()},');
          }
        }
      } else if (constructorChildEntity is BlockFunctionBody) {
        workingSource = sourceReplaceSubstring(
          workingSource,
          elementSource,
          constructorChildEntity.offset,
          constructor.end,
          '''{
            return $className.$constructorName(${parameterSourceBuilder.toString()}).asChild();
          }
          ''',
        );
      }
    }

    final out = workingSource.substring(constructor.offset,
        constructor.end + (workingSource.length - elementSource.length));

    return out;
  }
}

enum _ParameterAccessKeyword {
  self('this'),
  parent('super');

  final String value;
  const _ParameterAccessKeyword(this.value);
}

class _ClassField {
  final _ParameterAccessKeyword _parameterAccessKeyword;
  final InterfaceType type;
  final ClassElement parentElement;
  final String name;

  const _ClassField(
    this.name,
    this.type,
    this._parameterAccessKeyword,
    this.parentElement,
  );

  String get parameterKeyword {
    return _parameterAccessKeyword.value;
  }
}
