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
5. Add the component's default values to `lib/src/theme/themes/default_theme_variant.dart`. `ShadDefaultThemeNoSecondaryBorderVariant` subclasses it and overrides only the focus treatment, so touch the subclass only when the change is about focus geometry.
6. Add the theme to `test/src/theme/theme_data_equality_test.dart`.
7. Add a documentation page: an example under `example/lib/docs/examples/<slug>/`, a `ComponentDoc` in `example/lib/docs/pages/<slug>.dart`, and an entry in `example/lib/docs/registry.dart`.
8. Regenerate the component's skill page: `dart run scripts/generate_skills.dart`.
9. Add tests under `test/src/components/`.

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

- Run `dart format lib test example/lib example/test` before committing. CI fails on unformatted files.
- `flutter analyze` must report no issues. The package follows `very_good_analysis`; see `analysis_options.yaml` for project-specific overrides.
- Nothing under `lib/` may import `material.dart`, `cupertino.dart`, or the package's own barrel (`package:shad/shad.dart`). `lib/src/app.dart` and `lib/src/theme/theme_scope.dart` are the only exceptions (Material and Cupertino interop). CI enforces this.
- Add or update a doc comment (`///`) on every public member you add or change.
- Do not add comments that only restate what the code does. Add a comment when the code cannot explain its own intent, a trade-off, or a constraint.

## Tests

- New behavior needs a test. Bug fixes should include a test that fails before the fix and passes after.
- Prefer asserting resolved theme values over pixels or golden images.
- Use `matchesGoldenFile` only with `await expectLater(...)`. An unawaited `expect` never reports a mismatch.
- Goldens are generated and compared on Linux only. On macOS and Windows the suite skips pixel comparison. To update goldens, run the **Update goldens (Linux)** workflow on your branch and commit the `updated-goldens` artifact.
- Popover-based components animate their entrance behind an `IgnorePointer`. Pump about 12 frames of 50 ms before interacting with one in a test.

## Commit and pull request process

1. Fork the repository and create a branch for your change.
2. Make your change, following the conventions above.
3. Update `CHANGELOG.md` with a summary of your change, under the pattern already used at the top of the file.
4. Do not bump the version in `pubspec.yaml`; maintainers do that when they cut a release. The package follows [semantic versioning](https://semver.org/): breaking changes only in a major version, new features in a minor, fixes in a patch. To rename or remove public API, keep the old name with `@Deprecated('Use X instead. Will be removed in the next major version.')` and add an entry to `lib/fix_data.yaml`, so `dart fix` migrates callers.
5. Open a pull request describing what changed and why, and link the issue it fixes, if any.
6. Make sure CI passes. It runs `flutter analyze` and `flutter test` against the package and the example app, plus an import check and a check that generated files are up to date.

A maintainer merges your pull request once it is approved and CI passes. The example app deploys to GitHub Pages from `main`. A release is published when a maintainer bumps the version: the tests pass on `main`, `create-release.yaml` tags `v<version>`, and `publish.yaml` publishes that tag to pub.dev.
