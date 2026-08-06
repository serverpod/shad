# Contributing to shad

Thank you for your interest in contributing. This guide covers project setup, the test suite, coding conventions, and the pull request process.

## Ways to contribute

- Report bugs and reproduce or triage [existing issues](https://github.com/serverpod/shad/issues).
- Add or improve tests.
- Add a missing component, or improve an existing one.
- Improve the documentation in the example app or in `skills/shad-overview/`.

We communicate through GitHub issues and pull requests, and on the [Serverpod Discord](https://serverpod.dev/discord).

## Project setup

The repository has two separate Dart/Flutter projects:

| Path | What it is |
| --- | --- |
| `/` | The `shad` package. |
| `example/` | The docs site and component browser, also deployed to GitHub Pages. |

Install dependencies for each project you plan to touch:

```bash
flutter pub get
cd example && flutter pub get && cd ..
```

## Running the example app

The example app doubles as a manual test bed and documentation site. Run it like a normal Flutter app:

```bash
cd example
flutter run -d chrome # or a connected device/simulator
```

## Verifying your change

Run these before opening a pull request. CI runs the same commands against the package and the example app, each analyzed and tested on its own.

```bash
flutter analyze
flutter test

cd example
flutter analyze
flutter test
cd ..
```

### Regenerating generated files

Component themes are generated. After changing anything under `lib/src/theme/`, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Commit the resulting `*.g.theme.dart` files together with your change.

Translations use slang's legacy builder, which writes to disk directly instead of through `build_runner`. Only `lib/src/i18n/en.i18n.yaml` needs editing, other locales inherit from English. If a `lib/src/i18n/strings*.g.dart` file goes missing, regenerate it with:

```bash
dart run slang
```

## Adding a component

The component must exist on [ui.shadcn.com](https://ui.shadcn.com/docs/components).

1. Look up its markup, states, and measurements in the shadcn/ui reference (see `CLAUDE.md` for where each value lives). Read values from the reference; do not guess colors, padding, radii, or type.
2. Create `lib/src/components/<name>.dart`. Name the widget class `Shad<Name>`, for example `ShadAvatar` or `ShadDialog`.
3. Create its theme at `lib/src/theme/components/<name>.dart`, following the pattern of an existing component theme.
4. Export both files from `lib/shad.dart`.
5. Add the component's default values to both theme variants: `lib/src/theme/themes/default_theme_variant.dart` and `default_theme_no_secondary_border_variant.dart`. The two variants should differ only in how the component's decoration handles the secondary (outward) border.
6. Add a documentation page: an example under `example/lib/docs/examples/<slug>/`, a `ComponentDoc` in `example/lib/docs/pages/<slug>.dart`, and an entry in `example/lib/docs/registry.dart`.
7. Regenerate the component's skill page: `dart run scripts/generate_skills.dart`.
8. Add tests under `test/src/components/`.

### Component parameters

Make every parameter overridable on both the component and its theme, and resolve it the same way every other component does:

```dart
Widget build(BuildContext context) {
  final theme = ShadTheme.of(context);
  final effectivePadding = widget.padding ?? theme.avatarTheme.padding ?? kDefaultPadding;
}
```

Both the component's parameter and the theme's parameter must be optional for this pattern to work.

### Component variants

When a component has multiple variants, model them as an enum and give each variant its own named constructor, plus a `.raw` constructor for the general case:

```dart
enum ShadAlertVariant { primary, destructive }

class ShadAlert extends StatelessWidget {
  // The primary constructor.
  const ShadAlert({super.key}) : variant = ShadAlertVariant.primary;

  // A named constructor for a specific variant.
  const ShadAlert.destructive({super.key}) : variant = ShadAlertVariant.destructive;

  // A generic constructor that accepts any variant.
  const ShadAlert.raw({super.key, required this.variant});

  final ShadAlertVariant variant;
}
```

## Code style

- Run `dart format .` before committing.
- `flutter analyze` must report no issues. The package follows `very_good_analysis`; see `analysis_options.yaml` for project-specific overrides.
- Nothing under `lib/` may import `material.dart`, `cupertino.dart`, or the package's own barrel (`package:shad/shad.dart`). `lib/src/app.dart` is the only exception. CI enforces this.
- Add or update a doc comment (`///`) on every public member you add or change.
- Do not add comments that only restate what the code does. Add a comment when the code cannot explain its own intent, a trade-off, or a constraint.

## Tests

- New behavior needs a test. Bug fixes should include a test that fails before the fix and passes after.
- Prefer asserting resolved theme values over pixels or golden images.
- Use `matchesGoldenFile` only with `await expectLater(...)`. An unawaited `expect` never reports a mismatch.
- Popover-based components animate their entrance behind an `IgnorePointer`. Pump about 12 frames of 50 ms before interacting with one in a test.

## Commit and pull request process

1. Fork the repository and create a branch for your change.
2. Make your change, following the conventions above.
3. Update `CHANGELOG.md` with a summary of your change, under the pattern already used at the top of the file.
4. Bump the version in `pubspec.yaml`. Until the package reaches 1.0, the second number is the effective major version and the third is the effective minor version: a breaking change or a new feature bumps the second number (`0.18.0` to `0.19.0`), a fix or a chore bumps the third (`0.18.0` to `0.18.1`).
5. Open a pull request describing what changed and why, and link the issue it fixes, if any.
6. Make sure CI passes. It runs `flutter analyze` and `flutter test` against the package and the example app, plus an import check and a check that generated files are up to date.

A maintainer merges your pull request once it is approved and CI passes. Publishing to pub.dev and deploying the example app to GitHub Pages happen automatically from `main`.
