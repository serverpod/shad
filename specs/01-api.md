# 01 — Public API changes for 1.0

Guiding rule (from the brief): **keep the API, fix obvious mistakes and
inconsistencies, and make migration easy.** In practice:

- Fix every real bug and leak.
- Rename only where the current name is a typo, misleading, or breaks a
  pattern so badly that it causes errors. Every rename keeps the old name as
  `@Deprecated` and gets a `lib/fix_data.yaml` entry, so `dart fix --apply`
  migrates callers.
- Hide internals that nobody should depend on. A wonky grep found 0 uses of
  any of them in about 2,000 Dart files.
- **Do not** chase cosmetic consistency (callback tense, animation param
  names, controller shapes). The list of what was considered and deferred to
  2.0 is at the end, so the decision is on record.

`flutter analyze` is clean today. Findings come from a full pass over `lib/`;
`file:line` references are at HEAD `8ea5a35`.

## Release mechanics

1. **0.99.5, the "1.0 preview".** Add every new name, every `@Deprecated`
   shim and `lib/fix_data.yaml`, with no removals. Users upgrade, run
   `dart fix --apply`, and clear their deprecation warnings while still on
   0.x.
2. **1.0.0.** Remove only the 40 deprecations that already say "will be
   removed in v1.0.0" (§A2), and apply the few unavoidable breaks (§A1, §A9).
   The deprecations added in 0.99.5 **stay for all of 1.x** and are removed
   in 2.0.
3. Leave `remove_deprecations_in_breaking_versions` **off**. That lint
   flags every deprecated member while the version is `X.0.0`, and 1.0.0
   deliberately keeps the 0.99.5 shims. Turn it on for the 2.0.0 release,
   where it does what it is for.

## A. Must fix before 1.0

### A1. The barrel leaks all of slang (breaking, unavoidable)
- **Where:** `lib/src/i18n/strings.g.dart:17` has
  `export 'package:slang_flutter/slang_flutter.dart'`.
- **Effect:**
  - every `import 'package:shad/shad.dart'` pulls in `BaseAppLocale`, the
    plural resolvers and the rest of slang;
  - it also pulls in an unprefixed `AppLocaleUtils` (`:1289`), the same name
    that slang generates in a consumer's own app. Any slang-using app gets an
    ambiguous import.
- **Fix:** `export 'src/i18n/strings.g.dart' show ShadLocale,
  ShadLocalizationsData;`, plus whatever `ShadLocalizationsDelegate` needs.
  Set slang's `generate`/output options so the generated file does not
  re-export, otherwise the next `dart run slang` brings it back.
- **Migration:** code that used slang through shad imports slang directly.
  Wonky: 0 uses.

### A2. Remove the 40 deprecations that were promised for 1.0
- Typedef renames: `AnimEffect`, `SizeEffect`, `PaddingEffect`, the
  `UpperCase`/`LowerCase` formatters, `ResponsiveWidgetBuilder`,
  `FocusWidgetBuilder`, `PasteFiles*Callback`, `RestorableShadTabsController`,
  `ToastInfo`, `SheetDrag*Handler`, `SizeChangeCallback`,
  `To`/`FromValueTransformer`.
- `valueTransformer` on the base field and on 12 form fields.
- `ShadForm.onPopInvoked`.
- `ShadTextSelectionToolbar`, `ShadToolbarButton` (`input.dart:1443,1521`).
- `isSameDayOrGreatier`.
- Each removal gets a `fix_data.yaml` entry where the replacement is
  mechanical (renames: all of them). `valueTransformer` → `toValue`/
  `fromValue`, or whatever the current replacement is: check the deprecation
  messages.

### A3. Typos in public identifiers (non-breaking, with shims)
- `selectedDayButtonOusideMonthVariant` appears 47 times across `calendar.dart:857`,
  `date_picker.dart:728`, both themes and both form fields. Add
  `…OutsideMonthVariant` and keep the old parameter as `@Deprecated`
  (`new ?? old`).
- `ShadToastInfo.temporarelyHide` and `ShadSonnerState.hideTemporarely`: these
  become private with §A9.

### A4. Dead parameters (accepted, documented, never read)
For each one, either wire it up or deprecate it with "has no effect". Do not
freeze a promise that does not hold.

