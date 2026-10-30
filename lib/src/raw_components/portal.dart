import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The position of the [ShadPortal] in the global coordinate system.
sealed class ShadAnchorBase {
  const ShadAnchorBase();
}

/// Automatically infers the position of the [ShadPortal] in the global
/// coordinate system adjusting according to the [offset],
/// [followerAnchor] and [targetAnchor] properties.
@immutable
class ShadAnchorAuto extends ShadAnchorBase {
  /// Creates an anchor that places the overlay relative to the target.
  ///
  /// By default the bottom center of the overlay sits on the bottom center of
  /// the target, and the overlay follows the target when the window resizes.
  const ShadAnchorAuto({
    this.offset = Offset.zero,
    this.followTargetOnResize = true,
    this.followerAnchor = Alignment.bottomCenter,
    this.targetAnchor = Alignment.bottomCenter,
    this.fallback,
  });

  /// The offset of the overlay from the target widget.
  final Offset offset;

  /// Whether the overlay is automatically adjusted to follow the target
  /// widget when the target widget moves dues to a window resize.
  final bool followTargetOnResize;

  /// The coordinates of the overlay from which the overlay starts, which
  /// is calculated from the initial [targetAnchor].
  final AlignmentGeometry followerAnchor;

  /// The coordinates of the target from which the overlay starts.
  final AlignmentGeometry targetAnchor;

  /// The anchor to try when the overlay does not fit on screen here.
  ///
  /// When the overlay computed from this anchor overflows the screen on
  /// either axis, the [fallback] is tried, then its own fallback, and so on.
  /// The candidate that overflows least wins, so a fallback mirrored to the
  /// other side flips a menu or tooltip away from the edge it would cross.
  /// Whatever still overflows is then shifted back on screen.
  final ShadAnchorAuto? fallback;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShadAnchorAuto &&
        other.offset == offset &&
        other.followTargetOnResize == followTargetOnResize &&
        other.followerAnchor == followerAnchor &&
        other.targetAnchor == targetAnchor &&
        other.fallback == fallback;
  }

  @override
  int get hashCode =>
      offset.hashCode ^
      followTargetOnResize.hashCode ^
      followerAnchor.hashCode ^
      targetAnchor.hashCode ^
      fallback.hashCode;
}

/// Manually specifies the position of the [ShadPortal] in the global
/// coordinate system.
@immutable
class ShadAnchor extends ShadAnchorBase {
  /// Creates an anchor from a point on the child and a point on the overlay.
  ///
  /// By default the bottom-left corner of the overlay sits on the top-left
  /// corner of the child.
  const ShadAnchor({
    this.childAlignment = Alignment.topLeft,
    this.overlayAlignment = Alignment.bottomLeft,
    this.offset = Offset.zero,
  });

  /// The point on the child — the anchored widget — that the overlay
  /// attaches to.
  ///
  /// `childAlignment: Alignment.centerRight` with
  /// `overlayAlignment: Alignment.centerLeft` hangs the overlay off the
  /// child's right edge.
  final AlignmentGeometry childAlignment;

  /// The point on the overlay glued to [childAlignment], shifted by
  /// [offset].
  final AlignmentGeometry overlayAlignment;

  /// A further shift of the overlay, in logical pixels.
  final Offset offset;

  /// The overlay hangs centred below the child.
  static const center = ShadAnchor(
    childAlignment: Alignment.bottomCenter,
    overlayAlignment: Alignment.topCenter,
  );

  /// Returns a copy with the given fields replaced.
  ShadAnchor copyWith({
    AlignmentGeometry? childAlignment,
    AlignmentGeometry? overlayAlignment,
    Offset? offset,
  }) {
    return ShadAnchor(
      childAlignment: childAlignment ?? this.childAlignment,
      overlayAlignment: overlayAlignment ?? this.overlayAlignment,
      offset: offset ?? this.offset,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShadAnchor &&
        other.childAlignment == childAlignment &&
        other.overlayAlignment == overlayAlignment &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    return childAlignment.hashCode ^
        overlayAlignment.hashCode ^
        offset.hashCode;
  }
}

/// Positions the overlay at a point in the global coordinate system, such as
/// where the pointer was pressed.
@immutable
class ShadGlobalAnchor extends ShadAnchorBase {
  /// Creates an anchor at the global point [offset].
  const ShadGlobalAnchor(
    this.offset, {
    this.followerAnchor = Alignment.topCenter,
  });

  /// The global offset where the overlay is positioned.
  final Offset offset;

