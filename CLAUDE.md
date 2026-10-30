# Working notes for `shad`

Things that are true about this repo and are expensive to rediscover. Written
for whoever (or whatever) picks the work up next.

## The reference checkout

`reference/ui/` is a clone of [shadcn-ui/ui](https://github.com/shadcn-ui/ui).
It is gitignored — it is ~150 MB and not ours to vendor — but it is the source
of truth for every visual decision here.

**Look values up there. Do not guess at colours, paddings, radii or type.**
Several rounds of this project's history were spent fixing values that were
guessed rather than read.

| What | Where |
| --- | --- |
| Per-style component CSS (the eight styles) | `apps/v4/registry/styles/style-{vega,nova,maia,lyra,mira,luma,sera,rhea}.css` |
| Base colour palettes, OKLCH, light + dark | `apps/v4/registry/themes.ts` |
| The app's own tokens | `apps/v4/app/globals.css` |
| Component sources | `apps/v4/registry/new-york-v4/ui/*.tsx` |
| The `/create` theme editor we mirror | `apps/v4/app/(app)/(create)/` |
| Its individual pickers | `apps/v4/app/(app)/(create)/components/*.tsx` |

The style CSS files are ~1670 lines each of `.cn-<component> { @apply ... }`
blocks. To compare a component across all eight styles, parse the blocks and
diff them — **243 of the 407 classes differ between styles**, so eyeballing one
file tells you very little.

Tailwind conversions used throughout:

- Spacing: 1 unit = 4px. `px-2.5` is 10, `h-9` is 36, `p-[3px]` is a literal 3.
- Type: `text-xs` 12/16, `text-sm` 14/20, `text-base` 16/24, `text-lg` 18/28.
- Leading: `none` 1, `snug` 1.375, `normal` 1.5, `relaxed` 1.625.
- Tracking is in ems: `wide` .025, `wider` .05, `widest` .1 — multiply by the
  font size to get Flutter's logical-pixel `letterSpacing`.
- `ring-N` is a box-shadow at zero offset, so a ring has **no gap** between it
  and the element.
- OKLCH → sRGB needs a real conversion (Oklab matrices + the sRGB transfer
  function); there is a converter in this project's history, and the values it
  produces are pinned by `test/src/theme/color_scheme/shadcn_tokens_test.dart`.

## Theme architecture

The flow is: `ShadThemeData` factory → a `ShadThemeVariant` → per-component
themes. Understanding this order prevents most theming bugs.

- A **variant** is constructed from a colour scheme, a radius, a text theme, a
  `ShadStyleTokens` and a `ShadSpacing`, and **bakes all of them** into the
  component themes it returns. Change one of its inputs and the variant has to
  be rebuilt — `ShadThemeVariant.rebuild(...)` exists for exactly that, and the
  factory calls it when a caller passes both a variant and a different radius,
  scheme or text theme. Where the caller gives no explicit value, the variant's
  own wins, so the two can never disagree.
- `ShadThemeData.textTheme` comes from `variant.textTheme()`, **not** from the
  merged input. That is what applies the style's text roles to `small`, `muted`,
  `p`, `list` and `large`. Reading the raw input here once made a style change
  resize components but leave every font size alone.
- `ShadThemeData` records the caller's raw factory arguments (`_inputs`,
  `@ignore`d by the generator) and its hand-written `copyWith` re-runs the
  factory from them, so `copyWith(radius:/colorScheme:/style:/...)` re-derives
  every component theme. The generated mixin's `copyWith` is shadowed; its
  generated `merge` and `lerp` still go through the factory. **Adding a
  factory parameter means adding it to `_ShadThemeInputs` and `copyWith`
  too** — `test/src/theme/theme_data_copy_with_test.dart` catches the common
  ones.
- With no `brightness`, `ShadThemeData` takes it from the scheme's
  background luminance.
- There are **two variants**, but no longer two copies:
  `ShadDefaultThemeNoSecondaryBorderVariant` subclasses
  `ShadDefaultThemeVariant` and overrides only the focus treatment (a 2px
  inner `focusedBorder` recolour plus `focusReserve` insets, instead of the
  outward ring). Fix things in the parent; only touch the subclass when the
  change is about focus geometry.
