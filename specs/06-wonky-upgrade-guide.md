# 06 — Upgrading wonky from shad 0.99.4 to 1.0

This guide is for the `../wonky` monorepo. It lists every place where wonky
touches something that changes between 0.99.4 and 1.0, in the order it is
safest to change them. Paths are relative to the wonky root. Counts come
from a grep of all Dart files outside `build/`, `.dart_tool/` and
`third_party/`, run on 2026-10-29 against wonky's working tree.

The public `MIGRATION.md` (05 §D) is the generic subset of this guide.

## Overview

| Step | When | shad version | Effort | Required? |
| --- | --- | --- | --- | --- |
| 1. Own the fonts | **Now**: works on 0.99.4 already | any | ½ day | Yes, before 1.0 |
| 2. Upgrade to 0.99.5, then `dart fix` | at 0.99.5 | 0.99.5 | 1 hour | Yes |
| 3. Upgrade to 0.99.6 and delete workarounds | at 0.99.6 | 0.99.6 | 1–2 days | No, but it is most of the value |
| 4. Upgrade to 1.0 | at 1.0 | 1.0.0 | 1 hour | Yes |
| 5. Optional clean-ups | any time after step 2 | ≥0.99.5 | ½ day | No |

**What wonky does *not* need to change:**

- **Removed deprecations:** none of the 40 deprecations removed at 1.0 are
  used.
- **slang:** wonky uses `gen-l10n`.
- **Hidden internals:** none are used. The one exception is
  `ShadInputState.editableTextKey`, which stays public because of wonky
  (see step 4).
- **Renames:** none of the renamed identifiers (`Shadows`,
  `ShadToggleVariant.default_`, `…OusideMonth…`, `ShadFormBuilder*`,
  `onLineCountChange`, `GoogleFont*`) are used, except the two listed in
  step 2.

## Testing against an unreleased shad

Wonky resolves shad from pub.dev. Every pubspec pins `shad: ^0.99.4`. To try
a shad branch before it is published, add a path override to
`pubspec_overrides.yaml`. That is the Flutter-only overrides file; never put
the override in the root `pubspec.yaml`, which Serverpod Cloud reads.

```yaml
dependency_overrides:
  # TEMPORARY: local shad for the 1.0 upgrade. Remove before merging.
  shad:
    path: ../shad
```

Then run `flutter pub get` at the wonky root. Remove the override once the
version is on pub.dev, and bump the eight `shad:` constraints instead:

- `wonky_write/pubspec.yaml`
- `wonky_sheets/pubspec.yaml`
- `wonky_slides/pubspec.yaml`
- `wonky_drive/pubspec.yaml`
- `packages/wonky_app/pubspec.yaml`
- `packages/wonky_ui/pubspec.yaml`
- `packages/wonky_rich_editor/pubspec.yaml`
- `packages/wonky_charts_flutter/pubspec.yaml`

---

## Step 1 — Own the fonts (do this first, on 0.99.4)

shad 1.0 ships no fonts (02). Wonky uses all three of shad's faces:

- **Geist** is the UI font;
- **Geist Mono** is the UI mono font;
- **Inter** is the default document font in Write, the cell and chart font in
  Sheets and Charts, and a fallback.

This step moves them into wonky. It works on 0.99.4 already, so it can land
before any shad upgrade, and step 4 then has nothing font-related left to
do.

### 1a. Add the font files

Copy the variable TTFs from shad's 0.99.4 package. They are in the pub cache
at `~/.pub-cache/hosted/pub.dev/shad-0.99.4/fonts/`:

| File | Goes to | Why there |
| --- | --- | --- |
| `Geist[wght].ttf` | `packages/wonky_ui/fonts/` | UI font, needed at startup |
| `GeistMono[wght].ttf` | `packages/wonky_ui/fonts/` | UI mono, needed at startup |
| `Inter[opsz,wght].ttf` | `packages/wonky_fonts/fonts/` | screen-only document font, loaded on demand |

