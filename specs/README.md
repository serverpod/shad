# shad 1.0: review and plan

This plan comes from a review of the package at 0.99.4 (HEAD `8ea5a35`), the
`../wonky` apps that use it, and its readiness for pub.dev. It covers what
should change before 1.0, what can wait, and in what order.

| File | Covers |
| --- | --- |
| [01-api.md](01-api.md) | Public API fixes, renames with shims, what is hidden, what is deferred to 2.0, re-exports, dependencies, dartdoc |
| [02-fonts.md](02-fonts.md) | Unbundling Inter/Geist/GeistMono (apps choose their own fonts), Google Fonts at runtime in the example's theme editor |
| [03-new-components.md](03-new-components.md) | Components to upstream from wonky, and shadcn components shad still lacks |
| [04-fixes-from-wonky.md](04-fixes-from-wonky.md) | Shad bugs and gaps that wonky works around, and the wonky code each fix deletes |
| [05-publication.md](05-publication.md) | pubspec, `.pubignore`, README, CHANGELOG, example, CI, goldens |
| [06-wonky-upgrade-guide.md](06-wonky-upgrade-guide.md) | Step-by-step upgrade of the wonky monorepo from 0.99.4 to 1.0, with every affected file |

## Where things stand

The package is in good shape: `flutter analyze` is clean, 606 tests pass,
pana gives 150/160 (format only), and every platform plus WASM is supported.
Nothing needs a redesign. The 1.0 work is cleanup, plus a handful of real
bugs.

## Summary of proposed changes

**Breaking at 1.0, kept to the minimum:**

1. Remove the 40 deprecations that already announce removal in v1.0.0, with
   `dart fix` data for all of them.
2. Stop re-exporting slang. It leaks into every importer and collides with
   apps that use slang themselves.
3. Hide about 30 internal classes, extensions and helpers. Wonky uses none of
   them.
4. Stop bundling fonts (~1.2 MB in every app). The text uses the platform
   font unless the app picks one, through `google_fonts` or its own
   `fonts:` assets. There is no companion font package.
5. `ShadAvatar` gets two constructors, `ShadAvatar(String? src)` for URLs
   and asset paths and `ShadAvatar.image(ImageProvider?)` for anything else.
   This drops `universal_image` and its dependency chain. `IconData` and SVG
   strings stop working as sources.
6. `lucide_icons_flutter` moves 3.x → 4.x (still re-exported).

**Non-breaking fixes (bugs found in review):**

- `ShadThemeData.copyWith(radius:/colorScheme:/textTheme:)` leaves component
  themes stale.
- Generated theme `==` compares lists by identity, which re-animates the
  theme on every rebuild.
- 12 parameters are accepted and documented, but do nothing.
- Esc is swallowed by closed tooltips and popovers.
- All context menus share one tap-region group.
- `ShadButton` notifies listeners during build.
- Dialogs and sheets freeze the theme they opened with.
- Dialog close and barrier have no semantic labels.
- Disabled buttons never show their tooltips.
- Setting controller fields skips `notifyListeners`.
- `ThemeMode` is not exported, so the README snippet does not compile.

**Renames with deprecation shims:** `selectedDayButtonOusideMonthVariant`,
`ShadToggleVariant.default_`, `Shadows`, `GoogleFont*`, `ShadFormBuilderField`,
`ShadToast.duration`, and a few unprefixed constants. These are listed in
01 §B.

**Additions** (03, 04): menu flip/shift, scrolling, open-at-point and
type-ahead; `ShadScrollArea`; `ShadSurface` and `showShadPopover`; a
standalone tabs list; `ShadDropdownMenu`. In 1.x: toolbar with overflow,
tree view, number input, color picker, plus more shadcn gaps.

**Publication** (05):

- Fix the archive: 1.5 MB of golden failure PNGs and internal files ship
  today.
- Resolve the missing font licences: the package's fonts go away, and the
  example's JetBrains Mono gets its OFL file.
- Fix the URLs and the pubspec description.
- Rewrite the example README and add `example.md`.
- Add `MIGRATION.md` and `SECURITY.md`.
- Add a CI publish-on-tag workflow, plus format, dry-run and pana gates.
- Make the goldens actually compare. 52 of 58 never fail today, and 47 are
  stale.

## Release plan