- Menu appearance is a **theme-level** feature: `ShadThemeData` takes
  `menuColorScheme` (shadcn's "Inverted" — pass the dark counterpart scheme;
  the reference toggles the `dark` class on menu surfaces, so in dark mode
  inverted is a no-op), `menuTranslucent` (`popover/70` + backdrop blur,
  `foreground/10` row highlights) and `menuAccent` (bold = the scheme's
  accent pair is rewritten with its primary pair *before* derivation). The
  example editor passes these through; it no longer derives menu colours
  itself.

### Theme equality is load-bearing

The generator compares `List` fields by identity. Every theme class with a
list field overrides `==`/`hashCode` to compare them by value and defer to the
generated `==` for the rest (see the comment in any of them, e.g.
`ShadPopoverTheme`). A new list field needs adding to that override.
`flutter_animate` `Effect`s have no `==`, so effects lists only compare equal
when they are const.


`ShadAnimatedTheme` is an `ImplicitlyAnimatedWidget`: if `ShadThemeData !=` the
previous one, it starts a 200 ms lerp across ~54 component themes on every
rebuild. Anything that breaks value equality — a method tear-off in `==`, a
non-const `Widget` in a theme field, a `List` compared by identity — silently
costs a full re-animation per frame. `test/src/theme/theme_data_equality_test.dart`
locks the chain; add to it rather than trusting a local check.

## The token system

- `ShadRadii` — the `none/sm/md/lg/xl/2xl/4xl/full` scale, derived from
  `ShadThemeData.radius` (which is the **md** step). At the default 8: 6, 8, 10,
  14, 16, 32.
- `ShadStyleTokens` — one of shadcn's eight styles as 67 measured fields:
  radii per surface class, ring width/opacity, border opacities, control and
  field metrics, selection-control dimensions, surface padding, shadows, and
  six `ShadTextRole`s (`title`, `label`, `body`, `caption`, `overline`, `field`).
- `ShadSpacing` — the `--spacing` unit (4px default).
- **Metrics shadcn writes in spacing units** (`h-9`, `px-2.5`) are stored in the
  pixels they render at the default step and are passed through the variant's
  `scaled()` so they follow `spacing.step`. **Bracketed literals**
  (`h-[18.4px]`, `rounded-[4px]`, `p-[3px]`) are not scaled. Keep that
  distinction when adding a token.
- `uppercase` on a text role is **not** applied automatically: `TextStyle` has
  no text-transform, and every Shad component takes a caller's widget rather
  than a string. `role.applyCase(text)` is the escape hatch.
- **Icon sizes inside buttons are a token, not the caller's problem.**
  `.cn-button` carries `[&_svg:not([class*='size-'])]:size-4`, so the button
  hands 16 down through its `IconTheme`; without that Flutter's
  `IconThemeData.fallback()` renders every icon at **24**, which is what made
  toolbars look wrong and forced `size: 16` on call sites everywhere. The
  `:not` is the reason it is only a default — an `Icon` with its own `size`
  still wins. Text buttons and icon buttons are sized *separately*
  (`buttonIconSize{,Sm,Lg}` vs `iconButtonIconSize{,Sm,Lg}`): the reference's
  `.cn-button-size-icon-sm` keeps 16 where `.cn-button-size-sm` drops to 14.
  Only `mira` follows the step all the way down and only `sera` has a
  `size-3.5` base; `ShadButtonSizesTheme` carries `iconSm`/`iconLg` slots so
  an icon button never borrows a text button's metrics.

## Fonts

shad bundles **no fonts** since 1.0: `ShadTextTheme`'s default `family` is
null (the platform font). Inter/Geist/GeistMono used to ship in `fonts/`;
that cost every app ~1.2 MB and the web downloaded them at startup.
`kDefaultFontFamily`/`Mono` remain, deprecated, pointing at nothing. Nothing
under `lib/` may name a `packages/shad/` asset (CI greps for it).
`ShadInputOTP` uses tabular figures, not a mono face — the reference's slots
are not `font-mono`. The example loads every font through `google_fonts`.

