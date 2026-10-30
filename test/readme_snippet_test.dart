// The Usage snippet from README.md, verbatim apart from main(). Keep the two
// in sync: the README's snippet once did not compile (it used Material's
// Scaffold, and ThemeMode was not exported) and nothing noticed.
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadZincColorScheme.light(),
        style: ShadStyleTokens.nova,
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadZincColorScheme.dark(),
        style: ShadStyleTokens.nova,
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShadCard(
        width: 320,
        title: const Text('Create project'),
        description: const Text('Deploy your new project in one click.'),
        footer: ShadButton(
          onPressed: () {},
          child: const Text('Deploy'),
        ),
        child: const ShadInput(placeholder: Text('Name of your project')),
      ),
    );
  }
}

void main() {
  testWidgets('the README usage snippet builds', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Deploy'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('the snippet in README.md matches this file', () {
    // Compare the two widget classes, ignoring whitespace differences.
    String normalise(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim();
    final readme = File('README.md').readAsStringSync();
    final here = File('test/readme_snippet_test.dart').readAsStringSync();
    String classes(String s) {
      final start = s.indexOf('class MyApp');
      final end = s.indexOf('\n}\n', s.indexOf('class HomePage')) + 2;
      return normalise(s.substring(start, end));
    }

    expect(classes(readme), classes(here));
  });
}
