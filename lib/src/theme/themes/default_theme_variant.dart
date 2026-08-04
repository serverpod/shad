import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shadcn_ui/src/components/button.dart';
import 'package:shadcn_ui/src/raw_components/portal.dart';
import 'package:shadcn_ui/src/theme/color_scheme/base.dart';
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
import 'package:shadcn_ui/src/theme/text_theme/text_styles_default.dart';
import 'package:shadcn_ui/src/theme/text_theme/theme.dart';
import 'package:shadcn_ui/src/theme/themes/base.dart';
import 'package:shadcn_ui/src/theme/themes/shadows.dart';
import 'package:shadcn_ui/src/utils/border.dart';
import 'package:shadcn_ui/src/utils/extensions/text_style.dart';
import 'package:shadcn_ui/src/utils/gesture_detector.dart';

class ShadDefaultThemeVariant extends ShadThemeVariant {
  ShadDefaultThemeVariant({
    required this.colorScheme,
    required this.radius,
    required this.effectiveTextTheme,
    this.style = ShadStyleTokens.vega,
    this.spacing = const ShadSpacing(),
  });

  @override
  final ShadColorScheme colorScheme;

  /// The component ("md") radius. The rest of the scale derives from it.
  @override
  final BorderRadius radius;

  @override
  final ShadTextTheme effectiveTextTheme;

  /// The shadcn/ui style this variant renders.
  @override
  final ShadStyleTokens style;

  /// The spacing scale every padding and gap is a multiple of.
  @override
  final ShadSpacing spacing;

  /// The radius scale derived from [radius].
  @override
  ShadRadii get radii => ShadRadii(radius);

  @override
  ShadDefaultThemeVariant rebuild({
    ShadColorScheme? colorScheme,
    BorderRadius? radius,
    ShadTextTheme? effectiveTextTheme,
    ShadStyleTokens? style,
    ShadSpacing? spacing,
  }) {
    return ShadDefaultThemeVariant(
      colorScheme: colorScheme ?? this.colorScheme,
      radius: radius ?? this.radius,
      effectiveTextTheme: effectiveTextTheme ?? this.effectiveTextTheme,
      style: style ?? this.style,
      spacing: spacing ?? this.spacing,
    );
  }

  /// Scales a metric shadcn expresses in spacing units.
  ///
  /// Tailwind's `h-9` and `px-2.5` are multiples of `--spacing`, so they follow
  /// [spacing]; its bracketed literals — `h-[18.4px]`, `rounded-[4px]`,
  /// `p-[3px]` — do not. [ShadStyleTokens] stores everything in the pixels it
  /// renders at the default 4px step, and this converts the unit-based ones
  /// when that step changes.
  double scaled(double value) => value * spacing.step / 4;

  /// Table headers and footers.
  ///
  /// Most styles simply bold the body size; `sera` sets them as small
  /// uppercase overlines, which is what [ShadStyleTokens.overline] carries.
  TextStyle get _tableHeaderStyle => style.overline.uppercase
      ? style.overline.apply(effectiveTextTheme.muted)
      : style.body
            .apply(effectiveTextTheme.muted)
            .copyWith(fontWeight: style.label.fontWeight);

  /// The border a text field draws.
  ///
  /// Most styles box the field; `sera` underlines it, which is what
  /// [ShadStyleTokens.underlinedFields] selects.
  /// The focus ring for an element with the given corner radius.
  ///
  /// `ShadOutwardBorderPainter` inflates by `offset` and strokes inside it, so
  /// `offset == width` puts the stroke flush against the element; the outer
  /// radius is the element's plus the ring width so the two stay concentric.
  ShadBorder ringFor(BorderRadius elementRadius) => ShadBorder.all(
    width: style.ringWidth,
    color: colorScheme.ring.withValues(alpha: style.ringOpacity),
    radius: elementRadius.add(BorderRadius.circular(style.ringWidth)),
    offset: style.ringWidth,
  );

  /// A card's hairline outline, shadcn's `ring-foreground/10`.
  Color get cardBorderColor =>
      colorScheme.foreground.withValues(alpha: style.cardBorderOpacity);

  /// A popover, menu, dialog or sheet outline.
  Color get surfaceBorderColor =>
      colorScheme.foreground.withValues(alpha: style.surfaceBorderOpacity);

  /// The fill an unchecked checkbox or radio carries.
  ///
  /// shadcn leaves them transparent in light mode and washes them with
  /// `input/30` in dark; both controls use the same value, which is what keeps
  /// a checkbox and a radio looking like the same family.
  Color get uncheckedControlFill =>
      colorScheme.background.computeLuminance() < .5
      ? colorScheme.input.withValues(alpha: .3)
      : const Color(0x00000000);

  /// The border a multi-line field draws.
  ///
  /// Same treatment as [fieldBorder] but on [ShadStyleTokens.textareaRadius],
  /// which stays moderate even in the pill-shaped styles.
  ShadBorder get textareaBorder => style.underlinedFields
      ? fieldBorder
      : ShadBorder.all(
          width: 1,
          color: colorScheme.input,
          radius: radii.resolve(style.textareaRadius),
        );

  ShadBorder get fieldBorder => style.underlinedFields
      ? ShadBorder(
          bottom: ShadBorderSide(width: 1, color: colorScheme.input),
          radius: BorderRadius.zero,
        )
      : ShadBorder.all(
          width: 1,
          color: colorScheme.input,
          radius: controlRadius,
        );

  /// The radius controls use, per [style].
  BorderRadius get controlRadius => radii.resolve(style.buttonRadius);

  /// The radius cards use, per [style].
  BorderRadius get cardRadius => radii.resolve(style.cardRadius);

  /// The radius dialogs and sheets use, per [style].
  BorderRadius get dialogRadius => radii.resolve(style.dialogRadius);

  /// The radius popovers, select and menu surfaces use, per [style].
  BorderRadius get popoverRadius => radii.resolve(style.popoverRadius);

  /// The radius rows inside a surface use, per [style].
  BorderRadius get itemRadius => radii.resolve(style.itemRadius);

  @override
  ShadButtonTheme primaryButtonTheme() {
    return ShadButtonTheme(
      textStyle: style.label.apply(effectiveTextTheme.small),
      backgroundColor: colorScheme.primary,
      hoverBackgroundColor: colorScheme.primary.withValues(alpha: .9),
      foregroundColor: colorScheme.primaryForeground,
      hoverForegroundColor: colorScheme.primaryForeground,
      decoration: ShadDecoration(
        border: ShadBorder.all(radius: controlRadius, width: 0),
      ),
      gap: scaled(style.buttonGap),
      expands: false,
    );
  }

