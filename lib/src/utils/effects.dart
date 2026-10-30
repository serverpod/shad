import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// An effect from flutter_animate, under a shad name.
typedef ShadAnimEffect<T> = Effect<T>;

/// Animates the size of a widget along its vertical axis with a
/// [SizeTransition].
///
/// The value is the size factor: 0 is collapsed and 1 is the full size.
@immutable
class ShadSizeEffect extends Effect<double> {
  /// Creates a size effect.
  ///
  /// When neither [begin] nor [end] is given, it animates from 0 to 1. When
  /// only [end] is given, it starts at 1.
  const ShadSizeEffect({
    super.delay,
    super.duration,
    super.curve,
    double? begin,
    double? end,
  }) : super(
         begin: begin ?? (end == null ? defaultValue : neutralValue),
         end: end ?? neutralValue,
       );

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    return SizeTransition(
      sizeFactor: buildAnimation(controller, entry),
      child: child,
    );
  }

  /// The size factor at which the widget has its full size.
  static const neutralValue = 1.0;

  /// The size factor at which the widget is collapsed.
  static const defaultValue = 0.0;
}

/// Animates the padding around a widget, as a fraction of [padding].
///
/// It reads the animation value when it builds, so it moves only while
/// something above it rebuilds on every frame, such as a
/// `ShadAnimationBuilder`.
@immutable
class ShadPaddingEffect extends Effect<double> {
  /// Creates a padding effect.
  ///
  /// When neither [begin] nor [end] is given, it animates from 0 to 1. When
  /// only [end] is given, it starts at 1.
  const ShadPaddingEffect({
    required this.padding,
    super.delay,
    super.duration,
    super.curve,
    double? begin,
    double? end,
  }) : super(
         begin: begin ?? (end == null ? defaultValue : neutralValue),
         end: end ?? neutralValue,
       );

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    final animation = buildAnimation(controller, entry);
    return Padding(
      padding: padding * animation.value,
      child: child,
    );
  }

  /// The full padding, applied when the value is 1.
  final EdgeInsetsGeometry padding;

  /// The value at which the full [padding] is applied.
  static const neutralValue = 1.0;

  /// The value at which no padding is applied.
  static const defaultValue = 0.0;
}
