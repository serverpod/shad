# shad example

A minimal app: a themed `ShadApp` with a card, an input, a select and a
button.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

void main() => runApp(const App());

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
```

## Fonts

shad bundles no fonts, so the example above renders in the platform font.
To match shadcn/ui's Inter, add `google_fonts` and set:

```dart
ShadThemeData(textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.inter))
```

## More

The rest of this directory is the [live docs site](https://shad.serverpod.dev/):
every component with live previews, the exact source of each, and a theme
editor. See `README.md` here for running it locally.