## Colour tokens (v4)

- Fields, checkboxes, radios and OTP slots outline with `--input`; cards,
  popovers, dialogs, menus and toasts with a wash of their own foreground
  (`ring-foreground/10`). Not `--border`. The soft styles vary it per surface
  *and* per brightness — `luma`/`rhea` are `/5` light `/10` dark, `sera` is
  `/5` on cards but `/10` on menus — which is why the tokens carry
  light/dark pairs for card, surface and dialog opacities.
- The `/create` styles changed the button variants from classic shadcn:
  ghost/outline hover with `bg-muted` + `text-foreground` (not accent),
  destructive is a soft `/10` tint, secondary hover is a 5% foreground mix,
  and command items highlight with `bg-muted`. Menu items still use
  `focus:bg-accent focus:text-accent-foreground` — with **every descendant**
  (icons, shortcuts) following the foreground.
- **Dark `--border` and `--input` are translucent whites** (10% and 15%). This
  matters: an opaque grey hairline disappears against a card of the same value.
- The dark card and popover are a step lighter than the page.
- Overlays are `bg-black/10` with `backdrop-blur-xs` in both modes — the blur is
  what lets the tint stay that light.
- `ShadSlateColorScheme` and `ShadGrayColorScheme` are v3 palettes that shadcn
  no longer ships. They are kept for compatibility — and slate is still the
  package default — while `neutral`, `stone` and `zinc` are generated from
  `themes.ts`. Regenerating slate against v4 is an open question.

## Flutter gotchas hit in this codebase

- **CSS heights are border-box; `Container` adds its decoration's border as
  padding around the child** (`DecoratedBox` does not — the menubar strip
  relied on one and came out 2px short). A height constraint applied *inside*
  a `ShadDecorator` comes out `2 × border` too tall — that made outline
  buttons and toggles 2px taller than their borderless variants and every
  control 4px taller in the no-secondary-border variant (focus reserve).
  Size constraints go *outside* the decorator;
  `test/src/components/control_heights_test.dart` locks input, select
  trigger, buttons, toggles, date/time picker, OTP slots, the menubar and
  the calendar's geometry (cell size, nav buttons, caption dropdowns —
  `calendarCellSize`/`calendarCellRadius`/`calendarPadding`/
  `calendarCaptionHeight` tokens) to the style values in both variants.
  Calendar tests use single-glyph captions and small day text: the test
  font's em-wide glyphs wrap or overflow inside cells that fit real fonts
  comfortably. Related: the select trigger's `py-2`
  never acts in the reference (its height is pinned by `data-[size]:h-*`),
  so there is no `selectPaddingY` token — only `selectPaddingX` and
  `ShadSelectTheme.minHeight`. The time picker has no reference counterpart;
  its fields deliberately borrow the input's text role, decoration and
  height rather than carrying their own metrics.
- **`Border` requires colour-uniform sides to paint a radius**, and
  `BorderSide.none` carries opaque black. `ShadBorderSide.toBorderSide()`
  therefore keeps its colour at zero width. Any component that draws only some
  of its sides (the OTP strip) depends on this.
- **There is no z-index in a `Row`.** shadcn's focused OTP slot uses `z-10` to
  let its ring overlap its neighbours; in Flutter the next sibling paints over
  the ring's edge instead. The ring is still drawn *outside* the slot (slots
  are transparent, so only their hairlines cross it); don't move it inside —
  that reads as a different control from every other field.
- **The portal's overlay is nudged after it is anchored, and anything drawn
  against the anchor has to follow.** `ShadPositionDelegate` runs Flutter's
  `positionDependentBox`, which clamps the overlay into the viewport at layout
  time — so a tooltip near the window edge is slid inward while its arrow, a
  `Center` inside the bubble, stayed put and pointed at empty space. The
  portal now computes the same placement in `_calculatePosition` (through
  `ShadPositionDelegate.positionFor`, so the two cannot drift apart) and
  publishes the displacement as `ShadPortalPlacement.shift`; the arrow
  subtracts it, clamped to keep the bubble's corner radius plus its own
  half-diagonal clear of each end. Doing this at *paint* time instead
  (`localToGlobal` from the arrow) looks simpler and is wrong: the entrance
  `ScaleEffect` wraps the arrow, so the measurement moves while the tooltip
  animates in.
