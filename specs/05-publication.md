# 05 — Publication readiness (pub.dev, README, example, CI)

Current state, measured on clean HEAD `8ea5a35`:

- **pana 0.23.19: 150/160.** Static analysis loses 10 points because
  `lib/src/components/calendar.dart` and `time_picker.dart` do not match
  `dart format`. The live pub.dev score for 0.99.4 is 160, because pub.dev's
  formatter has not yet caught up with the current SDK.
- **`flutter test`: 606 passed, 0 failed** (about 18 s).
- **`flutter pub publish --dry-run`:** the archive is 2 MB compressed. Its
  one warning was an uncommitted `analysis_options.yaml` edit (see below).
- **Goldens:** 52 of 58 `matchesGoldenFile` assertions are unawaited
  `expect`s. They never fail, and **47 of them currently mismatch** without
  any report.

## A. Archive contents (`.pubignore`)

`.pubignore` replaces `.gitignore` for publishing, so everything that only
`.gitignore` excludes ships.

| Problem | Fix |
| --- | --- |
| `test/src/components/failures/` (208 PNGs, 1.3 MB) ships | add `failures/` |
| `example/test/failures/*.png` is **tracked in git** | `git rm -r example/test/failures` |
| `CLAUDE.md`, `build.yaml`, `scripts/`, `specs/` ship | add them (internal) |
| `fonts/` ships | moot after 02 |
| `example/fonts/` (1 MB JetBrains Mono, no OFL file) ships | exclude it, or add its OFL. It is needed only to run the docs site. |
| `fonts.zip` entry is stale; `build` etc. unanchored | clean up and anchor (`/build/`) |
| `skills/` ships | keep it (the README advertises it), but fix its content (§F) |

Add a CI step: `flutter pub publish --dry-run`, failing on warnings.

## B. pubspec.yaml

| Field | Change |
| --- | --- |
| `version` | `1.0.0` |
| `description` | It says "…and theme editor", but the editor is in the example. Proposed: *"A high-fidelity Flutter port of shadcn/ui: 40+ components, all eight shadcn styles and 16 color schemes, with no Material or Cupertino dependency."* (~150 chars) |
| `homepage` | `https://serverpod.dev/open-source` returns 405 to HEAD requests, and pana flags it. Use `https://shad.serverpod.dev/`. |
| `documentation` | `serverpod.github.io/shad` redirects to **http**. Use `https://shad.serverpod.dev/`. |
| `issue_tracker` | add explicitly |
| `topics` | add a 5th: `widgets` |
| `screenshots` | add `assets/screenshot.png` with a description |
| dependencies | normalise to `^` with real floors (`collection: >=1.0.0` is meaningless). Remove `flutter_svg` and `vector_graphics` (0 imports in `lib/`). Fix the misplaced `# used by Table` comment. See 01 §Dependencies for re-exports and the lucide 4.x bump. |
| `flutter: fonts:` | removed (02) |
| environment | Keep `>=3.41.0`, but add a CI job on 3.41.x so that the floor is tested. |

## C. README.md

- **The usage snippet does not compile.** `ThemeMode` is Material-only and
  is not re-exported, and `Scaffold` is a Material widget. Fixes:
  - re-export `ThemeMode` from the barrel
    (`export 'package:flutter/material.dart' show ThemeMode;` is not allowed
    by the import rule, so put the export in `lib/src/app.dart`, which is
    exempt);
  - replace `Scaffold` with `ShadApp`'s home and a `Center`, or a
    `ShadSidebarScaffold`.
  - Add a test that compiles the README snippet (copy it into
    `test/readme_snippet_test.dart` and keep them in sync), so this cannot
    rot again.
- New sections:
  - **Fonts** (from 02);
  - **Platform support** (all six, WASM-ready) and the minimum Flutter
    version;
  - **Versioning**: semver from 1.0; deprecations survive one minor at
    least and are removed only in a major; visual changes that match the
    reference better are not considered breaking. Say it explicitly.
  - **Migrating to 1.0**, linking to `MIGRATION.md`;
  - **Not yet available**: the shadcn components still missing (03), so
    their absence reads as deliberate;
  - a link to `example/`.
- Run the `documentation-writing` skill over the README and the guides
  before release.

## D. CHANGELOG, LICENSE, CONTRIBUTING, SECURITY

- **CHANGELOG:**
  - a `## 1.0.0` entry with *Breaking changes* (removed deprecations, fonts,
    lucide 4) and a link to `MIGRATION.md`;
  - note that `0.99.0` continued from `flutter-shadcn-ui` 0.57, and link to
    its changelog;
  - expand the 0.99.1 one-liner.
- **New `MIGRATION.md`:** 0.99 → 1.0, generated from the 01 tables.
- **LICENSE:** fine. MIT, with the original 2023 notice kept. The
  unlicensed bundled fonts go away with 02. Only `example/fonts/` still
  needs an OFL file.
