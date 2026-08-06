import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shad/src/components/popover.dart';
import 'package:shad/src/raw_components/portal.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:shad/src/theme/data.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/utils/animate.dart';
import 'package:shad/src/utils/gesture_detector.dart';
import 'package:shad/src/utils/mouse_area.dart';

/// Controls the visibility of a [ShadTooltip].
typedef ShadTooltipController = ShadPopoverController;

/// {@template ShadTooltip}
/// A widget that displays a tooltip on hover or focus, styled to match the
/// Shadcn UI design system.
///
/// Provides customizable delay, duration, animation effects, and styling.
/// {@endtemplate}
class ShadTooltip extends StatefulWidget {
  /// {@macro ShadTooltip}
  const ShadTooltip({
    super.key,
    required this.child,
    required this.builder,
    this.focusNode,
    this.waitDuration,
    this.showDuration,
    this.effects,
    this.padding,
    this.decoration,
    this.anchor,
    this.hoverStrategies,
    this.controller,
    this.longPressDuration,
    this.duration,
    this.reverseDuration,
    this.showArrow,
    this.arrowDirection,
  });

  /// {@template ShadTooltip.builder}
  /// The builder function that creates the tooltip content widget.
  ///
  /// Called with the [BuildContext] to build the tooltip's content.
  /// {@endtemplate}
  final WidgetBuilder builder;

  /// {@template ShadTooltip.child}
  /// The child widget that triggers the tooltip when hovered or focused.
  ///
  /// This is the widget that the tooltip is attached to.
  /// {@endtemplate}
  final Widget child;

  /// {@template ShadTooltip.focusNode}
  /// The focus node of the child widget.
  ///
  /// When the child gains focus, the tooltip will be shown.
  /// {@endtemplate}
  final FocusNode? focusNode;

  /// {@template ShadTooltip.waitDuration}
  /// The length of time that a pointer must hover over a tooltip's widget
  /// before the tooltip will be shown.
  ///
  /// Defaults to null (tooltips are shown immediately upon hover).
  /// {@endtemplate}
  final Duration? waitDuration;

  /// {@template ShadTooltip.showDuration}
  /// The length of time that the tooltip will be shown after a mouse pointer
  /// exits the widget.
  ///
  /// Defaults to null.
  /// {@endtemplate}
  final Duration? showDuration;

  /// {@template ShadTooltip.effects}
  /// The animation effects applied to the tooltip.
  ///
  /// Defaults to [FadeEffect(), ScaleEffect(begin: Offset(.95, .95), end:
  /// Offset(1, 1)),
  /// MoveEffect(begin: Offset(0, 2), end: Offset(0, 0))].
  /// {@endtemplate}
  final List<Effect<dynamic>>? effects;

  /// {@template ShadTooltip.padding}
  /// The padding of the tooltip content.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 12, vertical: 6)`.
  /// {@endtemplate}
  final EdgeInsetsGeometry? padding;

  /// {@template ShadTooltip.decoration}
  /// The decoration of the tooltip.
  ///
  /// Defines the visual appearance of the tooltip's container.
  /// {@endtemplate}
  final ShadDecoration? decoration;

  /// {@template ShadTooltip.anchor}
  /// The anchor position of the tooltip relative to its child.
  ///
  /// Defaults to
  /// ```dart
  /// const ShadAnchorAuto(
  ///   offset: Offset(0, -4),
  ///   followerAnchor: Alignment.topCenter,
  ///   targetAnchor: Alignment.topCenter,
  /// );
  /// ```
  /// {@endtemplate}
  final ShadAnchorBase? anchor;

  /// {@template ShadTooltip.hoverStrategies}
  /// The hover strategies to use for the tooltip on devices with touchscreens.
  ///
  /// Configures how hover interactions are interpreted, especially on touch
  /// devices.
  /// {@endtemplate}
  final ShadHoverStrategies? hoverStrategies;

  /// {@template ShadTooltip.controller}
  /// The controller that manages the visibility of the [ShadTooltip].
  ///
  /// Allows programmatic control over showing and hiding the tooltip. If null,
  /// a default [ShadTooltipController] is created internally.
  /// {@endtemplate}
  final ShadTooltipController? controller;

  /// {@template ShadTooltip.longPressDuration}
  /// The duration for a long press to be recognized, triggering the tooltip on
  /// touch devices.
  ///
  /// Specifies how long a press must be to trigger the tooltip on touch-based
  /// interactions.
  /// {@endtemplate}
  final Duration? longPressDuration;

  /// {@template ShadTooltip.duration}
  /// The duration of the tooltip's entrance animation.
  ///
  /// Defaults to [Animate.defaultDuration].
  /// {@endtemplate}
  final Duration? duration;

