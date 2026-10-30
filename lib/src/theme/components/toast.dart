import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shad/src/utils/border.dart';

import 'package:shad/src/utils/position.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'toast.g.theme.dart';

/// {@template ShadToastTheme}
/// Theme for the `ShadToast` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadToastTheme with _$ShadToastTheme {
  /// {@macro ShadToastTheme}
  const ShadToastTheme({
    bool canMerge = true,
    this.backgroundColor,
    this.closeIconData,
    this.alignment,
    this.offset,
    Duration? displayDuration,
    @Deprecated(
      'Use displayDuration. Will be removed in the next major version.',
    )
    Duration? duration,
    this.animateIn,
    this.animateOut,
    this.textDirection,
    this.crossAxisAlignment,
    this.showCloseIconOnlyWhenHovered,
    this.titleStyle,
    this.descriptionStyle,
    this.actionPadding,
    this.border,
    this.radius,
    this.shadows,
    this.padding,
    this.closeIconPosition,
    this.constraints,
    this.closeIcon,
    this.mainAxisAlignment,
    this.mainAxisSize,
  }) : displayDuration = displayDuration ?? duration,
       _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadToast.backgroundColor}
  final Color? backgroundColor;

  /// {@macro ShadToast.closeIconData}
  final IconData? closeIconData;

  /// {@macro ShadToast.alignment}
  final Alignment? alignment;

  /// {@macro ShadToast.offset}
  final Offset? offset;

  /// {@macro ShadToast.displayDuration}
  final Duration? displayDuration;

  /// The old name of [displayDuration].
  @Deprecated('Use displayDuration. Will be removed in the next major version.')
  Duration? get duration => displayDuration;

  /// {@macro ShadToast.animateIn}
  final List<Effect<dynamic>>? animateIn;

  /// {@macro ShadToast.animateOut}
  final List<Effect<dynamic>>? animateOut;

  /// {@macro ShadToast.textDirection}
  final TextDirection? textDirection;

  /// {@macro ShadToast.crossAxisAlignment}
  final CrossAxisAlignment? crossAxisAlignment;

  /// {@macro ShadToast.showCloseIconOnlyWhenHovered}
  final bool? showCloseIconOnlyWhenHovered;

  /// {@macro ShadToast.titleStyle}
  final TextStyle? titleStyle;

  /// {@macro ShadToast.descriptionStyle}
  final TextStyle? descriptionStyle;

  /// {@macro ShadToast.actionPadding}
  final EdgeInsetsGeometry? actionPadding;

  /// {@macro ShadToast.border}
  final ShadBorder? border;

  /// {@macro ShadToast.radius}
  final BorderRadius? radius;

  /// {@macro ShadToast.shadows}
  final List<BoxShadow>? shadows;

  /// {@macro ShadToast.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro ShadToast.closeIconPosition}
  final ShadPosition? closeIconPosition;

  /// {@macro ShadToast.constraints}
  final BoxConstraints? constraints;

  /// {@macro ShadToast.closeIcon}
  final Widget? closeIcon;

  /// {@macro ShadToast.mainAxisAlignment}
  final MainAxisAlignment? mainAxisAlignment;

  /// {@macro ShadToast.mainAxisSize}
  final MainAxisSize? mainAxisSize;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadToastTheme? lerp(
    ShadToastTheme? a,
    ShadToastTheme? b,
    double t,
  ) => _$ShadToastTheme.lerp(a, b, t);

  // The generated `==` compares lists by identity, so a theme built with a
  // non-const list would never equal its own rebuild, and ShadAnimatedTheme
  // would re-lerp on every frame. Compare the lists by value, then let the
  // generated `==` compare everything else against a copy that shares them.
  @override
  bool operator ==(Object other) =>
      other is ShadToastTheme &&
      listEquals(animateIn, other.animateIn) &&
      listEquals(animateOut, other.animateOut) &&
      listEquals(shadows, other.shadows) &&
      super ==
          other.copyWith(
            animateIn: animateIn,
            animateOut: animateOut,
            shadows: shadows,
          );

  // Equal themes must hash alike, and the lists may differ in identity.
  @override
  int get hashCode => Object.hash(
    runtimeType,
    Object.hashAll(animateIn ?? const []),
    Object.hashAll(animateOut ?? const []),
    Object.hashAll(shadows ?? const []),
  );
}
