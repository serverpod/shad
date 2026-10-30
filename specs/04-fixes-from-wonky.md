# 04 — Fixes in shad for workarounds found in wonky

Wonky uses shad 0.99.4 from pub.dev (8 pubspecs, no overrides). Each item
below is a workaround in wonky for a shad shortcoming. All of them still
apply at shad HEAD (`8ea5a35`). Items 1, 2 and 7 were spot-checked by hand.

Each fix ends with a **wonky clean-up** line: the code wonky can delete once
the fix ships.

**Breaking?** Only §11 changes default behaviour in a way someone could
notice. All the others are bug fixes or additive.

## Must fix for 1.0 (bugs)

### §1 Tooltip and popover swallow Esc even when closed
- **Where:** `lib/src/components/tooltip.dart:328-335` and
  `lib/src/components/popover.dart:395-399` bind Esc with an unconditional
  `CallbackShortcuts`, so the key is always handled.
- **Effect:**
  - an enclosing dialog, sheet or route never gets `DismissIntent`;
  - wonky has about 98 hand-written Esc bindings, plus `ToolbarEscapeScope`
    (`toolbar.dart:746-765`).
- **Fix:** bind Esc only while `controller.isOpen`. Better: replace the
  binding with `Shortcuts` + `Actions` and a `DismissIntent` action whose
  `isEnabled`/`consumesKey` returns false when closed. Check every other
  `CallbackShortcuts` in `lib/` for the same pattern.
- **Test:** a tooltip trigger with focus inside a dialog. Esc closes the
  dialog when the tooltip is hidden, and closes only the tooltip when it is
  shown.
- **Wonky clean-up:** delete `ToolbarEscapeScope`.

### §2 All context menus share one tap-region group
- **Where:** `kContextMenuGroupId = ValueKey('context-menu')` is a single
  global const (`context_menu.dart:19, 442, 462, 480`).
- **Effect:** a tap on menu B's trigger counts as "inside" menu A, so menu A
  stays open. Wonky works around it with a global `OpenMenu` slot
  (`menu/open_menu.dart`).
- **Fix:**
  - use a per-instance group id (the state object or its key), as
    `ShadPopover` already does at `popover.dart:188`;
  - keep submenus in their root menu's group;
  - add a "one open root menu per overlay" coordinator. Radix closes the
    open menu when another one opens.
- **API:** `kContextMenuGroupId` is exported. Deprecate it; it can stay as
  an unused const.
- **Wonky clean-up:** remove `OpenMenu` claims from the dropdown, the
  menubar, the context region and the popup host.

### §7 `ShadButton.didUpdateWidget` notifies listeners mid-build
- **Where:** `button.dart:836-838` calls
  `statesController.update(ShadState.disabled, ...)` synchronously in
  `didUpdateWidget`. This notifies listeners (the trailing icon) while
  building, which raises "setState() called during build".
- **Fix:** compute the disabled state at build time. The statesController
  then reflects it without notifying during `didUpdateWidget`. Or defer the
  notification to post-frame. Apply the same audit to every `*StatesController`
  user (toggle, menu items).
- **Wonky clean-up:** remove `_stableEnabled` re-keying
  (`menu/menu_items.dart:359-371`).

### §9 Dialog close button has no accessible label and ignores `PopScope`
- **Where:** `dialog.dart:640-659` sets no semantic label and calls
  `Navigator.pop()`.
- **Fix:**
  - `semanticLabel` from `ShadLocalizations` ("Close");
  - use `Navigator.maybePop()`;
  - add `ShadDialog.onClose` (default `maybePop`).
- **Wonky clean-up:** `WonkyDialogCloseButton`, passed as `closeIcon:` in
  68 places.

### §10 Barrier labels default to `''`
- **Where:** `dialog.dart:150`, `sheet.dart:44`. This fails
  `labeledTapTargetGuideline`.
- **Fix:** default `barrierLabel` to a localized "Dismiss".

### §11 Dialogs and sheets freeze the theme they were opened with
- **Where:** `dialog.dart:222` captures `ShadTheme.of(context, listen: false)`
  in a `ShadThemeScope`. `showShadSheet` and the sidebar's mobile drawer go
  through it.
- **Effect:** a light/dark switch while a sheet is open leaves the sheet in
  the old theme. This also affects the example's own theme editor if a sheet
  is open.
- **Fix:** wrap the route in a theme only when the opener's theme differs
  from the navigator's (a local `ShadThemeScope`). In that case, keep it live
  with an `InheritedNotifier`/listenable that the opener updates. Otherwise
  inherit the navigator's theme.
- **Behaviour change:** small. Document it in the changelog.

