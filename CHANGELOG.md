## 1.0.1

### Breaking changes

1.0.0 was available for less than an hour. This release fixes an API that
would otherwise have stayed until 2.0.

- **The core library no longer depends on Material or Cupertino.** Flutter
  is moving them out of the SDK into the `material_ui` and `cupertino_ui`
  packages. `package:shad/shad.dart` now imports only the widgets layer, so
  it is unaffected by that move. Interop is opt-in:
  - `ShadApp.themeMode` takes the new `ShadThemeMode` (`system`, `light`,
    `dark`). shad no longer re-exports Material's `ThemeMode`, so an app
    that imports both `shad` and `material_ui` does not get an ambiguous
    import.
  - `ShadApp` no longer installs a Material theme or the Material and
    Cupertino localizations. To use Material or Cupertino widgets, import
    `package:shad/material.dart` and wrap them in the new `ShadMaterial`,
    usually through `ShadApp(builder: (context, child) => ShadMaterial(child: child!))`.
    It installs the derived Material theme, a transparent `Material` and
    the missing localizations.
  - `shadMaterialThemeFrom` moves to `package:shad/material.dart`.
  - `ShadApp.materialThemeBuilder` moves to `ShadMaterial.themeBuilder`.
    The never-called `ShadApp.cupertinoThemeBuilder` is removed.
  - `ShadThemeScope.applyMaterialTheme` is removed. Put a `ShadMaterial`
    inside the scope.
  - `ShadApp` builds pages with the new `ShadPageRoute`, a short fade,
    instead of `MaterialPageRoute`. Pass `pageRouteBuilder` to keep
    Material or Cupertino transitions.
  - `ShadScrollBehavior` draws a `ShadScrollbar` on desktop and iOS
    instead of Material's `Scrollbar` and `CupertinoScrollbar`.

`ShadApp` and `ShadThemeScope` still set the icon theme (16, foreground)
and the text selection colours from the shad theme, which the Material
theme used to do. See MIGRATION.md.

### Fixes

- **Tapping a tooltip's trigger works again.** 1.0.0 put a non-opaque
  `MouseRegion` around the trigger so that tooltips show on disabled
  buttons. A non-opaque `MouseRegion` always reports a miss from its hit
  test, so a `GestureDetector` around a `ShadTooltip` never received taps
  on the trigger, and taps reached widgets behind it. The region now
  defers to its child. Tooltips on disabled buttons still show.
- **A menu item with a submenu no longer stays highlighted while the
  pointer moves on.** 1.0.0 added a 100ms grace period (`showDelay`)
  before such an item un-highlights and closes its submenu. Every pointer
  move outside the item restarted that period, so the item stayed
  highlighted, and several submenus stayed open, until the pointer
  stopped. The period now starts once.
- **An expanding `ShadButton` accepts a `Flexible` or `Expanded` child.**
  With `expands: true` the button wrapped its child in `Expanded`, so a
  `Flexible(child: Text(..., overflow: TextOverflow.ellipsis))` child threw
  "Incorrect use of ParentDataWidget". A child that is already flexible is
  now used as it is.

## 1.0.0

The first stable release. From here on `shad` follows semantic versioning:
breaking changes only in a major version, with the old API deprecated first
and migrated by `dart fix`. See [MIGRATION.md](MIGRATION.md).

### Breaking changes

- **Fonts are no longer bundled.** Inter, Geist and Geist Mono (about
  1.2 MB) shipped in every app, and the web downloaded them at startup. Text
  now uses the platform font until you choose one with
  `ShadTextTheme(family:)` or `ShadTextTheme.fromGoogleFont`. The README's
  "Fonts" section shows both. `ShadInputOTP` uses tabular figures instead
  of a monospace face.
- **Deprecations announced for 1.0 are removed:** the old unprefixed
  typedef names, `valueTransformer`, `ShadForm.onPopInvoked`,
  `ShadTextSelectionToolbar`, `ShadToolbarButton` and `isSameDayOrGreatier`.
  `dart fix --apply` migrates the renames.
- **slang is no longer re-exported.** Its `AppLocaleUtils` collided with
  the one slang generates in an app.
- **About 30 internal classes, extensions and helpers are no longer
  exported.** MIGRATION.md lists them.
