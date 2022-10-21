Warning: This package is still considered experimental.

`Mint` provides a framework to generate code through templates.  It comes out of the box with support for `copyWith`, `copyJar`, `equality`, `toJson`, and `fromJson`.  It achieves this through fully customizable templates which are configured to generate code inside a mixin or a child class.  It also allows you to define your own templates and enable/disable them through annotations.

## Usage

Usage is fairly straight forward:

### Add the dependencies to your `pubspec.yaml`

```yaml  
dependencies:
  au: ^0.1.0
  json_annotation: ^4.7.0

dev_dependencies:
  build_runner: ^2.0.0
  json_serializable: ^6.3.1
  mint: ^0.3.0
```

### Add it to a model

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

### Update your `build.yaml`

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

### Run the build runner
Run the build_runner to generate the code (or use the watch option to do it automatically on save):
`dart run build_runner build --delete-conflicting-outputs`
OR:
`dart run build_runner watch --delete-conflicting-outputs`
OR for Flutter:
`flutter packages pub run build_runner build --delete-conflicting-outputs`

### Copy the `_fromAu` constructor (if you didn't write it manually)
At the top of the generated code, you should find the au constructor code:

```dart
// Copy the _fromAu constructor into your base class.
// const Person._fromAu(this.age,this.name,);
```

### Good to go

```dart
  final p1 = const Person('John', 35);

  final p2 = p1.copyWith(
    age: const AuValue<int>(25),
  );

  assert(p1 != p2);

  // or just copy the jar
  final p3 = p1.copyJar(const AuPersonJar(
    age: 21,
    name: 'Joe',
  ));

  final p4 = AuPerson.fromJson(p3.toJson());

  assert(p3 == p4);

  final p5 = const AuPerson('John', 35);
  assert(p5 == p1);
```

Notice you no longer have to write code for these common functionalities.  You also no longer need to add the `fromJson` factory constructor, you can use the `AuPerson` (AuCLASS) generated child class's `fromJson` factory.  This works because instances of `Person` and `AuPerson` are equivalent.

This is the premise of Mint, the ability to generate whatever you wish and to interact with the generated code however you wish.  All generated code comes from templates which you can simply modify to suit your needs.  This power extends to interacting with third party libraries.  You can achieve this by configuring a given template for each annotation.  The aim of mint is clean, simple, and intuitive data classes.  Hopefully you use it as intended.  (With great power comes great responsibility)

### Regeneration

The only time you would ever need to rerun the build runner is if you ever modify the field or constructor definitions in a model. As previously mentioned this can be accomplished automatically with a watch command: `dart run build_runner watch --delete-conflicting-outputs`.  

If you want to take this a step farther, you can automate the execution of this command in VSCode so that it runs whenever you open your project.  This can be accomplished through the VSCode tasks configuration.  To set this up simply add this `tasks.json` inside your `.vscode` directory:

```json
{
	"version": "2.0.0",
	"tasks": [
		{
			"type": "flutter",
			"command": "flutter",
            "args": [
                "pub",
                "run",
                "build_runner",
                "watch",
                "lib/", 
                "--delete-conflicting-outputs",
            ],
			"problemMatcher": [
				"$dart-build_runner"
			],
			"options": {
				"cwd": "example",
			},
			"runOptions": {
        "runOn": "folderOpen"
      },
			"presentation": {
				"echo": true,
				"reveal": "always",
				"focus": false,
				"panel": "dedicated",
				"showReuseMessage": false,
				"clear": false
			},
			"group": "build",
			"label": "Flutter Build Runner",
			"detail": "example"
		}
	]
}
```

## Configuration

Configuration for code generation is done through the `build.yaml` file:

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

## Custom templates targeting an annotation

In the example project you can see an example of how to set this up.  It's fairly straight forward.

### Create your annotation  

In dart any class can be an annotation, it just has to have a const constructor.

```dart
class Foo {
  const Foo();
}
```

### Create your custom template

```
// Custom generated function from Foo annotation
String foo() {
    return 'foo on {{model_class_name}} - {{#fields}}{{field_name}}{{^field_is_last}},{{/field_is_last}}{{/fields}}';
}
```

### Update `build.yaml`

```yaml
  templates:
    abstract: "package:mint/src/templates/abstract.mustache"
    child: "package:mint/src/templates/child.mustache"
    from_au_hint: "package:mint/src/templates/from_au_hint.mustache"
    jar: "package:mint/src/templates/jar.mustache"
    mixin: "package:mint/src/templates/mixin.mustache"
    from_json: "package:mint/src/templates/from_json.mustache"
    to_json: "package:mint/src/templates/to_json.mustache"
    # Add your custom template
    with_foo: "package:example/templates/with_foo.mustache"
  mixin_annotations:
    - annotation: 'JsonSerializable'
      template: 'to_json'
    # Add your custom annotation, and configure it to be added to the mixin_annotations
    - annotation: 'Foo'
      template: 'with_foo'
```

### Use it

```dart
@Au()
@Foo()
@JsonSerializable(explicitToJson: true)
class WithFoo with _$WithFoo {
  final String name;
  final int age;

  const WithFoo(this.name, this.age);

  const WithFoo._fromAu(
    this.age,
    this.name,
  );
}
```

Since the model is annotated with `Foo`, and we configured Foo to generate the tempalte `with_foo`, the system will generate this additional function as part of the method:

```dart
  // Custom generated function from Foo annotation
  String foo() {
    return 'foo on WithFoo - age,name';
  }
```

You can now use it as any other method:

```dart
final w = WithFoo('foo', 99);
print(w.foo());
```

### Factory constructors

Factory constructors can't be defined as part of a mixin.  Therefore `Mint` also generates a child class which extends the original model.  This child class is named `Au(CLASS)`.  This child class is responsible for interacting with generated code for us.  It allows us to not have to define `fromJson` or other similar factory constructors which may be required by third party code generators.  You can utilize a child class in the same way you utilize it's parent model.

If you wish for code to be part of the child class instead you simply move the Foo annotation configuration to the child_annotations section:

```yaml
  child_annotations:
    - annotation: 'JsonSerializable'
      template: 'from_json'
    # Add the foo annotation configuration
    - annotation: 'Foo'
      template: 'with_foo'
```

#### Optional rewiring

Depending on the third party code generation library you're trying to integrate with, you may also need to "rewire" the third party generated code to now point to the child class instead of the original model it was generated for (Person > AuPerson).  To achieve this, you simply add the extension of the part file to the `mint_combining_builder` configuration:

```yaml
      mint:mint_combining_builder:
        enabled: True
        options:
          mint_rewire_parts:
            - 'json_serializable.g.part'
            # Add parts to rewire
```

## Closing

Fun Fact: This package was originally named `Augment`, and then I discovered the work in progress Dart feature by the same name.  Therefore I renamed it to: Au + Mint.  Hopefully augmentation gives us better options for accomplishing this type of behavior in the future, but until then.. keep minting gold!