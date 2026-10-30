# 03 — Components to add (from wonky and from shadcn gaps)

All additions are **additive and not breaking**, so none of them blocks 1.0.
They are ranked by value: how often wonky needs them, and whether shadcn has
a matching component that users will look for. Items marked **1.0** should
ship in 1.0. The rest can follow in 1.x minors.

Wonky paths are relative to `wonky/packages/wonky_ui/lib/src/widgets/`.

## Upstream from wonky

| # | New in shad | Source in wonky | shadcn match | Work | Target |
| --- | --- | --- | --- | --- | --- |
| 1 | `ShadScrollArea` | `scroll_area/scroll_area.dart` (110 LOC) | `scroll-area` | Small | **1.0** |
| 2 | `ShadSurface` (popover/card/dialog chrome as a widget) + `showShadPopover(anchorRect:)` | `wonky_app/lib/src/shell/anchored_popover.dart`, ~28 hand-rolled surfaces | none (exposes existing internals) | Small–medium | **1.0** |
| 3 | `ShadOverflowRow` (priority-based overflow layout) | `toolbar/overflow_layout.dart` (334 LOC, RenderObject) | none | Small (rename + tests) | 1.x |
| 4 | `ShadToolbar` on top of 3 | `toolbar/toolbar.dart` (768 LOC) | `button-group` / `toggle-group` | Medium | 1.x |
| 5 | `ShadTreeView` + `ShadTreeController` | `tree_view/tree_view.dart` (627 LOC) | none (file-tree block) | Medium | 1.x |
| 6 | `ShadNumberInput` | `number_stepper/number_stepper.dart` (213 LOC) | `input-group` + `button-group` | Small–medium | 1.x |
| 7 | `ShadColorPicker` (HSV square, hue/alpha, hex) | `color_picker/custom_color_panel.dart` (395 LOC) | none | Medium | 1.x |
| 8 | `ShadProgress` multi-segment mode | `stacked_bar/wonky_stacked_bar.dart` | `progress` | Small | 1.x, optional |

Things to leave in wonky: the palette color picker and `WonkyColor`, the
presence avatar stack, the shortcut recorder, the title field, the table
size picker, the empty state art, the status bar, the shimmer, the font
picker, sync status, split view, remote cursor and the mobile layouts. They
are domain-specific, or a thin wrapper over something shad already has.

### Per-item notes

**1. `ShadScrollArea`.**
- Add `ShadScrollAreaTheme`. The bar is `w-2.5` (10px, scaled). The thumb is
  `rounded-full bg-border`. Read the values per style from
  `.cn-scroll-area-*` in the eight style CSS files.
- Remove `WonkyThemeScope`.
- The scroll-edge shadows are wonky's own and are not in shadcn. Make them
  opt-in (`edgeShadows: true`), and paint them with theme colors, not
  hard-coded ones.
- Use it inside `ShadSelect`, `ShadContextMenu` (once menus scroll, see
  04 §4), `ShadCommand` and `ShadSheet`, so that every scrollable surface in
  the package has one scrollbar look.

**2. `ShadSurface` and `showShadPopover`.**
- Wonky has about 28 files that rebuild "a popover" with
  `colorScheme.popover` plus `BoxDecoration(boxShadow:)` plus
  `Border.all(border)`. Each of them has the wrong outline (`--border`
  instead of `ring-foreground/10`) and the `BoxShadow` clipping artefact
  that `ShadShadowDecoration` exists to fix (CLAUDE.md).
- `ShadSurface(kind: ShadSurfaceKind.popover | card | dialog | menu, child:)`
  reads the resolved decoration, radius, padding and shadows from the
  matching component theme.
- `showShadPopover(context, anchorRect: Rect, builder:, placement:)` is a
  route-based popover for callers that have a rectangle and no widget to
  anchor to: a text selection, a cell, a canvas hit. It uses the portal's
  flip-and-shift logic from 04 §3.

