import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/utils/debug_check.dart';

/// {@template ShadScrollbar}
/// shadcn/ui's scrollbar, around any scrollable [child]: a thin thumb in the
/// border colour that fades in while scrolling.
///
/// Use it to give a `ListView`, `GridView` or `CustomScrollView` the same
/// scrollbar as [ShadScrollArea]. The platform's own scrollbar is turned off
/// below it, so there is only one.
/// {@endtemplate}
class ShadScrollbar extends StatelessWidget {
  /// {@macro ShadScrollbar}
  const ShadScrollbar({
    super.key,
    required this.child,
    this.controller,
    this.thickness,
    this.crossAxisMargin,
    this.mainAxisMargin,
    this.radius,
    this.thumbColor,
    this.thumbVisibility,
    this.fadeDuration,
    this.timeToFade,
    this.notificationPredicate,
  });

  /// The scrollable the scrollbar belongs to.
  final Widget child;

  /// The controller of [child]. Defaults to the [PrimaryScrollController],
  /// as for Flutter's own scrollbars.
  final ScrollController? controller;

  /// {@template ShadScrollbar.thickness}
  /// The thumb's thickness. Defaults to 7: shadcn's `w-2.5` track less its
  /// `p-px` padding and its 1px transparent border.
  /// {@endtemplate}
  final double? thickness;

  /// {@template ShadScrollbar.crossAxisMargin}
  /// The gap between the thumb and the edge of the scrollable. Defaults to 1.
  /// {@endtemplate}
  final double? crossAxisMargin;

  /// {@template ShadScrollbar.mainAxisMargin}
  /// The gap between the thumb and the ends of the track. Defaults to 1.
  /// {@endtemplate}
  final double? mainAxisMargin;

  /// {@template ShadScrollbar.radius}
  /// The thumb's corner radius. Defaults to fully rounded, or square in the
  /// styles with square items.
  /// {@endtemplate}
  final Radius? radius;

  /// {@template ShadScrollbar.thumbColor}
  /// The thumb's colour. Defaults to the scheme's `border`.
  /// {@endtemplate}
  final Color? thumbColor;

  /// {@template ShadScrollbar.thumbVisibility}
  /// Whether the thumb stays visible when not scrolling. Defaults to false:
  /// it fades in while scrolling and out after [timeToFade], like Radix's
  /// default `hover` type.
  /// {@endtemplate}
  final bool? thumbVisibility;

  /// {@template ShadScrollbar.fadeDuration}
  /// How long the thumb takes to fade in and out.
  /// {@endtemplate}
  final Duration? fadeDuration;

  /// {@template ShadScrollbar.timeToFade}
  /// How long the thumb stays after scrolling stops. Defaults to 600ms,
  /// Radix's `scrollHideDelay`.
  /// {@endtemplate}
  final Duration? timeToFade;

  /// Which scroll notifications move the thumb. Defaults to those of
  /// [child] itself, not of scrollables nested inside it.
  final ScrollNotificationPredicate? notificationPredicate;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasShadTheme(context));
    final theme = ShadTheme.of(context);
    final scrollTheme = theme.scrollAreaTheme;

    return RawScrollbar(
      controller: controller,
      thumbVisibility: thumbVisibility ?? scrollTheme.thumbVisibility ?? false,
      thickness: thickness ?? scrollTheme.thickness ?? 7,
      crossAxisMargin: crossAxisMargin ?? scrollTheme.crossAxisMargin ?? 1,
      mainAxisMargin: mainAxisMargin ?? scrollTheme.mainAxisMargin ?? 1,
      radius: radius ?? scrollTheme.radius ?? const Radius.circular(999),
      thumbColor:
          thumbColor ?? scrollTheme.thumbColor ?? theme.colorScheme.border,
      fadeDuration:
          fadeDuration ??
          scrollTheme.fadeDuration ??
          const Duration(milliseconds: 300),
      timeToFade:
          timeToFade ??
          scrollTheme.timeToFade ??
          const Duration(milliseconds: 600),
      notificationPredicate:
          notificationPredicate ?? defaultScrollNotificationPredicate,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: child,
      ),
    );
  }
}