- **CSS clips outer box-shadows to outside the border box, and Flutter cannot
  express that with a `BoxShadow`.** `BlurStyle.normal` paints the shadow
  behind the whole box, which shows through any transparent or translucent
  fill as a grey wash; `BlurStyle.outer` cuts the hole out of
  `rect.shift(offset).inflate(spreadRadius)` — the *shadow's* rectangle, not
  the element's — so with any offset or spread the shadow disappears next to
  the element and then restarts with a hard edge a few pixels out. A
  `shadow-lg` dialog lost the 7px directly beneath it that way. Outer shadows
  therefore go through `ShadShadowDecoration` (`lib/src/utils/shadow.dart`),
  which blurs normally and clips to the region outside the wrapped
  decoration's own `getClipPath`. **Never put an outward shadow in a
  `BoxDecoration.boxShadow` here** — use `ShadShadowDecoration.box(...)`, which
  takes the same arguments. `test/src/utils/shadow_test.dart` locks the
  profile (monotone falloff, nothing inside the element, a crisp hairline for
  the spread-only shadows used as outlines) by rasterising and sampling; it
  flips `debugDisableShadows` off, which flutter_test otherwise leaves on.
  Tests that introspect a component's fill or border go through
  `test/decoration_finders.dart` to look past the wrapper.
- `ShadButton` centres its label (`TextAlign.center` in its DefaultTextStyle).
  Anything button-based that should read as a row — menu items — must merge
  `TextAlign.start` back in below the button.
- `ShadBorder.merge` takes the other's `radius` **and** `offset`
  unconditionally. An override that sets only the radius silently drops the
  offset — which collapses a focus ring onto the element's own border.
- `ShadOutwardBorderPainter` inflates the rect by `offset` and strokes *inside*
  it, so `offset == width` puts the stroke flush against the element. That is
  how the shadcn ring's "no gap" is reproduced.
- A `Positioned` child does not contribute to a `Stack`'s size. The slider's
  thumb is positioned, so the slider has to reserve `max(track, thumb)` itself
  or it lays out at track height and paints over its neighbours.
- A widget with no intrinsic height stretches when its parent hands down tight
  constraints. `ShadKbd` takes an explicit height and an `Align(heightFactor: 1)`
  so a key cap stays key-shaped inside a button's row.
- Fixed-size boxes around text (OTP slots) must multiply by
  `MediaQuery.textScalerOf(context).scale(1)` or the glyph is clipped.
- Vertical centring in a fixed-height field is governed by the **content
  column's `mainAxisAlignment`**, not by an inner `Align`.
- State-dependent text colour must be resolved where the state is known. A
  `DefaultTextStyle` inside a builder's captured `child` cannot see hover.
- **Anchors take a fallback chain** (`ShadAnchorAuto.fallback`, recursively);
  the portal keeps the candidate that overflows the screen least, then
  shifts. Submenus and `ShadDropdownMenu` rely on it to flip horizontally.
  `ShadGlobalAnchor.followerAnchor` picks the overlay point placed at the
  global offset; context menus use `topStart` (corner at the pointer).
- `ShadTextarea` has its own theme; it previously read `ShadInputTheme` for
  padding and alignment, which made every textarea-specific value dead.
- **A loop that only ever `await`s a synchronously-completed future never
  returns to the event loop.** Dart drains the *whole* microtask queue before
  taking the next event, so such a loop freezes the app outright: no frames,
  no pointer input, and no response to a window resize (the resize path is
  `scheduleForcedFrame`, which still needs an event-loop turn). This is not
  hypothetical — `ShadSelect`'s hover-to-scroll chevrons hit it. A second
  `animateTo` on a `ScrollPosition` calls `beginActivity`, which disposes the
  previous activity, and `DrivenScrollActivity.dispose` completes its
  completer **synchronously**; two loops therefore cancel each other in an
  unbroken microtask chain, and because the offset only advances on a frame
  that never comes, neither exit condition is ever met. Any driver loop here
  needs a re-entrancy guard *and* a real yield (`Future.delayed(Duration.zero)`)
  per iteration. `test/src/components/select_auto_scroll_test.dart` locks the
  guard. On web this reads as a browser bug, which is how it went unnoticed.
