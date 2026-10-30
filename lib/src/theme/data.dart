import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/color_scheme/base.dart';
import 'package:shad/src/theme/color_scheme/slate.dart';
import 'package:shad/src/theme/components/accordion.dart';
import 'package:shad/src/theme/components/alert.dart';
import 'package:shad/src/theme/components/avatar.dart';
import 'package:shad/src/theme/components/badge.dart';
import 'package:shad/src/theme/components/breadcrumb.dart';
import 'package:shad/src/theme/components/button.dart';
import 'package:shad/src/theme/components/button_sizes.dart';
import 'package:shad/src/theme/components/calendar.dart';
import 'package:shad/src/theme/components/card.dart';
import 'package:shad/src/theme/components/checkbox.dart';
import 'package:shad/src/theme/components/collapsible.dart';
import 'package:shad/src/theme/components/command.dart';
import 'package:shad/src/theme/components/context_menu.dart';
import 'package:shad/src/theme/components/date_picker.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:shad/src/theme/components/default_keyboard_toolbar.dart';
import 'package:shad/src/theme/components/dialog.dart';
import 'package:shad/src/theme/components/empty.dart';
import 'package:shad/src/theme/components/input.dart';
import 'package:shad/src/theme/components/input_otp.dart';
import 'package:shad/src/theme/components/kbd.dart';
import 'package:shad/src/theme/components/menubar.dart';
import 'package:shad/src/theme/components/option.dart';
import 'package:shad/src/theme/components/pagination.dart';
import 'package:shad/src/theme/components/popover.dart';
import 'package:shad/src/theme/components/progress.dart';
import 'package:shad/src/theme/components/radio.dart';
import 'package:shad/src/theme/components/resizable.dart';
import 'package:shad/src/theme/components/scroll_area.dart';
import 'package:shad/src/theme/components/select.dart';
import 'package:shad/src/theme/components/separator.dart';
import 'package:shad/src/theme/components/sheet.dart';
import 'package:shad/src/theme/components/sidebar.dart';
import 'package:shad/src/theme/components/skeleton.dart';
import 'package:shad/src/theme/components/slider.dart';
import 'package:shad/src/theme/components/sonner.dart';
import 'package:shad/src/theme/components/spinner.dart';
import 'package:shad/src/theme/components/switch.dart';
import 'package:shad/src/theme/components/table.dart';
import 'package:shad/src/theme/components/tabs.dart';
import 'package:shad/src/theme/components/textarea.dart';
import 'package:shad/src/theme/components/time_picker.dart';
import 'package:shad/src/theme/components/toast.dart';
import 'package:shad/src/theme/components/toggle.dart';
import 'package:shad/src/theme/components/tooltip.dart';
import 'package:shad/src/theme/radii.dart';
import 'package:shad/src/theme/spacing.dart';
import 'package:shad/src/theme/style.dart';
import 'package:shad/src/theme/text_theme/theme.dart';
import 'package:shad/src/theme/themes/base.dart';
import 'package:shad/src/theme/themes/default_theme_no_secondary_border_variant.dart';
import 'package:shad/src/theme/themes/default_theme_variant.dart';
import 'package:shad/src/utils/gesture_detector.dart';
import 'package:shad/src/utils/responsive.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'data.g.theme.dart';

/// How strongly menus highlight their hovered row, shadcn's "Menu Accent".
///
/// The reference implements "bold" by pointing `--accent` at `--primary` in
/// the theme itself, so it is a *scheme* transformation, not a per-menu one:
/// everything that highlights with the accent follows.
enum ShadMenuAccent {
  /// The accent pair as the palette defines it.
  subtle,

  /// The primary pair takes over the accent slots.
  bold,
}