Add the licences next to the files: `OFL-Geist.txt` (from
github.com/vercel/geist-font) and `OFL-Inter.txt` (from github.com/rsms/inter).
Add both to `BundledFonts.licenseFiles` in
`packages/wonky_fonts/lib/src/bundled_fonts.dart:145`. Also register them
with `LicenseRegistry.addLicense`, wherever wonky already does that for the
`wonky_fonts` licences.

### 1b. Geist and Geist Mono: declare under `wonky_ui`'s `fonts:`

Every wonky app shows its UI in Geist from the first frame, so declaring
them eagerly costs nothing extra: the web build already downloads shad's
Geist today.

```yaml
# packages/wonky_ui/pubspec.yaml
flutter:
  fonts:
    - family: Geist
      fonts:
        - asset: fonts/Geist[wght].ttf
    - family: GeistMono
      fonts:
        - asset: fonts/GeistMono[wght].ttf
```

Then add one place that owns the names, next to `WonkyTheme`:

```dart
// packages/wonky_ui/lib/src/theme/wonky_fonts.dart
/// The UI font families bundled by `wonky_ui`.
abstract final class WonkyUiFonts {
  static const sans = 'packages/wonky_ui/Geist';
  static const mono = 'packages/wonky_ui/GeistMono';
}
```

Export it from `wonky_ui.dart`.

### 1c. Inter: a lazy screen-only face in `wonky_fonts`

Inter must stay lazy. `tool/prune_web_fonts.dart` exists because shad's
eager Inter cost the web builds of Drive and Write about 877 KB each.

- `BundledFonts.faces` is documented as **static instances only**, because
  the `pdf` package cannot embed variable fonts. So do not add Inter there.
  Add a separate screen-only list to `bundled_fonts.dart` instead:
  ```dart
  /// Variable faces for on-screen rendering only (never embedded in PDFs).
  static const List<BundledFontFace> screenFaces = [
    BundledFontFace(inter, 400, 'Inter[opsz,wght].ttf'),
  ];
  static const inter = 'Inter';
  ```
  The `weight` field is nominal for a variable face. Flutter ≥3.41 drives
  the `wght` axis from `FontWeight`.
- Register it on demand with the `FontLoader` paths that already exist:
  - `WriteFonts.ensureLoaded` (`wonky_write/lib/features/themes/write_fonts.dart`)
  - `packages/wonky_app/lib/src/fonts/asset_font_registry.dart`
  - `wonky_sheets/lib/features/formatting/cell_fonts.dart`

  Use the family name `'Inter'`. Loading must happen before first use. Where
  Inter is a default (Write's body, Sheets' cells, charts), load it during
  app startup next to the other `ensureLoaded` calls. It is then fetched
  only by the apps that use it, and only once.

### 1d. Replace every shad font reference

