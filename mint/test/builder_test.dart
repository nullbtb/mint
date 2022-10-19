// CombiningBuilder tests adapted from:
// package:source_gen/test/builder_test.dart
// Copyright (c) 2017, the Dart project authors.

@TestOn('vm')

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:mint/builder.dart';
import 'package:mint/src/mint_combining_builder.dart';
import 'package:test/test.dart';

void main() {
  tearDown(() {
    // Increment this after each test so the next test has it's own package
    _pkgCacheCount++;
  });

  group('CombiningBuilder', () {
    test('includes a generated code header', () async {
      await testBuilder(
        const MintCombiningBuilder(),
        {
          '$_pkgName|lib/a.dart': 'library a; part "a.au.dart";',
          '$_pkgName|lib/a.foo.g.part': 'some generated content'
        },
        generateFor: {'$_pkgName|lib/a.dart'},
        outputs: {
          '$_pkgName|lib/a.au.dart': decodedMatches(
            startsWith('// GENERATED CODE - DO NOT MODIFY BY HAND'),
          ),
        },
      );
    });

    test('includes matching language version in all parts', () async {
      await testBuilder(
        const MintCombiningBuilder(),
        {
          '$_pkgName|lib/a.dart': '''
// @dart=2.12
library a;
part "a.au.dart";
''',
          '$_pkgName|lib/a.foo.g.part': 'some generated content'
        },
        generateFor: {'$_pkgName|lib/a.dart'},
        outputs: {
          '$_pkgName|lib/a.au.dart': decodedMatches(
            '''
// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of a;

some generated content
''',
          ),
        },
      );
    });

    test('outputs ".au.dart" files', () async {
      await testBuilder(
        const MintCombiningBuilder(),
        {
          '$_pkgName|lib/a.dart': 'library a; part "a.au.dart";',
          '$_pkgName|lib/a.foo.g.part': 'some generated content'
        },
        generateFor: {'$_pkgName|lib/a.dart'},
        outputs: {
          '$_pkgName|lib/a.au.dart':
              decodedMatches(endsWith('some generated content\n')),
        },
      );
    });

    test('outputs contain "part of"', () async {
      await testBuilder(
        const MintCombiningBuilder(),
        {
          '$_pkgName|lib/a.dart': 'library a; part "a.au.dart";',
          '$_pkgName|lib/a.foo.g.part': 'some generated content'
        },
        generateFor: {'$_pkgName|lib/a.dart'},
        outputs: {
          '$_pkgName|lib/a.au.dart': decodedMatches(contains('part of')),
        },
      );
    });

    test('joins part files', () async {
      await testBuilder(
        const MintCombiningBuilder(),
        {
          '$_pkgName|lib/a.dart': 'library a; part "a.au.dart";',
          '$_pkgName|lib/a.foo.g.part': 'foo generated content',
          '$_pkgName|lib/a.bar.g.part': 'bar generated content',
        },
        generateFor: {'$_pkgName|lib/a.dart'},
        outputs: {
          '$_pkgName|lib/a.au.dart': decodedMatches(
            endsWith('\n\nbar generated content\n\nfoo generated content\n'),
          ),
        },
      );
    });

    test('joins only associated part files', () async {
      await testBuilder(
        const MintCombiningBuilder(),
        {
          '$_pkgName|lib/a.dart': 'library a; part "a.au.dart";',
          '$_pkgName|lib/a.foo.g.part': 'foo generated content',
          '$_pkgName|lib/a.bar.g.part': 'bar generated content',
          '$_pkgName|lib/a.bar.other.g.part': 'bar.other generated content',
        },
        generateFor: {'$_pkgName|lib/a.dart'},
        outputs: {
          '$_pkgName|lib/a.au.dart': decodedMatches(
            endsWith('bar generated content\n\nfoo generated content\n'),
          ),
        },
      );
    });

    test('outputs nothing if no part files are found', () async {
      await testBuilder(
        const MintCombiningBuilder(),
        {
          '$_pkgName|lib/a.dart': 'library a; part "a.au.dart";',
        },
        generateFor: {'$_pkgName|lib/a.dart'},
        outputs: {},
      );
    });

    test('trims part content and skips empty and whitespace-only parts',
        () async {
      await testBuilder(
        const MintCombiningBuilder(),
        {
          '$_pkgName|lib/a.dart': 'library a; part "a.au.dart";',
          '$_pkgName|lib/a.foo.g.part': '\n\nfoo generated content\n',
          '$_pkgName|lib/a.only_whitespace.g.part': '\n\n\t  \n \n',
          '$_pkgName|lib/a.bar.g.part': '\nbar generated content',
        },
        generateFor: {'$_pkgName|lib/a.dart'},
        outputs: {
          '$_pkgName|lib/a.au.dart': decodedMatches(
            endsWith('\n\nbar generated content\n\nfoo generated content\n'),
          ),
        },
      );
    });

    test('includes part header if enabled', () async {
      await testBuilder(
        const MintCombiningBuilder(includePartName: true),
        {
          '$_pkgName|lib/a.dart': 'library a; part "a.au.dart";',
          '$_pkgName|lib/a.foo.g.part': '\n\nfoo generated content\n',
          '$_pkgName|lib/a.only_whitespace.g.part': '\n\n\t  \n \n',
          '$_pkgName|lib/a.bar.g.part': '\nbar generated content',
        },
        generateFor: {'$_pkgName|lib/a.dart'},
        outputs: {
          '$_pkgName|lib/a.au.dart': decodedMatches(
            endsWith(
              '\n\n'
              '// Part: a.bar.g.part\n'
              'bar generated content\n\n'
              '// Part: a.foo.g.part\n'
              'foo generated content\n\n'
              '// Part: a.only_whitespace.g.part\n\n',
            ),
          ),
        },
      );
    });

    test('includes ignore for file if enabled', () async {
      await testBuilder(
        const MintCombiningBuilder(
          ignoreForFile: {
            'lines_longer_than_80_chars',
            'prefer_expression_function_bodies',
          },
        ),
        {
          '$_pkgName|lib/a.dart': 'library a; part "a.au.dart";',
          '$_pkgName|lib/a.foo.g.part': '\n\nfoo generated content\n',
          '$_pkgName|lib/a.only_whitespace.g.part': '\n\n\t  \n \n',
          '$_pkgName|lib/a.bar.g.part': '\nbar generated content',
        },
        generateFor: {'$_pkgName|lib/a.dart'},
        outputs: {
          '$_pkgName|lib/a.au.dart': decodedMatches(
            endsWith(
              r'''
// ignore_for_file: lines_longer_than_80_chars, prefer_expression_function_bodies

part of a;

bar generated content

foo generated content
''',
            ),
          ),
        },
      );
    });

    test('warns about missing part statement', () async {
      final logs = <String>[];
      await testBuilder(
        mintCombiningBuilder(),
        {
          '$_pkgName|lib/a.dart': '',
          '$_pkgName|lib/a.foo.g.part': '// generated',
        },
        generateFor: {'$_pkgName|lib/a.dart'},
        onLog: (msg) => logs.add(msg.message),
        outputs: {},
      );

      expect(
        logs,
        contains(
          'a.au.dart must be included as a part directive in the input '
          'library with:\n    part \'a.au.dart\';',
        ),
      );
    });

    group('with custom extensions', () {
      test('generates relative "path of" for output in different directory',
          () async {
        await testBuilder(
          mintCombiningBuilder(
            const BuilderOptions({
              'build_extensions': {
                '^lib/{{}}.dart': 'lib/generated/{{}}.au.dart'
              }
            }),
          ),
          {
            '$_pkgName|lib/a.dart': 'part "generated/a.au.dart";',
            '$_pkgName|lib/a.foo.g.part': '\n\nfoo generated content\n',
            '$_pkgName|lib/a.only_whitespace.g.part': '\n\n\t  \n \n',
            '$_pkgName|lib/a.bar.g.part': '\nbar generated content',
          },
          generateFor: {'$_pkgName|lib/a.dart'},
          outputs: {
            '$_pkgName|lib/generated/a.au.dart': decodedMatches(
              endsWith(
                r'''
part of '../a.dart';

bar generated content

foo generated content
''',
              ),
            ),
          },
        );
      });

      test('warns about missing part statement', () async {
        final logs = <String>[];
        await testBuilder(
          mintCombiningBuilder(
            const BuilderOptions({
              'build_extensions': {
                '^lib/{{}}.dart': 'lib/generated/{{}}.au.dart'
              }
            }),
          ),
          {
            '$_pkgName|lib/a.dart': '',
            '$_pkgName|lib/a.foo.g.part': '// generated',
          },
          generateFor: {'$_pkgName|lib/a.dart'},
          onLog: (msg) => logs.add(msg.message),
          outputs: {},
        );

        expect(
          logs,
          contains(
            'generated/a.au.dart must be included as a part directive in the '
            'input library with:\n    part \'generated/a.au.dart\';',
          ),
        );
      });
    });
  });
}

// Ensure every test gets its own unique package name
String get _pkgName => 'pkg$_pkgCacheCount';
int _pkgCacheCount = 1;