/// The complete visual configuration of a Shad app: colour scheme, text theme,
/// radius, style, spacing and every component theme.
///
/// The factory resolves its inputs into a [ShadThemeVariant], which derives the
/// component themes. An explicit component theme passed here is merged over the
/// variant's. Provide it to the tree with `ShadApp` or `ShadTheme` and read it
/// back with `ShadTheme.of(context)`.
@immutable
@ThemeGen()
class ShadThemeData extends ShadBaseTheme with _$ShadThemeData {
  /// Creates a theme.
  ///
  /// Every argument is optional. Null values take the variant's defaults, and
  /// the variant itself defaults to [ShadDefaultThemeVariant], or
  /// [ShadDefaultThemeNoSecondaryBorderVariant] when [disableSecondaryBorder]
  /// is true.
  factory ShadThemeData({
    /// The color scheme to use for the theme.
    /// Defaults to [ShadSlateColorScheme] based on the [brightness].
    ShadColorScheme? colorScheme,

    /// The overall brightness of the theme, defaults to [Brightness.light].
    Brightness? brightness,
    ShadButtonTheme? primaryButtonTheme,
    ShadButtonTheme? secondaryButtonTheme,
    ShadButtonTheme? destructiveButtonTheme,
    ShadButtonTheme? outlineButtonTheme,
    ShadButtonTheme? ghostButtonTheme,
    ShadButtonTheme? linkButtonTheme,
    ShadBadgeTheme? primaryBadgeTheme,
    ShadBadgeTheme? secondaryBadgeTheme,
    ShadBadgeTheme? destructiveBadgeTheme,
    ShadBadgeTheme? outlineBadgeTheme,
    ShadBreadcrumbTheme? breadcrumbTheme,
    BorderRadius? radius,
    ShadAvatarTheme? avatarTheme,
    ShadButtonSizesTheme? buttonSizesTheme,
    ShadTooltipTheme? tooltipTheme,
    ShadPopoverTheme? popoverTheme,
    ShadDecoration? decoration,
    ShadTextTheme? textTheme,
    double? disabledOpacity,
    ShadSelectTheme? selectTheme,
    ShadOptionTheme? optionTheme,
    ShadCardTheme? cardTheme,
    ShadSwitchTheme? switchTheme,
    ShadCheckboxTheme? checkboxTheme,
    ShadInputTheme? inputTheme,
    ShadRadioTheme? radioTheme,
    ShadToastTheme? primaryToastTheme,
    ShadToastTheme? destructiveToastTheme,
    ShadBreakpoints? breakpoints,
    ShadAlertTheme? primaryAlertTheme,
    ShadAlertTheme? destructiveAlertTheme,
    ShadDialogTheme? primaryDialogTheme,
    ShadDialogTheme? alertDialogTheme,
    ShadSliderTheme? sliderTheme,
    ShadSheetTheme? sheetTheme,
    ShadProgressTheme? progressTheme,
    ShadAccordionTheme? accordionTheme,
    ShadTableTheme? tableTheme,
    ShadResizableTheme? resizableTheme,
    ShadHoverStrategies? hoverStrategies,
    bool? disableSecondaryBorder,
    ShadTabsTheme? tabsTheme,
    ShadSkeletonTheme? skeletonTheme,
    ShadKbdTheme? kbdTheme,
    ShadScrollAreaTheme? scrollAreaTheme,
    ShadSpinnerTheme? spinnerTheme,
    ShadToggleTheme? toggleTheme,
    ShadToggleTheme? outlineToggleTheme,
    ShadEmptyTheme? emptyTheme,
    ShadPaginationTheme? paginationTheme,
    ShadCollapsibleTheme? collapsibleTheme,
    ShadCommandTheme? commandTheme,
    ShadSidebarTheme? sidebarTheme,
    ShadThemeVariant? variant,
    ShadContextMenuTheme? contextMenuTheme,
    ShadCalendarTheme? calendarTheme,
    ShadDatePickerTheme? datePickerTheme,
    ShadTimePickerTheme? timePickerTheme,
    ShadInputOTPTheme? inputOTPTheme,
    ShadMenubarTheme? menubarTheme,
    ShadSeparatorTheme? separatorTheme,
    ShadSonnerTheme? sonnerTheme,
    ShadTextareaTheme? textareaTheme,
    ShadDefaultKeyboardToolbarTheme? defaultKeyboardToolbarTheme,

    /// The shadcn/ui style: the radius, focus-ring and label treatment shared
    /// by every component. Defaults to [ShadStyleTokens.nova], which is
    /// shadcn's own default (`DEFAULT_CONFIG.style`).
    ///
    /// When a [variant] is also given, the variant is rebuilt with this style.
    ShadStyleTokens? style,

    /// The spacing scale every padding and gap is a multiple of.
    ///
    /// When a [variant] is also given, the variant is rebuilt with this scale.
    ShadSpacing? spacing,

    /// The palette menu surfaces draw from, when it differs from the page's.
    ///
    /// This is shadcn's "Inverted" menu colour: the reference gives every
    /// menu surface the `dark` class — the whole opposite-brightness token
    /// set — so pass the dark counterpart of [colorScheme] here and select,
    /// context-menu and menubar surfaces derive their colours from it.
    ShadColorScheme? menuColorScheme,

    /// Whether menu surfaces are translucent, shadcn's "Translucent" finish:
    /// the popover colour at 70% over a backdrop blur, with row highlights
    /// as a `foreground/10` wash.
    bool? menuTranslucent,

    /// How strongly menus highlight their rows; see [ShadMenuAccent].
    ///
    /// Bold rewrites the scheme's accent pair with its primary pair before
    /// anything is derived from it, exactly as the reference does.
    ShadMenuAccent? menuAccent,
  }) {
    // A variant is built from a colour scheme, a radius and a text theme, and
    // bakes all three into its component themes. Where the caller gives one
    // explicitly it wins and the variant is rebuilt below; where they don't,
    // the variant's own value becomes the theme's, so the two never disagree.
    //
    // shadcn/ui's `--radius` is 0.625rem and `--radius-md` — what button,
    // input, checkbox and most other components use via `rounded-md` — is
    // `calc(var(--radius) * 0.8)`, i.e. 8px.
    final effectiveRadius =
        radius ?? variant?.radius ?? const BorderRadius.all(Radius.circular(8));

    final effectiveTextTheme = textTheme == null
        ? (variant?.effectiveTextTheme ??
              ShadDefaultThemeVariant.defaultTextTheme)
        : ShadDefaultThemeVariant.defaultTextTheme.merge(textTheme);

    final effectiveDisableSecondaryBorder = disableSecondaryBorder ?? false;
    // With no explicit brightness, follow the scheme: a dark scheme on a theme
    // that calls itself light gets light-mode menus, shadows and Material
    // colours. Schemes do not record their brightness, so read it off the
    // background.
    final schemeForBrightness = colorScheme ?? variant?.colorScheme;
    final effectiveBrightness =
        brightness ??
        (schemeForBrightness == null
            ? Brightness.light
            : _brightnessOf(schemeForBrightness.background));
    var effectiveColorScheme =
        colorScheme ??
        variant?.colorScheme ??
        switch (effectiveBrightness) {
          Brightness.light => const ShadSlateColorScheme.light(),
          Brightness.dark => const ShadSlateColorScheme.dark(),
        };

    // A bold menu accent is a scheme transformation in the reference —
    // `accent = primary` in the generated theme vars — so it is applied to
    // the scheme(s) before any component theme is derived.
    var effectiveMenuColorScheme = menuColorScheme;
    if (menuAccent == ShadMenuAccent.bold) {
      effectiveColorScheme = effectiveColorScheme.copyWith(
        accent: effectiveColorScheme.primary,
        accentForeground: effectiveColorScheme.primaryForeground,
      );
      effectiveMenuColorScheme = effectiveMenuColorScheme?.copyWith(
        accent: effectiveMenuColorScheme.primary,
        accentForeground: effectiveMenuColorScheme.primaryForeground,
      );
    }

    // A supplied variant already baked the colour scheme, radius and text
    // theme into its component themes, so any of those that arrived separately
    // — which is what `copyWith(radius: …)` does — has to be pushed back into
    // it. Without this, `copyWith` would move the theme's own `radius` field
    // and leave every component rendering the old one.
    // Whether the menu options above require the variant to change; a custom
    // variant type cannot receive them (its `rebuild` does not know them), so
    // they only apply to the shipped variants.
    final menuOptionsChanged =
        variant is ShadDefaultThemeVariant &&
        ((menuColorScheme != null &&
                effectiveMenuColorScheme != variant.menuColorScheme) ||
            (menuTranslucent != null &&
                menuTranslucent != variant.menuTranslucent));

    final rebuiltVariant = variant == null
        ? null
        : (variant.colorScheme == effectiveColorScheme &&
                  variant.radius == effectiveRadius &&
                  // Either form counts as unchanged: the variant is built
                  // from a raw text theme but publishes one with the style's
                  // roles applied, and `copyWith` hands the published one
                  // back. Comparing only the raw form rebuilt the variant on
                  // every copy.
                  (variant.effectiveTextTheme == effectiveTextTheme ||
                      variant.textTheme() == effectiveTextTheme) &&
                  (style == null || style == variant.style) &&
                  (spacing == null || spacing == variant.spacing) &&
                  !menuOptionsChanged
              ? variant
              : variant is ShadDefaultThemeVariant
              ? variant.rebuild(
                  colorScheme: effectiveColorScheme,
                  radius: effectiveRadius,
                  effectiveTextTheme: effectiveTextTheme,
                  style: style,
                  spacing: spacing,
                  menuColorScheme: menuColorScheme != null
                      ? effectiveMenuColorScheme
                      : ShadDefaultThemeVariant.unsetMenuColorScheme,
                  menuTranslucent: menuTranslucent,
                )
              : variant.rebuild(
                  colorScheme: effectiveColorScheme,
                  radius: effectiveRadius,
                  effectiveTextTheme: effectiveTextTheme,
                  style: style,
                  spacing: spacing,
                ));

    final effectiveVariant =
        rebuiltVariant ??
        switch (effectiveDisableSecondaryBorder) {
          false => ShadDefaultThemeVariant(
            colorScheme: effectiveColorScheme,
            radius: effectiveRadius,
            effectiveTextTheme: effectiveTextTheme,
            style: style ?? ShadStyleTokens.nova,
            spacing: spacing ?? const ShadSpacing(),
            menuColorScheme: effectiveMenuColorScheme,
            menuTranslucent: menuTranslucent ?? false,
          ),
          true => ShadDefaultThemeNoSecondaryBorderVariant(
            colorScheme: effectiveColorScheme,
            radius: effectiveRadius,
            effectiveTextTheme: effectiveTextTheme,
            style: style ?? ShadStyleTokens.nova,
            spacing: spacing ?? const ShadSpacing(),
            menuColorScheme: effectiveMenuColorScheme,
            menuTranslucent: menuTranslucent ?? false,
          ),
        };

    return ShadThemeData._internal(
      inputs: _ShadThemeInputs(
        colorScheme: colorScheme,
        brightness: brightness,
        primaryButtonTheme: primaryButtonTheme,
        secondaryButtonTheme: secondaryButtonTheme,
        destructiveButtonTheme: destructiveButtonTheme,
        outlineButtonTheme: outlineButtonTheme,
        ghostButtonTheme: ghostButtonTheme,
        linkButtonTheme: linkButtonTheme,
        primaryBadgeTheme: primaryBadgeTheme,
        secondaryBadgeTheme: secondaryBadgeTheme,
        destructiveBadgeTheme: destructiveBadgeTheme,
        outlineBadgeTheme: outlineBadgeTheme,
        breadcrumbTheme: breadcrumbTheme,
        radius: radius,
        avatarTheme: avatarTheme,
        buttonSizesTheme: buttonSizesTheme,
        tooltipTheme: tooltipTheme,
        popoverTheme: popoverTheme,
        decoration: decoration,
        textTheme: textTheme,
        disabledOpacity: disabledOpacity,
        selectTheme: selectTheme,
        optionTheme: optionTheme,
        cardTheme: cardTheme,
        switchTheme: switchTheme,
        checkboxTheme: checkboxTheme,
        inputTheme: inputTheme,
        radioTheme: radioTheme,
        primaryToastTheme: primaryToastTheme,
        destructiveToastTheme: destructiveToastTheme,
        breakpoints: breakpoints,
        primaryAlertTheme: primaryAlertTheme,
        destructiveAlertTheme: destructiveAlertTheme,
        primaryDialogTheme: primaryDialogTheme,
        alertDialogTheme: alertDialogTheme,
        sliderTheme: sliderTheme,
        sheetTheme: sheetTheme,
        progressTheme: progressTheme,
        accordionTheme: accordionTheme,
        tableTheme: tableTheme,
        resizableTheme: resizableTheme,
        hoverStrategies: hoverStrategies,
        disableSecondaryBorder: disableSecondaryBorder,
        tabsTheme: tabsTheme,
        skeletonTheme: skeletonTheme,
        kbdTheme: kbdTheme,
        scrollAreaTheme: scrollAreaTheme,
        spinnerTheme: spinnerTheme,
        toggleTheme: toggleTheme,
        outlineToggleTheme: outlineToggleTheme,
        emptyTheme: emptyTheme,
        paginationTheme: paginationTheme,
        collapsibleTheme: collapsibleTheme,
        commandTheme: commandTheme,
        sidebarTheme: sidebarTheme,
        variant: variant,
        contextMenuTheme: contextMenuTheme,
        calendarTheme: calendarTheme,
        datePickerTheme: datePickerTheme,
        timePickerTheme: timePickerTheme,
        inputOTPTheme: inputOTPTheme,
        menubarTheme: menubarTheme,
        separatorTheme: separatorTheme,
        sonnerTheme: sonnerTheme,
        textareaTheme: textareaTheme,
        defaultKeyboardToolbarTheme: defaultKeyboardToolbarTheme,
        style: style,
        spacing: spacing,
        menuColorScheme: menuColorScheme,
        menuTranslucent: menuTranslucent,
        menuAccent: menuAccent,
      ),
      colorScheme: effectiveColorScheme,
      brightness: effectiveBrightness,
      primaryButtonTheme: effectiveVariant.primaryButtonTheme().merge(
        primaryButtonTheme,
      ),
      secondaryButtonTheme: effectiveVariant.secondaryButtonTheme().merge(
        secondaryButtonTheme,
      ),
      destructiveButtonTheme: effectiveVariant.destructiveButtonTheme().merge(
        destructiveButtonTheme,
      ),
      outlineButtonTheme: effectiveVariant.outlineButtonTheme().merge(
        outlineButtonTheme,
      ),
      ghostButtonTheme: effectiveVariant.ghostButtonTheme().merge(
        ghostButtonTheme,
      ),
      linkButtonTheme: effectiveVariant.linkButtonTheme().merge(
        linkButtonTheme,
      ),
      primaryBadgeTheme: effectiveVariant.primaryBadgeTheme().merge(
        primaryBadgeTheme,
      ),
      secondaryBadgeTheme: effectiveVariant.secondaryBadgeTheme().merge(
        secondaryBadgeTheme,
      ),
      destructiveBadgeTheme: effectiveVariant.destructiveBadgeTheme().merge(
        destructiveBadgeTheme,
      ),
      outlineBadgeTheme: effectiveVariant.outlineBadgeTheme().merge(
        outlineBadgeTheme,
      ),
      breadcrumbTheme: effectiveVariant.breadcrumbTheme().merge(
        breadcrumbTheme,
      ),
      buttonSizesTheme: effectiveVariant.buttonSizesTheme().merge(
        buttonSizesTheme,
      ),
      radius: effectiveRadius,
      avatarTheme: effectiveVariant.avatarTheme().merge(avatarTheme),
      tooltipTheme: effectiveVariant.tooltipTheme().merge(tooltipTheme),
      popoverTheme: effectiveVariant.popoverTheme().merge(popoverTheme),
      decoration: effectiveVariant.decorationTheme().merge(decoration),
      // Through the variant, so the style's text roles are applied to the UI
      // entries. Reading `effectiveTextTheme` directly here is what used to
      // make a style change leave every font size untouched.
      textTheme: effectiveVariant.textTheme(),
      disabledOpacity: disabledOpacity ?? .5,
      selectTheme: effectiveVariant.selectTheme().merge(selectTheme),
      optionTheme: effectiveVariant.optionTheme().merge(optionTheme),
      cardTheme: effectiveVariant.cardTheme().merge(cardTheme),
      switchTheme: effectiveVariant.switchTheme().merge(switchTheme),
      checkboxTheme: effectiveVariant.checkboxTheme().merge(checkboxTheme),
      inputTheme: effectiveVariant.inputTheme().merge(inputTheme),
      radioTheme: effectiveVariant.radioTheme().merge(radioTheme),
      primaryToastTheme: effectiveVariant.primaryToastTheme().merge(
        primaryToastTheme,
      ),
      destructiveToastTheme: effectiveVariant.destructiveToastTheme().merge(
        destructiveToastTheme,
      ),
      breakpoints: breakpoints ?? ShadBreakpoints(),
      primaryAlertTheme: effectiveVariant.primaryAlertTheme().merge(
        primaryAlertTheme,
      ),
      destructiveAlertTheme: effectiveVariant.destructiveAlertTheme().merge(
        destructiveAlertTheme,
      ),
      primaryDialogTheme: effectiveVariant.primaryDialogTheme().merge(
        primaryDialogTheme,
      ),
      alertDialogTheme: effectiveVariant.alertDialogTheme().merge(
        alertDialogTheme,
      ),
      sliderTheme: effectiveVariant.sliderTheme().merge(sliderTheme),
      sheetTheme: effectiveVariant.sheetTheme().merge(sheetTheme),
      progressTheme: effectiveVariant.progressTheme().merge(progressTheme),
      accordionTheme: effectiveVariant.accordionTheme().merge(accordionTheme),
      tableTheme: effectiveVariant.tableTheme().merge(tableTheme),
      resizableTheme: effectiveVariant.resizableTheme().merge(resizableTheme),
      hoverStrategies: hoverStrategies ?? effectiveVariant.hoverStrategies(),
      disableSecondaryBorder: effectiveDisableSecondaryBorder,
      tabsTheme: effectiveVariant.tabsTheme().merge(tabsTheme),
      contextMenuTheme: effectiveVariant.contextMenuTheme().merge(
        contextMenuTheme,
      ),
      calendarTheme: effectiveVariant.calendarTheme().merge(calendarTheme),
      datePickerTheme: effectiveVariant.datePickerTheme().merge(
        datePickerTheme,
      ),
      timePickerTheme: effectiveVariant.timePickerTheme().merge(
        timePickerTheme,
      ),
      inputOTPTheme: effectiveVariant.inputOTPTheme().merge(inputOTPTheme),
      menubarTheme: effectiveVariant.menubarTheme().merge(menubarTheme),
      separatorTheme: effectiveVariant.separatorTheme().merge(separatorTheme),
      sonnerTheme: effectiveVariant.sonnerTheme().merge(sonnerTheme),
      textareaTheme: effectiveVariant.textareaTheme().merge(textareaTheme),
      defaultKeyboardToolbarTheme: effectiveVariant
          .defaultKeyboardToolbarTheme()
          .merge(defaultKeyboardToolbarTheme),
      skeletonTheme: effectiveVariant.skeletonTheme().merge(skeletonTheme),
      kbdTheme: effectiveVariant.kbdTheme().merge(kbdTheme),
      scrollAreaTheme: effectiveVariant.scrollAreaTheme().merge(
        scrollAreaTheme,
      ),
      spinnerTheme: effectiveVariant.spinnerTheme().merge(spinnerTheme),
      toggleTheme: effectiveVariant.toggleTheme().merge(toggleTheme),
      outlineToggleTheme: effectiveVariant.outlineToggleTheme().merge(
        outlineToggleTheme,
      ),
      emptyTheme: effectiveVariant.emptyTheme().merge(emptyTheme),
      paginationTheme: effectiveVariant.paginationTheme().merge(
        paginationTheme,
      ),
      collapsibleTheme: effectiveVariant.collapsibleTheme().merge(
        collapsibleTheme,
      ),
      commandTheme: effectiveVariant.commandTheme().merge(commandTheme),
      sidebarTheme: effectiveVariant.sidebarTheme().merge(sidebarTheme),
      variant: effectiveVariant,
    );
  }

