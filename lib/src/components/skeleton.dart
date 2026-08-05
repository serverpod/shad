import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/utils/debug_check.dart';

/// {@template ShadSkeleton}
/// A placeholder shown while content is loading.
///
/// Mirrors shadcn/ui's `Skeleton`: a muted, rounded block that pulses. Give it
/// a size the way you would any box — with a [SizedBox], a [width]/[height],
/// or by letting it fill its parent.
///
/// ```dart
/// const ShadSkeleton(width: 200, height: 16)
/// ```
///
/// Wrap real content once it has loaded rather than nesting it inside the
/// skeleton; a skeleton is a stand-in, not a container.
/// {@endtemplate}
class ShadSkeleton extends StatefulWidget {
  /// {@macro ShadSkeleton}
  const ShadSkeleton({
    super.key,
    this.width,
    this.height,
    this.color,
    this.highlightColor,
    this.radius,
    this.duration,
    this.curve,
    this.animate,
    this.child,
  });

  /// A circular skeleton, useful as an avatar placeholder.
  const ShadSkeleton.circle({
    super.key,
    required double size,
    this.color,
    this.highlightColor,
    this.duration,
    this.curve,
    this.animate,
    this.child,
  }) : width = size,
       height = size,
       radius = const BorderRadius.all(Radius.circular(9999));

  /// The width of the skeleton. Null means "as wide as the parent allows".
  final double? width;

  /// The height of the skeleton.
  final double? height;

  /// {@template ShadSkeleton.color}
  /// The base color of the skeleton.
  /// {@endtemplate}
  final Color? color;

  /// {@template ShadSkeleton.highlightColor}
  /// The color the skeleton pulses towards.
  /// {@endtemplate}
  final Color? highlightColor;

  /// {@template ShadSkeleton.radius}
  /// The corner radius of the skeleton.
  /// {@endtemplate}
  final BorderRadiusGeometry? radius;

  /// {@template ShadSkeleton.duration}
  /// The duration of one full pulse.
  /// {@endtemplate}
  final Duration? duration;

  /// {@template ShadSkeleton.curve}
  /// The curve of the pulse.
  /// {@endtemplate}
  final Curve? curve;

  /// {@template ShadSkeleton.animate}
  /// Whether the skeleton pulses, defaults to `true`.
  ///
  /// Set to `false` to respect a reduced-motion preference, or in tests and
  /// goldens where a running animation would be a source of flake.
  /// {@endtemplate}
  final bool? animate;

  /// An optional child laid out inside the skeleton, used to size it.
  ///
  /// The child is hidden from both painting and semantics — it is only there
  /// to give the placeholder the shape of the content it stands in for.
  final Widget? child;

  @override
  State<ShadSkeleton> createState() => _ShadSkeletonState();
}

class _ShadSkeletonState extends State<ShadSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  bool _animating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(ShadSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate ||
        widget.duration != oldWidget.duration) {
      _syncAnimation();
    }
  }

  void _syncAnimation() {
    final theme = ShadTheme.of(context);
    _controller.duration =
        widget.duration ??
        theme.skeletonTheme.duration ??
        const Duration(milliseconds: 1500);

    final shouldAnimate = widget.animate ?? theme.skeletonTheme.animate ?? true;
    if (shouldAnimate == _animating) return;
    _animating = shouldAnimate;
    if (shouldAnimate) {
      _controller.repeat(reverse: true);
    } else {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasShadTheme(context));
    final theme = ShadTheme.of(context);
    final skeletonTheme = theme.skeletonTheme;

    final effectiveColor =
        widget.color ?? skeletonTheme.color ?? theme.colorScheme.muted;
    final effectiveHighlightColor =
        widget.highlightColor ??
        skeletonTheme.highlightColor ??
        effectiveColor.withValues(alpha: .4);
    final effectiveRadius =
        widget.radius ?? skeletonTheme.radius ?? theme.radius;
    final effectiveCurve =
        widget.curve ?? skeletonTheme.curve ?? Curves.easeInOut;

    // The placeholder conveys nothing to a screen reader beyond "loading",
    // which the surrounding content is responsible for announcing.
    return ExcludeSemantics(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Color.lerp(
                  effectiveColor,
                  effectiveHighlightColor,
                  effectiveCurve.transform(_controller.value),
                ),
                borderRadius: effectiveRadius,
              ),
              child: child,
            );
          },
          child: widget.child == null
              ? null
              : Visibility.maintain(
                  visible: false,
                  child: widget.child!,
                ),
        ),
      ),
    );
  }
}