| Location | Today | Replace with |
| --- | --- | --- |
| `packages/wonky_ui/lib/src/theme/wonky_theme.dart:95` | `ShadTextTheme(family: 'Geist', package: 'shad')` | `ShadTextTheme(family: WonkyUiFonts.sans)` |
| `packages/wonky_ui/lib/src/theme/wonky_theme.dart:71` | `monoFamily = kDefaultFontFamilyMono` | `monoFamily = WonkyUiFonts.mono`. This covers the ~30 `WonkyTheme.monoFamily` uses with no further changes. |
| `packages/wonky_ui/lib/src/widgets/sync_status/sync_status.dart:244` | `'packages/shad/GeistMono'` | `WonkyTheme.monoFamily` |
| `packages/wonky_app/lib/src/mcp_bridge/developer_settings.dart:264, 308, 352` | `'packages/shad/GeistMono'` | `WonkyTheme.monoFamily` |
| `packages/wonky_app/lib/src/publications/publications_section.dart:441` | `'packages/shad/GeistMono'` | `WonkyTheme.monoFamily` |
| `wonky_sheets/lib/features/data_validation/dv_panel.dart:901` | `'packages/shad/GeistMono'` | `WonkyTheme.monoFamily` |
| `wonky_sheets/lib/features/conditional_format/cf_panel.dart:1167` | `…, package: 'shad'` | drop `package:`; family `WonkyTheme.monoFamily` |
| `wonky_sheets/lib/features/formatting/formula_field.dart:309, 330` | `…, package: 'shad'` | same |
| `wonky_sheets/lib/features/number_format/custom_date_time_dialog.dart:335` | `…, package: 'shad'` | same |
| `wonky_sheets/lib/features/number_format/custom_number_format_dialog.dart:177` | `TextStyle(fontFamily: 'GeistMono', package: 'shad')` | `TextStyle(fontFamily: WonkyTheme.monoFamily)` |
| `wonky_sheets/lib/features/formatting/cell_fonts.dart:210, 212, 214, 234` | `'packages/shad/Inter'`, `'…/Geist'`, `'…/GeistMono'`, fallback list | `'Inter'` (lazy, 1c), `WonkyUiFonts.sans`, `WonkyUiFonts.mono` |
| `wonky_sheets/lib/features/filters/filter_layers.dart:295` | `'packages/shad/Inter'` | `'Inter'` |
| `wonky_write/lib/features/themes/write_fonts.dart:37-39` | `shadInter/shadGeist/shadGeistMono` | rename to `inter/geist/geistMono` = `'Inter'`, `WonkyUiFonts.sans`, `WonkyUiFonts.mono`; update `screenFamilyFor` |
| `packages/wonky_charts_flutter/lib/src/render/chart_painter.dart:14, 17-18, 24-26, 37-39` | `'packages/shad/…'` | the same three names. `wonky_charts_flutter` gains a dependency on `wonky_ui` (for `WonkyUiFonts`) or `wonky_fonts`, or takes the family names as constants. Prefer the constants, to keep charts free of `wonky_ui`. |
| `wonky_write/test/features/screen/support/shad_fonts.dart:8-9` | loads `packages/shad/fonts/Geist[wght].ttf` | load `packages/wonky_ui/fonts/Geist[wght].ttf` under `WonkyUiFonts.sans`. Rename the file to `ui_fonts.dart`. |
| `tool/prune_web_fonts.dart:11-13, 25-30, 40` | prunes `packages/shad/Inter` for drive and write | delete the `_shadInter` rule and its doc lines. Nothing ships Inter eagerly any more. |

Verify there are no stragglers:

```bash
grep -rnE "packages/shad/|package: 'shad'|kDefaultFontFamily" --include='*.dart' --exclude-dir=build --exclude-dir=.dart_tool .
```

### 1e. A probable bug fixed on the way

`prune_web_fonts.dart` removes `packages/shad/Inter` from the **Write** web
build. The comment there says only chart text uses Inter. But
`WriteFonts.screenFamilyFor('Inter')` returns `packages/shad/Inter`, and
Inter is Write's default body and heading font (`FontRegistry.defaultBody`).
So Write documents most likely render in the platform fallback on the web
today. After 1c, Inter loads lazily wherever it is needed, so this goes
away. Check it in a Write web build: open a new document and check the
computed font of body text.

### 1f. Verify step 1

- Run `flutter analyze` and `flutter test` in `packages/wonky_ui`,
  `packages/wonky_app`, `packages/wonky_charts_flutter`, `wonky_write` and
  `wonky_sheets`.
- Run a web build of each app, and check `build/web/assets/FontManifest.json`.
  It should list no `packages/shad/*` families, and should list
  `packages/wonky_ui/Geist` and `packages/wonky_ui/GeistMono`.
- Check the goldens and screenshots that render UI text. They should be
  unchanged, because the files are the same.

---