| Parameter | Decision |
| --- | --- |
| `ShadSlider.label` (`slider.dart:286`) | **wire** (semantics label) |
| `ShadCollapsible.reverseCurve` + theme (`collapsible.dart:111`) | **wire** |
| `ShadContextMenuItem.showDelay` + theme `showDelay`, `itemConstraints` (`context_menu.dart:711, 78, 113`) | **wire** (submenu open delay; item constraints) |
| `ShadTab.selectedDecoration` (`tabs.dart:580`) | **wire** |
| `ShadCalendar.weekNumbersTextAlign` (+ theme, date picker pass-through) | **wire** |
| `ShadForm.skipDisabled` (`form.dart:79`) | **wire** (skip disabled fields in `value`/`validate`) |
| `ShadDatePicker.onMultipleChanged` (`date_picker.dart:542`) | deprecate: the date picker has no multiple mode |
| `ShadDatePickerTheme.disabledBackgroundColor` | wire, or deprecate if the reference has no such state |
| `ShadMenubarTheme.buttonLongPressDuration` | deprecate |
| `ShadDecoration.fallbackToLabelStyle` (`decorator.dart:85`) | deprecate |
| `ShadApp.cupertinoThemeBuilder` (`app.dart:420`, never settable) | deprecate |
| `ShadTheme.merge({Key? key})` (`theme.dart:34`), `key` ignored | wire |

Add a test per wired parameter.

### A5. `ShadAvatar.src` is `dynamic`, and pulls in a heavy dependency chain
- **Where:** `avatar.dart:30`. `src` goes to `UniversalImage`, which brings in
  `extended_image`, then `extended_image_library` (`crypto`,
  `http_client_helper`, the `path_provider` plugin, the discontinued `js`
  package) and `flutter_svg`. That chain is the package's only use of
  `universal_image`. `package` was accepted but never passed on.
- **Done:** two constructors.
  - `ShadAvatar(String? src)` keeps `src` as the positional argument, so
    wonky's `ShadAvatar(imageUrl, ...)` compiles unchanged. An `http(s)`
    string becomes a `NetworkImage`, any other string an `AssetImage`
    (which now honours `package`), and null or empty shows the fallback.
  - `ShadAvatar.image(ImageProvider? image)` covers every other source.
  - `IconData` is no longer accepted as a source; it goes in `fallback`.
  - **SVG sources stop working.** That is documented on `src`.
  - `placeholder` → `fallback` (shadcn's `AvatarFallback`), with a
    deprecated shim.
  - The public `effective*` helpers are gone.
  - `universal_image`, `flutter_svg` and `vector_graphics` were removed from
    the pubspec.

### A6. `ShadThemeData.copyWith` cannot re-derive components
- **Where:** the generated `copyWith` (`data.g.theme.dart:235`) passes every
  already-resolved component theme back into the factory, so
  `copyWith(colorScheme:)`, `copyWith(radius:)` and `copyWith(textTheme:)`
  move the field but not the components. CLAUDE.md documents this as a
  trap, but a trap in the most common theming call is a bug.
- **Also:**
  - there are no `style`, `spacing`, `menuColorScheme`, `menuTranslucent` or
    `menuAccent` parameters;
  - `copyWith(disableSecondaryBorder: true)` keeps the old variant.
- **Fix:**
  - store the caller's *own* inputs on `ShadThemeData` (the raw factory
    arguments);
  - hand-write `copyWith` to re-run the factory from those inputs merged
    with the new ones;
  - exclude `copyWith` from generation for this class only.
- **Non-breaking** (the signature only grows).
- **Test:** `copyWith(radius: X).buttonTheme` matches `ShadThemeData(radius: X).buttonTheme`
  for every input field.

### A7. `ShadToggleVariant.default_` (non-breaking)
- **Where:** `toggle.dart:15`. Every other enum uses `primary` for the
  default variant.
- **Fix:** rename it to `primary` and add
  `@Deprecated('Use primary') static const default_ = primary;`.

### A8. `typedef ShadSizeChangeCallback<Size>` shadows `dart:ui` `Size`
- **Where:** `sheet.dart:1851`. The type parameter shadows `Size`, so the
  callback is effectively `dynamic`.
- **Fix:** drop the type parameter. Source-compatible for every real use.

### A9. Hide internals (breaking on paper; 0 known users)
Hide at 1.0 (directly, no deprecation cycle; changelog lists every name).
Wonky: 0 uses of any of them.

- **Bookkeeping classes:** `ShadToastInfo` (mutable `visible`, `timer`),
  `ShadCalendarModel`, `ShadContextMenuItemController`,
  `ShadSheetInheritedWidget`, `ShadSheetGestureDetector`,
  `ShadSheetLayoutWithSizeListener`, `ShadInheritedTheme`.
- **Generic helpers:** `ShadProvider`, `ShadIndexProvider`,
  `ShadProviderIndex`, `ShadMouseCursorProvider/Controller/State`,
  `ShadAnimationBuilder`, `ShadAnimate`, `ShadTextEditingController`,
  `ShadTimePickerTextEditingController`.
- **Extensions on core types:** `OmitFamilyAndPackageExtension`
  (`TextStyle`), `PositionedExt` (`Widget`), `ShadDateTime` (`DateTime`; its
  `startOfWeek` is wrong, `day - day % 7`, and `isLeapYear(int)` ignores
  `this`, so fix it while it is being hidden).
