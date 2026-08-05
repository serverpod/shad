# Working notes for `shadcn_ui`

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
- `copyWith` forwards the already-resolved component themes, so it **cannot
  re-derive them**. `copyWith(radius: X)` moves the theme's `radius` field but
  not the components'. Rebuild the theme instead.
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
- `ShadStyleTokens` — one of shadcn's eight styles as 65 measured fields:
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

- **`Border` requires colour-uniform sides to paint a radius**, and
  `BorderSide.none` carries opaque black. `ShadBorderSide.toBorderSide()`
  therefore keeps its colour at zero width. Any component that draws only some
  of its sides (the OTP strip) depends on this.
- **There is no z-index in a `Row`.** shadcn's focused OTP slot uses `z-10` to
  let its ring overlap its neighbours; in Flutter the next sibling paints over
  the ring's edge instead. The ring is still drawn *outside* the slot (slots
  are transparent, so only their hairlines cross it); don't move it inside —
  that reads as a different control from every other field.
- **CSS clips outer box-shadows to outside the border box**; Flutter's default
  `BlurStyle.normal` paints the shadow behind the whole box, which shows
  through any transparent or translucent fill as a grey wash. Every outward
  shadow in `Shadows` therefore uses `BlurStyle.outer`. If a control with a
  transparent fill ever looks "slightly grey", check for a stray plain
  `BoxShadow` first.
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
- `ShadTextarea` has its own theme; it previously read `ShadInputTheme` for
  padding and alignment, which made every textarea-specific value dead.

## Testing

- **Most golden tests do not actually compare.** They use
  `expect(finder, matchesGoldenFile(...))`, and that matcher is asynchronous —
  an unawaited `expect` never reports the mismatch. Only `sheet_test.dart` uses
  `await expectLater(...)`, which is why those six are the only goldens that
  ever fail. Converting the rest is a known, unstarted job: it will surface
  every accumulated diff at once and require regenerating ~50 PNGs.
- Goldens in the working tree were regenerated on **macOS**; CI runs on Linux.
  Treat a local regeneration as provisional.
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
  package's own barrel** — `lib/src/app.dart` is the only exemption, and
  `.github/workflows/check-imports.yaml` enforces it. This is why `ShadSpinner`
  is a `CustomPainter` rather than a wrapped `CircularProgressIndicator`.
- Verify with: `flutter analyze` and `flutter test` at the root, then the same
  in `example/`, then `flutter analyze lib` in `playground/`. The example and
  playground consume the package through the public barrel, so they catch
  export breakage that the root analyzer does not.
- `example/macos/` is gitignored, so changes there (e.g. the
  `com.apple.security.network.client` entitlement that `google_fonts` needs)
  will not commit.

## The sidebar component

- `ShadSidebarScaffold` owns the responsive behaviour; `ShadSidebar` carries
  the configuration (`side`/`variant`/`collapsible`) and renders the panel.
  Descendants read `ShadSidebarScope.of(context)` for the collapsed state —
  that is how menu buttons shrink to squares and sub-menus vanish in the
  icon rail.
- The icon rail works by **geometry, not by swapping layouts**: the rail is
  48 wide, groups pad by 8, so a button is 32 wide — exactly `px(8) + icon(16)
  + px(8)` — and the label starts at the clip edge. The width animation plus
  `Clip.hardEdge` therefore reproduces the CSS truncation. Trailing widgets
  *are* dropped while collapsed, or the row's minimum width would overflow.
- Offcanvas keeps the content laid out at full width inside an `OverflowBox`
  anchored to the inner edge, so it slides off rather than reflowing.
- The mobile sheet is imperative: the scaffold listens to the controller and
  pushes/pops a `ShadSheet`. `openMobile` and `open` are independent, as in
  the reference.
- Sidebar metrics vary per style through `sidebarItemHeight`/`Sm`/`Lg` and
  `sidebarItemPaddingX`/`sidebarSubItemPaddingX` tokens; radius reuses
  `itemRadius`, the group label reuses the `overline` role, button text the
  `body` role. The floating/inset surface radius is the popover radius capped
  at the 2xl step (`_sidebarSurfaceRadius`), which matches all styles within
  2px without a dedicated token.

## The example docs browser

`example/lib` is a docs site: `common/app_shell.dart` (top nav) →
`screens/components_screen.dart` (a `ShadSidebarScaffold` listing
`docs/registry.dart`) → `docs/docs.dart` (the reusable page widgets).

- **The code shown is the code that runs.** Each example is one standalone
  widget file under `lib/docs/examples/<slug>/<id>.dart`, bundled as an
  *asset* (one pubspec entry per directory — asset dirs are non-recursive)
  and loaded with `rootBundle` by `CodeBlock.asset`. Adding an example means:
  widget file + `ComponentExample` in `docs/pages/<slug>.dart` + the pubspec
  entry if the directory is new.
- Code blocks are always dark, in JetBrains Mono (vendored in
  `example/fonts/`), highlighted by `syntax_highlight`, whose grammar loads
  in `main()` via `CodeHighlighter.ensureInitialized()` **before** `runApp`.
- The old knob pages under `example/lib/pages/` are still routed — each doc
  page links to its playground — but are no longer the primary navigation.
- `example/test_driver/app.dart` wraps `main()` in
  `enableFlutterDriverExtension()`; run with
  `flutter run -t test_driver/app.dart` to drive the app from tooling
  (screenshots, taps). Driver commands hang until
  `set_frame_sync: false` because doc previews contain forever-animating
  spinners.

## The example theme editor

`example/lib/pages/theme_editor.dart` plus `example/lib/common/theme_editor/`
mirrors `/create`. Points that were decided deliberately:

- The customizer panel is **fixed dark chrome**, not part of the theme being
  edited — a panel that follows the configuration becomes unreadable while
  editing a light or menu-inverted theme.
- Light/dark and text direction are the app-wide toolbar switches; the panel
  does not duplicate them.
- Menu colours are derived from the **menu's own opaque surface**, never from
  the page's `--accent`, which vanishes on an inverted or translucent menu.
- `fl_chart` and `google_fonts` are example-only dependencies. The package
  itself has neither.
