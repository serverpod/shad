import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/color_scheme/base.dart';
import 'package:shad/src/theme/components/calendar.dart';
import 'package:shad/src/theme/components/checkbox.dart';
import 'package:shad/src/theme/components/context_menu.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:shad/src/theme/components/input_otp.dart';
import 'package:shad/src/theme/components/radio.dart';
import 'package:shad/src/theme/components/select.dart';
import 'package:shad/src/theme/components/switch.dart';
import 'package:shad/src/theme/components/tabs.dart';
import 'package:shad/src/theme/components/time_picker.dart';
import 'package:shad/src/theme/spacing.dart';
import 'package:shad/src/theme/style.dart';
import 'package:shad/src/theme/text_theme/text_styles_default.dart';
import 'package:shad/src/theme/text_theme/theme.dart';
import 'package:shad/src/theme/themes/default_theme_variant.dart';
import 'package:shad/src/utils/border.dart';

/// [ShadDefaultThemeVariant] without the outward focus ring.
///
/// Focus is shown by recolouring a 2px border *inside* each control instead of
/// painting a ring around it, and every bordered control reserves that
/// thickness up front (see [focusReserve]) so focusing never shifts content.
/// Everything else — colours, metrics, menu handling — is inherited, so a
/// reference fix in the default variant lands here too.
class ShadDefaultThemeNoSecondaryBorderVariant extends ShadDefaultThemeVariant {
  ShadDefaultThemeNoSecondaryBorderVariant({
    required super.colorScheme,
    required super.radius,
    required super.effectiveTextTheme,
    super.style,
    super.spacing,
    super.menuColorScheme,
    super.menuTranslucent,
  });

  @override
  ShadDefaultThemeNoSecondaryBorderVariant rebuild({
    ShadColorScheme? colorScheme,
    BorderRadius? radius,
    ShadTextTheme? effectiveTextTheme,
    ShadStyleTokens? style,
    ShadSpacing? spacing,
    Object? menuColorScheme = ShadDefaultThemeVariant.unsetMenuColorScheme,
    bool? menuTranslucent,
  }) {
    return ShadDefaultThemeNoSecondaryBorderVariant(
      colorScheme: colorScheme ?? this.colorScheme,
      radius: radius ?? this.radius,
      effectiveTextTheme: effectiveTextTheme ?? this.effectiveTextTheme,
      style: style ?? this.style,
      spacing: spacing ?? this.spacing,
      menuColorScheme:
          identical(
            menuColorScheme,
            ShadDefaultThemeVariant.unsetMenuColorScheme,
          )
          ? this.menuColorScheme
          : menuColorScheme as ShadColorScheme?,
      menuTranslucent: menuTranslucent ?? this.menuTranslucent,
    );
  }

  /// The room the 2px focus border needs inside a control: whatever the
  /// control's own border does not already occupy. `spacing`-based so it
  /// follows a custom spacing step like every other inset.
  @override
  EdgeInsetsGeometry? focusReserve(double borderWidth) =>
      borderWidth >= 2 ? null : spacing.all((2 - borderWidth) / 4);

  @override
  ShadBorder get fieldBorder => super.fieldBorder.copyWith(
    padding: focusReserve(1),
  );

  @override
  ShadBorder get textareaBorder => super.textareaBorder.copyWith(
    padding: focusReserve(1),
  );

  @override
  ShadDecoration decorationTheme() {
    // No outward ring in this variant: a transparent 2px border reserves the
    // space and is recoloured with the ring colour on focus. The inherited
    // secondary (outward) borders never paint, because the decorator checks
    // the theme-wide `disableSecondaryBorder` flag this variant is built for.
    return super.decorationTheme().copyWith(
      border: ShadBorder.all(width: 2, color: const Color(0x00000000)),
      focusedBorder: ShadBorder.all(
        color: colorScheme.ring,
        radius: radius,
        width: 2,
      ),
    );
  }

  @override
  ShadSelectTheme selectTheme() => super.selectTheme().merge(
    ShadSelectTheme(
      decoration: ShadDecoration(
        border: ShadBorder.all(
          radius: controlRadius,
          color: colorScheme.input,
          padding: focusReserve(1),
          width: 1,
        ),
      ),
    ),
  );

  @override
  ShadSwitchTheme switchTheme() {
    final height = style.switchHeight;
    final radius = BorderRadius.all(Radius.circular(height));
    return super.switchTheme().merge(
      ShadSwitchTheme(
        decoration: ShadDecoration(
          border: ShadBorder.all(
            radius: radius,
            width: 0,
            padding: focusReserve(0),
          ),
          focusedBorder: ShadBorder.all(radius: radius, width: 2),
        ),
      ),
    );
  }

