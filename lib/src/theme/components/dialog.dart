import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:shad/src/utils/position.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'dialog.g.theme.dart';

/// {@template ShadDialogTheme}
/// Theme for the `ShadDialog` widget.
/// {@endtemplate}
@themeGen
@immutable
class ShadDialogTheme with _$ShadDialogTheme {
  /// {@macro ShadDialogTheme}
  const ShadDialogTheme({
    bool canMerge = true,
    this.closeIconData,
    this.closeIconPosition,
    this.radius,
    this.backgroundColor,
    this.expandActionsWhenTiny,
    this.padding,
    this.gap,
    this.animateIn,
    this.animateOut,
    this.constraints,
    this.border,
    this.shadows,
    this.removeBorderRadiusWhenTiny,
    this.actionsAxis,
    this.actionsMainAxisSize,
    this.actionsMainAxisAlignment,
    this.actionsVerticalDirection,
    this.titleStyle,
    this.descriptionStyle,
    this.titleTextAlign,
    this.descriptionTextAlign,
    this.alignment,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.scrollable,
    this.scrollPadding,
    this.actionsGap,
    this.useSafeArea,
    this.titlePinned,
    this.descriptionPinned,
    this.actionsPinned,
    this.barrierColor,
    this.barrierBlurSigma,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadDialog.closeIconData}
  final IconData? closeIconData;

  /// {@macro ShadDialog.closeIconPosition}
  final ShadPosition? closeIconPosition;

  /// {@macro ShadDialog.radius}
  final BorderRadius? radius;

  /// {@macro ShadDialog.backgroundColor}
  final Color? backgroundColor;

  /// {@macro ShadDialog.expandActionsWhenTiny}
  final bool? expandActionsWhenTiny;

  /// {@macro ShadDialog.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro ShadDialog.gap}
  final double? gap;

  /// The effects played when the dialog appears. Defaults to a fade and
  /// zoom in.
  final List<Effect<dynamic>>? animateIn;

  /// The effects played when the dialog disappears. Defaults to a fade and
  /// zoom out.
  final List<Effect<dynamic>>? animateOut;

  /// {@macro ShadDialog.constraints}
  final BoxConstraints? constraints;

  /// {@macro ShadDialog.actionsAxis}
  final Axis? actionsAxis;

  /// {@macro ShadDialog.actionsMainAxisSize}
  final MainAxisSize? actionsMainAxisSize;

  /// {@macro ShadDialog.actionsMainAxisAlignment}
  final MainAxisAlignment? actionsMainAxisAlignment;

  /// {@macro ShadDialog.actionsVerticalDirection}
  final VerticalDirection? actionsVerticalDirection;

  /// {@macro ShadDialog.border}
  final BoxBorder? border;

  /// {@macro ShadDialog.shadows}
  final List<BoxShadow>? shadows;

  /// {@macro ShadDialog.removeBorderRadiusWhenTiny}
  final bool? removeBorderRadiusWhenTiny;

  /// {@macro ShadDialog.titleStyle}
  final TextStyle? titleStyle;

  /// {@macro ShadDialog.descriptionStyle}
  final TextStyle? descriptionStyle;

  /// {@macro ShadDialog.titleTextAlign}
  final TextAlign? titleTextAlign;

  /// {@macro ShadDialog.descriptionTextAlign}
  final TextAlign? descriptionTextAlign;

  /// {@macro ShadDialog.alignment}
  final Alignment? alignment;

  /// {@macro ShadDialog.mainAxisAlignment}
  final MainAxisAlignment? mainAxisAlignment;

  /// {@macro ShadDialog.crossAxisAlignment}
  final CrossAxisAlignment? crossAxisAlignment;

  /// {@macro ShadDialog.scrollable}
  final bool? scrollable;

  /// {@macro ShadDialog.scrollPadding}
  final EdgeInsetsGeometry? scrollPadding;

  /// {@macro ShadDialog.actionsGap}
  final double? actionsGap;

  /// {@macro ShadDialog.useSafeArea}
  final bool? useSafeArea;

  /// {@macro ShadDialog.titlePinned}
  final bool? titlePinned;

  /// {@macro ShadDialog.descriptionPinned}
  final bool? descriptionPinned;

  /// {@macro ShadDialog.actionsPinned}
  final bool? actionsPinned;

  /// The colour of the barrier behind the dialog. Defaults to shadcn's
  /// `bg-black/10`, which reads because the barrier is also blurred.
  final Color? barrierColor;

  /// {@macro ShadDialog.barrierBlurSigma}
  final double? barrierBlurSigma;

  /// Linearly interpolates between [a] and [b] by [t].
  static ShadDialogTheme? lerp(
    ShadDialogTheme? a,
    ShadDialogTheme? b,
    double t,
  ) => _$ShadDialogTheme.lerp(a, b, t);

  // The generated `==` compares lists by identity, so a theme built with a
  // non-const list would never equal its own rebuild, and ShadAnimatedTheme
  // would re-lerp on every frame. Compare the lists by value, then let the
  // generated `==` compare everything else against a copy that shares them.
  @override
  bool operator ==(Object other) =>
      other is ShadDialogTheme &&
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
