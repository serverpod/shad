## Unreleased

### New component: Sidebar

A full port of shadcn/ui's `Sidebar`: `ShadSidebarScaffold` lays a
`ShadSidebar` next to the page content, with `offcanvas`/`icon`/`none`
collapse modes, `sidebar`/`floating`/`inset` variants, a directional
`start`/`end` side, an optional grab rail, and a `⌘B`/`Ctrl+B` shortcut.
Below the `md` breakpoint the sidebar presents as a modal sheet instead.
Content composes from `ShadSidebarGroup`, `ShadSidebarMenu`,
`ShadSidebarMenuButton` (sizes, outline variant, badges, tooltips in the
icon rail), `ShadSidebarMenuSub`, `ShadSidebarMenuSkeleton`,
`ShadSidebarSeparator` and `ShadSidebarTrigger`. Colours come from the
scheme's `sidebar*` tokens and metrics from five new per-style tokens
(`sidebarItemHeight`/`Sm`/`Lg`, `sidebarItemPaddingX`,
`sidebarSubItemPaddingX`).

### Example app: documentation browser

The example is now a docs site: a shadcn-style top navigation
(Components / Theme Editor, with the light-dark and LTR-RTL switches on the
right) over a component browser built on the new sidebar. Every component
has a documentation page — description, live examples with a Preview/Code
tab pair, and a link to the old knob playground page. Example source is
shown in JetBrains Mono, highlighted with `syntax_highlight`, and is loaded
from the *actual bundled example file*, so the code on screen cannot drift
from the code that runs.

A fidelity pass against shadcn/ui's `/create` registry: colours and states were re-read from `registry/styles/style-*.css` and `registry/config.ts` rather than from the older `new-york-v4` values, and the menu appearance options moved into the theme itself.

### Breaking (visual): button variants match the current reference

- **Ghost and outline** content is the `foreground`, no longer `primary` — on an accent theme, ghost buttons and menu rows stopped being tinted blue. Hover is `bg-muted hover:text-foreground` (`muted/50` in dark), not `bg-accent`.
- **Destructive** is a soft tint (`bg-destructive/10 text-destructive`, `/20` dark, hover one step stronger) instead of a solid fill, with a destructive focus ring.
- **Secondary** hover mixes 5% foreground into the surface; **primary** hover is `primary/80`.
- **Outline** fills follow the style tokens: `bg-background` + `dark:bg-input/30 dark:border-input` in `vega`, washes or transparency in `maia`/`mira`/`luma`/`sera`/`rhea`.

### Menus: reference state fidelity

- Menu rows recolour *all* their content on hover — text, leading/trailing icons and shortcuts — to `accent-foreground` (`focus:**:text-accent-foreground`). Previously a leaf item's hover changed only the background, which could leave white-on-white content in inverted or bold-accent themes.
- `ShadContextMenuItem.destructive` marks a destructive action: destructive text and icons over a `destructive/10` hover wash.
- Menubar triggers highlight with `bg-muted` on hover and while open (`aria-expanded:bg-muted`), and the strip follows `h-9 p-1 border shadow-xs` per style.
- Command items highlight with `bg-muted`/`text-foreground`, not the accent.
- Menu row height, min-width and surface padding come from the style tokens instead of a fixed 32/128/4.

### Menu appearance options on `ShadThemeData`

`ShadThemeData` now takes `menuColorScheme`, `menuTranslucent` and `menuAccent`, with the same semantics as shadcn's create editor: inverted menus take the whole opposite-brightness palette, translucent ones a blurred `popover/70` surface with `foreground/10` highlights, and a bold accent rewrites the scheme's accent pair with its primary. The example theme editor now uses these instead of hand-derived overrides.

### Selection controls

- A checked checkbox or radio recolours its outline with the fill (`data-checked:border-primary`) — no more pale halo.
- A selected radio is filled with the primary and its dot cut out in `primary-foreground`, matching the reference (it used to stay an outlined ring with a primary dot).
- Per-style fills: `luma`/`rhea` controls are `bg-input/90` and borderless; `sera` radios keep the outline form with a `foreground` border and dot.
- Text fields, textareas and select triggers gained their per-style fills (`dark:bg-input/30`, `maia` `input/30`, `mira` `input/20`, `luma`/`rhea` `input/50` borderless).

### Other reference fixes

- Dialogs sit on `bg-popover` with the foreground-wash hairline, like every floating surface.
- Slider and progress tracks are `bg-muted` (previously `secondary`, which an accent theme tinted); the slider thumb is white in both modes.
- Toggles press to `bg-muted` and follow the button metrics.
- Tabs take their strip and trigger radii from the style (`rounded-lg` / `rounded-md` in `vega`), and only `vega`/`nova` keep the active-tab shadow.
- Badges: `px-2`, soft destructive tint, square in the square styles, and `sera`'s flat text-only badges.
- Kbd is a plain `bg-muted` chip in the sans face (no border, no mono).
- Avatar default is `size-8` (32px).
- Cards separate their sections by `--card-spacing` (`ShadCardTheme.sectionGap`) while the title/description gap stays small.
- Surface hairlines are brightness-aware (`ring-foreground/5 dark:ring-foreground/10` in the soft styles); `rhea` cards/dialogs use the capped `min(radius-4xl, 24px)` corner.
- `ShadDefaultThemeNoSecondaryBorderVariant` is now a subclass of `ShadDefaultThemeVariant`, so every one of these fixes applies to both focus treatments.

### Breaking (visual): nova is the default style

`ShadThemeData` defaults to `ShadStyleTokens.nova` rather than `vega`, matching shadcn's own `DEFAULT_CONFIG.style`. nova is vega one size down and a step rounder: 32px controls and fields, 16px card and dialog padding, `rounded-lg` surfaces, no card shadow. Pass `style: ShadStyleTokens.vega` to keep the previous geometry. The `ShadStyleTokens` *field* defaults are still vega's, so a custom style only states what it changes.

### Rendering fixes