  /// {@template ShadTooltip.reverseDuration}
  /// The duration of the tooltip's exit animation.
  ///
  /// Defaults to [Duration.zero].
  /// {@endtemplate}
  final Duration? reverseDuration;

  /// {@template ShadTooltip.showArrow}
  /// Whether the tooltip draws the arrow pointing at its trigger, defaults
  /// to true.
  /// {@endtemplate}
  final bool? showArrow;

  /// {@template ShadTooltip.arrowDirection}
  /// The direction the arrow points, i.e. which edge of the tooltip it
  /// rides: [AxisDirection.down] puts it on the bottom edge.
  ///
  /// Defaults to pointing at the trigger through the default anchors: down
  /// while the tooltip sits above it, flipping up when the portal falls
  /// back below. Set it explicitly when using a custom [anchor] that places
  /// the tooltip to the side.
  /// {@endtemplate}
  final AxisDirection? arrowDirection;

  @override
  State<ShadTooltip> createState() => _ShadTooltipState();
}

class _ShadTooltipState extends State<ShadTooltip>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  ShadTooltipController? _controller;
  bool hovered = false;
  bool get hasFocus => widget.focusNode?.hasFocus ?? false;

  ShadTooltipController get controller => widget.controller ?? _controller!;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Animate.defaultDuration,
      reverseDuration: Duration.zero,
    );
    if (widget.controller == null) _controller = ShadTooltipController();
    widget.focusNode?.addListener(onFocusChange);
  }

  @override
  void dispose() {
    animationController.dispose();
    widget.focusNode?.removeListener(onFocusChange);
    _controller?.dispose();
    super.dispose();
  }

  /// The hover strategies this tooltip was configured with, before the
  /// tooltip's own onHoverChange is layered on top.
  ShadHoverStrategies? _baseHoverStrategies;

  /// The theme handed to [ShadTooltip.child], with the merged hover strategies
  /// applied.
  ///
  /// Computed here rather than in build(). Building it per build allocated a
  /// fresh `onHoverChange` closure, and ShadHoverStrategies compares that
  /// closure in `==`, so the copied theme was never equal to the previous one.
  /// ShadInheritedTheme then reported a change and rebuilt the tooltip's entire
  /// child subtree on every tooltip rebuild — and `ShadThemeData.copyWith`
  /// re-runs all 54 component-theme merges each time.
  late ShadThemeData _childTheme;

  void _handleHoverChange(bool value) {
    _baseHoverStrategies?.onHoverChange?.call(value);
    onHoverChange(value);
  }

  void _syncEffectiveTheme() {
    final theme = ShadTheme.of(context);
    final base =
        widget.hoverStrategies ??
        theme.tooltipTheme.hoverStrategies ??
        theme.hoverStrategies;
    _baseHoverStrategies = base;
    _childTheme = theme.copyWith(
      hoverStrategies: base.copyWith(
        // A tear-off of an instance method is canonicalized per receiver, so
        // this keeps a stable identity across rebuilds.
        onHoverChange: _handleHoverChange,
        longPressDuration:
            widget.longPressDuration ?? theme.tooltipTheme.longPressDuration,
      ),
    );
    animationController
      ..duration = widget.duration ?? theme.tooltipTheme.duration
      ..reverseDuration =
          widget.reverseDuration ?? theme.tooltipTheme.reverseDuration;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncEffectiveTheme();
  }

  @override
  void didUpdateWidget(ShadTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(onFocusChange);
      widget.focusNode?.addListener(onFocusChange);
    }
    if (widget.hoverStrategies != oldWidget.hoverStrategies ||
        widget.longPressDuration != oldWidget.longPressDuration ||
        widget.duration != oldWidget.duration ||
        widget.reverseDuration != oldWidget.reverseDuration) {
      _syncEffectiveTheme();
    }
  }

  void onFocusChange() {
    hasFocus ? controller.show() : controller.hide();
  }

  Future<void> onHoverChange(bool value) async {
    if (hovered == value) return;
    hovered = value;
    // Every await below can outlive the widget: the pointer leaves, the route
    // is popped, and the delay completes against a disposed controller.
    if (value) {
      if (widget.waitDuration != null) {
        await Future<void>.delayed(widget.waitDuration!);
        if (!mounted) return;
      }
      if (hovered) {
        controller.show();
      }
    } else {
      if (widget.showDuration != null) {
        await Future<void>.delayed(widget.showDuration!);
        if (!mounted) return;
      }
      if (!hovered && !hasFocus) {
        await animationController.reverse();
        if (!mounted) return;
        controller.hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final effectiveEffects = widget.effects ?? theme.tooltipTheme.effects ?? [];
    final effectivePadding = widget.padding ?? theme.tooltipTheme.padding;
    final effectiveDecoration =
        (theme.tooltipTheme.decoration ?? const ShadDecoration()).merge(
          widget.decoration,
        );

    final effectiveAnchor =
        widget.anchor ??
        theme.tooltipTheme.anchor ??
        const ShadAnchorAuto(
          offset: Offset(0, -4),
          followerAnchor: Alignment.topCenter,
          targetAnchor: Alignment.topCenter,
          fallback: ShadAnchorAuto(
            offset: Offset(0, 4),
          ),
        );

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return CallbackShortcuts(
          // Radix dismisses a tooltip on Escape; without this a keyboard user
          // who focused the trigger had no way to get rid of it.
          bindings: {
            const SingleActivator(LogicalKeyboardKey.escape): () {
              hovered = false;
              controller.hide();
            },
          },
          child: ShadPortal(
            visible: controller.isOpen,
            anchor: effectiveAnchor,
            portalBuilder: (context) {
              Widget tooltip = ShadDecorator(
                decoration: effectiveDecoration,
                child: Padding(
                  padding: effectivePadding ?? EdgeInsets.zero,
                  child: DefaultTextStyle(
                    // The inverted surface's `text-background`, at `text-xs`.
                    style:
                        theme.tooltipTheme.textStyle ??
                        theme.textTheme.muted.copyWith(
                          fontSize: 12,
                          height: 16 / 12,
                          color: theme.colorScheme.background,
                        ),
                    child: widget.builder(context),
                  ),
                ),
              );

              final maxWidth = theme.tooltipTheme.maxWidth ?? 320.0;
              tooltip = ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: tooltip,
              );

              final showArrow =
                  widget.showArrow ?? theme.tooltipTheme.showArrow ?? true;
              if (showArrow) {
                // The default anchors put the tooltip above the trigger, so
                // the arrow rides the bottom edge — flipping up when the
                // portal fell back below.
                final direction =
                    widget.arrowDirection ??
                    (ShadPortalPlacement.usedFallbackOf(context)
                        ? AxisDirection.up
                        : AxisDirection.down);
                tooltip = _ShadTooltipArrow(
                  direction: direction,
                  size: theme.tooltipTheme.arrowSize ?? 10,
                  radius: theme.tooltipTheme.arrowRadius ?? 2,
                  color:
                      effectiveDecoration.color ?? theme.colorScheme.foreground,
                  child: tooltip,
                );
              }

              if (effectiveEffects.isNotEmpty) {
                tooltip = ShadAnimate(
                  controller: animationController,
                  effects: effectiveEffects,
                  child: tooltip,
                );
              }
              return ShadMouseArea(groupId: 'tooltip', child: tooltip);
            },
            child: ShadMouseArea(
              groupId: 'tooltip',
              child: ShadTheme(
                data: _childTheme,
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// The arrow pointing from the tooltip at its trigger, shadcn/ui's
/// `TooltipArrow`: a `size-2.5` square rotated 45°, filled like the surface,
/// its tip rounded by `rounded-[2px]`.
///
/// The square's centre sits 2px inside the edge it rides
/// (`translate-y-[calc(-50%-2px)]`), so about half its diagonal — 5px —
/// pokes out across the anchor gap. It is painted under the bubble and in
/// the same colour, so the overlap never shows.
class _ShadTooltipArrow extends StatelessWidget {
  const _ShadTooltipArrow({
    required this.direction,
    required this.size,
    required this.radius,
    required this.color,
    required this.child,
  });

  final AxisDirection direction;
  final double size;
  final double radius;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final diamond = Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
      ),
    );

    // The square's centre sits 2px inside the bubble's edge.
    final inset = -(size / 2) + 2;
    final positioned = switch (direction) {
      AxisDirection.down => Positioned(
        bottom: inset,
        left: 0,
        right: 0,
        child: Center(child: diamond),
      ),
      AxisDirection.up => Positioned(
        top: inset,
        left: 0,
        right: 0,
        child: Center(child: diamond),
      ),
      AxisDirection.left => Positioned(
        left: inset,
        top: 0,
        bottom: 0,
        child: Center(child: diamond),
      ),
      AxisDirection.right => Positioned(
        right: inset,
        top: 0,
        bottom: 0,
        child: Center(child: diamond),
      ),
    };

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Painted before (under) the bubble, so only the protruding tip
        // shows.
        positioned,
        child,
      ],
    );
  }
}