**3–4. `ShadOverflowRow` and `ShadToolbar`.**
- The render object has no dependencies and has tests. It can be renamed
  and moved as-is: parent data for priority, group, pinned and separator,
  and a post-frame report of the hidden set.
- The toolbar shell needs these changes:
  - heights and button sizes from `ShadStyleTokens`, not
    `WonkyThemeExtension`;
  - the "More" and "Toolbar" labels in slang i18n;
  - its overflow menu built on `ShadContextMenu`, after 04 §2–6 have
    landed.
- `ToolbarEscapeScope` is deleted, not upstreamed. It exists only because of
  04 §1.

**5. `ShadTreeView`.**
- Features: a lazy controller (load, refresh, expand, reveal), keyboard
  navigation (arrows, Home/End, `*`), drop before/inside/after, inline
  rename with `ShadInput`, and Semantics.
- Changes:
  - expand/collapse labels go to i18n;
  - row height and radius come from `sidebarItemHeight` and `itemRadius`;
  - the drag feedback `boxShadow` (`tree_view.dart:608`) goes through
    `ShadShadowDecoration`;
  - the ring at `:517` uses the theme's focus border.

**6. `ShadNumberInput`.**
- Behaviour to keep: commit on Enter, blur, arrow keys or scroll; revert when
  the input is invalid; decimal comma; clamp; `null` for "mixed values".
- Replace the hard-coded 28/36 heights and 44/64 widths with the input's
  height token and `scaled()`.
- Add `Semantics(increasedValue:, decreasedValue:, onIncrease:, onDecrease:)`.
- Add a `ShadNumberInputFormField`, following the pattern of the other
  `*FormField`s.

**7. `ShadColorPicker`.**
- It is already generic and built on `ShadSlider` and `ShadInput`. The
  eyedropper is injected through a callback.
- Move about 12 strings to i18n.
- Add a `ShadColorPickerFormField`.

## shadcn components shad does not have yet

Not from wonky, but users will look for them. **None of these block 1.0.**
List them in the README under "Not yet available", so their absence reads as
deliberate.

| shadcn | Note | Suggested target |
| --- | --- | --- |
| `dropdown-menu` | shad reuses `ShadContextMenu`. A `ShadDropdownMenu(trigger:, items:)` wrapper is mostly naming. Wonky's declarative `WonkyMenuEntry` model is a good API for it. | **1.0** (thin wrapper) |
| `tabs-list` standalone / segmented control | Wonky rebuilds it twice. Allow `ShadTabs` without panels, or add `ShadTabsList`. | **1.0** |
| `avatar-group`, `avatar-badge` | `.cn-avatar-group*` exists in every style CSS | 1.x |
| `kbd-group` | trivial | 1.x |
| `button-group`, `input-group`, `field`, `label`, `item` | layout primitives. `field` overlaps with the existing form field decoration, so consider it alongside `ShadInputDecorator` (04 §17). | 1.x |
| `hover-card` | popover on hover, delay | 1.x |
| `drawer` | bottom sheet with a drag handle; also covers wonky's "dialog full-screen on mobile" | 1.x |
| `combobox` | partly covered by `ShadSelect.withSearch` | 1.x |
| `navigation-menu`, `carousel`, `chart`, `aspect-ratio`, `native-select` | low priority. `chart` belongs in a separate package if at all, because of `fl_chart`. | later |

## Process for each new component

1. Read the values from `reference/ui/apps/v4/registry/styles/style-*.css`.
   Add tokens to `ShadStyleTokens` only where the styles differ.
2. Add a component theme under `lib/src/theme/components/`, wire it through
   both variants (the parent only, see CLAUDE.md), and run build_runner.
3. Add it to `test/src/theme/theme_data_equality_test.dart`, and add a
   geometry test if the component has a control height.
4. Add a docs page and examples under `example/lib/docs/`, plus the pubspec
   asset entry.
5. Add a skill page under `skills/shad-overview/components/`.