### §15 A disabled button with a tooltip never shows the tooltip
- **Where:** `ShadButton` stops hover reporting when disabled, so
  `ShadTooltip` never opens. Radix wraps disabled triggers so that tooltips
  still work.
- **Fix:** `ShadTooltip` uses its own `MouseRegion` (opaque false) around
  the child, independent of the child's hover strategies.
- **Wonky clean-up:** `_HoverReport` (`board_widgets.dart:393-411`).

## Should fix for 1.0 (menus and popovers)

These five are one work package: **menu positioning and behaviour**. They
touch `portal.dart` and `context_menu.dart` together, so do them in that
order.

### §3 Anchors do not flip or shift
- **Where:** `portal.dart:35-42`. Only `ShadAnchorAuto` takes a fallback, and
  `:426-447` tries the fallback only vertically.
- **Fix:** a Floating-UI-style `flip` (both axes) plus `shift` for every
  anchor type, on by default for menus, submenus, selects and popovers.
  Opt-out flag `ShadAnchor.avoidCollisions` (Radix's name).
  `ShadPortalPlacement.shift` already exists for the tooltip arrow (CLAUDE.md),
  so extend that mechanism.
- **Wonky clean-up:** `WonkyMenuPlacement.onScreen` and the submenu anchor
  that hard-codes shad's -8 and 3/5 px offsets (`menu_placement.dart`).

### §4 Menus cannot cap their height or scroll
- **Fix:**
  - pass the space left on the chosen side down as a constraint (Radix's
    `--radix-dropdown-menu-content-available-height`);
  - wrap the item list in `ShadScrollArea` (03 #1);
  - keep keyboard focus scrolling into view.
- **Wonky clean-up:** `itemsMaxHeight*` and the leaked `chrome = 10.0`
  constants (`menu_placement.dart:15-16`, `popup_menu_host.dart:50-51`).

### §5 No way to open a menu at a point
- **Fix:** `ShadContextMenuController.showAt(Offset globalPosition)`. It
  places the top-left corner at the point, then applies §3. Note:
  `ShadGlobalAnchor` currently *centres* the overlay on the x coordinate, so
  check whether that is intentional or a bug.
- **Wonky clean-up:** `WonkyPopupMenuHost`'s render-offscreen, measure,
  reposition dance.

### §6 Menu items are eager; keyboard handling is missing
- **Fixes:**
  - accept `itemsBuilder` (built only while open), next to `items`;
  - focus the content on open, including pointer opens;
  - add type-ahead (first-letter jump);
  - Home/End.
- **Wonky clean-up:** items passed only while open, cached entries, and
  `requestFocus` hacks (`dropdown_menu.dart`, `popup_menu_host.dart`,
  `menu_items.dart:8-20`, `menubar.dart:232-236`).

### §8 Menubar strip shadow and overflow
- **Fixes:**
  - `ShadMenubarTheme.shadows`, defaulting to `style.controlShadow`;
  - optional overflow into a trailing "…" menu once 03 #3 exists.
- **Wonky clean-up:** the `ClipRect` around the menubar
  (`menubar.dart:205-208`).

## Smaller fixes (any time, additive)

| § | Fix | Wonky clean-up |
| --- | --- | --- |
| 12 | `ShadSurface` + `showShadPopover(anchorRect:)`, see 03 #2 | ~28 hand-rolled popover surfaces, `showAnchoredPopoverAt` |
| 13 | `ShadTabs` without panels / `ShadTabsList` | `_Segmented`, the board tab strip |
| 14 | `ShadAccordionItem.trailing` (header action slot) | `EditorSection` |
| 16 | `ShadDialog` stacked actions: labels `Flexible` + ellipsis | manual ellipsizing in two dialogs |
| 17 | Public `ShadInputDecorator` (field chrome + focus ring around any child) | hand-merged input/textarea decoration around super_editor |
| 18 | Icon size: `ShadToggle` hard-codes 16 (`toggle.dart:342-343`) → token; `ShadBadge` (`[&>svg]:size-3`) and tab triggers should pass down an icon size too | ~195 redundant `size: 14/16` on icons in buttons (wonky-side clean-up; the button token shipped in 0.99.4) |
| 19 | Font constants: see 02 | ~12 literal `packages/shad/...` strings |

## Suggested order

1. §1, §2, §7, §9, §10, §15. These are independent bug fixes, about one
   PR each.
2. §3 → §5 → §4 → §6 → §8, in that order. This is the menu work package,
   and the largest item in this file.
3. §11. It needs care around the sidebar drawer route (see CLAUDE.md, "The
   drawer route outlives the scaffold's State").
4. The table rows in any order.