- **Escape must not be bound unconditionally.** A `CallbackShortcuts` for
  Escape consumes the key even while its overlay is closed, so the enclosing
  dialog never closes. Use `ShadDismissShortcut` (`lib/src/utils/`), whose
  action reports itself disabled — and the key unhandled — while inactive.
- **Each root context menu has its own tap-region group**, shared with its
  submenus (`ShadContextMenuState.tapRegionGroupId`). A single global group
  made a tap on another menu's trigger count as inside, so the open menu
  never closed.
- **Dialog routes follow the app theme live** unless opened from a locally
  re-themed subtree; capturing `ShadTheme.of(context)` at push time froze open
  dialogs and sheets in the old theme across a light/dark switch.
- **Private field promotion is per library.** Two classes in one file with a
  same-named private field, one of them non-final, disable promotion of both
  (`ShadTimeOfDay._period` broke when the controller gained a `_period`).
- `calendar.dart` used to contain a literal NUL byte in a cache key, which
  made `grep` treat it as binary and silently skip it. It is `\u0000` now;
  keep NULs escaped.
- **A fully transparent `ColoredBox` still hit-tests as opaque** (it extends
  `RenderProxyBoxWithHitTestBehavior` with `behavior: opaque`). The dialog
  route's full-screen barrier-blur layer uses one to give its
  `BackdropFilter` extent, and without an `IgnorePointer` it silently ate
  every outside tap — barrier dismissal was dead for all dialogs and sheets
  and nobody noticed, because dialogs have close buttons.

## Testing

- **Every golden is `await expectLater(...)`.** `matchesGoldenFile` is
  asynchronous; inside a plain `expect` a mismatch is never reported, which is
  how 52 of 58 goldens went stale unnoticed until 1.0.
  `test/goldens_are_awaited_test.dart` fails on an unawaited one.
- **Goldens are Linux-only.** They are generated by the `update-goldens`
  workflow (`gh workflow run update-goldens.yml --ref <branch>`, then
  `gh run download <id> -n updated-goldens` and copy `test/` over) and
  compared only on Linux: `test/flutter_test_config.dart` skips pixel
  comparison elsewhere — macOS differs by several percent on these small
  images — and makes `--update-goldens` a no-op there, so macOS pixels can
  never be committed. `SHAD_COMPARE_GOLDENS=1` forces comparison;
  `SHAD_SKIP_GOLDENS=1` skips it on Linux too (the minimum-Flutter CI job).
- Prefer asserting resolved *theme values* over pixels. For anything with modes
  (menu colour × finish × accent × brightness) walk the whole matrix in one test
  and assert luminance contrast — that found a real collision (light + inverted
  + bold puts a near-black primary on a near-black surface) that reasoning about
  cases had missed twice.
- `pumpAndSettle` hangs on anything with `ShadSkeleton` or `ShadSpinner`; pump
  fixed frames instead.
- Popover contents are wrapped in `IgnorePointer` during the entrance
  animation — pump ~12 × 50 ms before tapping an option, and pick options near
  the top of the list, since ones below the scroll fold are found but not
  tappable.
- Example tests set `GoogleFonts.config.allowRuntimeFetching = false`; the
  resulting log lines are noise, not failures.

## Build and CI

- Component themes are generated: `dart run build_runner build
  --delete-conflicting-outputs` after touching anything under
  `lib/src/theme/**`. The generated `*.g.theme.dart` files are committed.
- i18n uses slang's **legacy** builder — regenerate with `dart run slang`, not
  `build_runner`. Only `lib/src/i18n/en.i18n.yaml` needs editing; other locales
  inherit from English.