## Step 2 — Upgrade to 0.99.5 and run `dart fix`

0.99.5 adds new names and deprecation shims (01 §A3, §A7, §B) plus bug
fixes. Nothing is removed. Bump the eight constraints to `^0.99.5`, then
run `dart fix --apply` at the wonky root.

### 2a. Deprecation warnings wonky will see

| Location | Old | New | Handled by `dart fix`? |
| --- | --- | --- | --- |
| `packages/wonky_app/lib/src/core/toasts.dart:37-49` (2×, plus the progress toast at `:73`) | `ShadToast(duration: …)` / `ShadToast.destructive(duration: …)` | `displayDuration:` | yes |
| `packages/wonky_ui/lib/src/widgets/presence/avatar.dart:83` | `ShadAvatar(imageUrl, …, placeholder: fallback)` | `ShadAvatar(imageUrl, …, fallback: fallback)` | yes. `src` keeps working: URL strings become a `NetworkImage`. |

That is the complete list. Everything else wonky uses keeps its name.

### 2b. Bug fixes in 0.99.5 that change behaviour wonky can see

None of these break wonky. Check each one, because some wonky code was
written around the old behaviour.

- **Esc no longer swallowed by closed tooltips and popovers** (04 §1).
  Wonky has about 200 `ShadTooltip`s and 19 `ShadPopover`s. Esc now reaches
  enclosing dialogs and routes even when focus is inside a tooltip trigger.
  Some of wonky's ~98 hand-written Esc bindings may now fire where they did
  not before. Run the keyboard tests in each app.
- **Per-menu tap groups** (04 §2). Tapping another menu's trigger now closes
  the open menu. Wonky's `OpenMenu` slot still works on top of this; delete
  it in step 3.
- **`ShadButton` no longer notifies during build** (04 §7). The
  `_stableEnabled` re-keying in
  `packages/wonky_ui/lib/src/widgets/menu/menu_items.dart:359-371` is now
  unnecessary, but harmless.
- **Dialog close button** gets a semantic label and uses `maybePop()`
  (04 §9). Wonky passes its own `closeIcon:` (72 places), so nothing changes
  until step 3.
- **Default barrier label** is a localized "Dismiss" (04 §10). Wonky's 7
  explicit `barrierLabel:` values still win.
- **Disabled buttons show their tooltips** (04 §15). Tooltips on disabled
  buttons that never showed before now show. Check that their text makes
  sense; this mostly affects toolbars.
- **`ShadThemeData` list equality** (01 §A11). This can only reduce
  rebuilds.
- **`brightness` follows the color scheme** when not given (01 §A12). Wonky
  always passes it (`wonky_theme.dart:90`), so nothing changes.

### 2c. Verify step 2

- Run `flutter analyze` at every wonky package. There should be no
  `deprecated_member_use` warnings for shad APIs.
- Run the full test suite.

---

## Step 3 — Upgrade to 0.99.6 and delete workarounds

0.99.6 adds the menu and portal work (04 §3–6, §8), `ShadScrollArea`,
`ShadSurface`/`showShadPopover`, `ShadTabsList` and `ShadDropdownMenu`, and
fixes the theme freeze (04 §11). Nothing is required here. Each item below
is wonky code that becomes deletable. Do them one at a time, with a test run
between each.