- **`ShadAvatar` drops `universal_image`, and with it `extended_image`,
  `path_provider` and the discontinued `js` package.** It has two
  constructors: `ShadAvatar(src)` takes a URL or asset path (`String?`), and
  `ShadAvatar.image(image)` takes any `ImageProvider`. `IconData` and SVG
  strings are no longer accepted as a source; put an icon in `fallback`.
- **`lucide_icons_flutter` moves to 4.x.**
- **`flutter_svg` and `vector_graphics` are removed.** shad did not use
  them.
- **`ShadContextMenuController` is now a class (adding `showAt`).**
  `controller:` parameters accept any `ShadPopoverController`.

### Fixes

- `ShadThemeData.copyWith` derives the component themes again, so a copy
  with a new radius, color scheme, text theme, style or spacing restyles
  every component. It now also accepts `style`, `spacing` and the menu
  options.
- Theme equality compares list fields (shadows, effects, snap sizes) by
  value. A theme built with a non-const list no longer restarts
  `ShadAnimatedTheme`'s transition on every rebuild.
- `ShadThemeData` takes its brightness from the color scheme when none is
  given.
- A closed tooltip, popover or select no longer swallows Escape, so the
  dialog around it closes.
- Each context menu has its own tap region: tapping another menu's trigger
  closes the open menu.
- `ShadButton` no longer notifies a shared states controller during build
  ("setState() called during build").
- Open dialogs and sheets follow app theme changes, such as a light/dark
  switch, instead of keeping the theme they opened with.
- Dialogs:
  - The close button has an accessible label, respects `PopScope`, and
    takes an `onClose`.
  - Dialog and sheet barriers have a localized "Dismiss" label in all 82
    locales.
  - Long action labels on small screens are shortened with an ellipsis
    instead of overflowing.
- A tooltip on a disabled button shows on hover.
- Parameters that were accepted but did nothing now work:
  `ShadSlider.label`, `ShadCollapsible.curve`/`reverseCurve`,
  `ShadTab.selectedDecoration`, `ShadCalendar.weekNumbersTextAlign`,
  `ShadForm.skipDisabled`, `ShadContextMenuItem.showDelay`,
  `ShadContextMenuTheme.itemConstraints`, `ShadToastTheme.displayDuration`
  and `ShadTheme.merge(key:)`. Those that cannot work are deprecated.
- `ShadTabsController.selected` and the `ShadTimePickerController` fields
  notify listeners when set.
- `ShadInputFormField`, `ShadTextareaFormField` and `ShadRadioGroupFormField`
  follow a swapped controller; the listener used to stay on the old one.
  `ShadTimePickerFormField` disposes its internal controller.
- `ShadInputDecorator` no longer throws on a label when
  `fallbackToLabelStyle` is off and no label style is set.
- `ShadBuilderTextStyle.copyWith` (Google fonts) keeps the weight or style
  it does not change, so an italic stays italic when its weight changes.
- `ShadBreadcrumbTheme.ellipsis` is used by `ShadBreadcrumbEllipsis`.
  `ShadDatePickerTheme.sizesTheme` never had an effect and is deprecated.
- `ShadRadioGroup` moves its listener to a swapped controller.
- `ShadRestorableTabsController` restores the selected tab, not always the
  first.
- `ShadSelect` notifies its controller when `initialValue(s)` change.
- `ShadPosition.lerp` interpolates, so animated position changes no longer
  jump. `ShadBreakpoints.lerp` accepts null ends.
- Month steps in the calendar clamp the day (Jan 31 + 1 month is Feb 28,
  not Mar 3).
- `ShadProgress` fills from the start edge in right-to-left layouts.
- `ShadApp.custom` accepts `materialThemeBuilder`.
- `ShadMouseArea.cursor` never had an effect and is deprecated.

### Menus

- Anchors take a chain of fallbacks, and the portal picks the one that
  overflows the screen least. Submenus flip to the other side of their
  parent instead of sliding over it.
- Menus are capped to the screen height and scroll.
- Keyboard: Home and End, type-ahead (repeating a letter cycles), and
  arrow keys straight after a pointer open.
- `ShadContextMenuController.showAt(offset)` opens a menu at a point, with
  its corner there (`ShadGlobalAnchor.followerAnchor`), mirrored to stay on
  screen.
- `ShadContextMenu.itemsBuilder` builds the items only while the menu is
  open.