  /// The point on the overlay placed at [offset].
  ///
  /// Defaults to [Alignment.topCenter]: the overlay hangs centred below the
  /// point. A context menu uses `AlignmentDirectional.topStart`, so it opens
  /// with its corner at the pointer as Radix's does.
  ///
  /// When the overlay would cross a screen edge it is mirrored to the other
  /// side of the point on that axis, and then shifted on screen if it still
  /// does not fit.
  final AlignmentGeometry followerAnchor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShadGlobalAnchor &&
        other.offset == offset &&
        other.followerAnchor == followerAnchor;
  }

  @override
  int get hashCode => Object.hash(offset, followerAnchor);
}

/// Publishes which position the enclosing [ShadPortal] resolved to: the
/// primary anchor, or its [ShadAnchorAuto.fallback].
///
/// An overlay that renders differently per side — a tooltip's arrow — reads
/// this to flip along with the portal. Outside an auto-anchored portal the
/// lookup reports the primary position.
class ShadPortalPlacement extends InheritedWidget {
  /// Creates the placement data for a portal's overlay.
  const ShadPortalPlacement({
    super.key,
    required this.usedFallback,
    required super.child,
    this.shift = Offset.zero,
  });

  /// Whether the overlay is positioned by the anchor's fallback.
  final bool usedFallback;

  /// How far the overlay had to move off its anchor point to stay on screen,
  /// as `actual centre - anchored centre`.
  ///
  /// An overlay that points back at its trigger — a tooltip's arrow — has to
  /// subtract this, or it keeps pointing at the middle of a bubble that is no
  /// longer over the trigger.
  final Offset shift;

  /// Whether the nearest portal above [context] fell back to its anchor's
  /// [ShadAnchorAuto.fallback] position.
  static bool usedFallbackOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<ShadPortalPlacement>()
          ?.usedFallback ??
      false;

  /// The [shift] of the nearest portal above [context], or [Offset.zero]
  /// outside an auto-anchored portal.
  static Offset shiftOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<ShadPortalPlacement>()
          ?.shift ??
      Offset.zero;

  @override
  bool updateShouldNotify(ShadPortalPlacement oldWidget) =>
      usedFallback != oldWidget.usedFallback || shift != oldWidget.shift;
}

/// Shows an overlay positioned relative to its child, such as a popover,
/// tooltip or menu.
///
/// The overlay is built in the nearest [Overlay] and placed by [anchor].
/// Descendants of the overlay can read the resolved placement with
/// [ShadPortalPlacement].
class ShadPortal extends StatefulWidget {
  /// Creates a portal that shows the result of [portalBuilder] while [visible]
  /// is true.
  const ShadPortal({
    super.key,
    required this.child,
    required this.portalBuilder,
    required this.visible,
    required this.anchor,
  });

  /// The widget that the overlay is anchored to.
  final Widget child;

  /// Builds the overlay content.
  final WidgetBuilder portalBuilder;

  /// Whether the overlay is shown.
  final bool visible;

  /// Where to place the overlay.
  final ShadAnchorBase anchor;

  @override
  State<ShadPortal> createState() => _ShadPortalState();
}

class _ShadPortalState extends State<ShadPortal> {
  final layerLink = LayerLink();
  final overlayPortalController = OverlayPortalController();
  final overlayKey = GlobalKey();
  Offset? _calculatedTarget;
  bool _usedFallback = false;
  Offset _shift = Offset.zero;
  // When scrolling, recalculate the position
  ScrollNotificationObserverState? _scrollNotificationObserver;
  bool _autoPositionUpdateScheduled = false;

  @override
  void initState() {
    super.initState();
    updateVisibility();
  }

  @override
  void didUpdateWidget(covariant ShadPortal oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Avoid scheduling a post-frame visibility update on every rebuild.
    final visibilityChanged = widget.visible != oldWidget.visible;
    final anchorChanged = widget.anchor != oldWidget.anchor;
    if (visibilityChanged || (widget.visible && anchorChanged)) {
      updateVisibility();
    }

    // Avoid subscribing hidden portals to scroll notifications.
    _syncScrollNotificationObserver();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncScrollNotificationObserver();

    if (widget.visible && widget.anchor is ShadAnchorAuto) {
      final anchor = widget.anchor as ShadAnchorAuto;
      if (anchor.followTargetOnResize) {
        _scheduleAutoPositionUpdate();
      }
    }
  }

  @override
  void dispose() {
    _unsubscribeScrollNotificationObserver();
    hide();
    super.dispose();
  }

  bool get _isAutoAnchor => widget.anchor is ShadAnchorAuto;

  bool get _shouldListenToScrollNotifications =>
      widget.visible && _isAutoAnchor;