| # | Delete or replace in wonky | Because shad now | Notes |
| --- | --- | --- | --- |
| 3.1 | `ToolbarEscapeScope` (`packages/wonky_ui/lib/src/widgets/toolbar/toolbar.dart:746-765`); review the hand-written Esc bindings that wrap tooltips and popovers | stops swallowing Esc (0.99.5) | Grep `LogicalKeyboardKey.escape` and remove the bindings whose only job was to get past a shad tooltip or popover. |
| 3.2 | `OpenMenu` (`packages/wonky_ui/lib/src/widgets/menu/open_menu.dart`) and its claims in `dropdown_menu.dart:193-200`, the menubar, the context region and `popup_menu_host.dart` | closes the open menu when another opens | |
| 3.3 | `WonkyMenuPlacement.onScreen` and the hard-coded submenu offsets (`packages/wonky_ui/lib/src/widgets/menu/menu_placement.dart:24-59`) | flips and shifts every anchor, including submenus horizontally | **Remove this before 3.4.** If it stays, wonky pre-flips and shad flips again, which is harmless but redundant. Check `TODO.md:245` (right-edge submenus cover their parent); it should be fixed. |
| 3.4 | `itemsMaxHeight*`, `buildWonkyMenuItems(maxHeight:)`, and the `chrome = 10.0` constants (`menu_placement.dart:15-16, 61-82`, `menu_items.dart:340-357`, `popup_menu_host.dart:50-51`) | caps menus to the available height and scrolls them | |
| 3.5 | `WonkyPopupMenuHost`'s off-screen render, measure and reposition (`popup_menu_host.dart:40-43, 105-140`) and its cached entries (`:31-36`) | `ShadContextMenuController.showAt(offset)` and `itemsBuilder` | |
| 3.6 | Items passed only while open (`dropdown_menu.dart:121, 227-236`), type-ahead and `requestFocus` (`menu_items.dart:8-20`), forced focus on pointer open (`menubar/menubar.dart:232-236`) | has `itemsBuilder`, focus-on-open and type-ahead | Consider rebuilding `WonkyDropdownMenu` on `ShadDropdownMenu`. |
| 3.7 | The `ClipRect` around the menubar (`menubar/menubar.dart:205-208`) | has `ShadMenubarTheme.shadows` | Pass `shadows: const []`. |
| 3.8 | `_stableEnabled` (`menu_items.dart:359-371`) | no longer notifies during build (0.99.5) | |
| 3.9 | `WonkyDialogCloseButton` (`packages/wonky_ui/lib/src/widgets/dialog/dialog_close_button.dart`), passed as `closeIcon:` 72 times | has a labelled close button that respects `PopScope` (0.99.5) | Where it was passed with `onPressed: _cancel` (e.g. `wonky_write/lib/features/tables/table_editor.dart:446`), use `ShadDialog(onClose: _cancel)`. Keep its test only if wonky keeps a custom icon. |
| 3.10 | `_HoverReport` (`packages/wonky_app/lib/src/board/pages/board_widgets.dart:393-411`) | shows tooltips on disabled buttons (0.99.5) | |
| 3.11 | `showAnchoredPopoverAt` (`packages/wonky_app/lib/src/shell/anchored_popover.dart`) and Write's wrapper (`wonky_write/lib/features/screen/anchored_popover.dart`) | has `showShadPopover(anchorRect:)` | Keep the wrapper signature, and reimplement it as a one-line call. |
| 3.12 | About 28 hand-built popover surfaces (`colorScheme.popover` + `BoxShadow` + `Border.all(border)`), e.g. `CellPopoverSurface` (`wonky_sheets/.../in_cell/cell_cards.dart:100-128`), `cell_editor_overlay.dart:165`, `formula_assist.dart:160`, `wonky_write/.../selection_toolbar.dart:276`, `packages/wonky_app/lib/src/find/find_bar.dart:168`, `comments_panel.dart:715`, `wonky_charts_flutter/.../chart_tooltip.dart:84` | has `ShadSurface(kind: ShadSurfaceKind.popover)` | Visible change: the outline becomes shadcn's `foreground/10` ring, and the shadow loses its clipping artefact. Check the affected goldens. |
| 3.13 | `_Segmented` (`wonky_write/lib/features/theme_editor/theme_editor_screen.dart:1223-1270`) and the board tab strip (`packages/wonky_app/lib/src/board/pages/board_chrome.dart:~565-605`) | has `ShadTabsList` | |
| 3.14 | `EditorSection`'s hand-built accordion (`wonky_sheets/lib/features/charts/editor/chart_editor_widgets.dart:303-345`) | has `ShadAccordionItem.trailing` | |
| 3.15 | Manual label ellipsizing in `form_dialog.dart:796-805` and `board_report_dialog.dart:1064-1075` | stacked dialog actions ellipsize | |
| 3.16 | The merged input/textarea decoration around super_editor (`WonkyRichEditor`, `markdown_composer.dart:16-18`) | has `ShadInputDecorator` | |
| 3.17 | `WonkyScrollArea` (`packages/wonky_ui/lib/src/widgets/scroll_area/scroll_area.dart`) | has `ShadScrollArea` | Keep a thin wrapper only if wonky wants the edge shadows (`edgeShadows: true` in shad). |
| 3.18 | The theme freeze on open drawers (`TODO.md:379-381`) | sheets and dialogs follow theme changes | Nothing to delete; close the TODO. |

