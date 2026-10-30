# shad

[![pub package](https://img.shields.io/pub/v/shad.svg)](https://pub.dev/packages/shad)
[![Flutter test](https://github.com/serverpod/shad/actions/workflows/flutter-test.yaml/badge.svg)](https://github.com/serverpod/shad/actions/workflows/flutter-test.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A Flutter port of [shadcn/ui](https://ui.shadcn.com). `shad` provides more than 40 components as plain Flutter widgets, themed by one `ShadThemeData`, with no dependency on Material or Cupertino.

[![Live demo](https://raw.githubusercontent.com/serverpod/shad/main/assets/screenshot.png)](https://shad.serverpod.dev/)

Live component browser and docs: **<https://shad.serverpod.dev/>**

## Features

- **Components.** Buttons, forms, dialogs, sheets, menus, a sidebar, a data table, and more. Every component is a regular `StatelessWidget` or `StatefulWidget`, so it composes with the rest of your widget tree.
- **Styles.** The eight named shadcn/ui styles (`vega`, `nova`, `maia`, `lyra`, `mira`, `luma`, `sera`, `rhea`) are complete presets for control size, radius, shadows, and type. You switch between them with one line.
- **Color schemes.** 16 palettes ship in light and dark, and you can define your own.
- **Theming.** One `ShadThemeData` resolves color, typography, radius, spacing, and every component's own theme. You can override any level without losing the rest.
- **Forms.** `ShadForm` and a `*FormField` widget for every input, with per-field validation.
- **Localization.** 82 locales, built on `slang`.
- **Material and Cupertino interop, opt-in.** `package:shad/material.dart` themes Material and Cupertino widgets from the `shad` theme, so both widget sets can share one page.

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
        style: ShadStyleTokens.nova,
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadZincColorScheme.dark(),
        style: ShadStyleTokens.nova,
      ),
      themeMode: ShadThemeMode.system,
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
```

The [live docs](https://shad.serverpod.dev/) give the full component reference. Each page pairs a live preview with the exact source that renders it. The site also has guides on theming, styles, layout, forms, and responsive design.

## Fonts

`shad` bundles no fonts. Text uses the platform's font (SF on Apple platforms, Roboto on Android, Segoe UI on Windows) until you choose another one. There are two ways to choose:

**Google Fonts, fetched at runtime:**

```bash
flutter pub add google_fonts
```

```dart
ShadThemeData(
  textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.inter),
)
```

Pass a static tear-off such as `GoogleFonts.inter`. If you wrap `GoogleFonts.getFont(name)` in a closure, create it once and reuse it. A new closure on every build makes the theme unequal to itself, which restarts the theme animation on every rebuild.

**Your own font files:** add the files to your app, declare them in your `pubspec.yaml`, and name the family:

```yaml
flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: fonts/Inter[opsz,wght].ttf
```

```dart
ShadThemeData(
  textTheme: ShadTextTheme(family: 'Inter'),
)
```

shadcn/ui's own default font is [Inter](https://rsms.me/inter/). The Vercel look is [Geist and Geist Mono](https://vercel.com/font).

## Material and Cupertino

`package:shad/shad.dart` does not import Material or Cupertino, which Flutter is moving out of the SDK into the [`material_ui`](https://pub.dev/packages/material_ui) and [`cupertino_ui`](https://pub.dev/packages/cupertino_ui) packages. To use Material or Cupertino widgets in a `shad` app, also import `package:shad/material.dart` and wrap the app in a `ShadMaterial`:

```dart
import 'package:shad/material.dart';
import 'package:shad/shad.dart';

ShadApp(
  builder: (context, child) => ShadMaterial(child: child!),
  home: const HomePage(),
)
```

`ShadMaterial` derives a Material theme from the `shad` theme. It also adds the Material and Cupertino localizations and a transparent `Material`, which widgets such as `TextField` and `Slider` need. To put `shad` widgets inside your own `MaterialApp`, use `ShadApp.custom` and `shadMaterialThemeFrom(ShadTheme.of(context))`. `package:shad/material.dart` uses the Material and Cupertino libraries that ship in the Flutter SDK.

## Platform support

Android, iOS, macOS, Windows, Linux and the web, including WebAssembly. The package needs Flutter 3.41 or later.

## Versioning

`shad` follows [semantic versioning](https://semver.org/) from 1.0:

- A breaking API change happens only in a major version. A renamed or removed member first stays as `@Deprecated` for at least the rest of that major version, with a data-driven fix, so `dart fix --apply` migrates your code.
- A visual change that brings a component closer to shadcn/ui is a bug fix, not a breaking change.

Upgrading from 0.x? See [MIGRATION.md](MIGRATION.md).

## Not yet available

These shadcn/ui components have no `shad` equivalent yet: navigation menu, hover card, drawer, carousel, chart, combobox (partly covered by `ShadSelect.withSearch`), aspect ratio, native select, and the layout primitives button group, input group, field and item. The [issue tracker](https://github.com/serverpod/shad/issues) is the place to ask for one.

## Repository layout

| Path | Contents |
| --- | --- |
| `lib/` | The `shad` package. |
| `example/` | The live docs site and component browser deployed to GitHub Pages. It is also a reference for how to structure an app around `shad`. |
| `test/` | The package's test suite. |
| `skills/shad-overview/` | An [Agent Skill](https://agentskills.io) describing `shad`'s API, for coding agents. |

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for how to set up the project, run the test suite, and open a pull request. To report a security problem, see [SECURITY.md](SECURITY.md).

## Credits

`shad` began as [flutter-shadcn-ui](https://github.com/nank1ro/flutter-shadcn-ui) by [Alexandru Mariuti](https://github.com/nank1ro). It is now maintained by [Serverpod](https://serverpod.dev).

## License

[MIT](LICENSE)
