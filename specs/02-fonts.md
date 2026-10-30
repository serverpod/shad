# 02 — Fonts: stop bundling them

## Problem

`pubspec.yaml` declares three font families under `flutter: fonts:`:

| File | Size |
| --- | --- |
| `fonts/Inter[opsz,wght].ttf` | 877 KB |
| `fonts/Geist[wght].ttf` | 169 KB |
| `fonts/GeistMono[wght].ttf` | 171 KB |

Flutter bundles every font that a dependency declares. Font assets are not
tree-shaken (only icon fonts are). As a result, **every app that depends on
`shad` ships about 1.2 MB of fonts**, even an app that sets its own font
family. On the web, the engine downloads every family in `FontManifest.json`
during startup, so users pay the cost on first load as well as in bundle
size. Wonky already works around this: `tool/prune_web_fonts.dart` deletes
`packages/shad/Inter` from its web builds.

Other problems with the current setup:

- **Licence.** The fonts use the SIL OFL 1.1, which requires the licence to
  ship with the font files. There is no `OFL.txt` next to them, so the
  published package does not comply. Removing the fonts solves this.
- **The mono face.** `kDefaultFontFamilyMono` (`packages/shad/GeistMono`) is
  used only by `ShadInputOTP` (`lib/src/components/input_otp.dart:531` and
  `lib/src/theme/themes/default_theme_variant.dart:1758`). The reference's
  `.cn-input-otp-slot` does **not** use `font-mono` in any of the eight
  styles; the mono face was added in 0.x.
- **Documentation.** The bundled faces are documented only in a comment at
  `lib/src/theme/text_theme/text_styles_default.dart:4`. The README says
  nothing about fonts.

## Decision

**`shad` ships no fonts, and there is no companion font package.** Fonts are
the app's choice. Text uses the platform font unless the app sets a family.
Shad supports two ways to set one, and both already work today:

1. **Google Fonts at runtime:**
   `ShadTextTheme.fromGoogleFont(GoogleFonts.inter)`.
2. **The app's own assets:** declare the font under the app's own
   `flutter: fonts:`, then pass `ShadTextTheme(family: 'Inter')`.

We considered and rejected two alternatives:

- A `shad_fonts` package. It would add a second package to version and
  publish, only to save users one `fonts:` block.
- Runtime fetching inside `shad`. A UI kit should not make network calls.

## Plan

### 1. Remove the assets

- Delete `fonts/` and the `flutter: fonts:` section of `pubspec.yaml`.
- Check whether `>=3.41.0` is still needed. The 0.54.0 changelog says the
  bump was made for variable-font weight support, which only the bundled
  faces needed. If nothing else depends on 3.41, the floor can drop. That
  needs a CI job on the lower version (see 05 §G). Otherwise keep it.

### 2. The default family becomes `null`

- `ShadTextTheme`'s default `family` becomes `null`, so text falls back to
  the platform font:
  - SF on Apple platforms;
  - Roboto on Android;
  - Segoe UI on Windows;
  - Flutter's own default on the web, which it fetches unless the app
    provides a font.
- `ShadTextTheme.family` becomes `String?`. Check every reader for null
  handling:
  - `lib/src/theme/theme_scope.dart:13`;
  - both variants' `defaultTextTheme`;
  - `ShadTextTheme.merge` and `lerp`;
  - `default_theme_no_secondary_border_variant.dart:250-263` and
    `default_theme_variant.dart:894+`, which pass `kDefaultFontFamily`
    explicitly.
- Fix a bug in the same place: `ShadTextTheme(package: 'x')` with no
  `family` currently produces `packages/x/packages/shad/Inter`
  (`text_theme/theme.dart:204`). With a null default, `package` must apply
  only when `family` is set.
- Control heights are pinned by tokens (see `control_heights_test.dart`), so
  another font changes text width but not control geometry.

### 3. `ShadInputOTP` stops using a mono face