- **Top-level helpers:** `paintOuterShadows`, `applyGoogleFontToTextTheme`,
  `kContextMenuGroupId` (made obsolete by 04 §2), `kInvisibleCharCode`,
  `IntlTextDirection` (unused).
- **State-class members:** make them `@protected` or private.
  `ShadSelectState.internalFocusNode`, `showScrollToTop/Bottom`;
  `ShadInputState.hasFocus`; `ShadTabsState.orderedValues`,
  `scrollController`; `ShadSonnerState.animationController`, `hovered`,
  `onEnter`, `onExit`; `ShadResizablePanelGroupState.dragging`,
  `currentConstraints`.

**Kept public:** `ShadInputState.editableTextKey`. Wonky Slides uses it to
reach `renderEditable` for spell-check hit-testing
(`wonky_slides/lib/features/outline_view/outline_view.dart:752, 1029`).
Document it as the supported way to reach the `EditableTextState`.

Process: move each one to `lib/src/.../_internal` or add `hide` to the
barrel. Run the example and the README snippet test to confirm that nothing
public used them.

### A10. Missing export: `ThemeMode`
`ShadApp.themeMode` is typed with Material's `ThemeMode`, which the barrel
does not export, so the README snippet does not compile. Export it through
`lib/src/app.dart` (import-exempt): `export 'package:flutter/material.dart'
show ThemeMode;`.

### A11. Theme equality holes (non-breaking fix)
- The generated `==` compares `List` fields **by identity**, for example
  `effects` and `shadows` in `popover.g.theme.dart:104-105`. A theme built
  with a non-const list is never equal to its rebuild, so `ShadAnimatedTheme`
  re-lerps every frame. See CLAUDE.md, "Theme equality is load-bearing".
- **Fix:** make the generator emit `listEquals`/`mapEquals`, or add custom
  equality for those fields.
- **Document** that widget- and closure-valued theme fields (breadcrumb
  `separator`, sheet and toast `closeIcon`, calendar `format*`,
  `googleFontBuilder`) must be const or cached.
- Extend `theme_data_equality_test.dart` to build each theme twice from
  non-const lists and assert equality.

### A12. Brightness that disagrees with the scheme
`ShadThemeData(colorScheme: X.dark())` with no `brightness` defaults to light
(`data.dart:196`). Make `brightness` default to the scheme's own. The
schemes know their brightness: if `ShadColorScheme` has no such field, add a
nullable one that the generated schemes set. This is a behaviour fix and is
not breaking for anyone who passes both.

## B. Renames with shims (non-breaking, all in `fix_data.yaml`)

Done because the current name is misleading or collides. Everything else
(section C) is left alone.

| Old | New | Why |
| --- | --- | --- |
| `Shadows` (`themes/shadows.dart:11`) | `ShadShadows` | unprefixed, collides with user code |
| `GoogleFontBuilder`, `GoogleFontTextStyle` | `ShadFontBuilder`, `ShadBuilderTextStyle` | not Google-specific (02 §5) |
| `addPasteFilesListener` and friends (`clipboard_service.dart:22-34`) | `ShadClipboard.addPasteFilesListener` … | unprefixed top-level functions |
| `kDefaultToastDuration`, `kDefaultSelectMinWidth`, `kDefaultSelectMaxHeight` | `ShadToast.defaultDuration`, … static consts | unprefixed |
| `kDefaultFontFamily`, `kDefaultFontFamilyMono` | deprecated, no replacement (02) | fonts unbundled |
| `AnimateEffect`, `ShadAnimEffect` (+ deprecated `AnimEffect`) | keep `ShadAnimEffect` | three names for one type |
| `ShadFormBuilderField`, `ShadFormBuilder*State` | `ShadFormField`, `Shad*FormFieldState` | leftover flutter_form_builder naming. The widgets are already `Shad*FormField`. |
| `ShadToast.duration` | `ShadToast.displayDuration` | everywhere else `duration` means animation length |
| `ShadSonner.visibleToastsAmount` | `maxVisibleToasts` | reads as a count of currently visible toasts |
| `onLineCountChange` (input, textarea) | `onLineCountChanged` | the only `…Change` for a value; Flutter uses `…Change` only for flags |
| `ShadTabsController.selected` and `ShadTimePickerController.hour/minute/second/period` (mutable fields) | private fields + notifying setters; deprecate `setHour()`-style methods | today assigning a field skips `notifyListeners` (bug) |

## C. Considered and deferred to 2.0

Each of these is a real inconsistency, but fixing it would touch most call
sites for little benefit. Record them in `specs/2.0-candidates.md` when
1.0 ships.

- Callback naming (`onSearchChanged` vs `onQueryChanged`, `onItemSelected`
  vs `onSelected`).