  @override
  ShadButtonTheme secondaryButtonTheme() {
    return ShadButtonTheme(
      textStyle: style.label.apply(effectiveTextTheme.small),
      backgroundColor: colorScheme.secondary,
      hoverBackgroundColor: colorScheme.secondary.withValues(alpha: .8),
      foregroundColor: colorScheme.secondaryForeground,
      hoverForegroundColor: colorScheme.secondaryForeground,
      decoration: ShadDecoration(
        border: ShadBorder.all(radius: controlRadius, width: 0),
      ),
      gap: scaled(style.buttonGap),
      expands: false,
    );
  }

  @override
  ShadButtonTheme destructiveButtonTheme() {
    return ShadButtonTheme(
      textStyle: style.label.apply(effectiveTextTheme.small),
      backgroundColor: colorScheme.destructive,
      hoverBackgroundColor: colorScheme.destructive.withValues(alpha: .9),
      foregroundColor: colorScheme.destructiveForeground,
      hoverForegroundColor: colorScheme.destructiveForeground,
      decoration: ShadDecoration(
        border: ShadBorder.all(radius: controlRadius, width: 0),
      ),
      gap: scaled(style.buttonGap),
      expands: false,
    );
  }

  @override
  ShadButtonTheme outlineButtonTheme() {
    return ShadButtonTheme(
      textStyle: style.label.apply(effectiveTextTheme.small),
      hoverBackgroundColor: colorScheme.accent,
      foregroundColor: colorScheme.primary,
      hoverForegroundColor: colorScheme.accentForeground,
      decoration: ShadDecoration(
        border: ShadBorder.all(
          radius: controlRadius,
          color: colorScheme.input,
          width: 1,
        ),
      ),
      gap: scaled(style.buttonGap),
      expands: false,
    );
  }

  @override
  ShadButtonTheme ghostButtonTheme() {
    return ShadButtonTheme(
      textStyle: style.label.apply(effectiveTextTheme.small),
      hoverBackgroundColor: colorScheme.accent,
      foregroundColor: colorScheme.primary,
      hoverForegroundColor: colorScheme.accentForeground,
      decoration: ShadDecoration(
        border: ShadBorder.all(radius: controlRadius, width: 0),
      ),
      gap: scaled(style.buttonGap),
      expands: false,
    );
  }

  @override
  ShadButtonTheme linkButtonTheme() {
    return ShadButtonTheme(
      textStyle: style.label.apply(effectiveTextTheme.small),
      foregroundColor: colorScheme.primary,
      hoverForegroundColor: colorScheme.primary,
      hoverTextDecoration: TextDecoration.underline,
      gap: scaled(style.buttonGap),
      expands: false,
    );
  }

  @override
  ShadButtonSizesTheme buttonSizesTheme() {
    // Matches shadcn/ui's button sizes: default `h-9 px-4 py-2`,
    // sm `h-8 px-3`, lg `h-10 px-6`, icon `size-9`.
    return ShadButtonSizesTheme(
      regular: ShadButtonSizeTheme(
        height: scaled(style.buttonHeight),
        padding: EdgeInsets.symmetric(horizontal: scaled(style.buttonPaddingX)),
      ),
      sm: ShadButtonSizeTheme(
        height: scaled(style.buttonHeightSm),
        padding: EdgeInsets.symmetric(
          horizontal: scaled(style.buttonPaddingXSm),
        ),
      ),
      lg: ShadButtonSizeTheme(
        height: scaled(style.buttonHeightLg),
        padding: EdgeInsets.symmetric(
          horizontal: scaled(style.buttonPaddingXLg),
        ),
      ),
      icon: ShadButtonSizeTheme(
        height: scaled(style.iconButtonSize),
        width: scaled(style.iconButtonSize),
        padding: EdgeInsets.zero,
      ),
    );
  }

  @override
  ShadBadgeTheme primaryBadgeTheme() {
    return ShadBadgeTheme(
      backgroundColor: colorScheme.primary,
      hoverBackgroundColor: colorScheme.primary.withValues(alpha: .8),
      foregroundColor: colorScheme.primaryForeground,
      shape: const StadiumBorder(),
      padding: spacing.symmetric(horizontal: 2.5, vertical: 0.5),
      textStyle: style.caption.apply(effectiveTextTheme.small),
    );
  }

  @override
  ShadBadgeTheme secondaryBadgeTheme() {
    return ShadBadgeTheme(
      backgroundColor: colorScheme.secondary,
      hoverBackgroundColor: colorScheme.secondary.withValues(alpha: .8),
      foregroundColor: colorScheme.secondaryForeground,
      shape: const StadiumBorder(),
      padding: spacing.symmetric(horizontal: 2.5, vertical: 0.5),
      textStyle: style.caption.apply(effectiveTextTheme.small),
    );
  }

  @override
  ShadBadgeTheme destructiveBadgeTheme() {
    return ShadBadgeTheme(
      backgroundColor: colorScheme.destructive,
      hoverBackgroundColor: colorScheme.destructive.withValues(alpha: .8),
      foregroundColor: colorScheme.destructiveForeground,
      shape: const StadiumBorder(),
      padding: spacing.symmetric(horizontal: 2.5, vertical: 0.5),
      textStyle: style.caption.apply(effectiveTextTheme.small),
    );
  }

  @override
  ShadBadgeTheme outlineBadgeTheme() {
    return ShadBadgeTheme(
      foregroundColor: colorScheme.foreground,
      shape: StadiumBorder(side: BorderSide(color: colorScheme.border)),
      padding: spacing.symmetric(horizontal: 2.5, vertical: 0.5),
    );
  }

  @override
  ShadAvatarTheme avatarTheme() {
    return ShadAvatarTheme(
      size: const Size.square(40),
      shape: const CircleBorder(),
      backgroundColor: colorScheme.muted,
    );
  }