| Release | Contents | Breaking? |
| --- | --- | --- |
| **0.99.5** (1.0 preview) | Every new name and `@Deprecated` shim, `lib/fix_data.yaml`; all non-breaking bug fixes (01 §A3–A8, §A10–A12; 04 §1, 2, 7, 9, 10, 15); archive, pubspec and licence fixes; `dart format`; CI gates | No |
| **0.99.6** | Menu/portal work package (04 §3–6, 8), `ShadScrollArea`, `ShadSurface`/`showShadPopover`, `ShadTabsList`, `ShadDropdownMenu`; theme-freeze fix (04 §11); goldens converted and regenerated on Linux | No (§11 changes behaviour slightly) |
| **1.0.0** | Remove the 40 v1.0 deprecations; hide internals (01 §A9); stop the slang re-export; unbundle fonts; lucide 4.x; avatar without `universal_image`; dartdoc pass; README/MIGRATION/CHANGELOG | Yes, with `dart fix` and `MIGRATION.md` |
| **1.x** | `ShadToolbar` + `ShadOverflowRow`, `ShadTreeView`, `ShadNumberInput`, `ShadColorPicker`, avatar group, kbd group, hover card, drawer, input/button group | No |
| **2.0** | Remove the 0.99.5 deprecations; the 01 §C consistency items | Yes |

Users migrate in three steps: upgrade to 0.99.6, run `dart fix --apply`, and
clear the deprecation warnings. After that, 1.0 needs only the font change
and any slang imports.

For wonky specifically, the migration is roughly:

- move Inter, Geist and GeistMono into wonky's own fonts (`wonky_ui` / `wonky_fonts`) and replace about 12 `packages/shad/...` font strings;
- delete the workarounds listed in 04 (`ToolbarEscapeScope`, `OpenMenu`,
  `WonkyMenuPlacement`, `WonkyPopupMenuHost`, `WonkyDialogCloseButton`,
  about 28 hand-built popover surfaces);
- optionally remove about 195 redundant `size: 16` icon arguments.

## Decisions (settled)

1. **Fonts.** shad ships none, and the default is the platform font. There
   is no `shad_fonts` package. Apps such as wonky handle their own fonts, and
   the example uses Google Fonts at runtime.
2. **lucide.** Keep the full re-export, and move to `^4.0.0` before 1.0. A
   lucide major means a shad major.
3. **Deprecation horizon.** Shims added in 0.99.5 survive all of 1.x and are
   removed in 2.0. Only the 40 deprecations that already say "removed in
   v1.0.0" go at 1.0.
4. **1.0 scope.** The menu work package (04 §3–6, §8), `ShadScrollArea`,
   `ShadSurface`/`showShadPopover`, `ShadTabsList` and `ShadDropdownMenu`
   are must-haves for 1.0.
5. **Goldens.** Convert all 58 to `await expectLater`, review the 47 stale
   diffs, and regenerate on Linux in CI.

The upgrade path for wonky, step by step, is in
[06-wonky-upgrade-guide.md](06-wonky-upgrade-guide.md). The public
`MIGRATION.md` (05 §D) is the generic subset of it.

## Housekeeping noticed during the review

- `analysis_options.yaml` has an uncommitted edit (`analyzer: exclude:
  [build/**]`). It was written by `flutter analyze` during the review, not
  by hand. Its top-level `exclude:` key is also invalid (05 §F). Fix both
  together.
- CLAUDE.md mentions a `cli/` directory that does not exist.
- Wonky's Write app probably renders Inter documents in a fallback font on
  the web, because its build prunes `packages/shad/Inter` (02, "Impact on
  the wonky apps").

## Implementation status (2026-10-29)

Built in one pass on `main` (uncommitted), straight to 1.0.0 rather than
through separate 0.99.5/0.99.6 releases. Every shim the plan put in 0.99.5
is in 1.0.0, so the wonky guide's "If 0.99.5 and 0.99.6 are not published
separately" path applies.

| Spec | Status |
| --- | --- |
| 01 §A1–A12 | Done. A5 changed: two constructors, `ShadAvatar(String? src)` and `ShadAvatar.image(ImageProvider?)`. Wonky's call compiles unchanged. `ShadInputState.editableTextKey` stays public. |
| 01 §B renames | Done, with `lib/fix_data.yaml` and a passing `test_fixes/` golden. |
| 01 §F docs | `public_member_api_docs` enabled; doc pass done by file area. Broken `{@macro}`s fixed. |
| 02 fonts | Done, as revised: no fonts, no `shad_fonts`, Google Fonts in the example with load-before-switch. |
| 03 #1 scroll area, #2 surface + `showShadPopover`, tabs list, dropdown menu | Done. |
| 03 #3–#8 (toolbar, tree view, number input, color picker, multi-segment progress) | Not done; 1.x as planned. |
| 04 §1, 2, 3–6, 7, 8, 9, 10, 11, 14, 15, 16, 18 | Done. §2 makes each root menu's tap group its own, but has no global "one open menu" coordinator. §6 type-ahead reads the item's first `Text`. |
| 04 §12 | Done via 03 #2. |
| 04 §13 | Done: tabs with no content render only the list. |
| 04 §17 | Not done: `ShadInputDecorator` was already public; no new API. |
| 05 | Done, except things that need a person: enabling automated publishing on pub.dev, running `update-goldens.yml` on Linux, and a pana run on the final tree. |
