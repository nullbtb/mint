import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

class TemplateDataSource {
  final String? fieldName;
  final InterfaceType? fieldType;
  final InterfaceType? argParentType;
  final String? parameterKeyword;
  final ClassElement parentMint;
  final bool isLast;

  TemplateDataSource(
      {required this.parentMint,
      this.parameterKeyword,
      this.fieldType,
      this.fieldName,
      this.argParentType,
      this.isLast = false});
}
