import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/src/theme/color_scheme/base.dart';
import 'package:shadcn_ui/src/theme/color_scheme/slate.dart';
import 'package:shadcn_ui/src/theme/components/accordion.dart';
import 'package:shadcn_ui/src/theme/components/alert.dart';
import 'package:shadcn_ui/src/theme/components/avatar.dart';
import 'package:shadcn_ui/src/theme/components/badge.dart';
import 'package:shadcn_ui/src/theme/components/breadcrumb.dart';
import 'package:shadcn_ui/src/theme/components/button.dart';
import 'package:shadcn_ui/src/theme/components/button_sizes.dart';
import 'package:shadcn_ui/src/theme/components/calendar.dart';
import 'package:shadcn_ui/src/theme/components/card.dart';
import 'package:shadcn_ui/src/theme/components/checkbox.dart';
import 'package:shadcn_ui/src/theme/components/collapsible.dart';
import 'package:shadcn_ui/src/theme/components/command.dart';
import 'package:shadcn_ui/src/theme/components/context_menu.dart';
import 'package:shadcn_ui/src/theme/components/date_picker.dart';
import 'package:shadcn_ui/src/theme/components/decorator.dart';
import 'package:shadcn_ui/src/theme/components/default_keyboard_toolbar.dart';
import 'package:shadcn_ui/src/theme/components/dialog.dart';
import 'package:shadcn_ui/src/theme/components/empty.dart';
import 'package:shadcn_ui/src/theme/components/input.dart';
import 'package:shadcn_ui/src/theme/components/input_otp.dart';
import 'package:shadcn_ui/src/theme/components/kbd.dart';
import 'package:shadcn_ui/src/theme/components/menubar.dart';
import 'package:shadcn_ui/src/theme/components/option.dart';
import 'package:shadcn_ui/src/theme/components/pagination.dart';
import 'package:shadcn_ui/src/theme/components/popover.dart';
import 'package:shadcn_ui/src/theme/components/progress.dart';
import 'package:shadcn_ui/src/theme/components/radio.dart';
import 'package:shadcn_ui/src/theme/components/resizable.dart';
import 'package:shadcn_ui/src/theme/components/select.dart';
import 'package:shadcn_ui/src/theme/components/separator.dart';
import 'package:shadcn_ui/src/theme/components/sheet.dart';
import 'package:shadcn_ui/src/theme/components/skeleton.dart';
import 'package:shadcn_ui/src/theme/components/slider.dart';
import 'package:shadcn_ui/src/theme/components/sonner.dart';
import 'package:shadcn_ui/src/theme/components/spinner.dart';
import 'package:shadcn_ui/src/theme/components/switch.dart';
import 'package:shadcn_ui/src/theme/components/table.dart';
import 'package:shadcn_ui/src/theme/components/tabs.dart';
import 'package:shadcn_ui/src/theme/components/textarea.dart';
import 'package:shadcn_ui/src/theme/components/time_picker.dart';
import 'package:shadcn_ui/src/theme/components/toast.dart';
import 'package:shadcn_ui/src/theme/components/toggle.dart';
import 'package:shadcn_ui/src/theme/components/tooltip.dart';
import 'package:shadcn_ui/src/theme/radii.dart';
import 'package:shadcn_ui/src/theme/spacing.dart';
import 'package:shadcn_ui/src/theme/style.dart';
import 'package:shadcn_ui/src/theme/text_theme/theme.dart';
import 'package:shadcn_ui/src/theme/themes/base.dart';
import 'package:shadcn_ui/src/theme/themes/default_theme_no_secondary_border_variant.dart';
import 'package:shadcn_ui/src/theme/themes/default_theme_variant.dart';
import 'package:shadcn_ui/src/utils/gesture_detector.dart';
import 'package:shadcn_ui/src/utils/responsive.dart';
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

@immutable
@ThemeGen()
class ShadThemeData extends ShadBaseTheme with _$ShadThemeData {
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
    ShadSpinnerTheme? spinnerTheme,
    ShadToggleTheme? toggleTheme,
    ShadEmptyTheme? emptyTheme,
    ShadPaginationTheme? paginationTheme,
    ShadCollapsibleTheme? collapsibleTheme,
    ShadCommandTheme? commandTheme,
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
    /// by every component. Defaults to [ShadStyleTokens.vega].
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
    final effectiveBrightness = brightness ?? Brightness.light;
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
            style: style ?? ShadStyleTokens.vega,
            spacing: spacing ?? const ShadSpacing(),
            menuColorScheme: effectiveMenuColorScheme,
            menuTranslucent: menuTranslucent ?? false,
          ),
          true => ShadDefaultThemeNoSecondaryBorderVariant(
            colorScheme: effectiveColorScheme,
            radius: effectiveRadius,
            effectiveTextTheme: effectiveTextTheme,
            style: style ?? ShadStyleTokens.vega,
            spacing: spacing ?? const ShadSpacing(),
            menuColorScheme: effectiveMenuColorScheme,
            menuTranslucent: menuTranslucent ?? false,
          ),
        };

    return ShadThemeData._internal(
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
      spinnerTheme: effectiveVariant.spinnerTheme().merge(spinnerTheme),
      toggleTheme: effectiveVariant.toggleTheme().merge(toggleTheme),
      emptyTheme: effectiveVariant.emptyTheme().merge(emptyTheme),
      paginationTheme: effectiveVariant.paginationTheme().merge(
        paginationTheme,
      ),
      collapsibleTheme: effectiveVariant.collapsibleTheme().merge(
        collapsibleTheme,
      ),
      commandTheme: effectiveVariant.commandTheme().merge(commandTheme),
      variant: effectiveVariant,
    );
  }

  const ShadThemeData._internal({
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
    required super.spinnerTheme,
    required super.toggleTheme,
    required super.emptyTheme,
    required super.paginationTheme,
    required super.collapsibleTheme,
    required super.commandTheme,
    required super.variant,
  });

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

  static ShadThemeData? lerp(
    ShadThemeData? a,
    ShadThemeData? b,
    double t,
  ) => _$ShadThemeData.lerp(a, b, t);
}
