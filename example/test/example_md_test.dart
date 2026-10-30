// The first snippet of example/example.md, which pub.dev shows on the
// package's Example tab. Keep the two in sync.
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      theme: ShadThemeData(
        colorScheme: const ShadZincColorScheme.light(),
        // One of shadcn/ui's eight styles: vega, nova, maia, lyra, mira,
        // luma, sera or rhea.
        style: ShadStyleTokens.nova,
      ),
      darkTheme: ShadThemeData(
        colorScheme: const ShadZincColorScheme.dark(),
        style: ShadStyleTokens.nova,
      ),
      home: const Center(child: SignUpCard()),
    );
  }
}

class SignUpCard extends StatelessWidget {
  const SignUpCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      width: 360,
      title: const Text('Create an account'),
      description: const Text('Enter your details to get started.'),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ShadButton(
            onPressed: () => ShadToaster.of(context).show(
              const ShadToast(title: Text('Account created')),
            ),
            child: const Text('Sign up'),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          const ShadInput(placeholder: Text('Email')),
          ShadSelect<String>(
            placeholder: const Text('Plan'),
            options: const [
              ShadOption(value: 'free', child: Text('Free')),
              ShadOption(value: 'pro', child: Text('Pro')),
            ],
            selectedOptionBuilder: (context, value) => Text(value),
          ),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('the example.md app builds', (tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('Sign up'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('example.md matches this file', () {
    String normalise(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim();
    String classes(String s) {
      final start = s.indexOf('class App');
      final end = s.indexOf('\n}\n', s.indexOf('class SignUpCard')) + 2;
      return normalise(s.substring(start, end));
    }

    expect(
      classes(File('example.md').readAsStringSync()),
      classes(File('test/example_md_test.dart').readAsStringSync()),
    );
  });
}