- **CONTRIBUTING.md:**
  - It claims that publishing happens automatically from main. Nothing
    publishes; fix the claim after §G.
  - It names only `app.dart` as import-exempt; `theme_scope.dart` is exempt
    too.
  - It says to add defaults to *both* variants. Per CLAUDE.md, only the
    parent gets them.
  - Rewrite the pre-1.0 versioning rule. The PR template has the same text.
- **SECURITY.md:** add one with a disclosure contact, or state that the org
  `.github` policy applies.
- **CLAUDE.md:** remove the stale `cli/` references. There is no `cli/`
  directory.

## E. Example app (pub.dev "Example" tab)

pub.dev shows `example/lib/main.dart`. That file is the whole docs site
(disco, solidart, Material, `CodeHighlighter`, app-shell imports), which is
a poor first impression.

- Add `example/example.md`. pub.dev and pana prefer it over `main.dart`. It
  should hold:
  - a short, compiling sample: `ShadApp` + `ShadThemeData(style:,
    colorScheme:)` + a `ShadCard` holding an input and a button;
  - a second snippet with fonts;
  - links to the live docs.
- Rewrite `example/README.md` (currently Flutter boilerplate) and fix the
  pubspec description "A new Flutter project.". Include how to run the
  example, the macOS network entitlement for `google_fonts`, and the
  `test_driver` entry point.
- Remove unused dependencies: `get`, `awesome_flutter_extensions`,
  `collection`, `boxy` (0 imports each).
- Align the example SDK floor (`>=3.9.0`) with the package (`>=3.11.0`).

## F. Docs quality

- **Dartdoc:**
  - The documented share is 71.9% (pana counts it). Enable
    `public_member_api_docs` and get to 100% for 1.0, or at least for every
    `Shad*` widget and theme.
  - Fix the 145 dartdoc warnings: unresolved `[popover]`, `[onEnter]`,
    `[onExit]` and `[child]` in templates; the undefined macro
    `ShadBreadcrumbDropMenuItem`; the unescaped `[FadeEffect(), ...]`; three
    bare `/// @macro` lines in `form/fields/time_picker.dart` (35, 198, 386)
    that should be `{@macro ...}`.
  - The SDK's `dart doc` (9.0.6) **crashes** on this package with a
    `RangeError` in `_stripDocImports`. pana's dartdoc succeeds, so pub.dev
    will build. Bisect it anyway (likely a re-exported library or an odd doc
    comment), since contributors cannot preview docs locally.
  - Normalise CRLF line endings in `lib/src/theme/text_theme/theme.dart` (692
    lines), and add `.gitattributes` with `* text=auto eol=lf`.
- **`analysis_options.yaml`:**
  - The top-level `exclude:` key is ignored. It must sit under `analyzer:`.
    Generated `*.g.dart` files are therefore currently analysed.
  - There is an **uncommitted** working-tree edit adding
    `analyzer: exclude: [build/**]`, made during this review by someone
    else. Merge both into one `analyzer.exclude`.
- **`skills/`:**
  - `guides/typography.md` says Geist is the default font (it is Inter, and
    after 02 it is the platform font).
  - Regenerate with `scripts/generate_skills.dart` and review it after the
    API changes in 01.

## G. CI

| Gap | Fix |
| --- | --- |
| No publish workflow | `publish.yaml`: on tag `v[0-9]+.[0-9]+.[0-9]+*`, `permissions: id-token: write`, `flutter pub publish --force`. Enable automated publishing on pub.dev for the repository and tag pattern. `create-release.yaml` already tags `v$VERSION` with a PAT, so that triggers it. |
| No format gate | `dart format --output=none --set-exit-if-changed lib test example/lib` |
| No dry-run / pana gate | add both (pana with `--exit-code-threshold 0`) |
| No minimum-Flutter job | add a 3.41.x matrix entry |
| build_runner drift check is weak | Add `--delete-conflicting-outputs`, fail on `git diff --exit-code`, and include `dart run slang` |
| `update-goldens.yml` is likely broken | `actions/upload-artifact` is labelled v3 (shut down January 2025), and its SHA is the same as `upload-pages-artifact`'s. Move to v4 with a correct SHA. |
| `Wandalen/wretry.action@v3.8.0` is not SHA-pinned | pin it |
| Example built only on main | build web on PRs |

## H. Goldens

The CLAUDE.md "known, unstarted job". It has to happen before 1.0. Freezing
a visual contract that no test checks is worse than having no goldens.

1. Convert all 52 to `await expectLater(...)`.
2. Generate the goldens on **Linux** through `update-goldens.yml` (after it
   is fixed), not on macOS. Commit the CI artifacts.
3. Review the 47 current diffs before regenerating. Each one is either an
   intended change since the PNG was made, or a regression. Treat the review
   as a QA pass.
4. Optional: add a lint or test that greps for `expect(` +
   `matchesGoldenFile` and fails, so that the bug cannot come back.
5. Delete `test/tolerant_golden_comparator.dart` if it is no longer needed
   once the goldens are Linux-generated.