  const ShadThemeData._internal({
    required _ShadThemeInputs inputs,
    required super.colorScheme,
    required super.brightness,
    required super.primaryButtonTheme,
    required super.secondaryButtonTheme,
    required super.destructiveButtonTheme,
    required super.outlineButtonTheme,
    required super.ghostButtonTheme,
    required super.linkButtonTheme,
    required super.primaryBadgeTheme,
    required super.secondaryBadgeTheme,
    required super.destructiveBadgeTheme,
    required super.outlineBadgeTheme,
    required super.breadcrumbTheme,
    required super.radius,
    required super.avatarTheme,
    required super.buttonSizesTheme,
    required super.tooltipTheme,
    required super.popoverTheme,
    required super.decoration,
    required super.textTheme,
    required super.disabledOpacity,
    required super.selectTheme,
    required super.optionTheme,
    required super.cardTheme,
    required super.switchTheme,
    required super.checkboxTheme,
    required super.inputTheme,
    required super.radioTheme,
    required super.primaryToastTheme,
    required super.destructiveToastTheme,
    required super.breakpoints,
    required super.primaryAlertTheme,
    required super.destructiveAlertTheme,
    required super.primaryDialogTheme,
    required super.alertDialogTheme,
    required super.sliderTheme,
    required super.sheetTheme,
    required super.progressTheme,
    required super.accordionTheme,
    required super.tableTheme,
    required super.resizableTheme,
    required super.hoverStrategies,
    required super.disableSecondaryBorder,
    required super.tabsTheme,
    required super.contextMenuTheme,
    required super.calendarTheme,
    required super.datePickerTheme,
    required super.timePickerTheme,
    required super.inputOTPTheme,
    required super.menubarTheme,
    required super.separatorTheme,
    required super.sonnerTheme,
    required super.textareaTheme,
    required super.defaultKeyboardToolbarTheme,
    required super.skeletonTheme,
    required super.kbdTheme,
    required super.scrollAreaTheme,
    required super.spinnerTheme,
    required super.toggleTheme,
    required super.outlineToggleTheme,
    required super.emptyTheme,
    required super.paginationTheme,
    required super.collapsibleTheme,
    required super.commandTheme,
    required super.sidebarTheme,
    required super.variant,
  }) : _inputs = inputs;