  @override
  ShadBreadcrumbTheme breadcrumbTheme() {
    return ShadBreadcrumbTheme(
      // No default `ellipsis` widget: [ShadBreadcrumbEllipsis] already renders
      // the same icon from `ellipsisSize` and `colorScheme.mutedForeground`,
      // and nothing reads this field. Defaulting it to a non-const Widget gave
      // ShadBreadcrumbTheme identity equality, which propagated all the way up
      // and made every ShadThemeData unequal to every other.
      spacing: 10,
      ellipsisSize: 16,
      separatorSize: 14,
      itemTextStyle: style.body
          .apply(effectiveTextTheme.small)
          .fallback(color: colorScheme.mutedForeground),
      lastItemTextColor: colorScheme.foreground,
      linkTextStyle: style.body
          .apply(effectiveTextTheme.small)
          .fallback(color: colorScheme.mutedForeground),
      linkNormalTextColor: colorScheme.mutedForeground,
      linkHoverTextColor: colorScheme.foreground,
      mainAxisAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      dropdownMenuBackgroundColor: colorScheme.popover,
      dropdownMenuPadding: spacing.all(1),
      dropdownTextStyle: style.body
          .apply(effectiveTextTheme.small)
          .fallback(
            color: colorScheme.foreground,
          ),
      dropdownItemPadding: spacing.symmetric(horizontal: 3, vertical: 2.5),
      dropdownMenuAnchor: const ShadAnchorAuto(
        offset: Offset(0, 4),
        targetAnchor: AlignmentDirectional.bottomStart,
        followerAnchor: AlignmentDirectional.bottomEnd,
        fallback: ShadAnchorAuto(
          offset: Offset(0, -4),
          targetAnchor: AlignmentDirectional.topStart,
          followerAnchor: AlignmentDirectional.topEnd,
        ),
      ),
      dropdownArrowGap: 4,
    );
  }

  @override
  ShadTooltipTheme tooltipTheme() {
    return ShadTooltipTheme(
      effects: const [
        FadeEffect(),
        ScaleEffect(begin: Offset(.95, .95), end: Offset(1, 1)),
        MoveEffect(begin: Offset(0, 2), end: Offset.zero),
      ],
      padding: EdgeInsets.symmetric(
        horizontal: scaled(style.popoverPadding) * .75,
        vertical: scaled(style.popoverPadding) * .375,
      ),
      decoration: ShadDecoration(
        border: ShadBorder.all(
          radius: popoverRadius,
          color: surfaceBorderColor,
          width: 0,
        ),
        color: colorScheme.popover,
        shadows: style.popoverShadow,
      ),
      anchor: const ShadAnchorAuto(
        offset: Offset(0, -4),
        followerAnchor: Alignment.topCenter,
        targetAnchor: Alignment.topCenter,
        fallback: ShadAnchorAuto(
          offset: Offset(0, 4),
        ),
      ),
      duration: Animate.defaultDuration,
      reverseDuration: Duration.zero,
      hoverStrategies: const ShadHoverStrategies(
        hover: {
          ShadHoverStrategy.onTap,
          ShadHoverStrategy.onLongPressDown,
          ShadHoverStrategy.onLongPressStart,
        },
        unhover: {
          ShadHoverStrategy.onTap,
          ShadHoverStrategy.onTapOutside,
          ShadHoverStrategy.onLongPressUp,
          ShadHoverStrategy.onLongPressEnd,
          ShadHoverStrategy.onLongPressCancel,
        },
        longPressDuration: kLongPressTimeout,
      ),
    );
  }

  @override
  ShadPopoverTheme popoverTheme() {
    return ShadPopoverTheme(
      effects: const [
        FadeEffect(
          duration: Duration(milliseconds: 150),
        ),
        ScaleEffect(
          begin: Offset(.95, .95),
          end: Offset(1, 1),
          duration: Duration(milliseconds: 150),
        ),
        MoveEffect(
          begin: Offset(0, 2),
          end: Offset.zero,
          duration: Duration(milliseconds: 150),
        ),
      ],
      reverseDuration: const Duration(milliseconds: 150),
      shadows: style.popoverShadow,
      textStyle: style.body.apply(effectiveTextTheme.small),
      padding: EdgeInsets.all(scaled(style.popoverPadding)),
      decoration: ShadDecoration(
        color: colorScheme.popover,
        shadows: style.popoverShadow,
        border: ShadBorder.all(
          radius: popoverRadius,
          color: surfaceBorderColor,
          width: 1,
        ),
      ),
      anchor: const ShadAnchorAuto(
        offset: Offset(0, 4),
        fallback: ShadAnchorAuto(
          offset: Offset(0, -4),
          followerAnchor: Alignment.topCenter,
          targetAnchor: Alignment.topCenter,
        ),
      ),
    );
  }

  @override
  ShadDecoration decorationTheme() {
    return ShadDecoration(
      secondaryBorder: ShadBorder.all(
        width: 0,
      ),
      // shadcn/ui's focus ring is `focus-visible:ring-[3px] ring-ring/50`:
      // a 3px ring at 50% opacity sitting directly against the element, with
      // no gap. Tailwind paints it as a box-shadow with zero offset and 3px
      // spread.
      //
      // ShadOutwardBorderPainter inflates the rect by `offset` and strokes
      // inside it, so `offset == width` makes the stroke occupy exactly
      // [0, 3] outside the element. The previous `offset: 4` with a 2px stroke
      // left 2px of blank space between element and ring — the visible "gap".
      // The outer radius is the element radius plus the ring width so the two
      // stay concentric.
      secondaryFocusedBorder: ringFor(controlRadius),
      labelStyle: style.label
          .apply(effectiveTextTheme.muted)
          .copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.foreground,
          ),
      errorStyle: style.body
          .apply(effectiveTextTheme.muted)
          .copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.destructive,
          ),
      labelPadding: spacing.only(bottom: 2),
      descriptionStyle: style.body.apply(effectiveTextTheme.muted),
      descriptionPadding: spacing.only(top: 2),
      errorPadding: spacing.only(top: 2),
      errorLabelStyle: style.body
          .apply(effectiveTextTheme.muted)
          .copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.destructive,
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