Later 1.x releases add `ShadOverflowRow`/`ShadToolbar`, `ShadTreeView`,
`ShadNumberInput` and `ShadColorPicker`, all upstreamed from `wonky_ui`.
When each one ships, swap wonky's version for shad's, behind wonky's
existing widget name if that keeps call sites unchanged.

### 3.x Verify step 3

- Run the full test suite, including the a11y tests. 3.9 and the barrier
  labels change semantics trees.
- Do a manual pass over:
  - every menu: menubar, dropdowns, context menus, submenus near the right
    edge, long menus in short windows;
  - Esc in dialogs with tooltips;
  - a light/dark switch with the Drive drawer open.

---

## Step 4 — Upgrade to 1.0

Bump the eight constraints to `^1.0.1`. After steps 1–3 the only breaking
changes in 1.0 that could reach wonky are these:

| Change | Wonky impact |
| --- | --- |
| Fonts unbundled | none, after step 1 |
| `kDefaultFontFamily`/`Mono` deprecated, pointing at nothing | none, after step 1 |
| 40 old deprecations removed | none (0 uses) |
| slang no longer re-exported | none (0 uses) |
| Internals hidden (01 §A9) | none, but see below |
| `lucide_icons_flutter` 3 → 4 | **check renamed icons**, see below |
| `ShadAvatar` drops `universal_image`: `ShadAvatar(String? src)` for URLs and asset paths, `ShadAvatar.image(ImageProvider?)` for the rest | none: wonky passes a URL string |
| 1.0.1: Material/Cupertino opt-in, `ShadThemeMode` | **`themeMode` and a `ShadMaterial`**, see below |

**Material and Cupertino (1.0.1).** shad's core no longer imports them, so
`ShadApp` stops providing a Material theme and Material localizations.
Wonky uses Material widgets (`Material` in `image_lightbox.dart` and
`file_preview_screen.dart`, and Material imports across `wonky_write`'s
editor), so:

1. In `wonky_app/lib/src/shell/wonky_shell.dart`, wrap the app:
   `ShadApp.router(builder: (context, child) => ShadMaterial(child: child!), ...)`,
   with `import 'package:shad/material.dart';`. If the shell already passes
   a `builder`, put the `ShadMaterial` innermost, inside any
   `Directionality` or `MediaQuery` it sets.
2. `PreferencesController.themeMode` returns Material's `ThemeMode`. Make it
   return `ShadThemeMode` (same three values), or convert where `ShadApp`
   takes it.
3. Do the same in `wonky_ui`'s `WonkyPreviewApp` and `testing.dart`, and in
   every test that pumps its own `ShadApp` (`wonky_write/test/...`:
   `screen_pump.dart`, `screen_harness.dart`, the theme-editor, print-preview,
   a11y, AI-overlay and perf tests). Those that import
   `ThemeMode` from `material.dart` switch to `ShadThemeMode`.