- The default slot style becomes the `muted` role in `foreground`, plus
  `fontFeatures: [FontFeature.tabularFigures()]`. Digits keep equal widths
  without a monospace font, which matches the reference.
- Callers who want a mono face can still set `style:` or
  `ShadInputOTPTheme.style`.

### 4. Deprecate the old constants

- Mark `kDefaultFontFamily` and `kDefaultFontFamilyMono` `@Deprecated`, with
  this message: "shad no longer bundles fonts; set
  `ShadTextTheme(family: ...)` or use `ShadTextTheme.fromGoogleFont`". Keep
  them for all of 1.x so that existing references still compile.
- They point to assets that no longer exist, so Flutter falls back to the
  platform font. The deprecation message should say so.
- `ShadTextTheme(family: 'Geist', package: 'shad')` stops resolving. Add a
  changelog line and a `MIGRATION.md` entry.

### 5. Google Fonts support: clearer names, documented equality

`ShadTextTheme.fromGoogleFont(builder)` is the integration point, and it
already works with dynamic loading. Changes:

- Rename `GoogleFontBuilder` to `ShadFontBuilder`, and `GoogleFontTextStyle`
  to `ShadBuilderTextStyle`. Neither is specific to Google: they suit any
  font source that registers one family per weight. Keep the old names as
  deprecated typedefs (see 01 §B).
- Document the **equality rule** in the dartdoc:
  - `ShadTextTheme` compares `googleFontBuilder` by identity.
  - A static tear-off such as `GoogleFonts.inter` is canonical, so it is
    safe.
  - A closure literal, for example one that wraps
    `GoogleFonts.getFont(name)`, is a new object on every build. That breaks
    `ShadThemeData` equality and restarts the 200 ms theme lerp on every
    rebuild (CLAUDE.md, "Theme equality is load-bearing").
  - Callers must cache such a closure, as
    `example/lib/common/theme_editor/fonts.dart` does.
- Add a test to `theme_data_equality_test.dart` that
  `ShadTextTheme.fromGoogleFont(f) == ShadTextTheme.fromGoogleFont(f)` for
  the same `f`.

### 6. Example app: every font from Google Fonts at runtime

The theme editor already loads more than 20 families at runtime with
`google_fonts` (`example/lib/common/theme_editor/fonts.dart`). Only the
three faces marked `bundled: true` come from `shad`. `google_fonts` 8.2.1
includes Inter, Geist and Geist Mono, so all three can move over:

- **Fonts list.** Remove `EditorFont.bundled`. Every entry resolves through
  `ShadTextTheme.fromGoogleFont(builder)`, using the cached per-family
  builder that already exists.
- **Startup.** `main()` requests the default face (Inter) and awaits
  `GoogleFonts.pendingFonts()` before `runApp`, so the first frame does not
  flash a fallback font. Add a short timeout so the app still starts
  offline.
- **Load before switch.** When the user picks a font, call
  `GoogleFonts.getFont(family)` and await `GoogleFonts.pendingFonts()`
  before the new config goes to `themeConfigProvider`. Show a `ShadSpinner`
  in the picker row while the font loads. Today the theme switches first,
  and the text reflows again when the face arrives, so every control's text
  jumps twice.
- **Picker labels.** Render each option's label in its own face, loaded
  lazily the first time the row builds. `/create` does this, and it makes a
  font picker usable.
- **Copy code.** The "copy code" output (`editor_config.dart:382`) always
  emits `textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.x),` with a
  `// flutter pub add google_fonts` comment. Add a one-line note that an app
  can bundle the font itself and use `ShadTextTheme(family: '...')`.
- **Tests.** Keep `GoogleFonts.config.allowRuntimeFetching = false`, and
  update `theme_editor_test.dart:541`, since "bundled" no longer exists.
- **Typography page.** The page's "Monospace" toggle uses
  `kDefaultFontFamilyMono`. Switch it to `GoogleFonts.geistMono()` (or to
  the vendored JetBrains Mono that the code blocks already use).