  @override
  ShadCheckboxTheme checkboxTheme() {
    final checkboxRadius = BorderRadius.all(
      Radius.circular(style.checkboxRadius),
    );
    ShadDecoration decorationWith(Color borderColor) => ShadDecoration(
      shadows: style.controlShadow,
      border: ShadBorder.all(
        color: borderColor,
        radius: checkboxRadius,
        padding: focusReserve(1),
        width: 1,
      ),
      focusedBorder: ShadBorder.all(width: 2),
    );
    return super.checkboxTheme().merge(
      ShadCheckboxTheme(
        decoration: decorationWith(controlBorderColor),
        checkedDecoration: decorationWith(colorScheme.primary),
      ),
    );
  }

  @override
  ShadRadioTheme radioTheme() {
    final base = super.radioTheme();
    final circleRadius = BorderRadius.all(
      Radius.circular(base.circleSize ?? 8),
    );
    ShadDecoration adapt(ShadDecoration? decoration) =>
        (decoration ?? const ShadDecoration()).copyWith(
          border: decoration?.border?.copyWith(padding: focusReserve(1)),
          focusedBorder: ShadBorder.all(
            radius: circleRadius.add(circleRadius / 2),
            width: 2,
          ),
        );
    return base.merge(
      ShadRadioTheme(
        decoration: adapt(base.decoration),
        checkedDecoration: adapt(base.checkedDecoration),
      ),
    );
  }

  @override
  ShadTabsTheme tabsTheme() => super.tabsTheme().merge(
    ShadTabsTheme(
      tabDecoration: ShadDecoration(
        border: ShadBorder.all(
          radius: const BorderRadius.all(Radius.circular(4)),
          width: 0,
        ),
        focusedBorder: ShadBorder.all(
          radius: const BorderRadius.all(Radius.circular(4)),
        ),
      ),
    ),
  );

  @override
  ShadContextMenuTheme contextMenuTheme() => super.contextMenuTheme().merge(
    ShadContextMenuTheme(
      itemDecoration: ShadDecoration(
        border: ShadBorder.all(radius: itemRadius, width: 0),
        focusedBorder: decorationTheme().border,
      ),
    ),
  );

  @override
  ShadCalendarTheme calendarTheme() => super.calendarTheme().merge(
    const ShadCalendarTheme(
      yearSelectorMinWidth: 100,
      monthSelectorMinWidth: 130,
    ),
  );

  @override
  ShadTimePickerTheme timePickerTheme() => super.timePickerTheme().merge(
    ShadTimePickerTheme(
      spacing: 4,
      gap: 2,
      fieldWidth: 50,
      periodHeight: 44,
      periodDecoration: ShadDecoration(
        border: ShadBorder.all(
          width: 2,
          color: colorScheme.border,
          radius: radius,
        ),
        focusedBorder: ShadBorder.all(
          width: 2,
          color: colorScheme.ring,
          radius: radius,
          padding: spacing.symmetric(horizontal: 0.25),
        ),
      ),
    ),
  );

  @override
  ShadInputOTPTheme inputOTPTheme() {
    final base = super.inputOTPTheme();
    return base.merge(
      ShadInputOTPTheme(
        padding: spacing.symmetric(vertical: 1),
        decoration: (base.decoration ?? const ShadDecoration()).copyWith(
          border: base.decoration?.border?.copyWith(
            padding: focusReserve(1),
          ),
        ),
      ),
    );
  }

  static ShadTextTheme get defaultTextTheme {
    return ShadTextTheme.custom(
      h1Large: ShadTextDefaultTheme.h1Large(family: kDefaultFontFamily),
      h1: ShadTextDefaultTheme.h1(family: kDefaultFontFamily),
      h2: ShadTextDefaultTheme.h2(family: kDefaultFontFamily),
      h3: ShadTextDefaultTheme.h3(family: kDefaultFontFamily),
      h4: ShadTextDefaultTheme.h4(family: kDefaultFontFamily),
      p: ShadTextDefaultTheme.p(family: kDefaultFontFamily),
      blockquote: ShadTextDefaultTheme.blockquote(family: kDefaultFontFamily),
      table: ShadTextDefaultTheme.table(family: kDefaultFontFamily),
      list: ShadTextDefaultTheme.list(family: kDefaultFontFamily),
      lead: ShadTextDefaultTheme.lead(family: kDefaultFontFamily),
      large: ShadTextDefaultTheme.large(family: kDefaultFontFamily),
      small: ShadTextDefaultTheme.small(family: kDefaultFontFamily),
      muted: ShadTextDefaultTheme.muted(family: kDefaultFontFamily),
      family: kDefaultFontFamily,
    );
  }
}