  @override
  ShadSelectTheme selectTheme() {
    return ShadSelectTheme(
      minWidth: kDefaultSelectMinWidth,
      maxHeight: kDefaultSelectMaxHeight,
      padding: EdgeInsets.symmetric(
        horizontal: scaled(style.selectPaddingX),
        vertical: scaled(style.selectPaddingY),
      ),
      decoration: ShadDecoration(
        border: ShadBorder.all(
          radius: controlRadius,
          color: colorScheme.input,
          width: 1,
        ),
      ),
      optionsPadding: EdgeInsets.all(scaled(style.menuPadding)),
      showScrollToTopChevron: true,
      showScrollToBottomChevron: true,
      popoverReverseDuration: Duration.zero,
      anchor: const ShadAnchorAuto(
        offset: Offset(0, 4),
        fallback: ShadAnchorAuto(
          offset: Offset(0, -4),
          followerAnchor: Alignment.topCenter,
          targetAnchor: Alignment.topCenter,
        ),
      ),
      searchPadding: EdgeInsets.all(scaled(style.popoverPadding) * .75),
    );
  }

  @override
  ShadOptionTheme optionTheme() {
    return ShadOptionTheme(
      padding: EdgeInsets.symmetric(
        horizontal: scaled(style.itemPaddingX),
        vertical: scaled(style.itemPaddingY),
      ),
      textStyle: style.body.apply(effectiveTextTheme.small),
      hoveredBackgroundColor: colorScheme.accent,
    );
  }

  @override
  ShadCardTheme cardTheme() {
    return ShadCardTheme(
      backgroundColor: colorScheme.card,
      padding: EdgeInsets.all(scaled(style.cardPadding)),
      border: ShadBorder.all(color: cardBorderColor, width: 1),
      radius: cardRadius,
      shadows: style.cardShadow,
      gap: scaled(style.cardGap),
      titleStyle: style.title.apply(effectiveTextTheme.large),
      descriptionStyle: style.body.apply(effectiveTextTheme.muted),
      rowMainAxisSize: MainAxisSize.min,
      rowCrossAxisAlignment: CrossAxisAlignment.start,
      rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
      columnMainAxisSize: MainAxisSize.min,
      columnCrossAxisAlignment: CrossAxisAlignment.start,
      columnMainAxisAlignment: MainAxisAlignment.start,
    );
  }

  @override
  ShadSwitchTheme switchTheme() {
    final width = style.switchWidth;
    final height = style.switchHeight;
    // The thumb is inset by whatever is left over, so a style that specifies
    // a bigger thumb automatically gets a tighter track.
    final margin = (height - style.switchThumbSize) / 2;
    final radius = BorderRadius.all(Radius.circular(height / 2));
    return ShadSwitchTheme(
      width: width,
      height: height,
      margin: margin,
      duration: 100.milliseconds,
      thumbColor: colorScheme.background,
      uncheckedTrackColor: colorScheme.input,
      checkedTrackColor: colorScheme.primary,
      padding: spacing.directional(start: 2),
      decoration: ShadDecoration(
        border: ShadBorder.all(radius: radius.add(radius / 2), width: 0),
        // ShadBorder.merge takes `other`'s radius and offset unconditionally,
        // so an override has to restate both or they fall back to null.
        secondaryFocusedBorder: ShadBorder.all(
          radius: radius
              .add(radius / 2)
              .add(
                const BorderRadius.all(Radius.circular(3)),
              ),
          width: 3,
          offset: 3,
        ),
      ),
    );
  }

  @override
  ShadCheckboxTheme checkboxTheme() {
    return ShadCheckboxTheme(
      size: scaled(style.checkboxSize),
      duration: 100.milliseconds,
      color: colorScheme.primary,
      uncheckedColor: uncheckedControlFill,
      padding: spacing.directional(start: 2),
      checkboxPadding: spacing.only(top: 0.25),
      decoration: ShadDecoration(
        border: ShadBorder.all(
          color: colorScheme.input,
          radius: BorderRadius.all(Radius.circular(style.checkboxRadius)),
          width: 1,
        ),
      ),
    );
  }

  @override
  ShadInputTheme inputTheme() {
    return ShadInputTheme(
      style: style.field.apply(effectiveTextTheme.muted),
      placeholderStyle: style.field.apply(effectiveTextTheme.muted),
      inputPadding: EdgeInsets.zero,
      decoration: ShadDecoration(border: fieldBorder),
      padding: EdgeInsets.symmetric(
        horizontal: scaled(style.inputPaddingX),
        vertical: scaled(style.inputPaddingY),
      ),
      constraints: BoxConstraints(minHeight: scaled(style.inputHeight)),
      // The field has a fixed height, so its text sits in the middle of it.
      // The default is top-aligned, which left the text riding high once the
      // height stopped being derived from the padding.
      alignment: AlignmentDirectional.centerStart,
      placeholderAlignment: AlignmentDirectional.centerStart,
      gap: 8,
    );
  }

  @override
  ShadRadioTheme radioTheme() {
    const circleSize = 10.0;
    return ShadRadioTheme(
      size: scaled(style.radioSize),
      circleSize: circleSize,
      duration: 100.milliseconds,
      color: colorScheme.primary,
      padding: spacing.directional(start: 2),
      decoration: ShadDecoration(
        shape: BoxShape.circle,
        color: uncheckedControlFill,
        border: ShadBorder.all(
          color: colorScheme.input,
          width: 1,
        ),
        // The radio itself is a circle, so its ring is fully rounded too.
        secondaryFocusedBorder: ShadBorder.all(
          radius: const BorderRadius.all(Radius.circular(9999)),
          width: 3,
          offset: 3,
        ),
      ),
      spacing: 4,
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      axis: Axis.vertical,
      radioPadding: spacing.only(top: 0.25),
    );
  }

  @override
  ShadToastTheme primaryToastTheme() {
    return ShadToastTheme(
      alignment: Alignment.bottomRight,
      closeIconData: LucideIcons.x,
      titleStyle: style.label
          .apply(effectiveTextTheme.muted)
          .copyWith(
            color: colorScheme.foreground,
          ),
      descriptionStyle: style.body
          .apply(effectiveTextTheme.muted)
          .copyWith(
            color: colorScheme.foreground.withValues(alpha: .9),
          ),
      actionPadding: spacing.directional(start: 4),
      border: ShadBorder.all(color: surfaceBorderColor, width: 1),
      // A toast is a floating surface; shadcn gives it the sheet's shadow.
      shadows: style.sheetShadow,
      backgroundColor: colorScheme.background,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      showCloseIconOnlyWhenHovered: true,
      padding: const EdgeInsetsGeometry.fromSTEB(24, 24, 32, 24),
      mainAxisSize: MainAxisSize.max,
    );
  }