  void _unsubscribeScrollNotificationObserver() {
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = null;
  }

  void _syncScrollNotificationObserver() {
    if (!_shouldListenToScrollNotifications) {
      _unsubscribeScrollNotificationObserver();
      return;
    }

    final observer = ScrollNotificationObserver.maybeOf(context);
    if (identical(observer, _scrollNotificationObserver)) return;

    _unsubscribeScrollNotificationObserver();
    _scrollNotificationObserver = observer;
    _scrollNotificationObserver?.addListener(_handleScrollNotification);
  }

  /// Queues a single reposition for the next frame.
  ///
  /// Every caller must go through here. The ad-hoc
  /// `addPostFrameCallback(_calculatePosition)` calls that used to live in
  /// [buildAutoPosition] and [_calculatePosition] bypassed this guard, so a
  /// portal that rebuilt N times in a frame queued N repositions.
  void _scheduleAutoPositionUpdate() {
    if (_autoPositionUpdateScheduled) return;
    _autoPositionUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoPositionUpdateScheduled = false;
      if (!mounted) return;
      _calculatePosition();
    });
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (!widget.visible || !_isAutoAnchor) return;

    // Check if the notification is a scroll update notification and if the
    // `notification.depth` is 0. This way we only listen to the scroll
    // notifications from the closest scrollable, instead of those that may be
    // nested.
    if (notification is ScrollUpdateNotification &&
        defaultScrollNotificationPredicate(notification)) {
      // Recalculate the position of the portal on scroll.
      _scheduleAutoPositionUpdate();
    }
  }

  void updateVisibility() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final shouldShow = widget.visible;
      if (shouldShow) {
        _calculatePosition();
        show();
      } else {
        if (_calculatedTarget != null) {
          setState(() {
            _calculatedTarget = null;
            // The next open starts from the primary position again.
            _usedFallback = false;
            _shift = Offset.zero;
          });
        }
        hide();
      }

      // Keep scroll listener registration in sync with the actual visibility.
      _syncScrollNotificationObserver();
    });
  }

  void hide() {
    if (overlayPortalController.isShowing) {
      overlayPortalController.hide();
    }
  }

  void show() {
    if (!overlayPortalController.isShowing) {
      overlayPortalController.show();
    }
  }

  /// Computes the target offset for the given [anchor] configuration.
  ///
  /// The returned [Offset] is the point in the overlay ancestor's coordinate
  /// system that [ShadPositionDelegate] uses as the top anchor for the
  /// overlay widget (i.e. the overlay's top-left corner is placed at this
  /// point when [ShadPositionDelegate.preferBelow] is `true`).
  Offset _computeTargetForAnchor({
    required RenderBox box,
    required RenderBox overlayAncestor,
    required Size overlaySize,
    required ShadAnchorAuto anchor,
    required TextDirection? textDirection,
  }) {
    final resolvedTargetAnchor = anchor.targetAnchor.resolve(textDirection);
    final resolvedFollowerAnchor = anchor.followerAnchor.resolve(textDirection);

    // Maps alignment coordinates (-1..1) to a position within the box.
    // Formula: (1 + coord) / 2 * size gives 0 at -1, size/2 at 0, size at 1.
    final targetOffset = Offset(
      (1 + resolvedTargetAnchor.x) / 2 * box.size.width,
      (1 + resolvedTargetAnchor.y) / 2 * box.size.height,
    );

    // Compute how much to shift the overlay so that the follower anchor point
    // aligns with the target anchor.
    // x: center the overlay horizontally around the anchor (x/2 * width).
    // y: (y-1)/2 * height shifts the overlay so its follower anchor is at 0;
    //    e.g. y=1 (bottom) → 0, y=0 (center) → -height/2, y=-1 (top) → -height.
    var followerOffset = Offset(
      resolvedFollowerAnchor.x / 2 * overlaySize.width,
      (resolvedFollowerAnchor.y - 1) / 2 * overlaySize.height,
    );

    followerOffset += targetOffset + anchor.offset;

    return box.localToGlobal(followerOffset, ancestor: overlayAncestor);
  }

  void _calculatePosition() {
    // Only auto-position when the overlay is visible.
    if (!mounted || !widget.visible || widget.anchor is! ShadAnchorAuto) return;

    final anchor = widget.anchor as ShadAnchorAuto;
    final box = context.findRenderObject();
    final overlayState = Overlay.of(context, debugRequiredFor: widget);
    final overlayAncestor = overlayState.context.findRenderObject();

    final ready =
        box is RenderBox &&
        box.attached &&
        box.hasSize &&
        overlayAncestor is RenderBox &&
        overlayAncestor.attached &&
        overlayAncestor.hasSize;

    if (!ready) {
      // Through the guard, not a bare callback: retrying directly queues one
      // immortal chain per caller, and each survives until the portal is
      // unmounted or hidden.
      _scheduleAutoPositionUpdate();
      return;
    }

    final overlay = overlayKey.currentContext?.findRenderObject() as RenderBox?;
    final overlaySize = (true == overlay?.hasSize) ? overlay!.size : Size.zero;

    final textDirection = Directionality.maybeOf(context);

    var target = _computeTargetForAnchor(
      box: box,
      overlayAncestor: overlayAncestor,
      overlaySize: overlaySize,
      anchor: anchor,
      textDirection: textDirection,
    );

    // With the overlay's size known, try the fallback chain when the primary
    // position crosses a screen edge, and keep whichever candidate overflows
    // least. [ShadPositionDelegate] centres the overlay on `target.dx` and
    // hangs it below `target.dy`.
    var usedFallback = false;
    if (anchor.fallback != null && overlay != null && overlay.hasSize) {
      final screen = overlayAncestor.size;
      double overflowAlong(double start, double extent, double limit) =>
          math.max(0, -start) + math.max(0, start + extent - limit);
      double overflowOf(Offset t) =>
          overflowAlong(
            t.dx - overlaySize.width / 2,
            overlaySize.width,
            screen.width,
          ) +
          overflowAlong(t.dy, overlaySize.height, screen.height);

      var best = overflowOf(target);
      var candidate = anchor.fallback;
      while (best > 0 && candidate != null) {
        final candidateTarget = _computeTargetForAnchor(
          box: box,
          overlayAncestor: overlayAncestor,
          overlaySize: overlaySize,
          anchor: candidate,
          textDirection: textDirection,
        );
        final overflow = overflowOf(candidateTarget);
        if (overflow < best) {
          best = overflow;
          target = candidateTarget;
          usedFallback = true;
        }
        candidate = candidate.fallback;
      }
    }

    // How far [ShadPositionDelegate] will push the overlay off its anchor to
    // keep it on screen. Worked out here rather than in the delegate because
    // the arrow that needs it is built, not laid out — and `overlaySize` is
    // one frame stale in exactly the way `target` already is.
    var shift = Offset.zero;
    if (overlay != null && overlay.hasSize) {
      shift =
          ShadPositionDelegate.positionFor(
            size: overlayAncestor.size,
            childSize: overlaySize,
            target: target,
            verticalOffset: 0,
            preferBelow: true,
          ) -
          ShadPositionDelegate.anchoredPositionFor(
            childSize: overlaySize,
            target: target,
            verticalOffset: 0,
          );
    }

    if (target != _calculatedTarget ||
        usedFallback != _usedFallback ||
        shift != _shift) {
      if (mounted) {
        setState(() {
          _calculatedTarget = target;
          _usedFallback = usedFallback;
          _shift = shift;
        });
      }
    } else if (overlay == null) {
      _scheduleAutoPositionUpdate();
    } else {
      // The target is unchanged but the overlay render object now exists.
      // Force a rebuild so that the overlay becomes visible (it was initially
      // built with Visibility.maintain(visible: false) while the render
      // object was being created).
      if (mounted) {
        setState(() {});
      }
    }
  }

  Widget buildAutoPosition(
    BuildContext context,
    ShadAnchorAuto anchor,
  ) {
    if (anchor.followTargetOnResize) {
      MediaQuery.sizeOf(context);
    }

    if (_calculatedTarget == null) {
      _scheduleAutoPositionUpdate();
      return const SizedBox.shrink();
    }

    final target = _calculatedTarget!;

    final overlay = overlayKey.currentContext?.findRenderObject() as RenderBox?;

    if (overlay == null) {
      _scheduleAutoPositionUpdate();
    }

    return CustomSingleChildLayout(
      delegate: ShadPositionDelegate(
        target: target,
        verticalOffset: 0,
        preferBelow: true,
      ),
      child: KeyedSubtree(
        key: overlayKey,
        child: Visibility.maintain(
          // The overlay layout details are available only after the view is
          // rendered, in this way we can avoid the flickering effect.
          visible: overlay != null,
          child: IgnorePointer(
            ignoring: overlay == null,
            child: ShadPortalPlacement(
              usedFallback: _usedFallback,
              shift: _shift,
              child: Builder(builder: widget.portalBuilder),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildManualPosition(
    BuildContext context,
    ShadAnchor anchor,
  ) {
    final textDirection = Directionality.maybeOf(context);
    return CompositedTransformFollower(
      link: layerLink,
      offset: anchor.offset,
      // The follower is the overlay and the target is the child; these used
      // to be crossed, which put every manually anchored overlay on the
      // opposite side of the one its alignments named.
      followerAnchor: anchor.overlayAlignment.resolve(textDirection),
      targetAnchor: anchor.childAlignment.resolve(textDirection),
      child: widget.portalBuilder(context),
    );
  }

  Widget buildGlobalPosition(
    BuildContext context,
    ShadGlobalAnchor anchor,
  ) {
    return CustomSingleChildLayout(
      delegate: _ShadPointPositionDelegate(
        point: anchor.offset,
        followerAnchor: anchor.followerAnchor.resolve(
          Directionality.maybeOf(context) ?? TextDirection.ltr,
        ),
      ),
      child: widget.portalBuilder(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: OverlayPortal(
        controller: overlayPortalController,
        overlayChildBuilder: (context) {
          return Center(
            widthFactor: 1,
            heightFactor: 1,
            child: switch (widget.anchor) {
              final ShadAnchorAuto anchor => buildAutoPosition(context, anchor),
              final ShadAnchor anchor => buildManualPosition(context, anchor),
              final ShadGlobalAnchor anchor => buildGlobalPosition(
                context,
                anchor,
              ),
            },
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// A delegate for computing the layout of an overlay to be displayed above or
/// below a target specified in the global coordinate system.
class ShadPositionDelegate extends SingleChildLayoutDelegate {
  /// Creates a delegate for computing the layout of an overlay.
  ShadPositionDelegate({
    required this.target,
    required this.verticalOffset,
    required this.preferBelow,
  });

  /// The offset of the target the overlay is positioned near in the global
  /// coordinate system.
  final Offset target;

  /// The amount of vertical distance between the target and the displayed
  /// overlay.
  final double verticalOffset;

  /// Whether the overlay is displayed below its widget by default.
  ///
  /// If there is insufficient space to display the tooltip in the preferred
  /// direction, the tooltip will be displayed in the opposite direction.
  final bool preferBelow;

  /// Where an overlay of [childSize] lands inside [size].
  ///
  /// Exposed so [ShadPortal] can work out how far this pushed the overlay off
  /// its anchor without re-deriving the rule; see [ShadPortalPlacement.shift].
  static Offset positionFor({
    required Size size,
    required Size childSize,
    required Offset target,
    required double verticalOffset,
    required bool preferBelow,
  }) {
    return positionDependentBox(
      size: size,
      childSize: childSize,
      target: target,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
      margin: 0,
    );
  }

  /// Where an overlay of [childSize] would land if the screen never ran out,
  /// i.e. anchored on [target] with nothing clamped.
  static Offset anchoredPositionFor({
    required Size childSize,
    required Offset target,
    required double verticalOffset,
  }) {
    return Offset(
      target.dx - childSize.width / 2,
      target.dy + verticalOffset,
    );
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return positionFor(
      size: size,
      childSize: childSize,
      target: target,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
    );
  }

  @override
  bool shouldRelayout(ShadPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        verticalOffset != oldDelegate.verticalOffset ||
        preferBelow != oldDelegate.preferBelow;
  }
}

/// Places an overlay so that its [followerAnchor] point sits on [point],
/// mirrored across the point on any axis where it would leave the screen,
/// then clamped onto the screen.
class _ShadPointPositionDelegate extends SingleChildLayoutDelegate {
  _ShadPointPositionDelegate({
    required this.point,
    required this.followerAnchor,
  });

  final Offset point;
  final Alignment followerAnchor;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  /// The start of an overlay of [extent] along one axis, given where on it
  /// (-1..1) the point sits, mirrored when it overflows [limit].
  static double _place(
    double point,
    double align,
    double extent,
    double limit,
  ) {
    double startFor(double a) => point - (1 + a) / 2 * extent;
    var start = startFor(align);
    if (start < 0 || start + extent > limit) {
      final mirrored = startFor(-align);
      if (mirrored >= 0 && mirrored + extent <= limit) start = mirrored;
    }
    return start.clamp(0, math.max(0, limit - extent)).toDouble();
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(
      _place(point.dx, followerAnchor.x, childSize.width, size.width),
      _place(point.dy, followerAnchor.y, childSize.height, size.height),
    );
  }

  @override
  bool shouldRelayout(_ShadPointPositionDelegate oldDelegate) =>
      point != oldDelegate.point ||
      followerAnchor != oldDelegate.followerAnchor;
}