4. Search for `materialThemeBuilder`, `shadMaterialThemeFrom` and
   `applyMaterialTheme`. There were no uses at the time of writing.

Any test that fails with "No MaterialLocalizations found" or "No Material
widget found" is missing the `ShadMaterial`.

**`ShadInputState.editableTextKey` stays public.** It was on the list of
internals to hide, but `wonky_slides/lib/features/outline_view/outline_view.dart:752, 1029`
uses it to hit-test misspelled words through `renderEditable`. 1.0 keeps it,
and documents it as the supported way to reach the `EditableTextState`.
01 §A9 is updated to match.

**Lucide 4.** Wonky uses `LucideIcons.` 2,204 times. It uses them through
shad's re-export, with no direct dependency on `lucide_icons_flutter`.
`wonky_slides_core` also has its own lucide glyph table
(`lucide_glyphs.dart`, `lucide_glyphs.g.dart`) and the stroke-weight font
families `Lucide100`–`Lucide600`. To find what breaks before the upgrade:

```bash
# Icons wonky uses
grep -rhoE "LucideIcons\.[a-zA-Z0-9_]+" --include='*.dart' --exclude-dir=build . | sort -u > /tmp/wonky_icons.txt
# Icons lucide_icons_flutter 4 defines (after `flutter pub get` with shad 1.0)
grep -hoE "static const IconData [a-zA-Z0-9_]+" ~/.pub-cache/hosted/pub.dev/lucide_icons_flutter-4.*/lib/lucide_icons.dart \
  | awk '{print "LucideIcons."$4}' | sort -u > /tmp/lucide4.txt
comm -23 /tmp/wonky_icons.txt /tmp/lucide4.txt   # used by wonky, gone in 4
```

Look up each missing name in Lucide's rename list (lucide.dev, "aliases").
Then regenerate `wonky_slides_core`'s glyph table against the 4.x font, and
check that `prune_web_fonts.dart`'s `_lucideWeights` family names still
match what lucide 4 declares.

### Verify step 4

- Run `flutter analyze` and the full test suite.
- Run web builds of all four apps, then rerun the `FontManifest.json` check
  from 1f.
- Remove the `shad` path override from `pubspec_overrides.yaml` if it is
  still there.

---

## Step 5 — Optional clean-ups (any time after step 2)

- **Redundant icon sizes.** There are 252 matches of `Icon(…, size: 14|16)`.
  Since 0.99.4, buttons pass their icon size down through `IconTheme`
  (CLAUDE.md, "Icon sizes inside buttons are a token"). Remove `size:` only
  where it equals what the button gives:
  - **16** inside a default-size `ShadButton`, `ShadIconButton`, or the
    `sm` icon button (`iconButtonIconSizeSm` stays 16 in vega);
  - **14** inside an `sm` *text* button (`buttonIconSizeSm`);
  - keep it everywhere else: icons outside buttons, in `ShadToggle` until
    04 §18 lands, and in the status bar's deliberate `IconTheme.merge(size: 14)`.

  Rerun the goldens afterwards; any diff means the size was not redundant.
- **Explicit barrier labels.** The 7 explicit `barrierLabel:` values can go
  if shad's localized "Dismiss" is acceptable. Wonky's strings are more
  specific ("Close image"), so keeping them is also fine.
- **`WonkyThemeScope` scrollbar thickness.** Once `WonkyScrollArea` is gone
  (3.17), drop `WonkyThemeExtension.scrollbarThickness` if nothing else
  reads it.

---

## If 0.99.5 and 0.99.6 are not published separately

The shims added for 0.99.5 survive all of 1.x (README, decision 3). So
wonky can also go straight from 0.99.4 to 1.0:

1. Do step 1.
2. Bump to `^1.0.0`, and run `dart fix --apply`.
3. Do the manual items from 2a and the lucide check from step 4.
4. Do step 3's deletions at leisure.

The order inside each step does not change.