- `ShadMenubar.stripShadows` (and its theme field) controls the strip's own
  shadow.

### New

- `ShadScrollArea` and `ShadScrollbar`, with `ShadScrollAreaTheme`.
- `ShadDropdownMenu`.
- `ShadSurface` paints popover and menu chrome around any widget.
  `showShadPopover` opens a popover anchored to a rectangle.
- `ShadTabs` whose tabs have no content renders only the tab list, a
  standalone segmented control.
- `ShadAccordionItem.trailing` for a header action.
- Style tokens `toggleIconSize` and `badgeIconSize`. Toggles and badges
  pass their icon size down.

### Renamed (old names deprecated, migrated by `dart fix`)

- `Shadows` → `ShadShadows`
- `GoogleFontBuilder` → `ShadFontBuilder`
- `GoogleFontTextStyle` → `ShadBuilderTextStyle`
- `ShadFormBuilderField` → `ShadFormField`, and the `ShadFormBuilder*State`
  classes → `Shad*FormFieldState`
- `ShadToggleVariant.default_` → `primary`
- `selectedDayButtonOusideMonthVariant` → `selectedDayButtonOutsideMonthVariant`
- `ShadToast.duration` → `displayDuration`
- `visibleToastsAmount` → `maxVisibleToasts`
- `ShadAvatar.placeholder` → `fallback`
- `onLineCountChange` → `onLineCountChanged`
- the paste-files functions → `ShadClipboard`
- the `kDefault*` constants → statics on their widgets

### Package

- The published archive no longer carries test failure images or internal
  files.
- The pubspec has a corrected description, URLs, screenshot and dependency
  constraints.
- New `SECURITY.md`, `MIGRATION.md`, `example/example.md` and
  `lib/fix_data.yaml` (with `test_fixes/`).
- CI publishes on a version tag, and checks formatting, the publish dry
  run, the data-driven fixes and the minimum Flutter version.
- Every golden test now compares. 52 of 58 never did, because their
  matcher was not awaited.

## 0.99.4

- Fixes the whole app freezing — no repaints, no input, no response to a window
  resize — when the pointer left and re-entered a `ShadSelect`'s scroll chevron
  within a fifth of a second. Two auto-scroll loops then ran against the same
  scroll controller and cancelled each other forever without yielding to the
  event loop. Only one loop can run now, and it always yields.
  `ShadSelectState.animateToTop`/`animateToBottom` and the
  `shouldAnimateToTop`/`shouldAnimateToBottom` flags are replaced by
  `startAutoScroll`/`stopAutoScroll`.
- Fixes `ShadSonner` leaking an `AnimationController`, and leaving a timer
  running, for every toast queued behind `visibleToastsAmount` and later shown.
- Fixes `ShadInputOTP` never dropping slots or groups that unmount, which grew
  its registry past `maxLength` and could then write out of range.
- Fixes an auto-anchored `ShadPortal` queueing an unbounded number of
  reposition callbacks while its overlay had no size yet.
- Fixes right-clicking a `ShadContextMenuRegion` on the web crashing any
  enclosing `SelectionArea` with `SelectableRegion`'s
  `assert(_selectable == null)`. The region toggled the global
  `BrowserContextMenu` around every click, and `SelectionArea` changes its
  tree shape on that flag; it now cancels the browser's own menu per event
  with a DOM-level `preventDefault` and leaves the global alone.

## 0.99.3

- Fixes the tooltip arrow pointing at nothing when the bubble is near a window
  edge. The bubble slides inward to stay on screen; the arrow now slides back
  with it and keeps pointing at the trigger, stopping short of the bubble's
  rounded corners.

## 0.99.2

- Fixes outer shadows being clipped to the wrong shape. Dialogs, sheets, cards,
  popovers, toasts, menus, the sidebar and every decorated control lost the
  shadow immediately around them and picked it up again a few pixels out with a
  hard edge. Shadows now paint the way CSS paints `box-shadow`: blurred, and
  clipped to outside the element itself.

## 0.99.1

- Fixes heights of components to comply with original Shadcn.

## 0.99.0

- First release under the `shad` name, continuing
  [flutter-shadcn-ui](https://github.com/nank1ro/flutter-shadcn-ui/blob/main/CHANGELOG.md) 0.57.