  /// What the caller passed to the factory, so [copyWith] can derive the
  /// theme again instead of copying already-resolved component themes.
  @ignore
  final _ShadThemeInputs _inputs;

  /// Creates a copy of this theme with the given inputs replaced.
  ///
  /// This runs the [ShadThemeData] factory again, from the inputs this theme
  /// was built from with the given ones replacing them. So
  /// `copyWith(radius: ...)`, `copyWith(colorScheme: ...)`,
  /// `copyWith(style: ...)` or `copyWith(disableSecondaryBorder: true)`
  /// re-derive every component theme. Component themes passed here are merged
  /// over the derived ones, exactly as in the factory.
  @override
  ShadThemeData copyWith({
    ShadColorScheme? colorScheme,
    Brightness? brightness,
    ShadButtonTheme? primaryButtonTheme,
    ShadButtonTheme? secondaryButtonTheme,
    ShadButtonTheme? destructiveButtonTheme,
    ShadButtonTheme? outlineButtonTheme,
    ShadButtonTheme? ghostButtonTheme,
    ShadButtonTheme? linkButtonTheme,
    ShadBadgeTheme? primaryBadgeTheme,
    ShadBadgeTheme? secondaryBadgeTheme,
    ShadBadgeTheme? destructiveBadgeTheme,
    ShadBadgeTheme? outlineBadgeTheme,
    ShadBreadcrumbTheme? breadcrumbTheme,
    BorderRadius? radius,
    ShadAvatarTheme? avatarTheme,
    ShadButtonSizesTheme? buttonSizesTheme,
    ShadTooltipTheme? tooltipTheme,
    ShadPopoverTheme? popoverTheme,
    ShadDecoration? decoration,
    ShadTextTheme? textTheme,
    double? disabledOpacity,
    ShadSelectTheme? selectTheme,
    ShadOptionTheme? optionTheme,
    ShadCardTheme? cardTheme,
    ShadSwitchTheme? switchTheme,
    ShadCheckboxTheme? checkboxTheme,
    ShadInputTheme? inputTheme,
    ShadRadioTheme? radioTheme,
    ShadToastTheme? primaryToastTheme,
    ShadToastTheme? destructiveToastTheme,
    ShadBreakpoints? breakpoints,
    ShadAlertTheme? primaryAlertTheme,
    ShadAlertTheme? destructiveAlertTheme,
    ShadDialogTheme? primaryDialogTheme,
    ShadDialogTheme? alertDialogTheme,
    ShadSliderTheme? sliderTheme,
    ShadSheetTheme? sheetTheme,
    ShadProgressTheme? progressTheme,
    ShadAccordionTheme? accordionTheme,
    ShadTableTheme? tableTheme,
    ShadResizableTheme? resizableTheme,
    ShadHoverStrategies? hoverStrategies,
    bool? disableSecondaryBorder,
    ShadTabsTheme? tabsTheme,
    ShadSkeletonTheme? skeletonTheme,
    ShadKbdTheme? kbdTheme,
    ShadScrollAreaTheme? scrollAreaTheme,
    ShadSpinnerTheme? spinnerTheme,
    ShadToggleTheme? toggleTheme,
    ShadToggleTheme? outlineToggleTheme,
    ShadEmptyTheme? emptyTheme,
    ShadPaginationTheme? paginationTheme,
    ShadCollapsibleTheme? collapsibleTheme,
    ShadCommandTheme? commandTheme,
    ShadSidebarTheme? sidebarTheme,
    ShadThemeVariant? variant,
    ShadContextMenuTheme? contextMenuTheme,
    ShadCalendarTheme? calendarTheme,
    ShadDatePickerTheme? datePickerTheme,
    ShadTimePickerTheme? timePickerTheme,
    ShadInputOTPTheme? inputOTPTheme,
    ShadMenubarTheme? menubarTheme,
    ShadSeparatorTheme? separatorTheme,
    ShadSonnerTheme? sonnerTheme,
    ShadTextareaTheme? textareaTheme,
    ShadDefaultKeyboardToolbarTheme? defaultKeyboardToolbarTheme,
    ShadStyleTokens? style,
    ShadSpacing? spacing,
    ShadColorScheme? menuColorScheme,
    bool? menuTranslucent,
    ShadMenuAccent? menuAccent,
  }) {
    final i = _inputs;
    return ShadThemeData(
      colorScheme: colorScheme ?? i.colorScheme,
      brightness: brightness ?? i.brightness,
      primaryButtonTheme: primaryButtonTheme ?? i.primaryButtonTheme,
      secondaryButtonTheme: secondaryButtonTheme ?? i.secondaryButtonTheme,
      destructiveButtonTheme:
          destructiveButtonTheme ?? i.destructiveButtonTheme,
      outlineButtonTheme: outlineButtonTheme ?? i.outlineButtonTheme,
      ghostButtonTheme: ghostButtonTheme ?? i.ghostButtonTheme,
      linkButtonTheme: linkButtonTheme ?? i.linkButtonTheme,
      primaryBadgeTheme: primaryBadgeTheme ?? i.primaryBadgeTheme,
      secondaryBadgeTheme: secondaryBadgeTheme ?? i.secondaryBadgeTheme,
      destructiveBadgeTheme: destructiveBadgeTheme ?? i.destructiveBadgeTheme,
      outlineBadgeTheme: outlineBadgeTheme ?? i.outlineBadgeTheme,
      breadcrumbTheme: breadcrumbTheme ?? i.breadcrumbTheme,
      radius: radius ?? i.radius,
      avatarTheme: avatarTheme ?? i.avatarTheme,
      buttonSizesTheme: buttonSizesTheme ?? i.buttonSizesTheme,
      tooltipTheme: tooltipTheme ?? i.tooltipTheme,
      popoverTheme: popoverTheme ?? i.popoverTheme,
      decoration: decoration ?? i.decoration,
      textTheme: textTheme ?? i.textTheme,
      disabledOpacity: disabledOpacity ?? i.disabledOpacity,
      selectTheme: selectTheme ?? i.selectTheme,
      optionTheme: optionTheme ?? i.optionTheme,
      cardTheme: cardTheme ?? i.cardTheme,
      switchTheme: switchTheme ?? i.switchTheme,
      checkboxTheme: checkboxTheme ?? i.checkboxTheme,
      inputTheme: inputTheme ?? i.inputTheme,
      radioTheme: radioTheme ?? i.radioTheme,
      primaryToastTheme: primaryToastTheme ?? i.primaryToastTheme,
      destructiveToastTheme: destructiveToastTheme ?? i.destructiveToastTheme,
      breakpoints: breakpoints ?? i.breakpoints,
      primaryAlertTheme: primaryAlertTheme ?? i.primaryAlertTheme,
      destructiveAlertTheme: destructiveAlertTheme ?? i.destructiveAlertTheme,
      primaryDialogTheme: primaryDialogTheme ?? i.primaryDialogTheme,
      alertDialogTheme: alertDialogTheme ?? i.alertDialogTheme,
      sliderTheme: sliderTheme ?? i.sliderTheme,
      sheetTheme: sheetTheme ?? i.sheetTheme,
      progressTheme: progressTheme ?? i.progressTheme,
      accordionTheme: accordionTheme ?? i.accordionTheme,
      tableTheme: tableTheme ?? i.tableTheme,
      resizableTheme: resizableTheme ?? i.resizableTheme,
      hoverStrategies: hoverStrategies ?? i.hoverStrategies,
      disableSecondaryBorder:
          disableSecondaryBorder ?? i.disableSecondaryBorder,
      tabsTheme: tabsTheme ?? i.tabsTheme,
      skeletonTheme: skeletonTheme ?? i.skeletonTheme,
      kbdTheme: kbdTheme ?? i.kbdTheme,
      scrollAreaTheme: scrollAreaTheme ?? i.scrollAreaTheme,
      spinnerTheme: spinnerTheme ?? i.spinnerTheme,
      toggleTheme: toggleTheme ?? i.toggleTheme,
      outlineToggleTheme: outlineToggleTheme ?? i.outlineToggleTheme,
      emptyTheme: emptyTheme ?? i.emptyTheme,
      paginationTheme: paginationTheme ?? i.paginationTheme,
      collapsibleTheme: collapsibleTheme ?? i.collapsibleTheme,
      commandTheme: commandTheme ?? i.commandTheme,
      sidebarTheme: sidebarTheme ?? i.sidebarTheme,
      variant: variant ?? i.variant,
      contextMenuTheme: contextMenuTheme ?? i.contextMenuTheme,
      calendarTheme: calendarTheme ?? i.calendarTheme,
      datePickerTheme: datePickerTheme ?? i.datePickerTheme,
      timePickerTheme: timePickerTheme ?? i.timePickerTheme,
      inputOTPTheme: inputOTPTheme ?? i.inputOTPTheme,
      menubarTheme: menubarTheme ?? i.menubarTheme,
      separatorTheme: separatorTheme ?? i.separatorTheme,
      sonnerTheme: sonnerTheme ?? i.sonnerTheme,
      textareaTheme: textareaTheme ?? i.textareaTheme,
      defaultKeyboardToolbarTheme:
          defaultKeyboardToolbarTheme ?? i.defaultKeyboardToolbarTheme,
      style: style ?? i.style,
      spacing: spacing ?? i.spacing,
      menuColorScheme: menuColorScheme ?? i.menuColorScheme,
      menuTranslucent: menuTranslucent ?? i.menuTranslucent,
      menuAccent: menuAccent ?? i.menuAccent,
    );
  }

