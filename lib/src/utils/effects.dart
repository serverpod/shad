import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

typedef ShadAnimEffect<T> = Effect<T>;

@immutable
class ShadSizeEffect extends Effect<double> {
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

  static const neutralValue = 1.0;
  static const defaultValue = 0.0;
}

@immutable
class ShadPaddingEffect extends Effect<double> {
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

  final EdgeInsetsGeometry padding;

  static const neutralValue = 1.0;
  static const defaultValue = 0.0;
}

@Deprecated('Renamed to ShadAnimEffect. This name will be removed in v1.0.0.')
typedef AnimEffect<T> = ShadAnimEffect<T>;

@Deprecated('Renamed to ShadSizeEffect. This name will be removed in v1.0.0.')
typedef SizeEffect = ShadSizeEffect;

@Deprecated(
  'Renamed to ShadPaddingEffect. This name will be removed in v1.0.0.',
)
typedef PaddingEffect = ShadPaddingEffect;
