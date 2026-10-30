# Typography

`ShadThemeData.textTheme` carries the prose scale. Read a role and hand it to a `Text` widget:

```dart
Text(
  'Taxing Laughter: The Joke Tax Chronicles',
  style: ShadTheme.of(context).textTheme.h1,
)
```

## Roles

| Role | Use for |
| --- | --- |
| `h1Large` | The largest heading, for hero-style titles. |
| `h1` | Page titles. |
| `h2` | Section titles. |
| `h3` | Sub-section titles. |
| `h4` | Card and dialog titles. |
| `p` | Body paragraphs. |
| `blockquote` | Quoted text, indented with a left border. |
| `table` | Table cell text. |
| `list` | List item text. |
| `lead` | The introductory paragraph under a page title. |
| `large` | Emphasized body text, for example a dialog's main question. |
| `small` | Field labels and secondary UI text. |
| `muted` | De-emphasized helper text. |

Every component that shows text (buttons, badges, cards, alerts, menus, and so on) reads its own style from a component theme instead of these roles directly. Those styles derive from the active style preset (see [styles.md](styles.md)) but can be overridden the same way as any other component theme, see [theming.md](theming.md).

## Fonts

`shad` bundles no fonts. Text uses the platform font (SF on Apple platforms, Roboto on Android, Segoe UI on Windows) until you choose one.

### Your own font files

Add the font to your project, for example under a `/fonts` directory, then declare it in `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: fonts/Inter[opsz,wght].ttf
```

Then name the family in a `ShadTextTheme`:

```dart
ShadThemeData(
  colorScheme: const ShadZincColorScheme.light(),
  textTheme: ShadTextTheme(family: 'Inter'),
)
```

### Google Fonts

Add the [google_fonts](https://pub.dev/packages/google_fonts) package, then build the text theme from one of its fonts:

```dart
ShadThemeData(
  colorScheme: const ShadZincColorScheme.light(),
  textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.inter),
)
```

Pass a static tear-off such as `GoogleFonts.inter`. A closure around `GoogleFonts.getFont(name)` must be created once and reused: a new closure on every build makes the theme unequal to itself, and the theme transition restarts on every rebuild.

shadcn/ui's default font is Inter; Geist and Geist Mono give the Vercel look.

## Custom styles

Add your own named styles with the `custom` parameter, the same pattern `ShadColorScheme` uses for custom colors:

```dart
ShadThemeData(
  textTheme: ShadTextTheme(
    custom: {
      'myCustomStyle': const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.blue,
      ),
    },
  ),
)
```

Read it back with `ShadTheme.of(context).textTheme.custom['myCustomStyle']!`, or add an extension to make it a getter:

```dart
extension CustomStyleExtension on ShadTextTheme {
  TextStyle get myCustomStyle => custom['myCustomStyle']!;
}
```