- **Outward shadows use `BlurStyle.outer`.** CSS clips a box-shadow to outside the border box; Flutter's default blur painted it behind the whole box, which showed through every transparent or translucent fill as a grey wash — checkboxes, text fields, select triggers, the menubar strip and translucent menus all looked "slightly grey" in light mode.
- Menu rows are start-aligned again (the item's button centres its text; the row merges `TextAlign.start` back in).
- `ShadCollapsible` reveals its content top-start instead of centring whatever is narrower than the strip.
- `ShadEmpty` draws its icon centred in the reference's `size-10 bg-muted rounded-lg` chip at `size-6`, instead of a bare full-size glyph.
- The focused OTP slot draws its ring *outside* the slot like every other field.
- `ShadSpinner` follows the ambient `IconTheme` (`text-current`), so it spins in a button's content colour; the theme no longer pins it to the primary.
- The select trigger's value, chevron, scroll chevrons and search field no longer borrow menu-palette colours — an inverted menu used to make the trigger's text invisible.
- A translucent menu keeps its drop shadow (it was clipped away with the backdrop filter).
- **Inter is the default font**, matching the reference's `font: "inter"`; the variable font is bundled. Geist and Geist Mono remain bundled and selectable (`ShadTextTheme(family: 'Geist', package: 'shadcn_ui')`).
- Focus rings only round the corners that the element itself rounds: a square-cornered element (the `lyra`/`sera` styles, the middle OTP slots) gets a square ring, and rounded corners grow by the ring width so ring and element stay concentric — the OTP ring no longer detaches at the strip's corners.
- Badges no longer react to hover; the reference only restyles badges rendered as links.
- Tabs lost the extra 4px gutter around each tab — the strip's `p-[3px]` is the only inset, as in the reference.
- The `sera` select trigger is underlined like its text fields (`border-transparent border-b-input px-0`) instead of a boxed border with zero padding.
- The time picker's fields grow with the text scale and centre their digits.
- The menubar opens on click; hovering another trigger only switches menus while one is already open, matching the reference menubar.
- `ShadEmpty`'s icon chip is centred, and the example's empty-state card keeps its breathing room.

## 0.57.0

A breaking release. The export surface was trimmed, eleven components were added, and the default theme was brought in line with shadcn/ui's own values.

### Breaking (visual): the default theme now matches shadcn/ui

Values taken from shadcn/ui's `new-york-v4` registry and `globals.css` rather than approximated.

- **Focus ring.** Was a 2px fully-opaque `ring`-coloured outline floating 4px away from the element, which read as a hard outline with a gap. It is now `focus-visible:ring-[3px] ring-ring/50`: 3px, at 50% opacity, sitting flush against the element with no gap, and concentric with its corner radius. `ShadOutwardBorderPainter` strokes *inside* a rect inflated by `offset`, so `offset == width` is what removes the gap.
- **Default radius `6` → `8`.** shadcn's `--radius` is `0.625rem` and `--radius-md` — what button, input, checkbox and most components use via `rounded-md` — is `calc(var(--radius) * 0.8)`, i.e. 8px.
- **Button sizes** now match `h-9 px-4 py-2` / `h-8 px-3` / `h-10 px-6` / `size-9`: default height `40 → 36`, sm `36 → 32`, lg `44 → 40` with horizontal padding `32 → 24`, and icon `40 → 36`.
- `ShadDefaultThemeNoSecondaryBorderVariant` keeps its inset focus border by design, but no longer hardcodes the old 6px radius — it follows `ShadThemeData.radius`.

Pass `radius:` and `buttonSizesTheme:` to `ShadThemeData` to keep the previous look.

### Breaking: the public barrel no longer re-exports unrelated packages

`import 'package:shadcn_ui/shadcn_ui.dart'` used to pull in several hundred symbols that have nothing to do with this package. Only what appears in a `Shad*` signature is re-exported now. If you were relying on one of these transitively, add the package to your own `pubspec.yaml` and import it directly:

| Dropped | What to do |
| --- | --- |
| `boxy` (all 8 libraries) | add `boxy` to your pubspec — nothing in this package's API uses it |
| `flutter_svg` | add `flutter_svg` |
| `universal_image` | add `universal_image` |
| `intl` — everything but `DateFormat` and `NumberFormat` | add `intl` |
| `two_dimensional_scrollables` — everything but the `TableSpan*`/`TableView*` types `ShadTable` needs | add `two_dimensional_scrollables` |

`flutter_animate` and `lucide_icons_flutter` are still re-exported: both appear in the public API (`effects:` parameters and icon constants respectively).

### Breaking: extensions on core types are no longer exported

`double`, `Duration`, `List`, `Map`, `Set`, `TextStyle` and `TapDownDetails` all silently gained methods — and `Duration` gained `+ - * /` operator overloads — in every file that imported this package. Those extensions are now internal. `ShadBreakpointsExt on BuildContext` and `ShadDateTime on DateTime` are still exported.

### Breaking: render objects and painters are no longer exported

`MouseAreaRegistry`, `MouseAreaSurfaceRenderBox`, `ShadMouseAreaRenderBox`, `RenderSheetLayoutWithSizeListener`, `SonnerBoxy`, `ShadOutwardBorderPainter`, `ShadResizeGripPainter` and `ShadPositionDelegate` were implementation details.

### Breaking (with deprecated aliases): un-prefixed public names

Each old name still works and is deprecated; all will be removed in v1.0.0.

`ToastInfo` → `ShadToastInfo` · `SizeEffect` → `ShadSizeEffect` · `PaddingEffect` → `ShadPaddingEffect` · `AnimEffect` → `ShadAnimEffect` · `UpperCaseTextInputFormatter` → `ShadUpperCaseTextInputFormatter` · `LowerCaseTextInputFormatter` → `ShadLowerCaseTextInputFormatter` · `SheetDragStartHandler` → `ShadSheetDragStartHandler` · `SheetDragEndHandler` → `ShadSheetDragEndHandler` · `SizeChangeCallback` → `ShadSizeChangeCallback` · `ToValueTransformer` → `ShadToValueTransformer` · `FromValueTransformer` → `ShadFromValueTransformer` · `FocusWidgetBuilder` → `ShadFocusWidgetBuilder` · `ResponsiveWidgetBuilder` → `ShadResponsiveWidgetBuilder` · `PasteFilesCallback` → `ShadPasteFilesCallback` · `PasteFilesErrorCallback` → `ShadPasteFilesErrorCallback` · `RestorableShadTabsController` → `ShadRestorableTabsController` · `DateTime.isSameDayOrGreatier` → `isSameDayOrGreater`

### New components

- **FEAT**: `ShadSkeleton` (+ `.circle`) — a pulsing loading placeholder.
- **FEAT**: `ShadSpinner` — an indeterminate circular indicator. Hand-painted, since nothing under `lib/` may import `material.dart`.
- **FEAT**: `ShadKbd` (+ `.group`) — keyboard key caps for documenting shortcuts.
- **FEAT**: `ShadToggle` and `ShadToggleGroup` (+ `.multiple`) with `ShadToggleGroupController`.
- **FEAT**: `ShadCollapsible` with `ShadCollapsibleController` — the single-section primitive under an accordion.
- **FEAT**: `ShadEmpty` — an empty state with icon, title, description and actions.
- **FEAT**: `ShadPagination` and `ShadPaginationCompact`. The page-window algorithm is exposed as `ShadPagination.buildPageWindow` so it can be tested and reused.
- **FEAT**: `ShadCommand` and `showShadCommandDialog` — a searchable, keyboard-navigable command palette with grouped items, keyword matching and a pluggable filter.
- **FEAT**: `ShadDataTable` with `ShadDataTableController` and `ShadDataTableColumn` — sorting, filtering, paging and key-based row selection composed over `ShadTable`. `ShadTable` itself is unchanged.
- **FEAT**: `ShadRovingFocus` and `ShadRovingFocusController` — the shared arrow-key/Home/End/typeahead substrate the WAI-ARIA roving-tabindex pattern needs. Used by `ShadCommand`.
- Each new component ships with a `ShadXTheme` wired into `ShadThemeData`.

### Breaking (visual): the neutral, stone and zinc palettes are shadcn v4's

They were still the v3 values. Regenerated from `registry/themes.ts`, which moves several tokens:

- **Dark `--border` and `--input` are translucent whites** (`oklch(1 0 0 / 10%)` and `/ 15%`) rather than opaque greys. A hairline now lightens whatever it sits on, instead of disappearing against a card of the same value — which is why a checkbox or radio outline was hard to make out in dark mode. `ShadSlateColorScheme` and `ShadGrayColorScheme` are not in shadcn v4; they keep their own palette but adopt these two.
- **The dark card and popover are a step lighter than the page** (`oklch(0.205)`), so a card reads as raised rather than as a bordered region of the background.
- Dark `primary`, `ring`, `muted-foreground` and `destructive` move to their v4 values.

### Design tokens: radius scale, styles and spacing

shadcn/ui derives every corner radius and every padding from two CSS variables. This release does the same, which is what makes a single setting move the whole UI in proportion instead of only the components that happened to read it.

- **FIX (visual)**: the default component sizes now match the current shadcn registry rather than an older snapshot of it. Button horizontal padding `16 → 10` (`px-2.5`), icon/label gap `8 → 6`, input padding `12/8 → 10/4` with a 36px minimum height, popover padding `12/6 → 16`, slider track `8 → 6` and thumb `20 → 16`, switch `44×24 → 32×18.4`, progress `16 → 6`, table cell padding `16 → 8` horizontally, and a 3px inset on the tab strip.
- **FEAT**: `ShadRadii` — the `none`/`sm`/`md`/`lg`/`xl`/`2xl`/`4xl`/`full` scale, derived from `ShadThemeData.radius` (the `md` step). At the default 8 it reproduces shadcn's scale exactly: sm 6, md 8, lg 10, xl 14, 2xl 16, 4xl 32. Available as `ShadThemeData.radii`.
- **FIX (visual)**: components now pick a *token* rather than a number, so the theme radius reaches all of them. `ShadCardTheme.radius` was hardcoded to 8 and ignored `ShadThemeData.radius` entirely; the dialogs, progress, kbd and the select/command item rows had the same problem. Cards are `rounded-xl`, dialogs and sheets `rounded-lg`, controls `rounded-md` and menu rows `rounded-sm`, matching the reference. **A card at the default radius is now 14px round rather than 8px.**
- **FEAT**: `ShadStyleTokens` — shadcn/ui's eight named styles (`vega`, `nova`, `maia`, `lyra`, `mira`, `luma`, `sera`, `rhea`) as `ShadThemeData(style:)`. Previously only two looks were reachable, through `disableSecondaryBorder`.

  A style is a full design set, not a colour variation — 243 of shadcn's 407 component classes differ in geometry between the eight. Everything here was read from `registry/styles/style-*.css`, converting Tailwind's scale at 4px per unit.

  *Sizes.* A `mira` button is 28px tall with 8px of horizontal padding; a `sera` one is 40px with 24px. Card padding runs 16 → 32 across the eight; slider tracks 2 → 12; switches 28×16.6 → 44×20; focus rings 1px at 50% → 3px at 30%.

  *Radii,* per surface class — controls, cards, dialogs, popovers and menu rows each pick their own token, which is why `nova` has `rounded-lg` buttons inside `rounded-xl` cards.

  *Type.* Each style redefines six `ShadTextRole`s — `title`, `label`, `body`, `caption`, `overline` and `field` — carrying size, weight, tracking, line height and case. `lyra` sets body copy at 12px, `mira` puts it on a 1.625 line, `sera` sets labels in 12px semibold uppercase tracked to 1.2px and titles at 18px. Every component theme's text style is derived from a role, so a style switch retypes the whole UI.

  *Shadows.* `nova`, `maia`, `lyra` and `mira` drop the card shadow entirely; `luma` gives it `md`; `maia` puts a `2xl` under popovers; `luma` and `rhea` an `xl` under dialogs.

  *Borders.* `sera` underlines its text fields rather than boxing them (`underlinedFields`), matching its `border-transparent border-b-input`.

  Metrics shadcn expresses in spacing units (`h-9`, `px-2.5`) are stored in the pixels they render at the default 4px step and rescale with `ShadThemeData.spacing`; its bracketed literals (`h-[18.4px]`, `rounded-[4px]`, `p-[3px]`) do not, matching Tailwind.
- **FEAT**: `ShadSpacing` — the spacing scale, shadcn's `--spacing`. `ShadThemeData(spacing:)` sets the step (4 by default); `theme.spacing(6)` is 24. Every padding in both shipped theme variants is now expressed in steps, so changing the step rescales the whole UI. Values are unchanged at the default step.
- **FEAT**: `ShadTextRole` — the typographic treatment of one role in a style: size, weight, tracking (in logical pixels, not ems), line height and case. `ShadTextRole.apply(base)` layers it onto a text style while keeping that style's colour and family, so it composes with a custom `ShadTextTheme` or a Google font. `uppercase` cannot be expressed in a `TextStyle`, so components that take a caller's widget leave the text alone; use `role.applyCase(text)` where you build the string.
- **FEAT**: new theme fields for text that components previously hardcoded — `ShadCardTheme.titleStyle`/`descriptionStyle`/`gap`, `ShadBadgeTheme.textStyle`, `ShadPopoverTheme.textStyle`, plus the matching widget parameters. `ShadCard` used `textTheme.h3` for its title and `ShadBadge` a hardcoded 12px/w600, neither of which a style could reach.
- **FEAT**: `Shadows.xs` and `Shadows.none`, completing Tailwind's set.
- **FEAT**: `ShadGap`, `ShadPadding`, `ShadColumn` and `ShadRow` — layout widgets measured in steps on that scale, so app layout lines up with component padding exactly. `ShadGap` sizes itself along whichever axis its enclosing flex runs.
- **FEAT**: `ShadThemeVariant.rebuild(...)`, plus `colorScheme`/`radius`/`effectiveTextTheme`/`style`/`spacing`/`radii` on the variant interface. A variant bakes its inputs into its component themes, so `ShadThemeData(variant: v, radius: r)` now rebuilds `v` at `r` instead of leaving the theme's radius and its components disagreeing. Where no explicit value is given, the variant's own wins — so the two can no longer be inconsistent.

### API

- **FIX**: `ShadThemeData.textTheme` is now produced by the theme variant, so a style's text roles reach it. It was taken straight from the merged input, which meant a style change resized the components but left `theme.textTheme.small` — and therefore any app text written against it — untouched. Prose entries (`h1`..`h4`, `lead`, `blockquote`, `table`) are the typography scale and are deliberately unaffected.
- **FIX (visual)**: a textarea has its own radius token, `ShadStyleTokens.textareaRadius`. It followed the button radius, so `maia`'s `rounded-4xl` put a 32px curve on a tall box and clipped the text; shadcn gives it `rounded-xl`.
- **FIX (visual)**: `ShadInputOTP` slots follow the control radius and the style's field treatment — rounded only at the ends of the strip, sized like a control, and underlined rather than boxed in `sera`.
- **FIX (visual)**: components outline with the token shadcn uses: fields, checkboxes, radios and OTP slots with `--input`, and cards, popovers, dialogs, menus and toasts with a wash of their own foreground (`ring-foreground/10`, or `/5` in `luma`, `sera` and `rhea`) rather than the full-strength `--border`. `ShadStyleTokens.cardBorderOpacity` and `surfaceBorderOpacity` carry the per-style values.
- **FIX**: `ShadOption`'s label follows its *background*, not just its selected state. Hovering an unselected row painted the highlight behind unchanged text, so a theme whose highlight is a strong fill left the label unreadable.
- **FIX**: popover content gets an `IconTheme` matching `popoverForeground`. Icons inherited the page's icon colour, which is wrong the moment the menu surface differs from the page — an inverted menu drew its icons in the surface colour.
- **FIX**: `ShadBorderSide.toBorderSide()` keeps its colour at zero width instead of returning `BorderSide.none`. `Border` asserts that every side shares a colour before it will paint a radius, so a component drawing only some of its sides — the OTP strip shares its vertical edges — crashed in paint.
- **FIX (visual)**: `ShadTabs` sizes its tabs to their labels, matching shadcn's `w-fit` list. Every tab was stretched across the bar, which read as enormous padding inside it. `ShadTabs.expandTabs` / `ShadTabsTheme.expandTabs` restores the old behaviour.
- **FIX (visual)**: `ShadInputOTP` draws its focus ring inside the focused slot. Slots share their vertical edges and Flutter has no z-index, so an outward ring was painted over by the next slot in the row and the strip looked broken.
- **FEAT**: `ShadInputOTP` slots scale with the ambient text scaler, so a larger accessibility text size no longer clips the digit.
- **FEAT**: `ShadContextMenuItem.selectedTextStyle` and the matching theme field. A menu whose selection is a strong fill needs its label to change with it; the item's text style was fixed regardless of state.
- **FIX**: `ShadTextarea` reads `ShadTextareaTheme` rather than `ShadInputTheme` for padding, alignment, gap and placeholder styling. Every textarea-specific value in its own theme was dead, so a multi-line field was padded like a single-line one — which is why its text sat hard against the top edge.
- **FIX (visual)**: a single-line field centres its text vertically. It is laid out at a fixed height now, and its content column was top-aligned, so short text rode high in the box. A multi-line field still grows from the top.
- **FIX (visual)**: overlays match shadcn's `bg-black/10` + `backdrop-blur-xs` instead of an opaque 80% black. `ShadDialogTheme` gained `barrierColor` and `barrierBlurSigma`, `showShadDialog` and `showShadSheet` resolve both from it, and `ShadDialogRoute` fades the blur in with the route. The blur is what lets the tint stay light enough to keep the palette recognisable in either mode.
- **FIX (visual)**: a checkbox and a radio share their unchecked look — `border-input` with the same fill (transparent in light, `input/30` in dark). The checkbox filled itself with `input` and outlined itself in `primary`, so the two read as different families.
- **FIX**: `ShadSlider`'s ring stays up for the whole gesture, including when the pointer leaves the slider, and appears on press as well as hover and focus.
- **FIX (visual)**: `ShadInputOTP`'s ring no longer collapses onto the slot's border. `ShadBorder.merge` takes the other's offset unconditionally, so the per-slot radius merge was silently dropping it and the neighbouring slots painted over the ring.
- **FEAT**: `ShadCard.action` — shadcn/ui's `CardAction`, a widget pinned to the end of the *header* row. `trailing` sits beside the card's whole content column, so using it for a dismiss button narrowed the entire card, not just the header.
- **FIX (visual)**: every focus ring is now concentric with the element it rings. The ring was built once from the control radius, so a textarea — which has a radius of its own — was ringed in the wrong shape. Both variants build rings through a `ringFor(radius)` helper.
- **FIX (visual)**: `ShadInputOTP` slots ring like any other field: a hairline border in the ring colour plus the theme's translucent ring outside it, instead of an opaque 2px box with the ring suppressed.
- **FIX (visual)**: `ShadSlider`'s thumb ring is the theme's — same colour, opacity and width as a focused field — and appears on hover as well as focus, matching shadcn's `hover:ring-4 focus-visible:ring-4`. It is painted outside the thumb, so it no longer resizes anything when it appears.
- **FIX (visual)**: textarea vertical padding is two pixels above shadcn's `py-2`. A browser textarea carries an intrinsic inset that `EditableText` does not, and matching the CSS exactly put the first line visibly close to the top edge.
- **FIX (visual)**: `ShadKbd` has a height of its own (`ShadKbdTheme.height`, shadcn's `h-5`) and no longer stretches to fill a row that sizes its children — inside a button, it grew to the button's full height.
- **FIX (visual)**: `ShadSlider` reserves room for its thumb. The thumb was positioned with a negative offset, so a slider laid out at track height — 6px — while painting a 16px thumb, and overlapped whatever sat above and below it. It now takes `max(track, thumb)`; the focus ring still overflows deliberately, so focusing never reflows the layout.
- **FIX**: `ShadPopover` no longer forces `TextAlign.center` on its content. Everything built on it — select options, menu items, popover forms — was centred; shadcn aligns all of it to the start. Wrap content in a `Center` or set `textAlign` yourself for the old behaviour.

- **FEAT**: `ShadThemeScope` applies a `ShadThemeData` to a *subtree*, including the Material theme it implies — the ambient `DefaultTextStyle` and `IconTheme`. Plain `ShadTheme` publishes only the Shad half, so a deliberately dark panel inside a light app rendered dark text on a dark surface. `ShadApp` now derives its Material theme through the same `shadMaterialThemeFrom` helper, so the two cannot drift.
- **FIX**: `showShadDialog` republishes the ambient `ShadTheme` inside the route. A route is built under the Navigator, so a dialog opened from a re-themed panel used to fall back to the app theme.
- **FIX**: A mouse click no longer clears a button's hover state. The default `hoverStrategies` list `onTapUp` under `unhover`; those exist to synthesise hover on touch devices, but they fired for mouse clicks too, so the highlight vanished mid-click while the cursor sat still. `ShadGestureDetector` now ignores the strategies whenever a mouse is inside it — which is what its own class doc already promised.
- **FEAT**: Buttons shift down one pixel while pressed, matching shadcn/ui's `active:translate-y-px`. Tunable via `ShadButton.pressedOffset` / `pressAnimationDuration` and the matching `ShadButtonTheme` fields; `Offset.zero` disables it. A button with no `onPressed`, or an explicitly disabled one, does not shift.

- **FEAT**: `ShadAccentScheme` — shadcn/ui's seventeen accent themes (amber, blue, cyan, emerald, fuchsia, green, indigo, lime, orange, pink, purple, red, rose, sky, teal, violet, yellow) in light and dark, applied with `ShadColorScheme.applyAccentScheme(...)`. shadcn splits a theme into a neutral *base colour* and an *accent* that overrides only the hue-carrying tokens; its accent entries define exactly `primary`, `secondary`, `chart-*` and `sidebar-primary`, which is what this type carries.
- **FEAT**: Four new base colour schemes matching shadcn's remaining neutrals — `ShadMauveColorScheme`, `ShadOliveColorScheme`, `ShadMistColorScheme`, `ShadTaupeColorScheme`. All values converted from the OKLCH literals in shadcn's `registry/themes.ts`.
- **FEAT**: `ShadColorScheme` gained shadcn's `--chart-1`..`--chart-5` and `--sidebar-*` tokens (`chart1`…`chart5`, `charts`, `sidebar`, `sidebarForeground`, `sidebarPrimary`, `sidebarPrimaryForeground`, `sidebarAccent`, `sidebarAccentForeground`, `sidebarBorder`, `sidebarRing`). They are optional and fall back to the closest existing token, so every existing scheme — including hand-written ones — keeps working unchanged.
- **FEAT**: `ShadColorScheme.applyAccent(color)` layers an arbitrary accent hue onto a neutral palette, re-tinting `primary`, `ring` and `selection` while leaving backgrounds, borders and muted tones alone. shadcn/ui's theme editor treats the neutral *base colour* and the *accent* as independent choices; a `ShadColorScheme` bundles both, so this is what makes that split expressible. `primaryForeground` is derived from the accent's relative luminance unless supplied.
- **FEAT**: `ShadButtonSize.icon`, matching shadcn/ui's `<Button size="icon">`. `ShadButtonSizesTheme` already carried the metrics; the enum could not express them.
- **FEAT**: `ShadIconButton.size` — icon buttons can now be `sm`/`lg`, not just the fixed icon size. Non-icon sizes fall back to a square derived from the height.
- **FEAT**: `ShadIconButton.semanticLabel`. An icon-only button has no text, so without it a screen reader announced nothing at all.
- **FEAT**: `ShadDialog.semanticLabel`, plus `scopesRoute`/`namesRoute`/`explicitChildNodes` semantics matching Flutter's own `AlertDialog`. (The focus trap was already provided by `PopupRoute`.)
- **FEAT**: `autofocus` and `onFocusChange` on `ShadCheckbox`, `ShadSwitch`, `ShadRadio` and `ShadSelect`; `onFocusChange` on `ShadSlider`.
- **FEAT**: `ShadBadge.enabled`.
- **FEAT**: `ShadTooltip` dismisses on Escape.
- **FEAT**: `ShadDisabled` and `ShadDefaultThemeNoSecondaryBorderVariant` are now exported. The latter was accepted by `ShadThemeData(variant:)` but unreachable.
- **CHORE**: All 23 existing `@Deprecated` annotations now state a removal version.

## 0.56.2

Performance. No API changes, and every golden is unchanged.

- **PERF**: `ShadSelect` no longer materializes its options on every layout pass. The `LayoutBuilder` wraps the whole select — anchor included — so it re-runs whenever the *closed* select is laid out, and `options` is a lazy `Iterable` that was being `toList()`ed each time. The options are now built inside the `popover:` builder.
- **PERF**: `ShadCalendar` memoizes its `DateFormat`s. Combined with the above, `captionLayout: dropdown` was constructing 201 `DateFormat`s — one per selectable year, each a pattern parse plus locale lookup — on every layout pass of a closed calendar.
- **PERF**: `ShadInput`/`ShadTextarea` rebuild only the placeholder when the text changes, instead of rebuilding `EditableText`, the decorator, the scrollbar and the leading/trailing row on every keystroke. Because `TextEditingController` also notifies on selection changes, this previously fired on every cursor move too.
- **PERF**: `ShadTable` builds its cell matrix once per build instead of once per hover tick. The hover `ValueListenableBuilder` wrapped the entire `TableView` and reallocated one `List` per row every time the pointer crossed a row boundary.
- **PERF**: `ShadPopover` rebuilds `ShadPortal` only when its visibility actually flips, rather than on every animation frame via an `AnimatedBuilder` reading `!isDismissed`.
- **PERF**: `ShadPortal` routes all reposition requests through its existing dedup guard. Three call sites scheduled raw post-frame callbacks that bypassed it, so a portal rebuilding N times in a frame queued N repositions.
- **PERF**: `ShadTooltip` no longer allocates a new `onHoverChange` closure per build. `ShadHoverStrategies` compares that closure in `==`, so the theme handed to `ShadTooltip.child` was never equal to the previous one and the entire child subtree rebuilt on every tooltip rebuild. `ShadSonner` memoizes its toast subtree theme for the same reason — both called `ShadThemeData.copyWith`, which re-runs all 54 component-theme merges.
- **FIX**: `ShadAnimationBuilder` now honours a changed `duration`; it captured the initial value and had no `didUpdateWidget`.
- **FIX**: `ShadStatesController.update` emits a new `Set` rather than mutating the one held by the `ValueNotifier`, so listeners can diff old against new.
- **CHORE**: `ShadPopover` and `ShadTooltip` no longer mutate their `AnimationController` durations from `build()`.

## 0.56.1

Value-equality and lifecycle fixes. No API changes.

- **FIX**: `ShadThemeData` is a value type again. `ShadBorder` had no `operator ==`/`hashCode` and `ShadBorderSide`'s compared the `merge` *method tear-off* instead of the `canMerge` field, so two identically-configured `ShadThemeData` instances were never equal. Because `ShadApp` wraps its child in a `ShadAnimatedTheme`, that made every `ShadApp` rebuild start a fresh 200ms lerp across all 54 component themes and republish a new theme every frame, rebuilding every `ShadTheme.of` dependent at frame rate. Apps that construct their theme inline — `ShadApp(theme: ShadThemeData(...))` — were affected on every rebuild. Theme changes are now applied instantly unless the theme actually changed; this is visible but intended.
- **FIX**: `ShadBreakpoints` and `ShadBreakpoint` gained `operator ==`/`hashCode`. The `ShadThemeData` factory allocates a fresh `ShadBreakpoints()` per construction, so this was a second, independent cause of the above.
- **FIX**: `ShadThemeData.copyWith` no longer discards a custom `variant`. `variant` was constructor-only and never stored, so `copyWith` silently reset it to `ShadDefaultThemeVariant` — and `ShadDialog`, `ShadTooltip` and `ShadSonner` all call `copyWith` in `build()`, meaning opening a dialog reverted a custom variant for its entire subtree. `ShadThemeData.variant` is now a public field.
- **FIX**: `ShadRoundedSuperellipseBorder.hashCode` only hashed `side`, ignoring `radius` and `canMerge` that `==` compares. `ShadBorder.copyWith` and `ShadColorScheme.copyWith`/`lerp` dropped `canMerge`, making the "replace, don't merge" opt-out unrecoverable.
- **FIX**: `ShadColorScheme.hashCode` was a chain of `^`, which is commutative — swapping any two colors produced an identical hash. It also hashed `MapEntry` objects (identity-hashed) for `custom` while `==` used `mapEquals`. Same `custom` issue in `ShadTextTheme.hashCode`.
- **FIX**: `ShadTextTheme` included `canMerge` in `hashCode` but not in `==`, violating the hashCode/`==` contract; `lerp` dropped `canMerge` and threw when both arguments were null.
- **FIX**: `ShadSonner` leaked an `AnimationController` and a `Timer` for every toast queued beyond `visibleToastsAmount` — `dispose()` drained `_toasts` but never `_temporarelyHiddenToasts`. It also called `setState` and `dispose` after `await`ing an animation with no `mounted` guard, which could double-dispose a controller.
- **FIX**: `ShadTooltip` could call `AnimationController.reverse()` on a disposed controller when the widget was disposed during `waitDuration`/`showDuration`.
- **FIX**: `ShadMenubarItem` removed its listener from the *new* controller instead of the old one when `ShadMenubar.controller` was swapped, leaving the listener attached to the old controller permanently.
- **BREAKING (minor)**: `ShadBreadcrumbTheme.ellipsis` no longer defaults to an `Icon`. The field was never read — `ShadBreadcrumbEllipsis` builds the same icon itself from `ellipsisSize` and `colorScheme.mutedForeground` — and a non-const `Widget` default gave `ShadBreadcrumbTheme` identity equality, which propagated up and defeated all of the above. There is no visual change.

## 0.56.0

- **BREAKING**: `slang` 4.18 renames the generated localization classes: `ShadLocalizationsDataTimePickerEn`, `ShadLocalizationsDataDatePickerEn`, `ShadLocalizationsDataInputEn` and `ShadLocalizationsDataKeyboardToolbarEn` are now `ShadLocalizationsData$timePicker$en`, `ShadLocalizationsData$datePicker$en`, `ShadLocalizationsData$input$en` and `ShadLocalizationsData$keyboardToolbar$en`.
- **CHORE**: Opt into `slang_build_runner`'s `legacy` builder. `dart run build_runner build` failed on a fresh checkout with `InvalidOutputException: Asset already exists`, because slang's default builder writes through build_runner's asset writer and cannot overwrite the committed `strings*.g.dart`. The `slang` header timestamp is also disabled, so regenerating produces identical output instead of a spurious diff on every run.

## 0.55.1

- **FIX**: Regression on `ShadSheet`'s opaque parameter; default is back to `false`.

## 0.55.0

- **FEAT**: Add expandable/resizable `ShadSheet` (#655): new `expandable`, `initialSize`, `minSize`, `maxSize`, `snap`, `snapSizes`, `snapAnimationDuration`, `snapAnimationCurve`, `snapFlingVelocity`, `dragHandle`, `dragHandleBuilder`, `showDragHandle`, `dragHandleExtent`, `onSizeChanged` and `controller` parameters, a public `ShadSheetController` (`animateTo`/`jumpTo`), `ShadSheetResizeHandle`, and matching `ShadSheetTheme` fields.
- **FEAT**: `showShadDialog` accepts `opaque`; `showShadSheet` now follows keyboard insets so sheets move with the keyboard.

## 0.54.0

- **FEAT**: `ShadTextTheme.fromGoogleFont` now accepts a `custom` parameter to include custom text styles in the Google Font text theme.
- **CHORE**: Migrate Geist and GeistMono fonts from individual weight-specific `.otf` files to variable font `.ttf` files, reducing the number of bundled font assets from 18 to 2.
- **BREAKING**: Minimum Flutter version raised to `3.41.0` (Dart `3.11.0`) for variable font weight support.

## 0.53.6

- **FIX**: Add `!hasSize` check to `MouseAreaSurfaceRenderBox.hitTest` to prevent assertion failure during early pointer events on desktop.

## 0.53.5

- **FIX**: `ShadDatePicker` now correctly falls back to `datePickerTheme.buttonDecoration` when no explicit `buttonDecoration` is provided.

## 0.53.4

- **FEAT**: Add per-tab `maintainState` support to `ShadTab`. Individual `ShadTab` widgets can now override the global `ShadTabs.maintainState` setting.

## 0.53.3

- **FIX**: Keyboard navigation in `ShadSlider` now works correctly with the Shift and arrow keys. (thanks to @Isakdl)

## 0.53.2

- **FIX**: `ShadInput` context menu now stays open after tapping **Select All**, allowing the user to then tap **Copy** or **Cut**.
- **FIX**: Hide **Select All** from the context menu when all text is already selected.

## 0.53.1

- **FIX**: `ShadThemeData.merge` now properly merges the `ShadColorScheme` instead of replacing it. The `custom` color maps are combined, with the overriding theme's values taking precedence for duplicate keys.

## 0.53.0

- **FEAT**: Use native browser context menu on web and support `onPasteFiles`.

## 0.52.3

- **FIX**: Add missing `groupId` to `ShadSelectMultipleFormField` constructors.

## 0.52.2

- **FIX**: Add `uncheckedColor` to `ShadCheckbox` to allow customizing the color of the checkbox when unchecked. (thanks to @Isakdl)

## 0.52.1

- **FIX**: i18n localization for `ShadInput.defaultContextMenuBuilder`.

## 0.52.0

- **FEAT**: Add built-in i18n support with 70+ locales using [slang](https://pub.dev/packages/slang). The `GlobalShadLocalizations` delegate is automatically included by `ShadApp`. Access translations via `ShadLocalizations.of(context)`.

## 0.51.0

- **REFACTOR**: `ShadInput.defaultContextMenuBuilder` now uses `ShadContextMenu` with `ShadContextMenuItem` for consistent styling with the rest of the component library.
- **FEAT**: Add `onTapDown` to `ShadContextMenuItem` for cases where the action must fire immediately on pointer down (e.g. text selection context menus).
- **FIX**: `ShadInput` now dismisses the context menu when the user types.
- **DEPRECATED**: `ShadTextSelectionToolbar` and `ShadToolbarButton` — use `ShadContextMenu` with `ShadContextMenuItem` instead.

## 0.50.3

- **FIX**: Cascade resize behavior in ShadResizable now properly propagates remaining drag delta when a panel collapses to minSize.

## 0.50.2

- **FIX**: Add missing "Select All" button to `ShadInput` default context menu.

## 0.50.1

- **FIX**: `ShadDatePicker.didUpdateWidget` ignored `selected` and `selectedRange` null values.
- **REFACTOR**: Make all form fields state public, to easily create a `GlobalKey` in the rare case you need it.

## 0.50.0

- **FEAT**: Add `fallback` to `ShadAnchorAuto` to have another optimal position as fallback.
- **FIX**: `ShadMenubar` now uses `ShadAnchor` instead of `ShadAnchorAuto` to always show the popover below the item.

## 0.49.0

- **FEAT**: `ShadContextMenuRegion` now automatically supports tap to open the context menu on Android and iOS. Added `tapEnabled` parameter to override the default behavior on any platform.

## 0.48.0

- **FEAT**: Add `defaultContextMenuBuilder` implementation for `ShadInput` to show Cut/Copy and Paste buttons. This introduces the following new widgets: `ShadTextSelectionToolbar` and `ShadToolbarButton`.

## 0.47.0

- **FEAT**: `ShadAnchor` and `ShadAnchorAuto` now accept `AlignmentGeometry` instead of `Alignment`.

## 0.46.4

- **FIX**: `ShadForm.onChanged` now fires with the updated value already present in `formKey.currentState!.value`.

## 0.46.3

- **FIX**: `ShadSelectMultipleFormField` `onChanged` not firing after first selection due to in-place Set mutation.

## 0.46.2

- **FIX**: `ShadAnchorAuto` with followerAnchor: bottomCenter breaks tooltip visibility #575

## 0.46.1

- **FIX**: Add `forceErrorText` to `ShadSelectMultipleFormField`, `ShadSelectFormField` and `ShadTimePickerFormField` in constructors where it was missing.

## 0.46.0

- **FIX**: Do not remove form field value when the form field is disabled.
- **FIX**: Revert last change about `readOnly` parameter.

## 0.45.2

- **FIX**: Add missing `readOnly` parameter to form fields.

## 0.45.1

- **FEAT**: Add `rawValue` method to `ShadForm` to get the raw form value without considering transformations.
- **FIX**: Form Fields now correctly retrieve the latest value from `ShadForm` as initial value.
- **FIX**: `ShadForm` now correctly resets to `initialValue`s when calling `reset()`.
- **REFACTOR**: Rename ShadForm `getInitialValue` method into `getFieldValue`.

## 0.45.0

- **FEAT**: Add dot notation support for nested form values in `ShadForm`. Field IDs like `user.email` are automatically converted to nested maps like `{'user': {'email': value}}`. The `initialValue` should be provided as a nested map structure, and the form will automatically extract values based on field IDs.
- **FEAT**: Add `fieldIdSeparator` parameter to `ShadForm` to customize the separator used for nested form values (defaults to `.`). You can use any string as a separator (e.g. `/`, `:`), or set it to `null` to disable dot notation support entirely.
- **FEAT**: Add `toNestedMap`, `getByPath` and `deepMerge` extension methods on `Map<String, dynamic>`.
- **FEAT**: Add `deepCopy` extension method to `Map`, `List` and `Set` to create deep copies of collections.

## 0.44.1

- **FIX**: `ShadForm` initial values were not considered when getting the form value for form fields that were not registered with the same `id`. Now, even custom values are returned, even if there is no form field associated with that `id`.

## 0.44.0

- **REFACTOR**: Deprecated `valueTransformer` in favor of `toValueTransformer`.
- **FEAT**: Add `fromValueTransformer` to form fields to easily transform the form initial value to the field value.
- **DOCS**: Add documentation about `fromValueTransformer` and `toValueTransformer` in form.

## 0.43.4

- **FIX**: `ShadForm` scroll to form fields without an associated `id`.

## 0.43.3

- **FIX**: Add `onPressed` to `ShadSelectMultipleFormField`.

## 0.43.2

- **FIX**: Correctly disable back and forth buttons in `ShadCalendar` when reaching min/max date.

## 0.43.1

- **FIX**: Improve `ShadPortal` scroll and resize handling.

## 0.43.0

- **BREAKING CHANGE**: Rename `icon` into `leading` in `ShadDatePicker` and `ShadDatePickerFormField` and add `trailing`.

## 0.42.1

- **CHORE**: Add `selectedIconColor` to `ShadOptionTheme` to allow customizing the color of the selected icon.

## 0.42.0

- **BREAKING CHANGE**: The old `setValue` has been renamed into `setFieldValue` to better reflect its purpose, and now accepts a `notifyField` boolean parameter (defaults to `true`) to control whether to notify the form field of the value change.
- **BREAKING CHANGE**: `ShadFormBuilderFieldState.setInternalError` has been renamed into `setError` for consistency.
- **BREAKING CHANGE**: `ShadFormState.removeInternalFieldValue` has been renamed into `removeFieldValue` for consistency.
- **BREAKING CHANGE**: Now `setValue` takes a `Map<String, dynamic>` as value and updates the entire form value. It also accepts a `notifyFields` boolean parameter (defaults to `true`) to control whether to notify the changed form fields of the value changes.

## 0.41.0

- **FEAT**: Add `setValue` to `ShadForm` to manipulate the value of a form field programmatically.
- **BREAKING CHANGE**: The map stored by `ShadForm` now uses `String` as a key instead of `Object`. Every form field `id` must be a `String` now. This change was made for convenience with JSON serialization.

## 0.40.6

- **FIX**: Add `maxLength` parameter to `ShadTextarea` (thanks to @mickey35vn).

## 0.40.5

- **FIX**: `ShadSonner` height normalization for stacked toasts with different heights.

## 0.40.4

- **FIX**: `ShadPopover` dismissal animation when multiple popovers were opened quickly one after another. This affected components like `ShadContextMenu` and `ShadMenubar`.
- **FIX**: `ShadMenubar` onPressed behavior, so mobile taps now open/close the menubar items correctly.

## 0.40.3

- **FIX**: `ShadButton` constraints regression when using a `LayoutBuilder` as child.

## 0.40.2

- **FIX**: `ShadSelectFormField` `onChanged` callback being fired twice when changing the value.

## 0.40.1

- **FIX**: `ShadInput` constraints are applied at the top of the widget and not to the inner editable text.
- **CHORE**: Run the Dart formatter.

## 0.40.0

- **FEAT**: Add new component `ShadBreadcrumb` and all of its related components (thanks to @MoazSalem).
- **FIX**: Update `ShadButton` to allow for more flexibility with height and width properties (thanks to @MoazSalem).
- **FIX**: Get `closeIcon` from theme in `ShadTheme` (thanks to @DMouayad).
- **FIX**: Merge of `ShadDecoration` in the component themes.

## 0.39.14

- **CHORE**: Downgrade Dart SDK constraint to `3.6.0` to temporarely fix the pub dev score issue about the Dart formatter (see [#9091](https://github.com/dart-lang/pub-dev/issues/9091))

## 0.39.13

- **FIX**: Provide more fallback colors to `ShadCalendar`.

## 0.39.12

- **FIX**: `weekNumbersHeaderTextStyle` in `ShadCalendar` not having a default color.

## 0.39.11

- **FIX**: `ShadAvatar` with null source.

## 0.39.10

- **FIX**: Update `theme_extensions_builder` and fix merge issues in themes.

## 0.39.9

- **FIX**: Regression in `ShadSelect` where the dropdown no longer expanded to the intrinsic width of its options.
- **FIX**: Select popover not respecting anchoring point when scrolling.
- **CHORE**: Bump min Dart SDK version to `3.10.0`.

## 0.39.8

- **FIX**: Autofocus search input in select dropdown (thanks @Isakdl).

## 0.39.7

- **FIX**: `ShadOption` selectedIcon position doesn't match original shadcn/ui (thanks to @DMouayad).

## 0.39.6

- **FIX**: Assertion error when using `ShadSelect.withSearch`.

## 0.39.5

- **FEAT**: Add `onPressed` to `ShadSelect` and its form fields to provide a custom callback when the select input is pressed, instead of toggling the popover.

## 0.39.4

- **FIX**: `ShadDatePicker` selected range not updated inside `didUpdateWidget`.

## 0.39.3

- **FIX**: Remove extra gap when `actions` is empty in `ShadDialog`.
- **FEAT**: Add `titlePinned`, `descriptionPinned` and `actionsPinned` to `ShadDialog` and `ShadSheet` to control whether to pin the title, description and actions when scrolling the content.

## 0.39.2

- **FEAT**: Add `buttonTextStyle` to `ShadDateRangePickerFormField`.

## 0.39.1

- **FEAT**: Add `buttonTextStyle` to `ShadDatePicker`, `ShadDatePickerTheme` and `ShadDatePickerFormField` to customize the text style of the button that triggers the date picker popover.

## 0.39.0

- **FEAT**: Add `top`, `bottom`, `verticalGap` and `onLineCountChange` to `ShadInput`, `ShadInputFormField`, `ShadTextArea` and `ShadTextAreaFormField` to add widgets above or below the input field, and to get notified when the number of lines in the input changes.
- **CHORE**: Export `boxy` package.
- **FIX**: `ShadTextarea` double scrollbar.
- **FEAT**: Add `editableTextSize` to `ShadInput` and `ShadInputFormField` to set a fixed size for the editable text area.
- **FIX**: Disable text selection inside buttons (thanks to @Isakdl).
- **FIX**: ShadDialog always expands to constraints.maxWidth (thanks to @DMouayad).

## 0.38.5

- **FIX**: `ShadTabs` consuming extra space when `expandContent` is true for unselected tabs.

## 0.38.4

- **REFACTOR**: Remove required parameters from `ShadThemeData`, use default values instead.
- **FEAT**: Add `setInternalFieldError` to `ShadForm` to set a forced error text for a form field.

## 0.38.3

- **FEAT**: Add `maintainState` to `ShadTabs` to control whether to maintain the state of the tabs when switching between them. Defaults to `true`.
- **FEAT**: Add `canRequestFocus` to `ShadButton`.
- **FIX**: Unselected `ShadTab` which was focusable.

## 0.38.2

- **FEAT**: Add `searchFocusNode` to `ShadSelect` and `ShadSelectFormField` to provide a custom focus node for the search input.
- **FEAT**: Add `onSearchSubmitted` to `ShadSelect` and `ShadSelectFormField` to handle the submission of the search input (e.g., when the user presses the Enter key).
- **FIX**: `ShadInput` crash when removing the external `focusNode`.

## 0.38.1

- **FIX**: Fix ShadTable doesn't support RTL (thanks to @DMouayad).
- **FIX**: ShadToast & ShadSonner doesn't react to text direction change (thanks to @DMouayad).
- **FIX**: ShadSheet crash when tap outside the sheet (thanks to @pro100andrey).
- **FIX**: Feat: direction-aware dialog and toast close buttons (thanks to @DMouayad).
- **FIX**: ShadDialog - scrolling doesn’t work when constraints are set (thanks to @pro100andrey).

## 0.38.0

- **BREAKING CHANGE**: `ShadTabs.expandContent` has been removed and added to `ShadTab.expandContent` to allow expanding only specific tabs.

## 0.37.4

- **FIX**: Export `Effect` from `flutter_animate` as `AnimateEffect` to avoid name conflicts.
- **FIX**: Export `TextDirection` from `intl` as `IntlTextDirection` to avoid name conflicts.

## 0.37.3

- **FIX**: `ShadSelect` not updating the controller when the form field value changes.
- **FIX**: Remove `initialValues` from `ShadSelectMultipleFormField`, use `controller` instead.
- **FIX**: `ShadSelect.withSearch` keyboard shortcuts closing the popover when the search input is focused.

## 0.37.2

- **FEAT**: Add `backgroundColor`, `selectedBackgroundColor`, `textStyle` and `selectedTextStyle` to `ShadOptionTheme` and `ShadOption`, to customize the background color and text style of `ShadOption` (thanks to @9dan).

## 0.37.1

- **FIX**: Test fails due to pending Timer when using `Animate` and `Duration.zero`, which has been replaced with `ShadAnimate`.
- **FEAT**: Add `ShadThemeData.merge` and `ShadTheme.merge` methods to easily merge two themes together. This is useful when you want to override only a few properties of the theme for a subtree of the widget tree.

## 0.37.0

- **FEAT**: Add `tabsGap` and `tabBarAlignment` to `ShadTabs` in order to customize the gaps between tabs and the alignment of the tab bar (thanks to @9dan).
- **FIX**: Fix the resulting TextStyle applied to ShadTab (thanks to @9dan).
- **FIX**: Fix the resulting decoration applied to ShadTab (thanks to @9dan).
- **REFACTOR**: Before all text styles from `ShadTextTheme` had a color applied and `inherited` set to `false`, this prevented customizing the text styles easily. Now all text styles have `inherit` set to `true` and no color applied, so they can be customized more easily (thanks to @9dan)
- **FEAT**: Expose `TextStyle.fallback` method to easily set a fallback property to a TextStyle if it is null; for example, `textStyle.fallback(color: Colors.red)` will set the color to red if it is null, and will keep the original color if it is not null (thanks to @9dan).
- **FIX**: `ShadOption.selectedIcon` was always visible, even if the option was not selected (thanks to @DMouayad).
- **FEAT**: Allow custom exit transition duration in `showShadDialog` (thanks to @DMouayad).
- **FEAT**: Add `showHours`, `showMinutes` and `showSeconds` to `ShadTimePicker` and `ShadTimePickerFormField` to customize which fields are shown.

## 0.36.1

- **FIX**: Expose `ShadButtonSizesTheme`.
- **FEAT**: Add `textStyle` to `ShadButton` and `ShadButtonTheme` to customize the text style of the button.

## 0.36.0

- **BREAKING CHANGE**: Remove `iconData` from `ShadAlert`, use `icon` instead.
- **FEAT**: Add `iconSize` to `ShadAlert` and `ShadAlertTheme`, fallbacks to `16` from inherited `IconTheme`.

## 0.35.1

- **FIX**: The `lerp` method of themes was overriding null double values with 0.
- **FIX**: Replaced `Border` with `ShadBorder` because `Border.merge` from Flutter is a mess (sums widths of a and b).

## 0.35.0

- **BREAKING CHANGE**: The `mergeWith` method has been renamed into `merge` and the `merge` boolean has been renamed into `canMerge` (ShadThemes).
- **CHORE**: The theme generation has been automated by using the [theme_extensions_builder](https://pub.dev/packages/theme_extensions_builder) package (thanks to @pro100andrey).

## 0.34.0

- **FEAT**: Add `leading`, `trailing`, `top` and `bottom` parameters to `ShadAlert` to add widgets before, after, above or below the main content of the alert.

## 0.33.1

- **FIX**: `ShadSelect` always scrolling to the selected option when opening the popover which can now be disabled with `ensureSelectedVisible: false`.
- **CHORE**: Remove `required` from `onSearchChanged` in `ShadSelect` and `ShadSelectFormField` to make it optional, as it is not required when a custom `search` widget is provided.

## 0.33.0

- **FEAT**: Allow extending `ShadTextTheme` with custom text styles through the `custom` parameter. [See docs](https://mariuti.com/flutter-shadcn-ui/typography#extend-with-custom-styles).
- **FEAT**: Allow extending `ShadColorScheme` with custom colors through the `custom` parameter. [See docs](https://mariuti.com/flutter-shadcn-ui/theme/data/#extend-with-custom-colors).

## 0.32.2

- **FIX**: `ShadTooltip` not showing on hover.

## 0.32.1

- **FIX**: `ShadToast` constraints were not being used.
- **FIX**: `ShadToast` text direction was not taken from theme.
- **FEAT**: Add `mainAxisSize` and `mainAxisAlignment` to `ShadToast` and `ShadToastTheme`, defaults to `MainAxisSize.max` and `MainAxisAlignment.spaceBetween`.

## 0.32.0

- **REFACTOR**: Now all components are material-free. The only exception is `ShadApp` which provides platform adaptive routing and scroll behavior.

## 0.31.9

- **FIX**: `ShadSelect` not reacting to the controller and rebuilding `selectedOptionBuilder`.
- **FIX**: `ShadSelectFormField` and `ShadSelectMultipleFormField` not resetting the value on form reset.

## 0.31.8

- **FEAT**: Add support for keyboard navigation in `ShadCalendar` (thanks to @pedromassango).

## 0.31.7

- **FEAT**: Add `controller` to `ShadRadioGroup` to manually control the selected value.

## 0.31.6

- **FIX**: `ShadSwitch` on RTL direction.

## 0.31.5

- **FEAT**: Add `useSafeArea` to `ShadDialog` and `ShadSheet` to wrap the content with a `SafeArea`. Defaults to `true`.

## 0.31.4

- **FIX**: `closeOnTapOutside` of `ShadDatePicker` which wasn't passed to `ShadPopover`.

## 0.31.3

- **FIX**: Convert all `EdgeInsets` to `EdgeInsetsGeometry` to better support RTL and fix many components.

## 0.31.2

- **FEAT**: Add `ShadAccordionController` to manually control the open/close state of the `ShadAccordionItem`s.
- **FEAT**: Toggle `ShadAccordionItem` by pressing `Space` (before it worked only with `Enter`) when the header is focused.

## 0.31.1

- **FEAT**: Add `side` to `ShadSheetTheme` to set the default side of the sheet from the theme.

## 0.31.0

- **FEAT**: Modify the `ShadTooltip` component and its hover strategies to work on mobile on tap without a long press.
- **FEAT**: Add `ShadHoverStrategy.onTapOutside` to trigger unhover when tapping outside the widget.
- **FEAT**: Add `ShadHoverStrategy.onTap` to trigger hover/unhover when tapping inside the widget.
- **FEAT**: Now if an hover strategy is present in both `hoverStrategies.hover` and `hoverStrategies.unhover`, the hover will be toggled.

## 0.30.5

- **FIX**: change `ShadSeparator.margin` type to `EdgeInsetsGeometry`

## 0.30.4

- **FIX**: `ShadTextareaFormField` initial value assert due to controller being used internally.

## 0.30.3

- **FIX**: `onChanged` of `ShadInputFormField` and `ShadTextareaFormField` fired twice for any change.

## 0.30.2

- **FIX**: Expose `ShadDefaultKeyboardToolbarTheme`.

## 0.30.1+1

- **CHORE**: Remove useless import.

## 0.30.1

- **FIX**: Fix `ShadResizable` on RTL (for real this time).
- **CHORE**: Bump min Flutter SDK version to `3.35.0` to support `FormField.onReset` and `Brightness` from `'package:flutter/widgets.dart'`

## 0.30.0

- **FEAT**: Add `ShadKeyboardToolbar` and `ShadDefaultKeyboardToolbar` components to show a toolbar above the keyboard. Add `keyboardToolbarBuilder` to `ShadInput`, `ShadInputFormField`, `ShadTextArea`, `ShadTextAreaFormField`, `ShadInputOTP`, `ShadInputOTPFormField` to easily add a keyboard toolbar to these components.

## 0.29.4

- **FIX**: Fix `ShadTextTheme.copyWith` was always overwriting custom font with default `Geist` font. [#425]

## 0.29.3

- **FIX**: Ensure `ShadForm.onChanged` is called for both standard `Form` fields and `ShadFormField` widgets.
- **FIX**: Add missing `forceErrorText` parameter to `ShadFormField` widgets.

## 0.29.2

- **FIX**: Fix `ShadResizable` on RTL. Remove useless `textDirection` parameter from `ShadResizable` and `ShadResizableTheme`.

## 0.29.1

- **FIX**: Add missing `alignment` parameter to `ShadInput`, `ShadInputFormField`, `ShadTextArea` and `ShadTextAreaFormField`.

## 0.29.0

- **FIX**: Add missing popover closing animation (thanks to @DMouayad).

## 0.28.8

- **CHORE**: Resolve lint issues.

## 0.28.7

- **FIX**: Updated `ShadPopover` filter logic to use effectiveFilter instead of widget.filter.

## 0.28.6

- **REFACTOR**: Add `cursor*` customizations through theme (thanks to @GuillaumeMCK).

## 0.28.5

- **FIX**: `ShadCalendar` back and forward buttons on RTL (thanks to @HarithHaroon).

## 0.28.4

- **FEAT**: Add `cursorColor` to `ShadInput` (thanks to @GuillaumeMCK).
- **FIX**: Use `AlignmentGeometry` instead of `Alignment` inside `ShadInput`, `ShadTextarea` and their form fields (thanks to @omaralmgerbie)

## 0.28.3

- **FIX**: pass `backgroundColor` to `ShadAppBuilder` (thanks to @GuillaumeMCK)

## 0.28.2

- **FIX**: `ShadDialog` and `ShadSheet` now use `SafeArea` to prevent the content from being cut off by the system UI.

## 0.28.1

- **FIX**: Add `clearValueOnUnregister` to `ShadForm` (defaults to `false`) to prevent clearing a form field's value from the form state when the field is unregistered (aka disposed).
- **FIX**: `ShadPopover` not closing when pressing ESC (thanks to @DMouayad)

## 0.28.0

- **REFACTOR**: Update `ShadCalendar` `yearSelectorMinWidth` from `100` to `64` and `monthSelectorMinWidth` from `120` to `64`.
- **REFACTOR**: Update `ShadCalendar` position of dropdown, which is now centered in the header.
- **REFACTOR**: Add `dropdownFormatMonth` and `dropdownFormatYear` to `ShadCalendar`.
- **FIX**: Center the placeholder in `ShadAvatar`.
- **DOCS**: Fix missing `MainAxisSize.min` in `ShadCard` notification example.
- **DOCS**: Adjust sheet docs example, with some spacing between buttons.
- **FIX**: Fix the hit test behavior of `ShadContextMenuRegion`.
- **FEAT**: Expose `hitTestBehavior` from `ShadContextMenuRegion`, defaults to `HitTestBehavior.opaque` (thanks to @NonymousMorlock).
- **REFACTOR**: Set default text align of `ShadTooltip` to `null` instead of `TextAlign.center`.

## 0.27.4

- **FIX**: `ShadIconButton` icon size property isn't applied (thanks to @TahaTesser).

## 0.27.3

- **FIX**: `ShadCalendar` `initialMonth` update when the user did not interact with the month selector yet.
- **DOCS**: Fix typo in button code snippet (thanks to @piedcipher).

## 0.27.2

- **FIX**: `ShadAccordion` title overflow when the title is too long (thanks to @monteiz).
- **FIX**: `ShadContextMenuItem` hover background color.
- **CHORE**: Bump the minimum Flutter version to `3.32.0` to support the `RoundedSuperellipseBorder`.

## 0.27.1

- **FEAT**: Add `ShadRoundedSuperellipseBorder` to support the rounded superellipse border style as the primary border of any widget that uses `ShadDecoration`.

## 0.27.0

- **BREAKING CHANGE**: The secondary border of `ShadDecoration` now is drawn outward of the widget, without consuming any extra space. This change affects all components that are focusable.
- **FEAT**: Add `offset` to `ShadBorder` to set the offset between the widget and the outward secondary border.
- **REFACTOR**: Remove all deprecated parameters across the whole package, including `orderPolicy`, `ShadApp.material`, `ShadApp.cupertino` and so on.
- **REFACTOR**: Update the default `anchor` of `ShadSelect`, `ShadTooltip` and `ShadPopover` from `ShadAnchorAuto()` to `ShadAnchorAuto(offset: Offset(0, 4))`.
- **REFACTOR**: Add `checkboxPadding` to `ShadCheckbox`, `ShadCheckboxTheme` and `ShadCheckboxFormField`, defaults to `EdgeInsets.only(top: 1)`.
- **REFACTOR**: Add `radioPadding` to `ShadRadio` and `ShadRadioTheme`, defaults to `EdgeInsets.only(top: 1)`.
- **FIX**: Background color of pages for pure `ShadApp` if no `Scaffold` is used, by adding a new `backgroundColor` parameter to `ShadApp` and `ShadAppBuilder`.
- **FEAT**: Add `actionsGap` to `ShadDialog`, defaults to `8`.
- **REFACTOR**: Update `ShadTimePickerTheme` parameters: `spacing` changed from `0` to `8`, `runSpacing` changed from `0` to `4`, `gap` changed from `2` to `4`, `fieldWidth` changed from `58` to `48`, `periodHeight` changed from `50` to `42`.
- **FIX**: Lookup of correct `ShadTextareaTheme` when retrieving the `scrollbarPadding`.
- **REFACTOR**: Update `ShadCalendarTheme.dayButtonDecoration.secondaryFocusedBorder` to use a new offset and 50% opacity for improved visibility.
- **REFACTOR**: The `ShadInputOTPTheme.padding` changed from `EdgeInsets.symmetric(vertical: 4)` to `null`.
- **REFACTOR**: Change `ShadInputOTPTheme.padding` from `EdgeInsets.symmetric(vertical: 4)` to `null`.
- **REFACTOR**: Automatically select the focused `ShadTab` to prevent secondary border collisions, matching original shadcn keyboard navigation behavior.
- **REFACTOR**: Change `ShadCalendarTheme.monthSelectorMinWidth` from `130` to `120`.
- **REFACTOR**: The `ShadCalendar.yearSelector` and `ShadCalendar.monthSelector` now use a secondary focused border with 50% opacity to match other parts.
- **REFACTOR**: Update `ShadSelect` with presets example by adding padding.
- **REFACTOR**: Remove secondary border removal from `ShadInput` example with trailing icon.
- **REFACTOR**: Update `ShadMenubar.anchor.offset` from `Offset(-8, 8)` to `Offset(-4, 8)`.
- **REFACTOR**: Update `ShadPopover` example by adding a gap between input fields.
- **FIX**: `ShadSelectController` now has a `Set` instead of a `List` to prevent duplicates in the selected options, this change has been applied to `ShadSelect.initialValues` and `ShadSelectFormField` as well.

## 0.26.5

- **CHORE**: Update lower bound dependency versions.

## 0.26.4

- **CHORE**: Relax dependencies, previous versions were too strict and have been retracted.

## 0.26.3

- **CHORE**: Bump the min flutter version to `3.32.0`.

## 0.26.2

- **FIX**: Add `supportedDevices` to `ShadContextMenuRegion` to decide which devices trigger the context menu (thanks to @MousyBusiness).

## 0.26.1

- **CHORE**: Update `intl` dependency to `^0.20.2` (thanks to @jg-l)
- **CHORE**: Update all other dependencies to the latest versions.

## 0.26.0

- **BREAKING CHANGE**: Update the `appBuilder` of the `ShadApp` by removing the `ThemeData` parameter.
- **REFACTOR**: Deprecate `ShadApp.material`, `ShadApp.materialRouter`, `ShadApp.cupertino` and `ShadApp.cupertinoRouter`. Use `ShadApp.custom` instead.

## 0.25.1

- **FIX**: The scrollbar of the `ShadTextarea` component has been fixed, added `scrollbarPadding` to `ShadTextareaTheme` and `ShadInputTheme`.
- **FIX**: Focus of `ShadTextarea` on resize.

## 0.25.0

- **CHORE**: Bump dependency versions (thanks to @mayapaw).
- **FEAT**: Add `ShadTextarea` and `ShadTextareaFormField` components (thanks to @dalroy44).
- **FIX**: `ShadSelectFormField` initial value from `ShadForm` not working.

## 0.24.0

- **FEAT**: Add `Sonner` component.

## 0.23.4

- **FIX**: `ShadSelectFormField` and `ShadSelectMultipleFormField` controller not updating the parent `ShadForm`.

## 0.23.3

- **FIX**: `ShadInput` `onPressedOutside` when tapping on another `ShadInput`.
- **FEAT**: Add `groupId` to `ShadInput` and `ShadInputFormField`, defaults to `UniqueKey` instead of `EditableText`.

## 0.23.2

- **FEAT**: Add `copyWith` method to `ShadColorScheme` (thanks to @Luckey-Elijah).

## 0.23.1

- **FIX**: `ShadResizable` divider alignments when `dividerSize` is overriden.

## 0.23.0

- **FIX**: Expose `ShadMouseCursorProvider`.
- **FIX**: `ShadMenubar` anchor.
- **FIX**: `ShadBadge` should not enter the gesture arena if the `onPressed` callback is not provided.
- **FEAT**: Add `cursor` to `ShadBadge`, defaults to `SystemMouseCursors.click` if `onPressed` is provided.
- **BREAKING CHANGE**: Refactor `ShadAnchorAuto` to make it more powerful, removed `verticalOffset` and `preferBelow` in favor of `offset`, `followerAnchor` and `targetAnchor`. Now every component uses it by default.

## 0.22.5

- **FIX**: `ShadGestureDetector` global coordinates when using multiple `Navigator`s.

## 0.22.4

- **FIX**: Pass `themeMode` to `MaterialApp` (thanks to @mubareksd).
- **FIX**: Add `focusNode` to `ShadInputFormField`.

## 0.22.3

- **FIX**: `ShadTooltip` exit animation, add `duration` and `reverseDuration` to it.
- **FIX**: `ShadMenubar` no longer steals the focus.
- **FIX**: `ShadButton` stealing focus when pressed.
- **FEAT**: Add `stylusHandwritingEnabled` to `ShadInput`.

## 0.22.2

- **FIX**: Add `constraints` to `ShadInput` and `ShadInputFormField`, by default the min height is calculated based on the `style` and `placeholderStyle`.
- **FIX**: `ShadInput` style and placeholder style which are now merged instead of replaced.
- **FIX** `ShadMenubar` wrong padding used for the context menu.
- **CHORE**: Set min flutter version to `3.29.0` (thanks to @qk7b)

## 0.22.1

- **FIX**: `ShadInput` icon color.

## 0.22.0

- **FEAT**: Add `ShadMenubar` component.
- **REFACTOR**: Deprecate `ShadDivider` and `ShadDividerTheme`, use `ShadSeparator` and `ShadSeparatorTheme` instead.
- **FEAT**: Add `onTapInside`, `onTapOutside`, `onTapUpInside` and `onTapUpOutside` to `ShadContextMenu`.

## 0.21.0

- **FEAT**: Add `ShadDivider` component (thanks to @Luckey-Elijah)
- **FIX**: Pass `buttonDecoration` to `ShadButton` inside `ShadDatePicker` (thanks to @plusema86)
- **CHORE**: Add comments to all components + test many of them

## 0.20.3

- **FIX**: Validation mode on form field reset (thanks to @Mayb3Nots)

## 0.20.2

- **REFACTOR**: Deprecate `ShadTab.icon`, use `ShadTab.leading` instead. Add `trailing`.
- **FIX**: Disable scroll inside `ShadCalendar`

## 0.20.1

- **REFACTOR**: Set `debugShowCheckedModeBanner` to `false` by default in `ShadApp`.
- **FIX** Expose `ShadInputOTPTheme`.

## 0.20.0

- **FEAT**: Add `ShadIconButton` component.
- **REFACTOR**: Deprecated `ShadButton.icon`, use `ShadIconButton` for a button with just an icon and `ShadButton.leading` for a button with an icon and a text.
- **REFACTOR**: Deprecate `orderPolicy`, use `leading` and `trailing` in the component.
- **REFACTOR**: Deprecate `prefix` and `suffix` in `ShadInput`, use `leading` and `trailing` instead.
- **REFACTOR** Deprecate `searchInputPrefix` in `ShadSelect`, use `searchInputLeading` instead.

## 0.19.3

- **FIX**: Make `selectedOptionBuilder` required in `ShadSelect` (thanks to @muradab).
- **FIX**: Add `optionsBuilder` to `ShadSelect` and its form fields where it was missing.

## 0.19.2

- **FIX**: Add constraints to `ShadCard` child.

## 0.19.1

- **REFACTOR**: Rename `materialTextTheme` into `applyGoogleFontToTextTheme`.
- **FEAT**: Allow accessing the `ShadTheme` with the context, in the `materialThemeBuilder` and `appBuilder`.

## 0.19.0

- **FIX**: `ShadInput` `readOnly` not updating.
- **BREAKING CHANGE**: Rename `ShadSelect` and form fields `controller` to `popoverController`.
- **FEAT**: Add `controller` to `ShadSelect` and form fields, to control the selected values.
- **FIX**: Improve the `ShadResizable` controller handling and simplify the logic to resize the panels.
- **FIX**: `ShadResizable` handle position with `Axis.vertical`.
- **BREAKING CHANGE**: Now `ShadResizable` requires an `id`, to be able to handle when a panel is removed/added from the widget tree correctly.
- **CHORE**: Correctly set the `theme` or `darkTheme` to the internal `MaterialApp`.

## 0.18.7

- **FIX**: `ShadApp` dark theme behavior now is the same as Material. The dark theme is applied only if you provide a `darkTheme` and the user theme mode is dark

## 0.18.6

- **FIX**: `ShadTimePicker` controller not being used correctly when the component is initialized. Now each field allows a single digit instead of two.

## 0.18.5

- **FIX**: `ShadCalendar` forward button icon color.
- **CHORE**: Bump the version of `universal_image` (thanks to @brunosemfio).

## 0.18.4

- **FIX**: `ShadDatePicker` popover closes on caption selection.
- **CHORE**: Add `onNavigationNotification` to `ShadApp` (thanks to @mllrr96)
- **FIX**: `ShadDatePicker` crash when caption layout is different from label, due to misleading `Locale` type passed to `DateFormat`, thanks `dynamic` for these amazing errors.

## 0.18.3

- **FIX**: Improve `ShadAvatar` (thanks to @mickey35vn).
- **FIX**: Locale not handled in `ShadCalendar` and `ShadDatePicker`.
- **REFACTOR**: Remove `optionsOrderPolicy` from `ShadSelectTheme` and move it to `ShadOptionTheme` with the name `orderPolicy`.

## 0.18.2

- **FIX**: `InputOTP` component with RTL directionality.

## 0.18.1

- **FIX**: Set `ShadCard` clipBehavior to `Clip.antialias`, add `clipBehavior` to `ShadCard` and `ShadCardTheme`.
- **FIX**: Use `selectedDecoration` in `ShadTabs` (thanks to @thisisamank)
- **FEAT**: Add colorSelector to the ShadcnUI docs (thanks to @0xharkirat)
- **FEAT**: Add `hourLabel`, `minuteLabel`, `secondLabel`, `periodLabel`, `hourPlaceholder`, `minutePlaceholder`, `secondPlaceholder` and `periodPlaceholder` to `ShadTimePickerTheme`.

## 0.18.0

- **BREAKING CHANGE**: Remove `applyIconColorFilter` from `ShadButton`.
- **BREAKING CHANGE**: Remove `ShadImage` component. Prefer using the `Icon` widget for `IconData`, the `Image` widget for normal images, and `SvgPicture` (from the [flutter_svg package](https://pub.dev/packages/flutter_svg) for SVG images. If you want a fallback, use `UniversalImage`.
- **BREAKING CHANGE**: Rename `iconSrc` in `iconData` around components.
- **FIX**: `TimePickerFormField` initial value.

## 0.17.6

- **FIX**: Fix the iconSize of `ShadButton`, add `iconSize` to `ShadButton`.

## 0.17.5

- **FEAT**: New `OrderPolicy`, `LinearOrderPolicy`, `ReverseOrderPolicy` and `CustomOrderPolicy` to update the order policy of the items in a list, this can be very useful to arrange the order of the parts of the shadcn components.
- **FEAT**: Add `orderPolicy` to `ShadOption`, `ShadAlert`, `ShadButton`, `ShadCheckbox`, `ShadCheckboxFormField`, `ShadDatePicker`, `ShadDatePickerFormField`, `ShadDateRangePickerFormField`, `ShadRadio`, `ShadSwitch`, `ShadSwitchFormField`, `ShadToast`.
- **FEAT**: Add `expands` to `ShadButton`, defaults to false. Use it if you want the button's child to expand to fill the available space.

## 0.17.4

- **FIX** `ShadTabs` onChanged runtime exception due to misleading type

## 0.17.3

- **FIX**: `ShadTable` protect `onExit` from setting value after dispose (thanks to @jezell)

## 0.17.2

- **FIX**: Add `allowDeselection` to `ShadCalendar.range`
- **CHORE**: Update dependencies

## 0.17.1

- **FIX**: `ShadInputOTP` text alignment and padding
- **FEAT**: Add `textInputAction` to `ShadInputOTPSlot`

## 0.17.0

- **FEAT**: Add `ShadInputOTP` and `ShadInputOTPFormField` components.
- **BREAKING CHANGE**: The `ShadBorder` no longer has default values, if you want to see the border rendered provide a color and a width greater than 0. This fixes the merge of material borders.
- **FIX**: `ShadTabs` border radius.
- **FIX**: `ShadSlider` focused thumb.
- **FIX**: `ShadResizable` resize when Directionality is RTL.
- **FIX**: Update the `destructive` color on dark mode to be more visible.
- **FIX**: Make inherited widget lookup untyped

## 0.16.3

- **FIX**: `showCursor` default value in `ShadInputFormField`

## 0.16.2

- **FIX**: `ShadTabs` and `ShadResizable` lerp
- **FIX**: `ShadTabs` focused border color in dark mode

## 0.16.1

- **FEAT**: Add parameters to `ShadFocusable`.

## 0.16.0

- **FEAT**: New `ShadTimePicker` and `ShadTimePickerFormField` components.
- **FIX**: `maxLength`, `maxLengthEnforcement` and `showCursor` not working on `ShadInput`
- **FIX**: `ShadCalendar` range day button text style when `disableSecondaryBorder` is `true`.
- **CHORE**: Set minimum Flutter version to `3.24.0`
- **CHORE**: Remove `trackColor` from `ShadSwitch` (thanks to @RaghavTheGreat)
- **FIX**: `ShadSlider` `onChanged` called on every controller update (thanks to @helightdev).

## 0.15.3

- **FIX**: `ShadDialog` and `ShadSheet` children constraints.
- **CHORE**: Replace `flutter_svg_plus` dependency with `flutter_svg` and `vector_graphics_plus` with `vector_graphics`.

## 0.15.2

- **FIX**: `ShadDialog` and `ShadSheet` children constraints.

## 0.15.1

- **FIX**: Decoration merge

## 0.15.0

- **FEAT**: New `ShadDatePicker` component.
- **FEAT**: Add `allowDeselection` property to `ShadCalendar`.
- **FIX**: `ShadSelect` crash when using `optionsBuilder`.
- **FEAT**: Add `itemCount` and `shrinkWrap` to `ShadSelect` and `ShadSelectFormField`.

## 0.14.1

- **FIX**: `ShadApp` scroll behavior.

## 0.14.0

- **BREAKING CHANGE**: Remove `onChangedNullable` from `ShadSelect` and `ShadSelectFormField`. Now the `onChanged` callback will be called with `null` when the user deselects an option if `allowDeselection` is set to `true`. (thanks to @moshOntong-IT)
- **FEAT**: Add click mouse cursor to `ShadTable` when `onRowTap` or `onColumnTap` is provided.

## 0.13.5

- **FIX**: Fix `ShadSelect` initial values on widget creation.

## 0.13.4+1

- **CHORE**: Update svg dependencies

## 0.13.4

- **CHORE**: Update svg dependencies

## 0.13.3

- **FEAT**: Add `ShadApp.custom` for custom _WidgetsApp_ implementation.

## 0.13.2

- **CHORE**: Use forked `flutter_svg` and `vector_graphics` packages.

## 0.13.1

- **CHORE**: Update `ShadImage` import due to WASM.

## 0.13.0

- **FEAT**: New `ShadCalendar` component with the `single`, `multiple` and `range` variants.

## 0.12.0

- **FEAT**: Add `axis`, `spacing`, `runSpacing`, `alignment`, `runAlignment`, `crossAxisAlignment` and `crossAxisAlignment` to `ShadRadioGroup` and `ShadRadioGroupFormField`.

## 0.11.1

- **FEAT**: Add `headers` to `ShadImage` to allow custom headers in the network requests.

## 0.11.0

- **FEAT**: Add `ShadSelect.multiple`, `ShadSelect.multipleWithSearch`, `ShadSelectMultipleFormField` and `ShadSelectMultipleFormField.withSearch` constructors.
- **FEAT**: Add `onChangedNullable` to `ShadSelect` and `ShadSelectFormField`, to allow the deselection of an option.
- Improve the `ShadSelect` focus behavior.
- Improve size of `ShadSelect` options to fit the available space.

## 0.10.0

- **BREAKING CHANGE**: Rename `children` parameter of `ShadContextMenu` and `ShadContextMenuRegion` into `items`.

## 0.9.8

- Improve the `ShadContextMenu` right click behavior on Web.

## 0.9.7

- Remove kind event from `ShadMouseArea`

## 0.9.6

- Fix: the browser context menu has been enabled again, and deactivated only for the `ShadContextMenu` component.

## 0.9.5

- Add text selection toolbar to `ShadInput` (thanks to @moshOntong-IT).

## 0.9.4

- Add gestures recognizers to `ShadTable` for rows and columns.

## 0.9.3

- Fix `ShadSelectFormField` focus when `readOnly` is true.

## 0.9.2

- Add `gap` to `ShadInput` and `ShadInputFormField` (thanks to @moshOntong-IT).

## 0.9.1

- Fix native context menu by disabling it on Web.
- Add `controller` to `ShadContextMenu`.
- Add `onLongPress` to `ShadContextMenuRegion`, defaults to `true` on mobile.

## 0.9.0

- New `ShadContextMenu` component.
- Add `groupId` to `ShadPopover`, to determine if the tap is inside the popover or not.
- Add `onFocusChange` to `ShadFocusable` and `ShadButton`.
- Add `onSecondaryTap` to `ShadButton`.

## 0.8.1

- Fix `ShadTabs` not updating the controller when the value changes.

## 0.8.0

- **BREAKING CHANGE**: Refactor `ShadResizablePanelGroup` in order to react to window resize correctly. The sizes have been normalized. You don't need to provide anymore a pixel size, but a value between 0 and 1 which indicates the percentage of the available space.
- Add `onChanged` to `ShadTabs`.
- Add `onSecondaryTap` to `ShadGestureDetector` and `ShadButton`.
- Fix `maxWidth` missing in `ShadSelectForlField`.

## 0.7.3

- Add `header` and `footer` to `ShadSelect` and `ShadSelectFormField`.
- Add `mainAxisAlignment` and `crossAxisAlignment` to `ShadAlert`.
- Fix unintentional disposal of `controller` in `ShadSelect`.
- Remove assert about `icon` and `iconSrc` in `ShadAlert`, you can avoid using an icon now.
- Fix height of Sheet.

## 0.7.2

- Add `controller` parameter to `ShadSelect` and `ShadSelectFormField`.

## 0.7.1

- Fix performance of `ShadSelect` with the new `optionsBuilder` parameter for a large number of options.
- Fix keyboard appearance of `ShadInput` (thanks to @hieupm2096).
- Add `onPressed` to `ShadBadge`.
- Rename button `text` parameter into `child`.
- Rename dialog `content` parameter into `child`.
- Rename sheet `content` parameter into `child`.
- Rename tab `text` parameter into `child`.

## 0.7.0

- Rename Tabs `defaultValue` parameter into `value`.
- Rename Card `content` parameter into `child`.
- Rename Badge `text` parameter into `child`.
- Rename Input `onTap` parameter into `onPressed`.
- Rename AccordionItem `content` parameter into `child`.
- Add `filter` to Select and Popover in order to blur the background when the popover is open.
- Pass `errorText` to `error` build of Form Fields.
- Add `gap` to Buttons, default to `8`.
- Update type of `src` parameter of Avatar
- Add `Alert.raw` constructor
- Add `Dialog.raw` constructor
- Add `Select.raw` and `SelectFormField.raw` constructors
- Add `TableCell.raw` constructor
- Add `draggable` to Sheet to make it draggable, it works on every side.
- Add `ThemeVariant` to handle the default theme variant, and the one without the secondary border.

## 0.6.5

- Add `textDirection` to `ShadButton`

## 0.6.4

- Make `content` of `ShadTab` optional
- Add `TextSelectionTheme` using shadcn colors
- Add `crossAxisAlignment` to `ShadCheckbox`
- Fix `ShadSelect` popover padding

## 0.6.3

- Fix `FormField`s label not getting the correct style.
- Update the `Popover` animation duration to be faster, the same applies to the `Select` component.
- Remove unused `waitDuration` and `showDuration` from `Popover`.
- Add `effects` and `shadows` to `Select` and `SelectTheme`.

## 0.6.2

- Fix form field error border decoration not working
- Add `ShadAutovalidateMode` to `ShadForm`, with the new `alwaysAfterFirstValidation` mode (the new default)
- Fix: apply Google Font to Material text theme

## 0.6.1

- Remove `ShadButtonSize.icon`. Now by default, when the `icon` is provided and the `text` is not, the button will use the `icon` size.

## 0.6.0

- Add `ShadTabs` component
- Add `ShadColorScheme.fromName` to easily create a color scheme from a name (String)
- Add `package` to `ShadImage` (thanks to @farhanfadila1717)
- Fix `decoration` of form fields
- Fix selection controls of `ShadInput`

## 0.5.7

- Renamed the breakpoints
- Add `context.breakpoint` extension

## 0.5.6

- Fix mismatch of `childAlignment` and `overlayAlignment` in `ShadPortal`
- Remove top padding of `ShadPopover`
- Set default values to `ShadAnchor` and `ShadAnchorAuto`

## 0.5.5

- Remove `inputDecoration` from form fields.
- Fix `ShadApp` default dark theme.

## 0.5.4

- Fix double padding on form fields.

## 0.5.3

- Update dependencies
- Removed deprecated parameters `checkerboard...` from `ShadApp`

## 0.5.2

- Fix `onTap` not working in `ShadInput` and `ShadInputFormField`

## 0.5.1

- Fix `ShadInputFormField` which disposed the controller being passed to it.
- Add `scrollable` and `scrollPadding` to `ShadDialog` and `ShadSheet`. By default, the dialogs and sheets are scrollable and the viewInsets are the default scroll padding.

## 0.5.0

- Add the `ShadSelect.withSearch` constructor to easily add a search input to the select component.

## 0.4.7

- Add `maintainState` to `ShadAccordion` to keep the child in the tree even if the item is closed, defaults to `false`.
- Update `ShadAccordion` to use `effects` instead of `transitionBuilder`.
- Remove `rive` dependency and Rive support in `ShadImage` due to many issues with the package.
- Remove `colorScheme` from `ShadTextTheme`. Now the colors will be automatically derived, unless specified.
- Fix popover position in `ShadSelect` component.
- Refactor `ShadDecoration` to easily change the default borders and add new decoration properties to it. Some properties have been moved from the components to the `decoration` of the component.
- Fix `ShadTable` row indexes when using an `headerBuilder` (thanks to @Kyziq).

## 0.4.6

- Update depencencies versions
- Remove `ShadSameWidthColumn` component
- Remove boxy dependency
- Make components keyboard accessible

## 0.4.5

- Remove `placeholderStyle` and `placeholderAlignment` from `ShadDecoration` and move to `ShadInput` and `ShadInputFormField`
- Add `suffix` and `prefix` to `ShadInput` and `ShadInputFormField`

## 0.4.4

- Add `horizontalScrollPhysics` and `verticalScrollPhysics` to `ShadTable`
- Add `mainAxisAlignment` and `crossAxisAlignment` to `ShadButton`
- Fix `ShadDialog` content adding default text style
- Remove popover asserts and ignore operation if already opened/closed.
- Add `longPressDuration` to `ShadGestureDetector`
- Add `hoverStrategies` to ShadButtonTheme's
- Fix use `strutStyle` in `ShadInput`
- Add `backgroundColor` to `ShadInput` and `ShadInputFormField` (thanks to @Dredayduncan)
- Remove `inputDecoration` from `ShadInput`
- Put `placeholder` on top of `ShadInput`
- Fix text style alignment

## 0.4.3

- Fix `ShadResizable` divider position

## 0.4.2

- Add `ShadGestureDetector` with hover strategies for touchscreens.
- Add `ShadTooltipController` to `ShadTooltip`.
- Increase the divider size in the `ShadResizable` component.

## 0.4.1

- Expose `ShadResizableTheme`.

## 0.4.0

- Add `ShadResizable` component

## 0.3.3

- Improve pub dev score

## 0.3.2

- Fix `preferBelow` default value for `ShadSelect` and `ShadPopover`

## 0.3.1

- Add `ShadAnchorAuto` to `ShadPortal`, to automatically adjust the position of the overlay. This applies to all components that use `ShadPortal`, like `ShadSelect`, `ShadTooltip`, `ShadPopover`.

## 0.3.0

- Add `ShadTable` component
- Improved `ShadInput` placeholder alignment

## 0.2.6

- Fix buttons state not updated correctly
- Remove `ShadAssets` in favor of `LucideIcons`

## 0.2.5

- Add `width` and `height` to `ShadCard`
- Add `leading` and `trailing` to `ShadCard`

## 0.2.4

- Add workaround for google_fonts issue about font weights. see <https://github.com/material-foundation/flutter-packages/issues/35>
- Make `from` of `ShadTextTheme.fromGoogleFont` unnamed.

## 0.2.3

- Expose `ShadTextTheme`
- Fix `ShadTextTheme` to add ability to change font family
- Add `materialThemeBuilder` to default `ShadApp`
- Add `ShadTextTheme.fromGoogleFont` to use a Google Font

## 0.2.2

- Fix lerp of `ShadDecoration` and `ShadBorder`
- Add `ShadDecoration.none` and `ShadBorder.none`

## 0.2.1

- Fix export of color schemes (thanks to @Pietervdw)

## 0.2.0

- Add `materialThemeBuilder` and `cupertinoThemeBuilder` to `ShadApp`
- Fix `readOnly` for `ShadInput`
- Fix `initialValue` for `ShadInputFormField`
- Rename `AnimatedShadTheme` into `ShadAnimatedTheme`

## 0.1.0

- new `ShadProgress` component
- new `ShadAccordion` component
- new `ShadSheet` component
- add `onLongPress` to buttons
- add `ShadStatesController` to buttons
- update `showShadDialog`
- set toast default animations based on alignment
- change toast default offset
- add Material and Cupertino constructors in `ShadApp`

## 0.0.1-dev1

- First development release

## 0.0.0

- Initial commit
