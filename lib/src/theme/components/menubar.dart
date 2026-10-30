import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shad/src/components/button.dart';
import 'package:shad/src/raw_components/portal.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:shad/src/utils/border.dart';
import 'package:shad/src/utils/gesture_detector.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'menubar.g.theme.dart';

/// {@template ShadMenubarTheme}
/// Theme for the `ShadMenubar` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadMenubarTheme with _$ShadMenubarTheme {
  /// {@macro ShadMenubarTheme}
  const ShadMenubarTheme({
    bool canMerge = true,
    this.radius,
    this.padding,
    this.backgroundColor,
    this.border,
    this.constraints,
    this.contextMenuPadding,
    this.effects,
    this.shadows,
    this.decoration,
    this.filter,
    this.anchor,
    this.buttonVariant,
    this.buttonSize,
    this.buttonCursor,
    this.buttonWidth,
    this.buttonHeight,
    this.buttonPadding,
    this.buttonBackgroundColor,
    this.buttonSelectedBackgroundColor,
    this.buttonHoverBackgroundColor,
    this.buttonForegroundColor,
    this.buttonHoverForegroundColor,
    this.buttonPressedBackgroundColor,
    this.buttonPressedForegroundColor,
    this.buttonShadows,
    this.stripShadows,
    this.buttonGradient,
    this.buttonTextDecoration,
    this.buttonHoverTextDecoration,
    this.buttonDecoration,
    this.buttonGap,
    this.buttonMainAxisAlignment,
    this.buttonCrossAxisAlignment,
    this.buttonHoverStrategies,
    @Deprecated(
      'Has no effect: menubar items do not respond to long presses. '
      'Will be removed in the next major version.',
    )
    this.buttonLongPressDuration,
    this.buttonTextDirection,
    this.buttonExpands,
    this.selectOnHover,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadMenubar.radius}
  final BorderRadiusGeometry? radius;

  /// {@macro ShadMenubar.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro ShadMenubar.backgroundColor}
  final Color? backgroundColor;

  /// {@macro ShadMenubar.border}
  final ShadBorder? border;

  /// {@macro ShadContextMenu.constraints}
  final BoxConstraints? constraints;

  /// {@macro ShadContextMenu.padding}
  final EdgeInsetsGeometry? contextMenuPadding;

  /// {@macro ShadPopover.effects}
  final List<Effect<dynamic>>? effects;

  /// {@macro ShadPopover.shadows}
  final List<BoxShadow>? shadows;

  /// {@macro ShadPopover.decoration}
  final ShadDecoration? decoration;

  /// {@macro ShadPopover.filter}
  final ImageFilter? filter;

  /// {@macro ShadMenubarItem.anchor}
  final ShadAnchorBase? anchor;

  /// {@macro ShadButton.variant}
  final ShadButtonVariant? buttonVariant;

  /// {@macro ShadButton.size}
  final ShadButtonSize? buttonSize;

  /// {@macro ShadButton.cursor}
  final MouseCursor? buttonCursor;

  /// {@macro ShadButton.width}
  final double? buttonWidth;

  /// {@macro ShadMenubarItem.height}
  final double? buttonHeight;

  /// {@macro ShadButton.padding}
  final EdgeInsetsGeometry? buttonPadding;

  /// {@macro ShadButton.backgroundColor}
  final Color? buttonBackgroundColor;

  /// {@macro ShadMenubarItem.selectedBackgroundColor}
  final Color? buttonSelectedBackgroundColor;

  /// {@macro ShadButton.hoverBackgroundColor}
  final Color? buttonHoverBackgroundColor;

  /// {@macro ShadButton.foregroundColor}
  final Color? buttonForegroundColor;

  /// {@macro ShadButton.hoverForegroundColor}
  final Color? buttonHoverForegroundColor;

  /// {@macro ShadButton.pressedBackgroundColor}
  final Color? buttonPressedBackgroundColor;

  /// {@macro ShadButton.pressedForegroundColor}
  final Color? buttonPressedForegroundColor;

  /// {@macro ShadButton.shadows}
  final List<BoxShadow>? buttonShadows;

  /// {@macro ShadMenubar.stripShadows}
  final List<BoxShadow>? stripShadows;

  /// {@macro ShadButton.gradient}
  final Gradient? buttonGradient;

  /// {@macro ShadButton.textDecoration}
  final TextDecoration? buttonTextDecoration;

  /// {@macro ShadButton.hoverTextDecoration}
  final TextDecoration? buttonHoverTextDecoration;

  /// {@macro ShadButton.decoration}
  final ShadDecoration? buttonDecoration;

  /// {@macro ShadButton.gap}
  final double? buttonGap;

  /// {@macro ShadButton.mainAxisAlignment}
  final MainAxisAlignment? buttonMainAxisAlignment;

  /// {@macro ShadButton.crossAxisAlignment}
  final CrossAxisAlignment? buttonCrossAxisAlignment;

  /// {@macro ShadButton.hoverStrategies}
  final ShadHoverStrategies? buttonHoverStrategies;

  /// Has no effect: menubar items do not respond to long presses.
  @Deprecated(
    'Has no effect: menubar items do not respond to long presses. '
    'Will be removed in the next major version.',
  )
  final Duration? buttonLongPressDuration;

  /// {@macro ShadButton.textDirection}
  final TextDirection? buttonTextDirection;

  /// {@macro ShadButton.expands}
  final bool? buttonExpands;

  /// {@macro ShadMenubar.selectOnHover}
  final bool? selectOnHover;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadMenubarTheme? lerp(
    ShadMenubarTheme? a,
    ShadMenubarTheme? b,
    double t,
  ) => _$ShadMenubarTheme.lerp(a, b, t);

  // The generated `==` compares lists by identity, so a theme built with a
  // non-const list would never equal its own rebuild, and ShadAnimatedTheme
  // would re-lerp on every frame. Compare the lists by value, then let the
  // generated `==` compare everything else against a copy that shares them.
  @override
  bool operator ==(Object other) =>
      other is ShadMenubarTheme &&
      listEquals(effects, other.effects) &&
      listEquals(shadows, other.shadows) &&
      listEquals(buttonShadows, other.buttonShadows) &&
      listEquals(stripShadows, other.stripShadows) &&
      super ==
          other.copyWith(
            effects: effects,
            shadows: shadows,
            buttonShadows: buttonShadows,
            stripShadows: stripShadows,
          );

  // Equal themes must hash alike, and the lists may differ in identity.
  @override
  int get hashCode => Object.hash(
    runtimeType,
    Object.hashAll(effects ?? const []),
    Object.hashAll(shadows ?? const []),
    Object.hashAll(buttonShadows ?? const []),
    Object.hashAll(stripShadows ?? const []),
  );
}