/// {@template ShadScrollArea}
/// shadcn/ui's ScrollArea: scrolls [child] along [scrollDirection], with a
/// [ShadScrollbar].
///
/// [child] is the content, not a scrollable; wrap a `ListView` or other
/// scrollable in a [ShadScrollbar] instead.
///
/// ```dart
/// SizedBox(
///   height: 200,
///   child: ShadScrollArea(
///     child: Column(children: [for (final tag in tags) Text(tag)]),
///   ),
/// )
/// ```
/// {@endtemplate}
class ShadScrollArea extends StatefulWidget {
  /// {@macro ShadScrollArea}
  const ShadScrollArea({
    super.key,
    required this.child,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.physics,
    this.thumbVisibility,
    this.edgeShadows = false,
    this.edgeShadowColor,
    this.edgeShadowExtent = 8,
  });

  /// The content to scroll.
  final Widget child;

  /// Controls the scroll position. One is created when not given.
  final ScrollController? controller;

  /// The axis the content scrolls along.
  final Axis scrollDirection;

  /// Padding around [child], inside the scrollable.
  final EdgeInsetsGeometry? padding;

  /// The scroll physics.
  final ScrollPhysics? physics;

  /// {@macro ShadScrollbar.thumbVisibility}
  final bool? thumbVisibility;

  /// Whether to fade the edges that have more content beyond them, a cue
  /// that the area scrolls. Not part of shadcn's ScrollArea; off by default.
  final bool edgeShadows;

  /// The colour of [edgeShadows], fading to transparent. Defaults to the
  /// foreground at 12% (40% in dark mode).
  final Color? edgeShadowColor;

  /// How far [edgeShadows] reach into the area.
  final double edgeShadowExtent;

  @override
  State<ShadScrollArea> createState() => _ShadScrollAreaState();
}

class _ShadScrollAreaState extends State<ShadScrollArea> {
  ScrollController? _ownController;
  ScrollController get _controller =>
      widget.controller ?? (_ownController ??= ScrollController());

  bool _contentBefore = false;
  bool _contentAfter = false;

  @override
  void dispose() {
    _ownController?.dispose();
    super.dispose();
  }

  bool _onMetrics(ScrollMetrics metrics) {
    if (!widget.edgeShadows || metrics.axis != widget.scrollDirection) {
      return false;
    }
    final before = metrics.extentBefore > .5;
    final after = metrics.extentAfter > .5;
    if (before != _contentBefore || after != _contentAfter) {
      setState(() {
        _contentBefore = before;
        _contentAfter = after;
      });
    }
    return false;
  }

  Widget _edge(BuildContext context, {required bool start}) {
    final theme = ShadTheme.of(context);
    final color =
        widget.edgeShadowColor ??
        theme.colorScheme.foreground.withValues(
          alpha: theme.brightness == Brightness.dark ? .4 : .12,
        );
    final vertical = widget.scrollDirection == Axis.vertical;
    final from = vertical
        ? (start ? Alignment.topCenter : Alignment.bottomCenter)
        : (start
                  ? AlignmentDirectional.centerStart
                  : AlignmentDirectional.centerEnd)
              .resolve(Directionality.of(context));
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: (start ? _contentBefore : _contentAfter) ? 1 : 0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: vertical ? null : widget.edgeShadowExtent,
          height: vertical ? widget.edgeShadowExtent : null,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: from,
              end: Alignment(-from.x, -from.y),
              colors: [color, color.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = ShadScrollbar(
      controller: _controller,
      thumbVisibility: widget.thumbVisibility,
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: widget.scrollDirection,
        padding: widget.padding,
        physics: widget.physics,
        child: widget.child,
      ),
    );

    if (!widget.edgeShadows) return result;

    final vertical = widget.scrollDirection == Axis.vertical;
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (n) => _onMetrics(n.metrics),
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) => _onMetrics(n.metrics),
        child: Stack(
          children: [
            result,
            if (vertical) ...[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _edge(context, start: true),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _edge(context, start: false),
              ),
            ] else ...[
              PositionedDirectional(
                top: 0,
                bottom: 0,
                start: 0,
                child: _edge(context, start: true),
              ),
              PositionedDirectional(
                top: 0,
                bottom: 0,
                end: 0,
                child: _edge(context, start: false),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