  /// The corner-radius scale derived from [radius].
  ///
  /// [radius] is the `md` step — what buttons and inputs use — and the other
  /// steps scale from it, so one setting keeps cards, dialogs and menu rows in
  /// proportion.
  ShadRadii get radii => variant.radii;

  /// The shadcn/ui style this theme renders.
  ShadStyleTokens get style => variant.style;

  /// The spacing scale every padding and gap is a multiple of.
  ///
  /// Call it to convert steps to logical pixels: `theme.spacing(6)` is `24`
  /// with the default step. See `ShadGap` and `ShadPadding` for laying out
  /// against the scale directly.
  ShadSpacing get spacing => variant.spacing;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadThemeData? lerp(
    ShadThemeData? a,
    ShadThemeData? b,
    double t,
  ) => _$ShadThemeData.lerp(a, b, t);
}

/// Whether [color] reads as a light or a dark background, by the same rule
/// as Material's `ThemeData.estimateBrightnessForColor`.
Brightness _brightnessOf(Color color) {
  final luminance = color.computeLuminance();
  return (luminance + 0.05) * (luminance + 0.05) > 0.15
      ? Brightness.light
      : Brightness.dark;
}

/// The arguments a [ShadThemeData] was created with.
@immutable
final class _ShadThemeInputs {
  const _ShadThemeInputs({
    this.colorScheme,
    this.brightness,
    this.primaryButtonTheme,
    this.secondaryButtonTheme,
    this.destructiveButtonTheme,
    this.outlineButtonTheme,
    this.ghostButtonTheme,
    this.linkButtonTheme,
    this.primaryBadgeTheme,
    this.secondaryBadgeTheme,
    this.destructiveBadgeTheme,
    this.outlineBadgeTheme,
    this.breadcrumbTheme,
    this.radius,
    this.avatarTheme,
    this.buttonSizesTheme,
    this.tooltipTheme,
    this.popoverTheme,
    this.decoration,
    this.textTheme,
    this.disabledOpacity,
    this.selectTheme,
    this.optionTheme,
    this.cardTheme,
    this.switchTheme,
    this.checkboxTheme,
    this.inputTheme,
    this.radioTheme,
    this.primaryToastTheme,
    this.destructiveToastTheme,
    this.breakpoints,
    this.primaryAlertTheme,
    this.destructiveAlertTheme,
    this.primaryDialogTheme,
    this.alertDialogTheme,
    this.sliderTheme,
    this.sheetTheme,
    this.progressTheme,
    this.accordionTheme,
    this.tableTheme,
    this.resizableTheme,
    this.hoverStrategies,
    this.disableSecondaryBorder,
    this.tabsTheme,
    this.skeletonTheme,
    this.kbdTheme,
    this.scrollAreaTheme,
    this.spinnerTheme,
    this.toggleTheme,
    this.outlineToggleTheme,
    this.emptyTheme,
    this.paginationTheme,
    this.collapsibleTheme,
    this.commandTheme,
    this.sidebarTheme,
    this.variant,
    this.contextMenuTheme,
    this.calendarTheme,
    this.datePickerTheme,
    this.timePickerTheme,
    this.inputOTPTheme,
    this.menubarTheme,
    this.separatorTheme,
    this.sonnerTheme,
    this.textareaTheme,
    this.defaultKeyboardToolbarTheme,
    this.style,
    this.spacing,
    this.menuColorScheme,
    this.menuTranslucent,
    this.menuAccent,
  });

