# Theming

One `ShadThemeData` drives every component: color scheme, radius, typography, and per-component overrides.

## Reading the theme

Every component resolves its appearance from the nearest `ShadTheme`. Your own widgets read it the same way:

```dart
final theme = ShadTheme.of(context);

theme.colorScheme.primary;   // the palette
theme.textTheme.p;           // the type scale
theme.radius;                // the base corner radius
theme.style;                 // the active style preset
```

## Color schemes

Sixteen schemes ship in light and dark: blue, gray, green, mauve, mist, neutral, olive, orange, red, rose, slate (the default), stone, taupe, violet, yellow, and zinc.

```dart
ShadApp(
  theme: ShadThemeData(
    colorScheme: const ShadZincColorScheme.light(),
  ),
  darkTheme: ShadThemeData(
    brightness: Brightness.dark,
    colorScheme: const ShadZincColorScheme.dark(),
  ),
)
```

To let users pick a palette at runtime, resolve one by name with `ShadColorScheme.fromName`:

```dart
final scheme = ShadColorScheme.fromName(
  'rose',
  brightness: Brightness.dark,
);
```

## Customizing a scheme

A scheme is a value. Override individual slots where you construct it, and carry your own colors in the `custom` map so they lerp and switch with the rest of the theme.

```dart
ShadThemeData(
  colorScheme: const ShadSlateColorScheme.light(
    primary: Color(0xFF16A34A),
    custom: {
      'highlight': Color(0xFFFACC15),
    },
  ),
)

// Read it back anywhere:
ShadTheme.of(context).colorScheme.custom['highlight'];
```

An extension keeps custom colors as convenient as the built-in ones:

```dart
extension AppColors on ShadColorScheme {
  Color get highlight => custom['highlight']!;
}
```

## Component themes

Every component has a theme slot on `ShadThemeData`: `primaryButtonTheme`, `cardTheme`, `inputTheme`, and so on. Values you pass are merged over what the style derives, so an override touches exactly the property you name:

```dart
ShadThemeData(
  primaryButtonTheme: const ShadButtonTheme(
    backgroundColor: Color(0xFF16A34A),
  ),
)
```

## Radius

The theme carries one base radius, the `md` step of the scale. Everything else derives from it: at the default 8 the scale runs sm 6, md 8, lg 10, xl 14, 2xl 16, 3xl 24, 4xl 32, and each component picks the step its style prescribes.

```dart
ShadThemeData(
  radius: const BorderRadius.all(Radius.circular(10)),
)
```

## Menu appearance

The shadcn theme editor's menu options are theme settings here too. `menuColorScheme` renders menu surfaces on another palette (pass the dark counterpart for the "Inverted" look), `menuTranslucent` gives them the blurred 70% finish, and `menuAccent` picks how strongly rows highlight.

```dart
ShadThemeData(
  menuColorScheme: const ShadSlateColorScheme.dark(),
  menuTranslucent: true,
  menuAccent: ShadMenuAccent.bold,
)
```

## Focus rings

Focus is shown as an outward ring, like shadcn/ui. Set `disableSecondaryBorder: true` to switch to the alternative treatment: a 2px border inside the control, which keeps focus visible where an outward ring would be clipped.

```dart
ShadThemeData(
  disableSecondaryBorder: true,
)
```

## Interop with Material and Cupertino

`ShadApp.custom` renders shadcn components inside a `MaterialApp` or `CupertinoApp`, so both widget sets can share one page. Add the localizations delegate for each set you use and wrap `builder` in a `ShadAppBuilder`:

```dart
import 'package:flutter/material.dart';
import 'package:shad/shad.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.custom(
      themeMode: ThemeMode.dark,
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadSlateColorScheme.dark(),
      ),
      appBuilder: (context) {
        return MaterialApp(
          theme: Theme.of(context),
          localizationsDelegates: const [
            GlobalShadLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          builder: (context, child) => ShadAppBuilder(child: child!),
        );
      },
    );
  }
}
```

`Theme.of(context)` inside `appBuilder` already carries a `ThemeData` derived from the `ShadThemeData` (color scheme, typography, and common widget themes), so Material widgets on the same page pick up matching colors without extra work. Use `CupertinoApp` and `CupertinoTheme.of(context)` the same way for Cupertino. If the app needs the `Router` API, use `MaterialApp.router` or `CupertinoApp.router` inside `appBuilder`.