- **Nothing under `lib/` may import `material.dart`, `cupertino.dart` or the
  package's own barrel** — `lib/src/app.dart` and `lib/src/theme/theme_scope.dart`
  are the only exemptions (Material/Cupertino interop), and
  `.github/workflows/check-imports.yaml` enforces it. This is why `ShadSpinner`
  is a `CustomPainter` rather than a wrapped `CircularProgressIndicator`.
- Renames keep the old name `@Deprecated('Use X. Will be removed in the next
  major version.')` and get an entry in `lib/fix_data.yaml`; add a line to
  `test_fixes/shad.dart(.expect)` and run
  `dart fix --compare-to-golden test_fixes` (CI does). Data-driven fixes only
  trigger on reported diagnostics, which is why `test_fixes/` enables
  `deprecated_member_use_from_same_package`.
- `test/readme_snippet_test.dart` and `example/test/example_md_test.dart` hold
  verbatim copies of the README and `example/example.md` snippets and check
  they still match.
- Releases: bump `pubspec.yaml` + `CHANGELOG.md` on main; after tests pass
  `create-release.yaml` tags `v<version>`, and `publish.yaml` publishes that
  tag to pub.dev (OIDC).
- Verify with: `flutter analyze` and `flutter test` at the root, then the same
  in `example/`. The example consumes the
  package through the public barrel, so it catches export breakage that the
  root analyzer does not. There is no separate `playground/` app any more —
  it was a standalone Flutter web project superseded by the example app's own
  `PlaygroundScreen` and removed with its Firebase hosting config.
- `example/macos/` is gitignored, so changes there (e.g. the
  `com.apple.security.network.client` entitlement that `google_fonts` needs)
  will not commit.

## The sidebar component

- `ShadSidebarScaffold` owns the responsive behaviour; `ShadSidebar` carries
  the configuration (`side`/`variant`/`collapsible`) and renders the panel.
  Descendants read `ShadSidebarScope.of(context)` for the collapsed state —
  that is how menu buttons shrink to squares and sub-menus vanish in the
  icon rail.
- **Both collapse modes keep content laid out at the expanded width** inside
  an `OverflowBox` and let the animated container clip it — that is what CSS
  `overflow-hidden` does, and it is why a header that is a plain `Row` (logo +
  gap + label) truncates instead of throwing a RenderFlex overflow. Offcanvas
  anchors the box to the inner edge so the panel slides off; the icon rail
  anchors it to the start.
