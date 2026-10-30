# Migrating to shad 1.0

Most apps migrate in three steps:

1. Bump the constraint to `shad: ^1.0.0`.
2. Run `dart fix --apply`. Data-driven fixes rename everything that was
   renamed (see the table below).
3. Choose a font (see "Fonts"), and handle the few manual items below.

## Breaking changes

### Fonts are no longer bundled

0.x shipped Inter, Geist and Geist Mono (about 1.2 MB) inside every app that
used shad, and the web downloaded them at startup. 1.0 ships no fonts. Text
uses the platform font until you choose one.

To keep the 0.x look, choose one of these:

```dart
// Fetched at runtime with google_fonts (`flutter pub add google_fonts`):
ShadThemeData(textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.inter))
```

Or bundle the font yourself. Copy the file from shad 0.99.4's `fonts/`
folder (in your pub cache) or from [rsms.me/inter](https://rsms.me/inter/),
together with its OFL licence:

```yaml
flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: fonts/Inter[opsz,wght].ttf
```

```dart
ShadThemeData(textTheme: ShadTextTheme(family: 'Inter'))
```

Then replace these:

| 0.x | 1.0 |
| --- | --- |
| `ShadTextTheme(family: 'Geist', package: 'shad')` | your own `Geist` family, or `GoogleFonts.geist` |
| `kDefaultFontFamily`, `kDefaultFontFamilyMono` | your own family names. The constants still exist, deprecated, but they point at fonts that are gone. |
| `'packages/shad/Inter'` and other `packages/shad/...` strings | your own family names |

`ShadInputOTP` no longer uses a monospace font. It uses tabular figures, as
shadcn's does. Pass `style:` to keep a mono face.

### Deprecations removed

These were deprecated in 0.x and announced for removal in 1.0. `dart fix`
handles every rename.

| Removed | Use |
| --- | --- |
| `AnimEffect`, `SizeEffect`, `PaddingEffect` | `ShadAnimEffect`, `ShadSizeEffect`, `ShadPaddingEffect` |
| `UpperCaseTextInputFormatter`, `LowerCaseTextInputFormatter` | `ShadUpperCaseTextInputFormatter`, `ShadLowerCaseTextInputFormatter` |
| `ResponsiveWidgetBuilder`, `FocusWidgetBuilder` | `ShadResponsiveWidgetBuilder`, `ShadFocusWidgetBuilder` |
| `PasteFilesCallback`, `PasteFilesErrorCallback` | `ShadPasteFilesCallback`, `ShadPasteFilesErrorCallback` |
| `RestorableShadTabsController` | `ShadRestorableTabsController` |
| `SheetDragStartHandler`, `SheetDragEndHandler` | `ShadSheetDragStartHandler`, `ShadSheetDragEndHandler` |
| `ToValueTransformer`, `FromValueTransformer` | `ShadToValueTransformer`, `ShadFromValueTransformer` |
| `valueTransformer:` on every form field | `toValueTransformer:` |
| `ShadForm.onPopInvoked` | `onPopInvokedWithResult` (by hand: the callback also receives the result) |
| `ShadTextSelectionToolbar`, `ShadToolbarButton` | `ShadContextMenu` with `ShadContextMenuItem` |
| `ToastInfo`, `SizeChangeCallback`, `isSameDayOrGreatier` | internal now |

### slang is no longer re-exported

`package:shad/shad.dart` used to re-export all of `slang` and
`slang_flutter`, including an unprefixed `AppLocaleUtils` that collides with
the class slang generates in an app. If you used slang through shad, import
it directly. shad's own localization types (`ShadLocale`,
`ShadLocalizationsData`, `ShadLocalizations`, `GlobalShadLocalizations`)
are still exported.

### Internals are no longer exported

Nothing documented used these. If you did, copy what you need, or open an
issue.

- **Bookkeeping classes:** `ShadToastInfo`, `ShadCalendarModel`,
  `ShadContextMenuItemController`, `ShadSheetGestureDetector`,
  `ShadSheetLayoutWithSizeListener`, `ShadInheritedTheme`.
- **Generic helpers:** `ShadProvider`, `ShadIndexProvider`,
  `ShadProviderIndex`, `ShadMouseCursorProvider` and its controller,
  `ShadAnimate`, `ShadAnimationBuilder`, `ShadTextEditingController`,
  `ShadTimePickerTextEditingController`.
- **Extensions:** `OmitFamilyAndPackageExtension`, `PositionedExt`,
  `ShadDateTime`.
- **Top-level helpers:** `paintOuterShadows`, `applyGoogleFontToTextTheme`,
  `kInvisibleCharCode`, `kContextMenuGroupId`, `IntlTextDirection`.

Some `State` members are now `@protected`, so using them from outside
triggers an analyzer warning:

- `ShadSelectState.showScrollToTop` and `showScrollToBottom`;
- `ShadInputState.hasFocus`;
- `ShadTabsState.orderedValues` and `scrollController`;
- `ShadSonnerState.animationController`, `hovered`, `onEnter` and `onExit`;
- `ShadResizablePanelGroupState.dragging` and `currentConstraints`.

### Smaller changes