- Animation naming (`effects` vs `animateIn/Out`; five spellings of reverse
  duration).
- Value/controller semantics (`value` vs `initialValue` vs `selected`;
  `ValueNotifier<Set>` vs `<List>` vs `ChangeNotifier`). One step that *is*
  cheap and additive for 1.0: give every open/close controller an `isOpen`
  getter.
- `radius` as `BorderRadius?` vs `BorderRadiusGeometry?`; `borderRadius` on
  input and sidebar; `ShadBorder` vs `BoxBorder`.
- `label: String` on slider and kbd vs `Widget` elsewhere; `action` vs
  `actions`; `items` vs `children`.
- `ShadThemeData` field naming (`primaryDialogTheme`, `outlineToggleTheme`);
  the two ways to pick the focus treatment (`disableSecondaryBorder` vs the
  subclass variant).
- `ShadInputOTP` → `ShadInputOtp` (acronym casing).
- `ShadInput.onPressed*` vs TextField's `onTap*`; `onPressedAlwaysCalled`
  is a bool.
- `ShadSheetSide` physical vs `ShadSidebarSide` directional;
  `ShadSeparatorVariant` vs `Axis`; the seven `ShadBreakpoint*` classes vs an
  enum.
- `ShadGap.raw` stores pixels in a field named `steps`; `ShadTextTheme.custom`
  is both a constructor and a field.
- Three ways to install a theme (`ShadTheme`, `ShadThemeScope`,
  `ShadAnimatedTheme`).

## D. Third-party re-exports

| Package | Today | 1.0 decision |
| --- | --- | --- |
| `lucide_icons_flutter` | full re-export, `>=3.0.0 <4.0.0` | **Keep the re-export, move to `^4.0.0` before 1.0.** Wonky alone uses `LucideIcons.` 2,204 times through shad with no direct dependency, so dropping it would be the single most expensive migration step for users. The cost: a lucide major forces a shad major. Accept it, and widen the constraint (`>=4.0.0 <6.0.0`) when a lucide major does not touch names we use. **See the open question in README.** |
| `flutter_animate` | everything except `Effect` | Keep. Narrowing it would break `.animate()` and `.ms` users for no gain. |
| `intl` | `show DateFormat, NumberFormat`, `>=0.19.0 <1.0.0` | Keep the narrow export; tighten to `^0.20.0` (0.x minors are breaking). |
| `two_dimensional_scrollables` | narrow `show`, `>=0.2.1 <1.0.0` | Keep; tighten to `^0.x` of the current version (`ShadTableCell extends TableViewCell`). |
| `slang` / `slang_flutter` | accidental full re-export | Remove (§A1). |

## E. Dependencies after 1.0

- **Removed:** `universal_image`, `flutter_svg`, `vector_graphics`. This
  removes `extended_image`, `path_provider` and the discontinued `js` package
  from every consumer's tree.
- **Kept:** `boxy` (3 files, light, not exported), `collection`, `intl`,
  `slang`/`slang_flutter`, `theme_extensions_builder_annotation`, `web`
  (conditional imports), `flutter_animate`, `lucide_icons_flutter`,
  `two_dimensional_scrollables`.
- **Later (1.x):** generate the localizations as plain Dart classes and drop
  the slang runtime dependency (81 deferred locale libraries, about 1 MB of
  generated source).

## F. Documentation

- 161 of 377 exported top-level types (about 43%) have **no class doc**.
  These include `ShadApp`, `ShadThemeData`, `ShadTheme`, `ShadColorScheme`,
  `ShadDecoration`, `ShadPopover`, `ShadContextMenu`, `ShadOption` and about
  35 of the 47 `*Theme` classes. Over all public declarations, 22% are
  undocumented.
- The worst files: `theme/themes/base.dart` (67/68 undocumented),
  `utils/responsive.dart` (28/28), `theme/color_scheme/base.dart` (23/23),
  `text_theme/theme.dart` (24/25), `raw_components/focusable.dart` (16/16),
  `decorator.dart` (26/37), `sidebar.dart` (41/95).
- 46 `{@macro}` references resolve to nothing (typos such as
  `ShadButton.bakcgroundColor`, `ShadowButton.height`, `ShadDivider.*`).
- **Plan:**
  - document every exported class first, then the theme fields;
  - fix the macros;
  - enable `public_member_api_docs` once it passes;
  - run `documentation-writing` over new prose.

  This is the largest single block of 1.0 work by volume, but it is
  parallelisable and has no risk.

## G. `lib/fix_data.yaml`

Write it alongside the 0.99.5 shims. Cover every rename in §A3, §A7 and §B,
and the §A2 removals that are pure renames. Add `test_fixes/` with
before/after files (`dart fix --compare-to-golden`) and run them in CI.