  final ShadColorScheme? colorScheme;
  final Brightness? brightness;
  final ShadButtonTheme? primaryButtonTheme;
  final ShadButtonTheme? secondaryButtonTheme;
  final ShadButtonTheme? destructiveButtonTheme;
  final ShadButtonTheme? outlineButtonTheme;
  final ShadButtonTheme? ghostButtonTheme;
  final ShadButtonTheme? linkButtonTheme;
  final ShadBadgeTheme? primaryBadgeTheme;
  final ShadBadgeTheme? secondaryBadgeTheme;
  final ShadBadgeTheme? destructiveBadgeTheme;
  final ShadBadgeTheme? outlineBadgeTheme;
  final ShadBreadcrumbTheme? breadcrumbTheme;
  final BorderRadius? radius;
  final ShadAvatarTheme? avatarTheme;
  final ShadButtonSizesTheme? buttonSizesTheme;
  final ShadTooltipTheme? tooltipTheme;
  final ShadPopoverTheme? popoverTheme;
  final ShadDecoration? decoration;
  final ShadTextTheme? textTheme;
  final double? disabledOpacity;
  final ShadSelectTheme? selectTheme;
  final ShadOptionTheme? optionTheme;
  final ShadCardTheme? cardTheme;
  final ShadSwitchTheme? switchTheme;
  final ShadCheckboxTheme? checkboxTheme;
  final ShadInputTheme? inputTheme;
  final ShadRadioTheme? radioTheme;
  final ShadToastTheme? primaryToastTheme;
  final ShadToastTheme? destructiveToastTheme;
  final ShadBreakpoints? breakpoints;
  final ShadAlertTheme? primaryAlertTheme;
  final ShadAlertTheme? destructiveAlertTheme;
  final ShadDialogTheme? primaryDialogTheme;
  final ShadDialogTheme? alertDialogTheme;
  final ShadSliderTheme? sliderTheme;
  final ShadSheetTheme? sheetTheme;
  final ShadProgressTheme? progressTheme;
  final ShadAccordionTheme? accordionTheme;
  final ShadTableTheme? tableTheme;
  final ShadResizableTheme? resizableTheme;
  final ShadHoverStrategies? hoverStrategies;
  final bool? disableSecondaryBorder;
  final ShadTabsTheme? tabsTheme;
  final ShadSkeletonTheme? skeletonTheme;
  final ShadKbdTheme? kbdTheme;
  final ShadScrollAreaTheme? scrollAreaTheme;
  final ShadSpinnerTheme? spinnerTheme;
  final ShadToggleTheme? toggleTheme;
  final ShadToggleTheme? outlineToggleTheme;
  final ShadEmptyTheme? emptyTheme;
  final ShadPaginationTheme? paginationTheme;
  final ShadCollapsibleTheme? collapsibleTheme;
  final ShadCommandTheme? commandTheme;
  final ShadSidebarTheme? sidebarTheme;
  final ShadThemeVariant? variant;
  final ShadContextMenuTheme? contextMenuTheme;
  final ShadCalendarTheme? calendarTheme;
  final ShadDatePickerTheme? datePickerTheme;
  final ShadTimePickerTheme? timePickerTheme;
  final ShadInputOTPTheme? inputOTPTheme;
  final ShadMenubarTheme? menubarTheme;
  final ShadSeparatorTheme? separatorTheme;
  final ShadSonnerTheme? sonnerTheme;
  final ShadTextareaTheme? textareaTheme;
  final ShadDefaultKeyboardToolbarTheme? defaultKeyboardToolbarTheme;
  final ShadStyleTokens? style;
  final ShadSpacing? spacing;
  final ShadColorScheme? menuColorScheme;
  final bool? menuTranslucent;
  final ShadMenuAccent? menuAccent;
}