  @override
  ShadToastTheme destructiveToastTheme() {
    return ShadToastTheme(
      alignment: Alignment.bottomRight,
      closeIconData: LucideIcons.x,
      titleStyle: style.label
          .apply(effectiveTextTheme.muted)
          .copyWith(
            color: colorScheme.destructiveForeground,
          ),
      descriptionStyle: style.body
          .apply(effectiveTextTheme.muted)
          .copyWith(
            color: colorScheme.destructiveForeground.withValues(alpha: .9),
          ),
      actionPadding: spacing.directional(start: 4),
      border: ShadBorder.all(color: surfaceBorderColor, width: 1),
      // A toast is a floating surface; shadcn gives it the sheet's shadow.
      shadows: style.sheetShadow,
      backgroundColor: colorScheme.destructive,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      showCloseIconOnlyWhenHovered: true,
      padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 32, 24),
      mainAxisSize: MainAxisSize.max,
    );
  }

  @override
  ShadAlertTheme primaryAlertTheme() {
    return ShadAlertTheme(
      iconPadding: spacing.directional(end: 3),
      decoration: ShadDecoration(
        border: ShadBorder.all(
          color: colorScheme.border,
          radius: cardRadius,
          padding: EdgeInsets.symmetric(
            horizontal: scaled(style.alertPaddingX),
            vertical: scaled(style.alertPaddingY),
          ),
          width: 1,
        ),
      ),
      iconColor: colorScheme.foreground,
      titleStyle: style.body
          .apply(effectiveTextTheme.p)
          .copyWith(
            color: colorScheme.foreground,
            fontWeight: style.label.fontWeight,
            height: 1,
          ),
      descriptionStyle: style.body
          .apply(effectiveTextTheme.muted)
          .copyWith(color: colorScheme.foreground),
    );
  }

  @override
  ShadAlertTheme destructiveAlertTheme() {
    return ShadAlertTheme(
      iconPadding: spacing.directional(end: 3),
      decoration: ShadDecoration(
        border: ShadBorder.all(
          color: colorScheme.destructive,
          radius: cardRadius,
          padding: EdgeInsets.symmetric(
            horizontal: scaled(style.alertPaddingX),
            vertical: scaled(style.alertPaddingY),
          ),
          width: 1,
        ),
      ),
      iconColor: colorScheme.destructive,
      titleStyle: style.body
          .apply(effectiveTextTheme.p)
          .copyWith(
            color: colorScheme.destructive,
            fontWeight: style.label.fontWeight,
            height: 1,
          ),
      descriptionStyle: style.body
          .apply(effectiveTextTheme.muted)
          .copyWith(
            color: colorScheme.destructive,
          ),
    );
  }

  @override
  ShadDialogTheme primaryDialogTheme() {
    return ShadDialogTheme(
      closeIconData: LucideIcons.x,
      radius: dialogRadius,
      backgroundColor: colorScheme.background,
      removeBorderRadiusWhenTiny: true,
      expandActionsWhenTiny: true,
      animateIn: const [
        FadeEffect(),
        ScaleEffect(begin: Offset(.95, .95), end: Offset(1, 1)),
      ],
      animateOut: const [
        FadeEffect(begin: 1, end: 0),
        ScaleEffect(begin: Offset(1, 1), end: Offset(.95, .95)),
      ],
      constraints: const BoxConstraints(maxWidth: 512),
      // shadcn's overlay is `bg-black/10` with `backdrop-blur-xs`: the blur is
      // what separates the dialog from the page, so the tint can stay light
      // and the palette behind it stays recognisable in both modes.
      barrierColor: const Color(0x1a000000),
      barrierBlurSigma: 2,
      shadows: style.dialogShadow.isEmpty ? Shadows.lg : style.dialogShadow,
      padding: EdgeInsets.all(scaled(style.dialogPadding)),
      gap: scaled(style.dialogGap),
      titleStyle: style.title.apply(effectiveTextTheme.large),
      descriptionStyle: style.body.apply(effectiveTextTheme.muted),
      alignment: Alignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      actionsGap: 8,
    );
  }

  @override
  ShadDialogTheme alertDialogTheme() {
    return ShadDialogTheme(
      backgroundColor: colorScheme.background,
      radius: dialogRadius,
      removeBorderRadiusWhenTiny: true,
      expandActionsWhenTiny: true,
      animateIn: const [
        FadeEffect(),
        ScaleEffect(begin: Offset(.95, .95), end: Offset(1, 1)),
      ],
      animateOut: const [
        FadeEffect(begin: 1, end: 0),
        ScaleEffect(begin: Offset(1, 1), end: Offset(.95, .95)),
      ],
      constraints: const BoxConstraints(maxWidth: 512),
      // shadcn's overlay is `bg-black/10` with `backdrop-blur-xs`: the blur is
      // what separates the dialog from the page, so the tint can stay light
      // and the palette behind it stays recognisable in both modes.
      barrierColor: const Color(0x1a000000),
      barrierBlurSigma: 2,
      shadows: style.dialogShadow.isEmpty ? Shadows.lg : style.dialogShadow,
      padding: EdgeInsets.all(scaled(style.dialogPadding)),
      gap: scaled(style.dialogGap),
      titleStyle: style.title.apply(effectiveTextTheme.large),
      descriptionStyle: style.body.apply(effectiveTextTheme.muted),
      alignment: Alignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  @override
  ShadSliderTheme sliderTheme() {
    return ShadSliderTheme(
      mouseCursor: SystemMouseCursors.click,
      disabledMouseCursor: SystemMouseCursors.forbidden,
      min: 0,
      max: 1,
      thumbColor: colorScheme.background,
      thumbBorderColor: colorScheme.primary,
      disabledThumbColor: colorScheme.background,
      disabledThumbBorderColor: colorScheme.primary.withValues(alpha: .5),
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: colorScheme.secondary,
      disabledActiveTrackColor: colorScheme.primary.withValues(alpha: .5),
      disabledInactiveTrackColor: colorScheme.secondary.withValues(alpha: .5),
      trackHeight: scaled(style.sliderTrackHeight),
      thumbRadius: scaled(style.sliderThumbSize) / 2,
    );
  }

  @override
  ShadSheetTheme sheetTheme() {
    return const ShadSheetTheme(
      radius: BorderRadius.zero,
      expandCrossSide: true,
    );
  }

  @override
  ShadProgressTheme progressTheme() {
    return ShadProgressTheme(
      minHeight: scaled(style.progressHeight),
      color: colorScheme.primary,
      backgroundColor: colorScheme.secondary,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
    );
  }

  @override
  ShadAccordionTheme accordionTheme() {
    const bezierCurve = Cubic(0.87, 0, 0.13, 1);
    const duration = Duration(milliseconds: 300);
    return ShadAccordionTheme(
      iconData: LucideIcons.chevronDown,
      padding: spacing.symmetric(vertical: 4),
      underlineTitleOnHover: true,
      duration: duration,
      maintainState: false,
      iconEffects: const [
        RotateEffect(
          begin: 0,
          end: .5,
          duration: duration,
          curve: bezierCurve,
        ),
      ],
      curve: bezierCurve,
      titleStyle: style.label
          .apply(effectiveTextTheme.list)
          .copyWith(
            fontWeight: FontWeight.w500,
          ),
    );
  }

  @override
  ShadTableTheme tableTheme() {
    return ShadTableTheme(
      diagonalDragBehavior: DiagonalDragBehavior.none,
      dragStartBehavior: DragStartBehavior.start,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      cellAlignment: Alignment.centerLeft,
      cellHeight: 48,
      // Horizontal only: shadcn's `p-2` sits on a cell that grows with its
      // content, while ShadTable rows have a fixed height, so vertical padding
      // there just squeezes the content out.
      cellPadding: EdgeInsets.symmetric(
        horizontal: scaled(style.tableCellPadding),
      ),
      cellStyle: style.body.apply(effectiveTextTheme.muted),
      cellHeaderStyle: _tableHeaderStyle,
      cellFooterStyle: _tableHeaderStyle,
    );
  }

  @override
  ShadResizableTheme resizableTheme() {
    return ShadResizableTheme(
      showHandle: false,
      dividerThickness: 1,
      dividerSize: 8,
      dividerColor: colorScheme.border,
      resetOnDoubleTap: true,
      handleDecoration: ShadDecoration(
        color: colorScheme.border,
        border: ShadBorder.all(
          radius: const BorderRadius.all(Radius.circular(4)),
          width: 0,
        ),
        disableSecondaryBorder: true,
      ),
      handleSize: 10,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      verticalDirection: VerticalDirection.down,
    );
  }

  @override
  ShadHoverStrategies hoverStrategies() {
    return const ShadHoverStrategies(
      hover: {
        ShadHoverStrategy.onTapDown,
        ShadHoverStrategy.onLongPressDown,
        ShadHoverStrategy.onLongPressStart,
      },
      unhover: {
        ShadHoverStrategy.onTapUp,
        ShadHoverStrategy.onTapOutside,
        ShadHoverStrategy.onTapCancel,
        ShadHoverStrategy.onLongPressUp,
        ShadHoverStrategy.onLongPressEnd,
        ShadHoverStrategy.onLongPressCancel,
      },
      longPressDuration: kLongPressTimeout,
    );
  }

  @override
  ShadTabsTheme tabsTheme() {
    return ShadTabsTheme(
      dragStartBehavior: DragStartBehavior.start,
      padding: EdgeInsets.all(style.tabsListPadding),
      decoration: ShadDecoration(
        color: colorScheme.muted,
        border: ShadBorder.all(
          radius: radius,
          width: 0,
          color: colorScheme.ring,
        ),
      ),
      tabDecoration: ShadDecoration(
        border: ShadBorder.all(
          radius: const BorderRadius.all(Radius.circular(4)),
          width: 0,
        ),
      ),
      gap: 8,
      expandContent: false,
      tabBackgroundColor: const Color(0x00000000),
      tabSelectedBackgroundColor: colorScheme.background,
      tabHoverBackgroundColor: const Color(0x00000000),
      tabSelectedHoverBackgroundColor: colorScheme.background,
      tabPadding: EdgeInsets.symmetric(
        horizontal: scaled(style.tabPaddingX),
        vertical: scaled(style.tabPaddingY),
      ),
      tabTextStyle: style.label.apply(effectiveTextTheme.small),
      tabForegroundColor: colorScheme.foreground,
      tabSelectedForegroundColor: colorScheme.foreground,
      tabSelectedShadows: Shadows.sm,
    );
  }

  @override
  ShadTextTheme textTheme() {
    // The UI entries carry the style's roles, so app code written against
    // `theme.textTheme.small` retypes with the style just as the components
    // do. The prose entries — h1..h4, lead, blockquote, table — are the
    // typography scale and are deliberately left alone.
    return effectiveTextTheme.copyWith(
      large: style.title.apply(effectiveTextTheme.large),
      small: style.label.apply(effectiveTextTheme.small),
      p: style.body.apply(effectiveTextTheme.p),
      list: style.body.apply(effectiveTextTheme.list),
      muted: style.body.apply(effectiveTextTheme.muted),
    );
  }

  @override
  ShadContextMenuTheme contextMenuTheme() => ShadContextMenuTheme(
    constraints: const BoxConstraints(minWidth: 128),
    padding: spacing.symmetric(vertical: 1),
    itemPadding: spacing.symmetric(horizontal: 1),
    leadingPadding: spacing.directional(end: 2),
    trailingPadding: spacing.directional(start: 2),
    showDelay: const Duration(milliseconds: 100),
    height: 32,
    buttonVariant: ShadButtonVariant.ghost,
    itemDecoration: const ShadDecoration(
      secondaryBorder: ShadBorder.none,
      secondaryFocusedBorder: ShadBorder.none,
    ),
    textStyle: style.body.apply(effectiveTextTheme.small),
    trailingTextStyle: style.caption
        .apply(effectiveTextTheme.muted)
        .copyWith(
          height: 1,
        ),
    selectedBackgroundColor: colorScheme.accent,
  );

  @override
  ShadCalendarTheme calendarTheme() => ShadCalendarTheme(
    dayButtonDecoration: ShadDecoration(
      // Day cells sit on a tight grid, so the ring is kept to 2px rather than
      // the global 3px to avoid neighbouring cells colliding.
      secondaryFocusedBorder: ShadBorder.all(
        width: 2,
        offset: 2,
        radius: radius.add(const BorderRadius.all(Radius.circular(2))),
        color: colorScheme.ring.withValues(alpha: .5),
      ),
    ),
    hideNavigation: false,
    yearSelectorMinWidth: 64,
    monthSelectorMinWidth: 64,
    yearSelectorPadding: spacing.symmetric(horizontal: 2, vertical: 1),
    monthSelectorPadding: spacing.symmetric(horizontal: 2, vertical: 1),
    navigationButtonSize: 28,
    navigationButtonIconSize: 16,
    backNavigationButtonIconData: LucideIcons.chevronLeft,
    forwardNavigationButtonIconData: LucideIcons.chevronRight,
    navigationButtonPadding: EdgeInsets.zero,
    navigationButtonDisabledOpacity: .5,
    decoration: ShadDecoration(
      border: ShadBorder.all(
        radius: radius,
        padding: spacing.all(3),
        color: colorScheme.border,
        width: 1,
      ),
    ),
    spacingBetweenMonths: 16,
    runSpacingBetweenMonths: 16,
    headerHeight: 38,
    headerPadding: spacing.only(bottom: 4),
    captionLayoutGap: 8,
    headerTextStyle: style.label.apply(effectiveTextTheme.small),
    weekdaysPadding: spacing.only(bottom: 2),
    weekNumbersHeaderText: '#',
    weekNumbersHeaderTextStyle: textTheme().muted.copyWith(fontSize: 12.8),
    weekNumbersTextStyle: textTheme().muted.copyWith(fontSize: 12.8),
    dayButtonSize: 36,
    dayButtonOutsideMonthOpacity: .5,
    dayButtonPadding: EdgeInsets.zero,
    selectedDayButtonTextStyle: textTheme().small.copyWith(
      fontWeight: FontWeight.normal,
      color: colorScheme.primaryForeground,
    ),
    insideRangeDayButtonTextStyle: textTheme().small.copyWith(
      color: colorScheme.foreground,
    ),
    dayButtonTextStyle: textTheme().small.copyWith(
      fontWeight: FontWeight.normal,
      color: colorScheme.foreground,
    ),
    dayButtonOutsideMonthVariant: ShadButtonVariant.ghost,
    dayButtonOutsideMonthTextStyle: textTheme().muted,
    dayButtonVariant: ShadButtonVariant.ghost,
    todayButtonVariant: ShadButtonVariant.secondary,
    selectedDayButtonVariant: ShadButtonVariant.primary,
    selectedDayButtonOusideMonthVariant: ShadButtonVariant.secondary,
    insideRangeDayButtonVariant: ShadButtonVariant.secondary,
    weekdaysTextStyle: textTheme().muted.copyWith(fontSize: 12.8),
    weekdaysTextAlign: TextAlign.center,
    gridMainAxisSpacing: 8,
    gridCrossAxisSpacing: 0,
    hideWeekdayNames: false,
    showOutsideDays: true,
    showWeekNumbers: false,
    weekStartsOn: 1,
    fixedWeeks: false,
    allowDeselection: false,
  );

  @override
  ShadDatePickerTheme datePickerTheme() {
    return const ShadDatePickerTheme(
      calendarDecoration: ShadDecoration.none,
      allowDeselection: true,
      buttonVariant: ShadButtonVariant.outline,
      width: 276,
      mainAxisAlignment: MainAxisAlignment.start,
      iconData: LucideIcons.calendar,
    );
  }

  @override
  ShadTimePickerTheme timePickerTheme() {
    return ShadTimePickerTheme(
      axis: Axis.horizontal,
      spacing: 8,
      runSpacing: 4,
      jumpToNextFieldWhenFilled: true,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      gap: 4,
      style: style.field
          .apply(effectiveTextTheme.muted)
          .copyWith(
            color: colorScheme.foreground,
            fontSize: 16,
            height: 24 / 16,
          ),
      placeholderStyle: style.field
          .apply(effectiveTextTheme.muted)
          .copyWith(
            fontSize: 16,
            height: 24 / 16,
          ),
      labelStyle: effectiveTextTheme.small.copyWith(fontSize: 12),
      fieldWidth: 48,
      fieldPadding: spacing.symmetric(horizontal: 3, vertical: 2),
      periodHeight: 42,
      periodMinWidth: 65,
      fieldDecoration: ShadDecoration(
        border: ShadBorder.all(
          color: colorScheme.border,
          radius: radius,
          width: 1,
        ),
      ),
    );
  }

  @override
  ShadInputOTPTheme inputOTPTheme() {
    return ShadInputOTPTheme(
      width: scaled(style.inputHeight),
      height: scaled(style.inputHeight),
      style: effectiveTextTheme.muted.copyWith(
        color: colorScheme.foreground,
        fontFamily: kDefaultFontFamilyMono,
      ),
      // shadcn rounds only the outer corners of the strip, at the control
      // radius: `first:rounded-l-md last:rounded-r-md`.
      firstRadius: BorderRadius.only(
        topLeft: controlRadius.topLeft,
        bottomLeft: controlRadius.bottomLeft,
      ),
      lastRadius: BorderRadius.only(
        topRight: controlRadius.topRight,
        bottomRight: controlRadius.bottomRight,
      ),
      singleRadius: controlRadius,
      middleRadius: BorderRadius.zero,
      decoration: ShadDecoration(
        focusedBorder: ShadBorder.all(color: colorScheme.ring, width: 1),
        // Same ring as every other field; the slot supplies the radius, since
        // only the ends of the strip are rounded.
        secondaryFocusedBorder: ShadBorder.all(
          width: style.ringWidth,
          color: colorScheme.ring.withValues(alpha: style.ringOpacity),
          offset: style.ringWidth,
        ),
        // `border-y border-r` with `first:border-l`: the slots share their
        // vertical edges, so only the right one is drawn per slot. An
        // underlined style draws the bottom edge alone.
        border: style.underlinedFields
            ? ShadBorder(
                bottom: ShadBorderSide(color: colorScheme.input, width: 1),
              )
            : ShadBorder(
                top: ShadBorderSide(color: colorScheme.input, width: 1),
                bottom: ShadBorderSide(color: colorScheme.input, width: 1),
                right: ShadBorderSide(color: colorScheme.input, width: 1),
              ),
      ),
    );
  }

  @override
  ShadMenubarTheme menubarTheme() {
    return ShadMenubarTheme(
      radius: popoverRadius,
      padding: spacing.all(1),
      border: ShadBorder.all(color: surfaceBorderColor, width: 1),
      anchor: const ShadAnchor(
        offset: Offset(-4, 8),
        childAlignment: AlignmentDirectional.topStart,
        overlayAlignment: AlignmentDirectional.bottomStart,
      ),
      buttonHeight: 32,
      buttonVariant: ShadButtonVariant.ghost,
      buttonSelectedBackgroundColor: colorScheme.accent,
      buttonDecoration: const ShadDecoration(disableSecondaryBorder: true),
    );
  }

  @override
  ShadSeparatorTheme separatorTheme() {
    return ShadSeparatorTheme(
      thickness: 1,
      color: colorScheme.border,
      verticalMargin: spacing.symmetric(horizontal: 4),
      horizontalMargin: spacing.symmetric(vertical: 4),
    );
  }

  @override
  ShadSonnerTheme sonnerTheme() {
    return ShadSonnerTheme(
      alignment: Alignment.bottomRight,
      padding: spacing.all(4),
      collapsedGap: 16,
      expandedGap: 8,
      scaleFactor: 0.05,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: const Cubic(0.215, 0.61, 0.355, 1),
    );
  }

  @override
  ShadTextareaTheme textareaTheme() {
    return ShadTextareaTheme(
      style: style.field.apply(effectiveTextTheme.muted),
      placeholderStyle: style.field.apply(effectiveTextTheme.muted),
      inputPadding: EdgeInsets.zero,
      decoration: ShadDecoration(
        border: textareaBorder,
        // A textarea is rounder or squarer than a control, so its ring has to
        // be built from its own radius rather than the shared one.
        secondaryFocusedBorder: ringFor(radii.resolve(style.textareaRadius)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: scaled(style.textareaPaddingX),
        vertical: scaled(style.textareaPaddingY),
      ),
      gap: 8,
      minHeight: 80,
      maxHeight: 500,
      resizable: true,
      scrollbarPadding: spacing.only(bottom: 2.5),
    );
  }

  @override
  ShadDefaultKeyboardToolbarTheme defaultKeyboardToolbarTheme() {
    return ShadDefaultKeyboardToolbarTheme(
      backgroundColor: colorScheme.accent,
      doneText: 'Done',
      showDoneButton: true,
      showNextButton: true,
      showPreviousButton: true,
    );
  }

  @override
  ShadSkeletonTheme skeletonTheme() {
    return ShadSkeletonTheme(
      color: colorScheme.muted,
      highlightColor: colorScheme.muted.withValues(alpha: .4),
      radius: radius,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
      animate: true,
    );
  }

  @override
  ShadKbdTheme kbdTheme() {
    return ShadKbdTheme(
      backgroundColor: colorScheme.muted,
      foregroundColor: colorScheme.mutedForeground,
      border: ShadBorder.all(
        color: colorScheme.border,
        width: 1,
        radius: itemRadius,
      ),
      padding: EdgeInsets.symmetric(horizontal: scaled(style.kbdPaddingX)),
      textStyle: style.caption
          .apply(effectiveTextTheme.muted)
          .copyWith(fontFamily: 'GeistMono', package: 'shadcn_ui'),
      gap: 4,
      height: scaled(style.kbdHeight),
      minWidth: scaled(style.kbdHeight),
    );
  }

  @override
  ShadSpinnerTheme spinnerTheme() {
    return ShadSpinnerTheme(
      color: colorScheme.primary,
      trackColor: colorScheme.primary.withValues(alpha: .2),
      size: 16,
      strokeWidth: 2,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  ShadToggleTheme toggleTheme() {
    return ShadToggleTheme(
      hoverBackgroundColor: colorScheme.muted,
      selectedBackgroundColor: colorScheme.accent,
      selectedHoverBackgroundColor: colorScheme.accent,
      foregroundColor: colorScheme.foreground,
      hoverForegroundColor: colorScheme.mutedForeground,
      selectedForegroundColor: colorScheme.accentForeground,
      padding: spacing.symmetric(horizontal: 3),
      decoration: ShadDecoration(
        border: ShadBorder.all(radius: controlRadius, width: 0),
      ),
      textStyle: style.label.apply(effectiveTextTheme.small),
      gap: 8,
      height: 40,
    );
  }

  @override
  ShadEmptyTheme emptyTheme() {
    return ShadEmptyTheme(
      padding: spacing.symmetric(horizontal: 6, vertical: 12),
      gap: 8,
      iconSize: 40,
      iconColor: colorScheme.mutedForeground,
      titleStyle: style.title.apply(effectiveTextTheme.large),
      descriptionStyle: style.body.apply(effectiveTextTheme.muted),
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  @override
  ShadPaginationTheme paginationTheme() {
    return ShadPaginationTheme(
      gap: 4,
      mainAxisAlignment: MainAxisAlignment.center,
      siblingCount: 1,
      boundaryCount: 1,
      showEdges: true,
      ellipsisTextStyle: effectiveTextTheme.muted,
    );
  }

  @override
  ShadCollapsibleTheme collapsibleTheme() {
    return const ShadCollapsibleTheme(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }

  @override
  ShadCommandTheme commandTheme() {
    return ShadCommandTheme(
      backgroundColor: colorScheme.popover,
      decoration: ShadDecoration(
        border: ShadBorder.all(radius: radius, color: colorScheme.border),
      ),
      padding: EdgeInsets.zero,
      searchPadding: spacing.symmetric(horizontal: 3, vertical: 3),
      optionsPadding: spacing.all(1),
      groupHeadingStyle: style.overline
          .apply(effectiveTextTheme.muted)
          .copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
      groupHeadingPadding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      itemPadding: spacing.symmetric(horizontal: 2, vertical: 2),
      itemTextStyle: style.body
          .apply(effectiveTextTheme.small)
          .copyWith(
            fontWeight: FontWeight.normal,
          ),
      itemSelectedBackgroundColor: colorScheme.accent,
      itemSelectedForegroundColor: colorScheme.accentForeground,
      itemForegroundColor: colorScheme.popoverForeground,
      itemRadius: itemRadius,
      itemGap: 8,
      height: 300,
      width: 400,
      emptyPadding: spacing.symmetric(vertical: 6),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ShadDefaultThemeVariant &&
        other.colorScheme == colorScheme &&
        other.radius == radius &&
        other.effectiveTextTheme == effectiveTextTheme &&
        other.style == style &&
        other.spacing == spacing;
  }

  @override
  int get hashCode =>
      Object.hash(colorScheme, radius, effectiveTextTheme, style, spacing);
}
