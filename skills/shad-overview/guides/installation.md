# Installation

Add `shad` to your project from the command line:

```bash
flutter pub add shad
```

Everything ships through one import: components, theme, Lucide icons, and animation effects.

```dart
import 'package:shad/shad.dart';
```

## Set up ShadApp

`ShadApp` takes the place of `MaterialApp`. It installs the theme, localizations, navigation, and the overlay layer the floating components use. With no arguments it uses the slate color scheme and the nova style.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadApp(
      home: HomePage(),
    );
  }
}
```

Apps that use the `Router` API use `ShadApp.router` with the usual `routerConfig` or delegate parameters.

## Dark mode

Pass a `theme` and a `darkTheme`, and pick between them with `themeMode`. Follow the platform, or bind it to your own setting.

```dart
ShadApp(
  themeMode: ThemeMode.system,
  theme: ShadThemeData(),
  darkTheme: ShadThemeData(
    brightness: Brightness.dark,
  ),
  home: const HomePage(),
)
```

## Use the components

Components are plain widgets. Icons come from the bundled Lucide set:

```dart
ShadButton(
  leading: const Icon(LucideIcons.mail),
  onPressed: () {},
  child: const Text('Login with Email'),
)
```

## Padding

Use `ShadPadding` instead of Flutter's `Padding` to keep insets on the theme's spacing scale. It has no plain constructor, only `ShadPadding.all`, `.symmetric`, `.only`, and `.directional`, and their arguments are steps, not logical pixels:

```dart
ShadPadding.symmetric(
  horizontal: 6, // px-6
  vertical: 4, // py-4
  child: const Text('Inset by the theme spacing scale'),
)
```

See [layout.md](layout.md#padding) for a full example.

From here, [theming.md](theming.md) and [styles.md](styles.md) cover how to make it yours, and each page under `components/` pairs a description with the actual example source that ships in the example app.