- Because the parent no longer narrows, the icon rail's square is the menu
  button's own doing: it animates an explicit width to `collapsedWidth −
  group padding` (48−16 = 32 = `px(8)+icon(16)+px(8)`) inside an
  `Align(start, heightFactor: 1)`. Every fixed-width part of its row — the
  icon-label gap, the trailing badge — animates to zero on the *same*
  timeline, because anything that disappears instantly (or stays fixed) makes
  the row's minimum width overflow mid-animation in one direction or the
  other.
- The mobile sheet is imperative: the scaffold listens to the controller and
  pushes/pops a `ShadSheet` with `scrollable: false` — the sheet's own scroll
  view hands the sidebar's `Expanded` column unbounded height, and the crash
  surfaces as a misleading `mouse_tracker` assertion. `openMobile` and `open`
  are independent, as in the reference. Growing past the breakpoint pops the
  sheet (post-frame, from `didChangeDependencies`), matching the reference
  unmounting its mobile branch.
- **The drawer route outlives the scaffold's State**, and its builder re-runs
  on every MediaQuery change — so `_showMobileSheet` captures everything the
  builder needs (controller, sidebar, collapsed width) instead of reading
  `this.widget`/`this.context`, which are gone after unmount. The route
  itself is captured via `ModalRoute.of` in the builder: closing goes through
  it (`pop` when current, `removeRoute` when covered — never a blind
  `Navigator.pop`), and `dispose` removes an orphaned drawer post-frame.
- `ShadSidebarScaffold.borderRadius` clips the whole scaffold; it exists for
  embedding in rounded containers (the docs demos), where the sidebar's
  square surface would otherwise cover the host's corners.
- Sidebar metrics vary per style through `sidebarItemHeight`/`Sm`/`Lg` and
  `sidebarItemPaddingX`/`sidebarSubItemPaddingX` tokens; radius reuses
  `itemRadius`, the group label reuses the `overline` role, button text the
  `body` role. The floating/inset surface radius is the popover radius capped
  at the 2xl step (`_sidebarSurfaceRadius`), which matches all styles within
  2px without a dedicated token.

## The example docs browser

`example/lib` is a docs site: `common/app_shell.dart` (top nav, two sections)
→ `screens/components_screen.dart` (a `ShadSidebarScaffold` listing
`docs/registry.dart`) → `docs/docs.dart` (the reusable page widgets). The
other section is `screens/playground_screen.dart`, which is the section the
app opens on.

- **The code shown is the code that runs.** Each example is one standalone
  widget file under `lib/docs/examples/<slug>/<id>.dart`, bundled as an
  *asset* (one pubspec entry per directory — asset dirs are non-recursive)
  and loaded with `rootBundle` by `CodeBlock.asset`. Adding an example means:
  widget file + `ComponentExample` in `docs/pages/<slug>.dart` + the pubspec
  entry if the directory is new.
- Code blocks are always dark, in JetBrains Mono (vendored in
  `example/fonts/`), highlighted by `syntax_highlight`, whose grammar loads
  in `main()` via `CodeHighlighter.ensureInitialized()` **before** `runApp`.
- `example/test_driver/app.dart` wraps `main()` in
  `enableFlutterDriverExtension()`; run with
  `flutter run -t test_driver/app.dart` to drive the app from tooling
  (screenshots, taps). Driver commands hang until
  `set_frame_sync: false` because doc previews contain forever-animating
  spinners.

## The example theme editor

`example/lib/common/theme_editor/` mirrors `/create`. Points that were decided
deliberately:

- **The editor themes the whole app, not a preview pane.** The configuration
  lives in `themeConfigProvider` (`main.dart`) and `ShadApp`'s `theme`,
  `darkTheme` and text scale are all built from it, so the top nav, the
  playground and the docs browser restyle together. There is no preview-only
  `ShadThemeScope` any more.
- `customizer_panel.dart` is the panel; `app_shell.dart` docks it beside the
  page (`ThemeCustomizerPanel.width`) and lets it cover the viewport below
  700px, where a docked panel leaves nothing usable. It is toggled from the
  top nav, so it is reachable from both sections.
- The page is **always** the first child of the shell's `Stack` and `Row`,
  and the panel is added after it. Building the page conditionally instead
  reshaped the element above `ComponentsScreen` and threw its `State` away,
  so opening the editor bounced you back to the first component — which
  reads as "the editor does nothing to this page".
- The customizer panel is **fixed dark chrome** at an unscaled text size, not
  part of the theme being edited — a panel that follows the configuration
  becomes unreadable while editing a light, menu-inverted or 1.6×-scaled
  theme.
- Light/dark and text direction are the app-wide toolbar switches; the panel
  does not duplicate them.
- Anything the app adds on top of the generated theme has to be passed
  *into* `ThemeEditorConfig.build()` — `customTextStyles` is how `main.dart`
  keeps its `myCustomStyle` example alive, since the editor owns the whole
  `ShadTextTheme`.
- The shell reads its signals in the `SignalBuilder` body, **not** inside the
  `LayoutBuilder` below it: that callback runs during layout, outside the
  scope solidart tracks, so a read in there never subscribes and the panel
  never opens.
- Menu colours are derived from the **menu's own opaque surface**, never from
  the page's `--accent`, which vanishes on an inverted or translucent menu.
- Fonts all come from `google_fonts` at runtime. `EditorFont.load()` fetches
  the weights the text roles use; `main()` awaits the default font before
  `runApp`, and the font pickers load a face *before* applying it, so text
  reflows once, not twice. Builders and text themes are cached per family
  (closure identity is part of theme equality).
- `fl_chart` and `google_fonts` are example-only dependencies. The package
  itself has neither.
