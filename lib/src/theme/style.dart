import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/src/theme/radii.dart';
import 'package:shadcn_ui/src/theme/text_role.dart';
import 'package:shadcn_ui/src/theme/themes/shadows.dart';

/// The metrics that distinguish one shadcn/ui *style* from another.
///
/// shadcn ships eight named styles. They are not colour variations — they are
/// full geometry sets. Comparing `registry/styles/style-*.css` shows the same
/// components rebuilt at different sizes: a `mira` button is 28px tall with 8px
/// of horizontal padding while a `sera` button is 40px tall with 24px, and
/// everything around them — inputs, menu rows, card padding, slider tracks,
/// switch dimensions — moves with it.
///
/// They also retype it. Each style redefines a handful of [ShadTextRole]s —
/// title, label, body, caption, overline and field — so `lyra` sets body copy
/// at 12px, `mira` puts it on a relaxed line, and `sera` sets labels in 12px
/// semibold uppercase with wide tracking. Shadows move too: `nova` drops the
/// card shadow entirely, `maia` gives popovers a 2xl one.
///
/// The headline differences, in logical pixels:
///
/// | style | button h / px | body | title | card pad | slider | ring |
/// | ----- | ------------- | ---- | ----- | -------- | ------ | ---- |
/// | vega  | 36 / 10 | 14 | 16 | 24 | 6  | 3 @ 50% |
/// | nova  | 32 / 10 | 14 | 16 | 16 | 4  | 3 @ 50% |
/// | maia  | 36 / 12 | 14 | 16 | 24 | 12 | 3 @ 50% |
/// | lyra  | 32 / 10 | 12 | 14 | 16 | 4  | 1 @ 50% |
/// | mira  | 28 / 8  | 12 | 14 | 16 | 4  | 2 @ 30% |
/// | luma  | 36 / 12 | 14 | 16 | 24 | 8  | 3 @ 30% |
/// | sera  | 40 / 24 | 14 | 18 | 32 | 2  | 2 @ 30% |
/// | rhea  | 32 / 12 | 14 | 16 | 20 | 4  | 3 @ 30% |
///
/// Every value here was read from shadcn's own CSS, converting Tailwind's
/// scale at 4px per unit (`px-2.5` is 10, `h-9` is 36). Passing one of these
/// to a theme variant reshapes every component at once, which is what makes a
/// style switch a single setting rather than a second theme.
///
/// The defaults are `vega`'s, so a custom style only has to state what it
/// changes.
@immutable
class ShadStyleTokens {
  const ShadStyleTokens({
    required this.name,
    // Radii.
    this.buttonRadius = ShadRadiusToken.md,
    this.cardRadius = ShadRadiusToken.xl,
    this.dialogRadius = ShadRadiusToken.xl,
    this.popoverRadius = ShadRadiusToken.md,
    this.textareaRadius = ShadRadiusToken.md,
    this.itemRadius = ShadRadiusToken.sm,
    this.checkboxRadius = 4,
    // Focus ring.
    this.cardBorderOpacity = .1,
    this.surfaceBorderOpacity = .1,
    this.ringWidth = 3,
    this.ringOpacity = .5,
    // Typography, by role.
    this.title = const ShadTextRole(fontSize: 16, fontWeight: FontWeight.w500),
    this.label = const ShadTextRole(fontSize: 14, fontWeight: FontWeight.w500),
    this.body = const ShadTextRole(fontSize: 14),
    this.caption = const ShadTextRole(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    this.overline = const ShadTextRole(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    this.field = const ShadTextRole(fontSize: 14),
    // Shadows.
    this.cardShadow = Shadows.xs,
    this.popoverShadow = Shadows.md,
    this.dialogShadow = Shadows.none,
    this.sheetShadow = Shadows.lg,
    // Buttons and toggles.
    this.buttonHeight = 36,
    this.buttonHeightSm = 32,
    this.buttonHeightLg = 40,
    this.buttonPaddingX = 10,
    this.buttonPaddingXSm = 10,
    this.buttonPaddingXLg = 10,
    this.buttonGap = 6,
    this.iconButtonSize = 36,
    this.iconButtonSizeSm = 32,
    this.iconButtonSizeLg = 40,
    // Text fields.
    this.inputHeight = 36,
    this.inputPaddingX = 10,
    this.inputPaddingY = 4,
    this.textareaPaddingX = 10,
    this.textareaPaddingY = 10,
    this.underlinedFields = false,
    // Select and menus.
    this.selectPaddingX = 10,
    this.selectPaddingY = 8,
    this.menuPadding = 4,
    this.itemPaddingX = 8,
    this.itemPaddingY = 6,
    // Selection controls.
    this.checkboxSize = 16,
    this.radioSize = 16,
    this.switchWidth = 32,
    this.switchHeight = 18.4,
    this.switchThumbSize = 16,
    this.sliderTrackHeight = 6,
    this.sliderThumbSize = 16,
    // Surfaces.
    this.cardPadding = 24,
    this.cardGap = 4,
    this.dialogPadding = 24,
    this.dialogGap = 8,
    this.popoverPadding = 16,
    // Everything else.
    this.tabsListPadding = 3,
    this.tabPaddingX = 8,
    this.tabPaddingY = 4,
    this.accordionTitlePaddingY = 16,
    this.alertPaddingX = 16,
    this.alertPaddingY = 12,
    this.tableCellPadding = 8,
    this.kbdHeight = 20,
    this.kbdPaddingX = 4,
    this.progressHeight = 6,
  });

  /// The shadcn/ui name of this style, e.g. `nova`.
  final String name;

  // --- Radii --------------------------------------------------------------

  /// Corner radius of buttons, inputs, toggles and other controls.
  final ShadRadiusToken buttonRadius;

  /// Corner radius of cards.
  final ShadRadiusToken cardRadius;

  /// Corner radius of dialogs and sheets.
  final ShadRadiusToken dialogRadius;

  /// Corner radius of popovers, select and menu surfaces.
  final ShadRadiusToken popoverRadius;

  /// Corner radius of a textarea.
  ///
  /// Separate from [buttonRadius] because shadcn keeps it moderate even in the
  /// pill-shaped styles: `maia` has `rounded-4xl` buttons but a `rounded-xl`
  /// textarea, since a 32px radius on a tall box eats into the text.
  final ShadRadiusToken textareaRadius;

  /// Corner radius of rows inside a surface, e.g. menu and select items.
  final ShadRadiusToken itemRadius;

  /// Corner radius of a checkbox, in logical pixels.
  ///
  /// shadcn hardcodes this one (`rounded-[4px]`) rather than deriving it: a
  /// checkbox is too small for the scale to look right on it.
  final double checkboxRadius;

  // --- Focus ring ---------------------------------------------------------

  /// Opacity of a card's hairline outline, shadcn's `ring-foreground/10`.
  ///
  /// A card is outlined with a wash of its own foreground rather than the
  /// `--border` token, so the line stays proportionate on any surface.
  final double cardBorderOpacity;

  /// Opacity of a popover, menu, dialog or sheet outline.
  final double surfaceBorderOpacity;

  /// Focus-ring thickness, shadcn's `focus-visible:ring-N`.
  final double ringWidth;

  /// Focus-ring alpha, the `/50` in `ring-ring/50`.
  final double ringOpacity;

  // --- Typography ---------------------------------------------------------

  /// Card and dialog titles.
  final ShadTextRole title;

  /// Interactive labels: buttons, toggles, tabs and form labels.
  final ShadTextRole label;

  /// Body copy: descriptions, menu rows, popover content, table cells.
  final ShadTextRole body;

  /// Small supporting text: badges, keyboard keys, command shortcuts.
  final ShadTextRole caption;

  /// Section headings inside a surface: menu group labels, table headers.
  final ShadTextRole overline;

  /// Text inside a field: input, textarea, select trigger.
  final ShadTextRole field;

  // --- Shadows ------------------------------------------------------------

  final List<BoxShadow> cardShadow;
  final List<BoxShadow> popoverShadow;
  final List<BoxShadow> dialogShadow;
  final List<BoxShadow> sheetShadow;

  // --- Buttons ------------------------------------------------------------

  /// Height of a default-size button, shadcn's `h-9`.
  final double buttonHeight;
  final double buttonHeightSm;
  final double buttonHeightLg;

  /// Horizontal padding of a default-size button, shadcn's `px-2.5`.
  final double buttonPaddingX;
  final double buttonPaddingXSm;
  final double buttonPaddingXLg;

  /// Space between a button's icon and its label, shadcn's `gap-1.5`.
  final double buttonGap;

  /// Side of a square icon button, shadcn's `size-9`.
  final double iconButtonSize;
  final double iconButtonSizeSm;
  final double iconButtonSizeLg;

  // --- Text fields --------------------------------------------------------

  /// Minimum height of a single-line input.
  final double inputHeight;
  final double inputPaddingX;
  final double inputPaddingY;

  final double textareaPaddingX;

  /// Vertical padding of a textarea.
  ///
  /// Two pixels above shadcn's `py-2`. A browser textarea's first line is
  /// pushed down by half of its line box's leading; Flutter's `EditableText`
  /// starts the glyphs at the top of the box instead, so the same number reads
  /// tighter here.
  final double textareaPaddingY;

  /// Whether fields are drawn as a single underline rather than a box.
  ///
  /// `sera` does this — `border-transparent border-b-input` — and it is the
  /// most visible thing about the style after its uppercase labels.
  final bool underlinedFields;

  // --- Select and menus ---------------------------------------------------

  /// Padding of a select trigger.
  final double selectPaddingX;
  final double selectPaddingY;

  /// Padding around the rows of a menu surface, shadcn's `p-1`.
  final double menuPadding;

  /// Padding of a single menu or select row.
  final double itemPaddingX;
  final double itemPaddingY;

  // --- Selection controls -------------------------------------------------

  final double checkboxSize;
  final double radioSize;

  /// Track dimensions of a switch.
  final double switchWidth;
  final double switchHeight;

  /// Diameter of a switch thumb; the inset is what is left over.
  final double switchThumbSize;

  final double sliderTrackHeight;
  final double sliderThumbSize;

  // --- Surfaces -----------------------------------------------------------

  /// Card padding, shadcn's `--card-spacing`.
  final double cardPadding;

  /// Space between a card's title, description, content and footer.
  final double cardGap;

  final double dialogPadding;

  /// Space between a dialog's stacked children — title, description, body and
  /// actions.
  ///
  /// shadcn splits this in two: `gap-6` between a dialog's sections and
  /// `gap-2` inside its header. `ShadDialog` stacks all four children
  /// uniformly, so this carries the header value, which is the one that shows.
  final double dialogGap;

  final double popoverPadding;

  // --- Everything else ----------------------------------------------------

  /// Padding of the strip a tab bar's tabs sit in, shadcn's `p-[3px]`.
  final double tabsListPadding;
  final double tabPaddingX;
  final double tabPaddingY;

  /// Vertical padding of an accordion's title row.
  final double accordionTitlePaddingY;

  final double alertPaddingX;
  final double alertPaddingY;

  /// Padding inside a table cell, shadcn's `p-2`.
  final double tableCellPadding;

  final double kbdHeight;
  final double kbdPaddingX;

  /// Thickness of a progress bar, shadcn's `h-1.5`.
  final double progressHeight;

  // --- shadcn/ui's eight styles ------------------------------------------

  /// The shadcn/ui default: 36px controls, 24px card padding, a 3px ring.
  static const vega = ShadStyleTokens(name: 'vega');

  /// vega, one size down and a step rounder.
  static const nova = ShadStyleTokens(
    name: 'nova',
    // `leading-snug` on the card title.
    title: ShadTextRole(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.375,
    ),
    cardShadow: Shadows.none,
    buttonRadius: ShadRadiusToken.lg,
    popoverRadius: ShadRadiusToken.lg,
    textareaRadius: ShadRadiusToken.lg,
    itemRadius: ShadRadiusToken.md,
    buttonHeight: 32,
    buttonHeightSm: 28,
    buttonHeightLg: 36,
    iconButtonSize: 32,
    iconButtonSizeSm: 28,
    iconButtonSizeLg: 36,
    inputHeight: 32,
    itemPaddingX: 6,
    itemPaddingY: 4,
    sliderTrackHeight: 4,
    sliderThumbSize: 12,
    cardPadding: 16,
    dialogPadding: 16,
    popoverPadding: 10,
    tabPaddingX: 6,
    tabPaddingY: 2,
    accordionTitlePaddingY: 10,
    alertPaddingX: 10,
    alertPaddingY: 8,
    progressHeight: 4,
  );

  /// Pill-shaped and roomy.
  static const maia = ShadStyleTokens(
    name: 'maia',
    cardShadow: Shadows.none,
    popoverShadow: Shadows.xl2,
    buttonRadius: ShadRadiusToken.xl4,
    cardRadius: ShadRadiusToken.xl2,
    dialogRadius: ShadRadiusToken.xl4,
    popoverRadius: ShadRadiusToken.xl2,
    textareaRadius: ShadRadiusToken.xl,
    itemRadius: ShadRadiusToken.xl,
    checkboxRadius: 6,
    surfaceBorderOpacity: .05,
    buttonPaddingX: 12,
    buttonPaddingXSm: 12,
    buttonPaddingXLg: 16,
    inputPaddingX: 12,
    textareaPaddingX: 12,
    textareaPaddingY: 12,
    selectPaddingX: 12,
    itemPaddingX: 12,
    itemPaddingY: 8,
    cardGap: 8,
    sliderTrackHeight: 12,
    tableCellPadding: 12,
    progressHeight: 12,
  );

  /// Square and compact.
  static const lyra = ShadStyleTokens(
    name: 'lyra',
    buttonRadius: ShadRadiusToken.none,
    cardRadius: ShadRadiusToken.none,
    dialogRadius: ShadRadiusToken.none,
    popoverRadius: ShadRadiusToken.none,
    textareaRadius: ShadRadiusToken.none,
    itemRadius: ShadRadiusToken.none,
    checkboxRadius: 0,
    ringWidth: 1,
    title: ShadTextRole(fontSize: 14, fontWeight: FontWeight.w500),
    label: ShadTextRole(fontSize: 12, fontWeight: FontWeight.w500),
    body: ShadTextRole(fontSize: 12),
    field: ShadTextRole(fontSize: 12),
    cardShadow: Shadows.none,
    buttonHeight: 32,
    buttonHeightSm: 28,
    buttonHeightLg: 36,
    iconButtonSize: 32,
    iconButtonSizeSm: 28,
    iconButtonSizeLg: 36,
    inputHeight: 32,
    menuPadding: 0,
    itemPaddingY: 8,
    sliderTrackHeight: 4,
    sliderThumbSize: 12,
    cardPadding: 16,
    dialogPadding: 16,
    dialogGap: 4,
    popoverPadding: 10,
    tabPaddingX: 6,
    tabPaddingY: 2,
    accordionTitlePaddingY: 10,
    alertPaddingX: 10,
    alertPaddingY: 8,
    progressHeight: 4,
  );

  /// The densest of the eight: 28px controls.
  static const mira = ShadStyleTokens(
    name: 'mira',
    cardRadius: ShadRadiusToken.lg,
    popoverRadius: ShadRadiusToken.lg,
    itemRadius: ShadRadiusToken.md,
    ringWidth: 2,
    ringOpacity: .3,
    // `text-xs/relaxed` throughout: 12px on a 1.625 line.
    title: ShadTextRole(fontSize: 14, fontWeight: FontWeight.w500),
    label: ShadTextRole(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.625,
    ),
    body: ShadTextRole(fontSize: 12, height: 1.625),
    caption: ShadTextRole(fontSize: 10, fontWeight: FontWeight.w500),
    field: ShadTextRole(fontSize: 12, height: 1.625),
    cardShadow: Shadows.none,
    buttonHeight: 28,
    buttonHeightSm: 24,
    buttonHeightLg: 32,
    buttonPaddingX: 8,
    buttonPaddingXSm: 8,
    buttonGap: 4,
    iconButtonSize: 28,
    iconButtonSizeSm: 24,
    iconButtonSizeLg: 32,
    inputHeight: 28,
    inputPaddingX: 8,
    inputPaddingY: 2,
    textareaPaddingX: 8,
    textareaPaddingY: 8,
    selectPaddingX: 8,
    selectPaddingY: 6,
    itemPaddingY: 4,
    switchWidth: 28,
    switchHeight: 16.6,
    switchThumbSize: 14,
    sliderTrackHeight: 4,
    sliderThumbSize: 12,
    cardPadding: 16,
    dialogPadding: 16,
    dialogGap: 4,
    popoverPadding: 10,
    tabPaddingX: 6,
    tabPaddingY: 2,
    accordionTitlePaddingY: 8,
    alertPaddingX: 8,
    alertPaddingY: 6,
    progressHeight: 4,
  );

  /// Soft and pill-shaped, with a wide switch and a thick slider.
  static const luma = ShadStyleTokens(
    name: 'luma',
    buttonRadius: ShadRadiusToken.xl4,
    cardRadius: ShadRadiusToken.xl4,
    dialogRadius: ShadRadiusToken.xl4,
    popoverRadius: ShadRadiusToken.xl4,
    textareaRadius: ShadRadiusToken.xl2,
    itemRadius: ShadRadiusToken.xl2,
    checkboxRadius: 5,
    cardBorderOpacity: .05,
    surfaceBorderOpacity: .05,
    ringOpacity: .3,
    cardGap: 6,
    cardShadow: Shadows.md,
    popoverShadow: Shadows.lg,
    dialogShadow: Shadows.xl,
    sheetShadow: Shadows.xl,
    buttonPaddingX: 12,
    buttonPaddingXSm: 12,
    buttonPaddingXLg: 16,
    inputPaddingX: 12,
    textareaPaddingX: 12,
    textareaPaddingY: 12,
    selectPaddingX: 12,
    menuPadding: 6,
    itemPaddingX: 12,
    itemPaddingY: 8,
    dialogGap: 6,
    switchWidth: 44,
    switchHeight: 20,
    sliderTrackHeight: 8,
    tabsListPadding: 4,
    tabPaddingX: 12,
    tableCellPadding: 12,
    kbdHeight: 22,
    kbdPaddingX: 6,
    progressHeight: 12,
  );

  /// Editorial: square, uppercase, letter-spaced, and the largest of the eight.
  static const sera = ShadStyleTokens(
    name: 'sera',
    buttonRadius: ShadRadiusToken.none,
    cardRadius: ShadRadiusToken.none,
    dialogRadius: ShadRadiusToken.none,
    popoverRadius: ShadRadiusToken.none,
    textareaRadius: ShadRadiusToken.none,
    itemRadius: ShadRadiusToken.none,
    checkboxRadius: 0,
    cardBorderOpacity: .05,
    ringWidth: 2,
    ringOpacity: .3,
    // Uppercase and tracked out, at Tailwind's `tracking-wider` (0.05em) and
    // `tracking-widest` (0.1em) converted to pixels at each size.
    title: ShadTextRole(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.9,
      uppercase: true,
    ),
    label: ShadTextRole(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      uppercase: true,
    ),
    body: ShadTextRole(fontSize: 14, height: 1.625),
    caption: ShadTextRole(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 1,
      uppercase: true,
    ),
    overline: ShadTextRole(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.6,
      uppercase: true,
    ),
    cardShadow: Shadows.sm,
    dialogShadow: Shadows.md,
    sheetShadow: Shadows.md,
    buttonHeight: 40,
    buttonHeightSm: 36,
    buttonHeightLg: 44,
    buttonPaddingX: 24,
    buttonPaddingXSm: 16,
    buttonPaddingXLg: 32,
    iconButtonSize: 40,
    iconButtonSizeSm: 36,
    iconButtonSizeLg: 44,
    inputHeight: 40,
    // sera's fields are underlined rather than boxed, so they carry no
    // horizontal inset at all.
    inputPaddingX: 0,
    textareaPaddingX: 0,
    textareaPaddingY: 12,
    underlinedFields: true,
    selectPaddingX: 0,
    menuPadding: 6,
    itemPaddingX: 12,
    itemPaddingY: 8,
    checkboxSize: 18,
    radioSize: 18,
    switchWidth: 33,
    switchHeight: 18,
    switchThumbSize: 14,
    sliderTrackHeight: 2,
    sliderThumbSize: 12,
    cardPadding: 32,
    cardGap: 6,
    tabsListPadding: 4,
    tabPaddingX: 16,
    tabPaddingY: 6,
    tableCellPadding: 12,
    kbdHeight: 22,
    kbdPaddingX: 6,
    progressHeight: 2,
  );

  /// Rounded and compact.
  static const rhea = ShadStyleTokens(
    name: 'rhea',
    buttonRadius: ShadRadiusToken.xl2,
    cardRadius: ShadRadiusToken.xl2,
    dialogRadius: ShadRadiusToken.xl2,
    popoverRadius: ShadRadiusToken.xl2,
    textareaRadius: ShadRadiusToken.xl2,
    itemRadius: ShadRadiusToken.xl,
    checkboxRadius: 5,
    cardBorderOpacity: .05,
    surfaceBorderOpacity: .05,
    ringOpacity: .3,
    cardShadow: Shadows.sm,
    popoverShadow: Shadows.lg,
    dialogShadow: Shadows.xl,
    sheetShadow: Shadows.xl,
    buttonHeight: 32,
    buttonHeightSm: 28,
    buttonHeightLg: 36,
    buttonPaddingX: 12,
    buttonPaddingXSm: 12,
    buttonPaddingXLg: 16,
    iconButtonSize: 32,
    iconButtonSizeSm: 28,
    iconButtonSizeLg: 36,
    inputHeight: 32,
    selectPaddingX: 12,
    dialogGap: 6,
    switchHeight: 20,
    sliderTrackHeight: 4,
    cardPadding: 20,
    cardGap: 6,
    tabPaddingX: 6,
    tabPaddingY: 2,
    progressHeight: 8,
  );

  /// All eight, in shadcn/ui's order.
  static const all = <ShadStyleTokens>[
    vega,
    nova,
    maia,
    lyra,
    mira,
    luma,
    sera,
    rhea,
  ];

  static ShadStyleTokens fromName(String name) => all.firstWhere(
    (s) => s.name == name,
    orElse: () => throw ArgumentError.value(name, 'name', 'Unknown style'),
  );

  ShadStyleTokens copyWith({
    String? name,
    ShadRadiusToken? buttonRadius,
    ShadRadiusToken? cardRadius,
    ShadRadiusToken? dialogRadius,
    ShadRadiusToken? popoverRadius,
    ShadRadiusToken? textareaRadius,
    ShadRadiusToken? itemRadius,
    double? checkboxRadius,
    double? cardBorderOpacity,
    double? surfaceBorderOpacity,
    double? ringWidth,
    double? ringOpacity,
    ShadTextRole? title,
    ShadTextRole? label,
    ShadTextRole? body,
    ShadTextRole? caption,
    ShadTextRole? overline,
    ShadTextRole? field,
    List<BoxShadow>? cardShadow,
    List<BoxShadow>? popoverShadow,
    List<BoxShadow>? dialogShadow,
    List<BoxShadow>? sheetShadow,
    double? buttonHeight,
    double? buttonHeightSm,
    double? buttonHeightLg,
    double? buttonPaddingX,
    double? buttonPaddingXSm,
    double? buttonPaddingXLg,
    double? buttonGap,
    double? iconButtonSize,
    double? iconButtonSizeSm,
    double? iconButtonSizeLg,
    double? inputHeight,
    double? inputPaddingX,
    double? inputPaddingY,
    double? textareaPaddingX,
    double? textareaPaddingY,
    bool? underlinedFields,
    double? selectPaddingX,
    double? selectPaddingY,
    double? menuPadding,
    double? itemPaddingX,
    double? itemPaddingY,
    double? checkboxSize,
    double? radioSize,
    double? switchWidth,
    double? switchHeight,
    double? switchThumbSize,
    double? sliderTrackHeight,
    double? sliderThumbSize,
    double? cardPadding,
    double? cardGap,
    double? dialogPadding,
    double? dialogGap,
    double? popoverPadding,
    double? tabsListPadding,
    double? tabPaddingX,
    double? tabPaddingY,
    double? accordionTitlePaddingY,
    double? alertPaddingX,
    double? alertPaddingY,
    double? tableCellPadding,
    double? kbdHeight,
    double? kbdPaddingX,
    double? progressHeight,
  }) {
    return ShadStyleTokens(
      name: name ?? this.name,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      cardRadius: cardRadius ?? this.cardRadius,
      dialogRadius: dialogRadius ?? this.dialogRadius,
      popoverRadius: popoverRadius ?? this.popoverRadius,
      textareaRadius: textareaRadius ?? this.textareaRadius,
      itemRadius: itemRadius ?? this.itemRadius,
      checkboxRadius: checkboxRadius ?? this.checkboxRadius,
      cardBorderOpacity: cardBorderOpacity ?? this.cardBorderOpacity,
      surfaceBorderOpacity: surfaceBorderOpacity ?? this.surfaceBorderOpacity,
      ringWidth: ringWidth ?? this.ringWidth,
      ringOpacity: ringOpacity ?? this.ringOpacity,
      title: title ?? this.title,
      label: label ?? this.label,
      body: body ?? this.body,
      caption: caption ?? this.caption,
      overline: overline ?? this.overline,
      field: field ?? this.field,
      cardShadow: cardShadow ?? this.cardShadow,
      popoverShadow: popoverShadow ?? this.popoverShadow,
      dialogShadow: dialogShadow ?? this.dialogShadow,
      sheetShadow: sheetShadow ?? this.sheetShadow,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      buttonHeightSm: buttonHeightSm ?? this.buttonHeightSm,
      buttonHeightLg: buttonHeightLg ?? this.buttonHeightLg,
      buttonPaddingX: buttonPaddingX ?? this.buttonPaddingX,
      buttonPaddingXSm: buttonPaddingXSm ?? this.buttonPaddingXSm,
      buttonPaddingXLg: buttonPaddingXLg ?? this.buttonPaddingXLg,
      buttonGap: buttonGap ?? this.buttonGap,
      iconButtonSize: iconButtonSize ?? this.iconButtonSize,
      iconButtonSizeSm: iconButtonSizeSm ?? this.iconButtonSizeSm,
      iconButtonSizeLg: iconButtonSizeLg ?? this.iconButtonSizeLg,
      inputHeight: inputHeight ?? this.inputHeight,
      inputPaddingX: inputPaddingX ?? this.inputPaddingX,
      inputPaddingY: inputPaddingY ?? this.inputPaddingY,
      textareaPaddingX: textareaPaddingX ?? this.textareaPaddingX,
      textareaPaddingY: textareaPaddingY ?? this.textareaPaddingY,
      underlinedFields: underlinedFields ?? this.underlinedFields,
      selectPaddingX: selectPaddingX ?? this.selectPaddingX,
      selectPaddingY: selectPaddingY ?? this.selectPaddingY,
      menuPadding: menuPadding ?? this.menuPadding,
      itemPaddingX: itemPaddingX ?? this.itemPaddingX,
      itemPaddingY: itemPaddingY ?? this.itemPaddingY,
      checkboxSize: checkboxSize ?? this.checkboxSize,
      radioSize: radioSize ?? this.radioSize,
      switchWidth: switchWidth ?? this.switchWidth,
      switchHeight: switchHeight ?? this.switchHeight,
      switchThumbSize: switchThumbSize ?? this.switchThumbSize,
      sliderTrackHeight: sliderTrackHeight ?? this.sliderTrackHeight,
      sliderThumbSize: sliderThumbSize ?? this.sliderThumbSize,
      cardPadding: cardPadding ?? this.cardPadding,
      cardGap: cardGap ?? this.cardGap,
      dialogPadding: dialogPadding ?? this.dialogPadding,
      dialogGap: dialogGap ?? this.dialogGap,
      popoverPadding: popoverPadding ?? this.popoverPadding,
      tabsListPadding: tabsListPadding ?? this.tabsListPadding,
      tabPaddingX: tabPaddingX ?? this.tabPaddingX,
      tabPaddingY: tabPaddingY ?? this.tabPaddingY,
      accordionTitlePaddingY:
          accordionTitlePaddingY ?? this.accordionTitlePaddingY,
      alertPaddingX: alertPaddingX ?? this.alertPaddingX,
      alertPaddingY: alertPaddingY ?? this.alertPaddingY,
      tableCellPadding: tableCellPadding ?? this.tableCellPadding,
      kbdHeight: kbdHeight ?? this.kbdHeight,
      kbdPaddingX: kbdPaddingX ?? this.kbdPaddingX,
      progressHeight: progressHeight ?? this.progressHeight,
    );
  }

  /// Every field, in declaration order — the basis of [==] and [hashCode].
  List<Object?> get _props => [
    name,
    buttonRadius,
    cardRadius,
    dialogRadius,
    popoverRadius,
    textareaRadius,
    itemRadius,
    checkboxRadius,
    cardBorderOpacity,
    surfaceBorderOpacity,
    ringWidth,
    ringOpacity,
    title,
    label,
    body,
    caption,
    overline,
    field,
    cardShadow,
    popoverShadow,
    dialogShadow,
    sheetShadow,
    buttonHeight,
    buttonHeightSm,
    buttonHeightLg,
    buttonPaddingX,
    buttonPaddingXSm,
    buttonPaddingXLg,
    buttonGap,
    iconButtonSize,
    iconButtonSizeSm,
    iconButtonSizeLg,
    inputHeight,
    inputPaddingX,
    inputPaddingY,
    textareaPaddingX,
    textareaPaddingY,
    underlinedFields,
    selectPaddingX,
    selectPaddingY,
    menuPadding,
    itemPaddingX,
    itemPaddingY,
    checkboxSize,
    radioSize,
    switchWidth,
    switchHeight,
    switchThumbSize,
    sliderTrackHeight,
    sliderThumbSize,
    cardPadding,
    cardGap,
    dialogPadding,
    dialogGap,
    popoverPadding,
    tabsListPadding,
    tabPaddingX,
    tabPaddingY,
    accordionTitlePaddingY,
    alertPaddingX,
    alertPaddingY,
    tableCellPadding,
    kbdHeight,
    kbdPaddingX,
    progressHeight,
  ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ShadStyleTokens) return false;
    final a = _props;
    final b = other._props;
    for (var i = 0; i < a.length; i++) {
      final x = a[i];
      final y = b[i];
      // Shadow lists are compared by value: two structurally identical lists
      // built at different call sites must not make two themes unequal, or
      // every rebuild re-animates the theme.
      if (x is List && y is List) {
        if (!listEquals<Object?>(x, y)) return false;
      } else if (x != y) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(
    _props.map((p) => p is List ? Object.hashAll(p) : p),
  );

  @override
  String toString() => 'ShadStyleTokens($name)';
}
