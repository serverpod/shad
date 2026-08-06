import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shad/src/raw_components/portal.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:shad/src/utils/gesture_detector.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'tooltip.g.theme.dart';

@themeGen
@immutable
class ShadTooltipTheme with _$ShadTooltipTheme {
  const ShadTooltipTheme({
    bool canMerge = true,
    this.waitDuration,
    this.showDuration,
    this.effects,
    this.padding,
    this.decoration,
    this.anchor,
    this.hoverStrategies,
    this.longPressDuration,
    this.duration,
    this.reverseDuration,
    this.textStyle,
    this.maxWidth,
    this.showArrow,
    this.arrowSize,
    this.arrowRadius,
  }) : _canMerge = canMerge;

  @ignore
  final bool _canMerge;

  @override
  bool get canMerge => _canMerge;

  /// {@macro ShadTooltip.waitDuration}
  final Duration? waitDuration;

  /// {@macro ShadTooltip.showDuration}
  final Duration? showDuration;

  /// {@macro ShadTooltip.effects}
  final List<Effect<dynamic>>? effects;

  /// {@macro ShadTooltip.anchor}
  final ShadAnchorBase? anchor;

  /// {@macro ShadTooltip.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro ShadTooltip.decoration}
  final ShadDecoration? decoration;

  /// {@macro ShadTooltip.hoverStrategies}
  final ShadHoverStrategies? hoverStrategies;

  /// {@macro ShadTooltip.longPressDuration}
  final Duration? longPressDuration;

  /// {@macro ShadTooltip.duration}
  final Duration? duration;

  /// {@macro ShadTooltip.reverseDuration}
  final Duration? reverseDuration;

  /// The text style of the tooltip's content, `text-xs` on the inverted
  /// surface's `text-background`.
  final TextStyle? textStyle;

  /// The widest the tooltip may grow, `max-w-xs`.
  final double? maxWidth;

  /// {@macro ShadTooltip.showArrow}
  final bool? showArrow;

  /// The edge length of the arrow's rotated square, `size-2.5`.
  final double? arrowSize;

  /// The corner radius of the arrow's tip, `rounded-[2px]` — zero in the
  /// square styles.
  final double? arrowRadius;

  static ShadTooltipTheme? lerp(
    ShadTooltipTheme? a,
    ShadTooltipTheme? b,
    double t,
  ) => _$ShadTooltipTheme.lerp(a, b, t);
}
