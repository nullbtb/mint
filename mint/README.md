Warning: This package is still considered experimental.

`Mint` provides a framework to generate code through templates.  It's intended primarily as a prototyping tool.  It comes out of the box with support for `copyWith`, `copyJar`, `equality`, `toJson`, and `fromJson`.  It achieves this through fully customizable templates which are configured to generate code inside a mixin, or a child class.  

## Usage

Usage is fairly straight forward:

```dart
// Import the au annotation
import 'package:au/au.dart';
// Import whatever other libraries you may need
import 'package:json_annotation/json_annotation.dart';

// Include the generated code.  Notice the extension is .au.dart and not .g.dart.
part 'person.au.dart';

// Annotate the class with Au
@Au()
// Add whatever other annotations you may need.
@JsonSerializable(explicitToJson: true)
// Include the _$Person mixin (Pattern is _$CLASS)
class Person with _$Person {
  final String name;
  final int age;

  const Person(this.name, this.age);

  // Copy this constructor from the generated code
  // The positional arguments represent the field names in alphabetical order
  const Person._fromAu(
    this.age,
    this.name,
  );
}
```

Ensure you have the following configuration in your `build.yaml` (in your project's root).  More details about these in the configuration section below.

```yaml
targets:
  $default:
    builders:
      mint:mint_builder:
        enabled: True
        options:
          templates:
            abstract: "package:mint/src/templates/abstract.mustache"
            child: "package:mint/src/templates/child.mustache"
            from_au_hint: "package:mint/src/templates/from_au_hint.mustache"
            jar: "package:mint/src/templates/jar.mustache"
            mixin: "package:mint/src/templates/mixin.mustache"
            from_json: "package:mint/src/templates/from_json.mustache"
            to_json: "package:mint/src/templates/to_json.mustache"
          mixin_annotations:
            - annotation: 'JsonSerializable'
              template: 'to_json'
          child_annotations:
            - annotation: 'JsonSerializable'
              template: 'from_json'
      source_gen:combining_builder:
        enabled: False
      mint:mint_combining_builder:
        enabled: True
        options:
          mint_rewire_parts:
            - 'json_serializable.g.part'
```

Run the build_runner to generate the code (or use the watch option to do it automatically on save):
`dart run build_runner build --delete-conflicting-outputs`
OR:
`dart run build_runner watch --delete-conflicting-outputs`
OR for Flutter:
`flutter packages pub run build_runner build --delete-conflicting-outputs`

At the top of the generated code, you should find the au constructor code:

```dart
// Copy the _fromAu constructor into your base class.
// const Person._fromAu(this.age,this.name,);
```

Now you're ready to go:

```dart
  final p1 = const Person('John', 35);

  final p2 = p1.copyWith(
    age: const AuValue<int>(25),
  );

  (p1 == p2) // false

  // or just copy the jar
  final p3 = p1.copyJar(const AuPersonJar(
    age: 21,
    name: 'Joe',
  ));

  final p4 = AuPerson.fromJson(p3.toJson());

  (p3 == p4); // true

  final p5 = const AuPerson('John', 35);
  (p5 == p1); // true
```

Notice you no longer have to write code for these common functionalities.  You also no longer need to add the `fromJson` factory constructor, you can use the `AuPerson` (AuCLASS) generated child class's `fromJson` factory.  Instances of `Person` and `AuPerson` are equivalent.

This is the premise of Mint, the ability to generate whatever you wish and to interact with the generated code either through the mixin or through the child class (in the case of factories).  This power extends to any other annotations, including your own.  The aim of mint is clean and intuitive data classes without useless repetition and clutter.  Hopefully you use it as intended.  (With great power comes great responsibility)

## Configuration

Configuration is done through the `build.yaml` file.

```yaml
targets:
  $default:
    builders:
      mint:mint_builder:
        enabled: True
        options:
          templates:
            # Required templates
            abstract: "package:mint/src/templates/abstract.mustache"
            child: "package:mint/src/templates/child.mustache"
            from_au_hint: "package:mint/src/templates/from_au_hint.mustache"
            jar: "package:mint/src/templates/jar.mustache"
            mixin: "package:mint/src/templates/mixin.mustache"
            # Annotation templates
            from_json: "package:mint/src/templates/from_json.mustache"
            to_json: "package:mint/src/templates/to_json.mustache"
          mixin_annotations:
            - annotation: 'JsonSerializable'
              template: 'to_json'
          child_annotations:
            - annotation: 'JsonSerializable'
              template: 'from_json'
      # Disable source gen combining_builder for improved performance
      source_gen:combining_builder:
        enabled: False
      # Utilize the mint:combining_builder instead
      mint:mint_combining_builder:
        enabled: True
        options:
          # Which parts will have generated model references replaced with Au child references (Person > AuPerson). This is only needed when there are factories being created in child_annotations. It essentially rewires the part generated code to function as if it were generated for the child class instead of the model.  This allows you to interact with it from other generated code without ever needing to add anything to the model.  
          mint_rewire_parts:
            - 'json_serializable.g.part'
```

The first step is to define the templates map.  The required keys are: `abstract`, `child`, `from_au_hint`, `jar`, and `mixin`.  The keys represent the identifier of each template, the value is the URI to the mustache template file.  If you want to use your own template simply replace the corresponding URI with one in your project.

There is also support for annotation templates (which is how Mint provides support for `JsonSerializable`).  It can also be used to create your own annotation driven generations.  Once the templates are defined, we simply provide a list of maps for `mixin_annotations` and `child_annotations` with the corresponding template identifier.  

eg: If the class is annotated with `JsonSerializable`, generate the `to_json` template into the mixin.  The same applies if we need to add some functionality to the child class (eg: for a factory constructor), we simply utilize the `child_annotations` list instead.

Note: As you may have realized, the configured annotations are strings and not actual TypeInterfaces.  If you have multiple annotation classes with the same name this may present some challenges.

Note: You may not wish to follow along with referencing generated Au* classes in your codebase.  If thats the case, you could opt to only use the mixin, which will still give you the majority of the functionality: copyWith, copyJar, equality, toJson, etc.  You would of course have to define the necessary factories in your models (fromJson).  The only other change would be to disable the mint_combining_builder, and enable the source_gen one.

## Template Parameters
When creating your own templates for annotations, you will will need to access some model metadata.  This can be done with the variables below:

```dart
[
  'model_class_name',
  'model_abstract_class_name',
  'model_child_class_name',
  'model_jar_class_name',
  'fields': [
    'field_name',
    'field_name_capitalized',
    'field_type',
    'field_type_with_nullability',
    'field_is_nullable',
    'field_is_private',
    'field_is_last',
  ]
]
```

Here's an example of the `abstract.mustache` file, which creates an abstract class with the same fields as the model:

```
abstract class {{model_abstract_class_name}} extends AuMinted {
    {{#fields}}
    {{field_type_with_nullability}} get {{field_name}};
    {{/fields}}
}
```

## Closing

Fun Fact: This package was originally supposed to be named `Augment`, and then I discovered the work in progress language feature in Dart by the same name.  Therefore I renamed it to: Au + Mint.  The goal is to hopefully not need this package in the future when augmentation is live, but until then.. keep minting gold!