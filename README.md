# shad

[![pub package](https://img.shields.io/pub/v/shad.svg)](https://pub.dev/packages/shad)
[![Flutter test](https://github.com/serverpod/shad/actions/workflows/flutter-test.yaml/badge.svg)](https://github.com/serverpod/shad/actions/workflows/flutter-test.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A Flutter port of [shadcn/ui](https://ui.shadcn.com). `shad` provides more than 40 components as plain Flutter widgets, themed by one `ShadThemeData`, with no dependency on Material or Cupertino.

[![Live demo](https://raw.githubusercontent.com/serverpod/shad/main/assets/screenshot.png)](https://shad.serverpod.dev/)

Live component browser and docs: **<https://shad.serverpod.dev/>**

## Features

- **Components.** Buttons, forms, dialogs, sheets, menus, a sidebar, a data table, and more. Every component is a regular `StatelessWidget` or `StatefulWidget`, so it composes with the rest of your widget tree.
- **Styles.** The eight named shadcn/ui styles (`vega`, `nova`, `maia`, `lyra`, `mira`, `luma`, `sera`, `rhea`) are complete presets for control size, radius, shadows, and type, switchable with one line.
- **Color schemes.** 16 palettes ship in light and dark, plus support for fully custom schemes.
- **Theming.** One `ShadThemeData` resolves color, typography, radius, spacing, and every component's own theme. Override any level without losing the rest.
- **Forms.** `ShadForm` and a `*FormField` widget for every input, with per-field validation.
- **Localization.** Built on `slang`, with English included and other locales inheriting from it.
- **Material and Cupertino interop.** `ShadApp.custom` renders `shad` components inside a `MaterialApp` or `CupertinoApp`, so both widget sets can share one page.

## Installation

```bash
flutter pub add shad
```

## Usage

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
    return ShadApp(
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadZincColorScheme.light(),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadZincColorScheme.dark(),
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
    return Scaffold(
      body: Center(
        child: ShadButton(
          onPressed: () {},
          child: const Text('Get started'),
        ),
      ),
    );
  }
}
```

See <https://shad.serverpod.dev/> for the full component reference, each page pairs a live preview with the exact source that renders it, plus guides on theming, styles, layout, forms, and responsive design.

## Repository layout

| Path | Contents |
| --- | --- |
| `lib/` | The `shad` package. |
| `example/` | The live docs site and component browser deployed to GitHub Pages, and a reference for how to structure an app around `shad`. |
| `test/` | The package's test suite. |
| `skills/shad-overview/` | An [Agent Skill](https://agentskills.io) describing `shad`'s API, for coding agents. |

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for how to set up the project, the test suite, and the pull request process.

## Credits

`shad` began as [flutter-shadcn-ui](https://github.com/nank1ro/flutter-shadcn-ui) by [Alexandru Mariuti](https://github.com/nank1ro). It is now maintained by [Serverpod](https://serverpod.dev).

## License

[MIT](LICENSE)