- **macOS.** `google_fonts` needs the `com.apple.security.network.client`
  entitlement. `example/macos/` is gitignored, so document the entitlement
  in `example/README.md`.
- **Licence.** `example/fonts/` (JetBrains Mono, for code blocks) also has
  no OFL file. Add one.

### 7. Documentation

- **README.** Add a short **Fonts** section:
  - text uses the platform font by default;
  - to use a Google font, show the `google_fonts` snippet;
  - to bundle a font, show the app's `pubspec.yaml` `fonts:` block plus
    `ShadTextTheme(family: 'Inter')`;
  - to match shadcn's default, use Inter, or Geist and Geist Mono for the
    Vercel look.
- **Docs site.** Add a "Typography & fonts" guide page with the same paths,
  plus the equality rule from §5.
- **MIGRATION.md.** Add an entry: "shad no longer bundles Inter, Geist or
  GeistMono. To keep the 0.x look, either add
  `ShadTextTheme.fromGoogleFont(GoogleFonts.inter)`, or copy the TTF into
  your app, declare it under `fonts:`, and set
  `ShadTextTheme(family: 'Inter')`." Include the exact `fonts:` YAML.
- **Skills.** Fix `skills/shad-overview/guides/typography.md`, which still
  says Geist is the default.

## Tests

- `ShadTextTheme()` with no arguments has `family == null`, and every role
  has `fontFamily == null`.
- `ShadTextTheme(package: 'x')` without `family` leaves the family null.
- The default style of `ShadInputOTP` has tabular figures and no family.
- No file under `lib/` contains `packages/shad/`. Add a grep check in
  `check-imports.yaml`.
- The `flutter pub publish --dry-run` archive contains no `.ttf` outside
  `example/`.

## Size of the change

This is a small change:

- about 6 files in `lib/`;
- the example's `fonts.dart`, `editor_config.dart`, picker, typography page
  and `main()`.

It changes the look of apps that relied on the bundled Inter, but it does
not break compilation.

## Impact on the wonky apps

Wonky depends on all three bundled faces by literal asset path:

- **Geist is the UI font.** `ShadTextTheme(family: 'Geist', package:
  'shad')` in `packages/wonky_ui/lib/src/theme/wonky_theme.dart:95`.
- **GeistMono is the UI mono font.** `WonkyTheme.monoFamily =
  kDefaultFontFamilyMono` is set at `wonky_theme.dart:71` and used in about
  15 places. The literal `'packages/shad/GeistMono'` appears in about 6
  more.
- **Inter is a document, chart and cell font.** It is used in
  `wonky_write/lib/features/themes/write_fonts.dart`,
  `wonky_sheets/.../cell_fonts.dart` and
  `wonky_charts_flutter/.../chart_painter.dart:14`.
- **A test helper** loads `packages/shad/fonts/Geist[wght].ttf` directly.

Wonky already has the right place for its fonts: `packages/wonky_fonts`, a
pure-Dart asset package with a font registry that loads faces lazily through
`FontLoader`. Migration steps:

1. Add Geist and GeistMono to `wonky_ui` under `fonts:`. They are needed at
   startup, so eager loading is fine. Alternatively, add them to
   `wonky_fonts` and load them before `runApp`.
2. Add Inter to `wonky_fonts`' lazy registry, next to the faces it already
   carries, with the OFL files.
3. Replace the roughly 12 literal `packages/shad/...` strings, and
   `kDefaultFontFamily`/`Mono`, with wonky's own constants.
4. Point the test helper at the new asset path.
5. Delete the Inter rule in `prune_web_fonts.dart`, since nothing ships
   Inter eagerly any more.

This takes about half a day. It also fixes a likely existing bug: Write maps
`'Inter'` to `packages/shad/Inter`, but its web build prunes that face, so
Inter documents probably render in a fallback font on the web today.