- **Avatars:** `ShadAvatar` no longer depends on `universal_image`, and has
  two constructors:
  - `ShadAvatar(src)` takes a URL or an asset path as a `String?` (and
    `package:` now works for assets). Existing calls with a string compile
    unchanged.
  - `ShadAvatar.image(image)` takes any `ImageProvider`: a file, memory
    bytes, a cached network image, or an SVG rasterised by a provider.

  An `IconData` or an SVG string is no longer a valid source. For an icon,
  use `ShadAvatar(null, fallback: Icon(...))`.
- **Icons:** `lucide_icons_flutter` moved from 3.x to 4.x. Check icons that
  Lucide renamed: they surface as analyzer errors.
- **Context menus:** `ShadContextMenuController` is now a class, a
  `ShadPopoverController` with `showAt`. Every `controller:` parameter
  accepts any `ShadPopoverController`.
- **Sheets:** `ShadSizeChangeCallback` lost its type parameter, which
  shadowed `Size`.

## Renamed, with the old names deprecated

These still compile in 1.0. Each warns, and `dart fix --apply` rewrites
it. They will be removed in 2.0.

| Deprecated | Use |
| --- | --- |
| `Shadows` | `ShadShadows` |
| `GoogleFontBuilder`, `GoogleFontTextStyle` | `ShadFontBuilder`, `ShadBuilderTextStyle` |
| `AnimateEffect` | `ShadAnimEffect` |
| `ShadFormBuilderField`, `ShadFormBuilderFieldState` | `ShadFormField`, `ShadFormFieldState` |
| `ShadFormBuilder<X>State` (all 11) | `Shad<X>FormFieldState` |
| `ShadToggleVariant.default_` | `ShadToggleVariant.primary` |
| `selectedDayButtonOusideMonthVariant` | `selectedDayButtonOutsideMonthVariant` |
| `ShadToast(duration:)`, `ShadToastTheme.duration` | `displayDuration` |
| `ShadSonner.visibleToastsAmount` (and theme) | `maxVisibleToasts` |
| `ShadSonnerState.hideTemporarely` | `hideTemporarily` |
| `ShadAvatar(placeholder:)` | `fallback:` |
| `onLineCountChange` (input, textarea and their form fields) | `onLineCountChanged` |
| `addPasteFilesListener` and the other three functions | `ShadClipboard.addPasteFilesListener` and so on |
| `kDefaultToastDuration` | `ShadToast.defaultDuration` |
| `kDefaultSelectMinWidth`, `kDefaultSelectMaxHeight` | `ShadSelect.defaultMinWidth`, `ShadSelect.defaultMaxHeight` |

## Deprecated because they never did anything

These parameters were accepted and documented, but never read. They are
deprecated with a note; remove them.

- `ShadDatePicker.onMultipleChanged` (also on both date form fields);
- `ShadDatePickerTheme.disabledBackgroundColor` and `sizesTheme`;
- `ShadMenubarTheme.buttonLongPressDuration`;
- `ShadApp.cupertinoThemeBuilder`.

These now work as documented:

- `ShadSlider.label`, now the accessible name;
- `ShadCollapsible.curve` and `reverseCurve`;
- `ShadTab.selectedDecoration`;
- `ShadCalendar.weekNumbersTextAlign`;
- `ShadForm.skipDisabled`;
- `ShadContextMenuItem.showDelay` and `ShadContextMenuTheme.itemConstraints`;
- `ShadToastTheme.displayDuration`;
- `ShadTheme.merge(key:)`;
- `ShadBreadcrumbTheme.ellipsis`.

## Behaviour changes worth checking

- **`ShadThemeData.copyWith`** now derives the component themes again. A
  copy with a new `radius`, `colorScheme`, `textTheme`, `style` or
  `spacing` restyles every component. Before, it changed only the theme's
  own field.
- **Brightness:** `ShadThemeData(colorScheme: X.dark())` with no
  `brightness` is now dark. It used to default to light.
- **Escape:** a closed tooltip, popover or select no longer swallows
  Escape. A dialog around a focused trigger now closes on Escape.
- **Menus:**
  - Each context menu has its own tap region, so tapping another menu's
    trigger closes the open menu.
  - Menus flip and shift to stay on screen, submenus included.
  - Long menus scroll.
  - Menus support type-ahead, and Home and End.
  - A context menu opens with its corner at the pointer.
- **Theme changes:** open dialogs and sheets follow light/dark and other
  app theme changes.
- **Dialogs:**
  - The close button has an accessible label and respects `PopScope`.
    `ShadDialog.onClose` overrides what it does.
  - Barriers have a localized "Dismiss" label.
  - Long action labels on small screens are shortened with an ellipsis.
- **Tooltips:** a tooltip on a disabled button now shows.
- **Icon sizes:** badges and toggles pass an icon size down from the style
  (`badgeIconSize`, `toggleIconSize`).

## New in 1.0

- `ShadScrollArea` and `ShadScrollbar`;
- `ShadDropdownMenu`;
- `ShadSurface` and `showShadPopover(anchorRect:)`;
- `ShadTabs` without content as a standalone tabs list;
- `ShadAccordionItem.trailing`;
- `ShadMenubar.stripShadows`;
- `ShadContextMenu.itemsBuilder`;
- `ShadContextMenuController.showAt`;
- `ShadGlobalAnchor.followerAnchor`;
- `ShadAnchorAuto` fallback chains.
