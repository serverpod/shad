import 'dart:async';
import 'dart:math' as math;

import 'package:boxy/boxy.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shad/src/components/toast.dart';
import 'package:shad/src/theme/components/sonner.dart';
import 'package:shad/src/theme/data.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/utils/animate.dart';
import 'package:shad/src/utils/mouse_area.dart';
import 'package:shad/src/utils/responsive.dart';

///
/// Allows descendants to access the toaster state via [ShadSonner.of] or
/// [ShadSonner.maybeOf] for showing and hiding toasts.
class ShadSonnerScope extends InheritedWidget {
  /// Creates a scope widget that holds the [ShadSonnerState] and child.
  const ShadSonnerScope({
    super.key,
    required super.child,
    required this.shadMessengerState,
  });

  /// The [ShadSonnerState] instance managing toast display.
  final ShadSonnerState shadMessengerState;

  @override
  bool updateShouldNotify(ShadSonnerScope oldWidget) =>
      shadMessengerState != oldWidget.shadMessengerState;
}

/// A widget that manages and displays toasts within the widget tree.
///
/// The [ShadSonner] widget acts as a provider for toast notifications,
/// displaying them as overlays on top of its child widget. It uses an
/// [InheritedWidget] to allow descendants to access its state and show toasts
/// via [ShadSonner.of].
class ShadSonner extends StatefulWidget {
  /// Creates a toaster widget that wraps the provided child.
  const ShadSonner({
    super.key,
    required this.child,
    int? maxVisibleToasts,
    @Deprecated(
      'Use maxVisibleToasts. Will be removed in the next major version.',
    )
    int? visibleToastsAmount,
    this.alignment,
    this.padding,
    this.expandedGap,
    this.collapsedGap,
    this.scaleFactor,
    this.animationDuration,
    this.animationCurve,
  }) : maxVisibleToasts = maxVisibleToasts ?? visibleToastsAmount;

  /// The widget below the toaster in the tree, over which toasts are displayed.
  /// Typically the main app content.
  final Widget child;

  /// {@template ShadSonner.visible_toasts_amount}
  /// The maximum number of toasts that can be displayed at once.
  ///
  /// Defaults to 3 if not provided.
  /// {@endtemplate}
  final int? maxVisibleToasts;

  /// The old name of [maxVisibleToasts].
  @Deprecated(
    'Use maxVisibleToasts. Will be removed in the next major version.',
  )
  int? get visibleToastsAmount => maxVisibleToasts;

  /// {@template ShadSonner.alignment}
  /// The alignment of the toasts within the widget.
  ///
  /// Defaults to [Alignment.bottomRight] if not provided.
  /// {@endtemplate}
  final AlignmentGeometry? alignment;

  /// {@template ShadSonner.padding}
  /// The padding around the toasts.
  ///
  /// Defaults to [EdgeInsets.all(16)] if not provided.
  /// {@endtemplate}
  final EdgeInsetsGeometry? padding;

  /// {@template ShadSonner.expandedGap}
  /// The gap between toasts in the expanded state.
  ///
  /// Defaults to 8.0 if not provided.
  /// {@endtemplate}
  final double? expandedGap;

  /// {@template ShadSonner.collapsedGap}
  /// The gap between toasts in the collapsed state.
  ///
  /// Defaults to 16.0 if not provided.
  /// {@endtemplate}
  final double? collapsedGap;

  /// {@template ShadSonner.scaleFactor}
  /// The scale factor for the toasts when they are collapsed.
  /// The scale factor is applied to the width and height of the toasts.
  /// The most recent toast will have no scale factor.
  /// The second toast will be scaled to `0.95` if the `scaleFactor` is `0.05`
  /// (1 - 0.05).
  /// The third toast will be scaled to `0.90` if the `scaleFactor` is `0.05`
  /// (1 - 0.05 * 2).
  ///
  /// Defaults to 0.05 if not provided.
  /// {@endtemplate}
  final double? scaleFactor;

  /// {@template ShadSonner.animationDuration}
  /// The duration of the animation when showing and hiding toasts.
  ///
  /// Defaults to 300 milliseconds if not provided.
  /// {@endtemplate}
  final Duration? animationDuration;

  /// {@template ShadSonner.animationCurve}
  /// The curve used for the animation when showing and hiding toasts.
  ///
  /// Defaults to [Cubic(0.215, 0.61, 0.355, 1)] if not provided.
  /// {@endtemplate}
  final Curve? animationCurve;

  @override
  State<ShadSonner> createState() => ShadSonnerState();

  /// Retrieves the [ShadSonnerState] from the nearest [ShadSonner] ancestor.
  ///
  /// Throws a [FlutterError] if no [ShadSonner] is found in the widget tree.
  static ShadSonnerState of(BuildContext context) {
    final provider = maybeOf(context);
    if (provider == null) {
      throw FlutterError(
        '''Could not find ShadSonner InheritedWidget in the ancestor widget tree.''',
      );
    }
    return provider;
  }

  /// Attempts to retrieve the [ShadSonnerState] from the nearest [ShadSonner]
  /// ancestor.
  ///
  /// Returns null if no [ShadSonner] is found, allowing optional access.
  static ShadSonnerState? maybeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ShadSonnerScope>();
    return scope?.shadMessengerState;
  }
}

/// The state of one toast in a [ShadSonner].
class ShadToastInfo {
  /// Creates the state of a toast. The toast starts visible.
  ShadToastInfo({
    required this.id,
    required this.toast,
    required this.controller,
    this.visible = true,
    this.temporarilyHide = false,
  });

  /// The identifier of the toast.
  final Object id;

  /// The toast to show.
  final ShadToast toast;

  /// Drives the enter and exit animation of the toast.
  final AnimationController controller;

  /// Whether the toast is shown. It becomes false when the toast starts to
  /// hide.
  bool visible;

  /// Whether the toast is off screen because too many toasts are visible.
  bool temporarilyHide;

  /// Hides the toast when its display duration ends. Cancelled while the
  /// pointer is over the toasts.
  Timer? timer;
}

/// The state of a [ShadSonner]. Use it to show and hide toasts.
///
/// Get it with `ShadSonner.of(context)`.
class ShadSonnerState extends State<ShadSonner> with TickerProviderStateMixin {
  /// The sonner theme of the current [ShadTheme].
  ShadSonnerTheme get sonnerTheme =>
      ShadTheme.of(context, listen: false).sonnerTheme;

  /// How many toasts are on screen at once.
  int get maxVisibleToasts =>
      widget.maxVisibleToasts ?? sonnerTheme.maxVisibleToasts ?? 3;

  final _temporarelyHiddenToasts = <ShadToastInfo>[];
  final _toasts = <ShadToastInfo>[];

  /// How long a toast takes to enter and exit. Defaults to 300 milliseconds.
  Duration get animationDuration =>
      widget.animationDuration ??
      sonnerTheme.animationDuration ??
      const Duration(milliseconds: 300);

  /// The curve of the enter and exit animation. Defaults to an ease-out cubic
  /// curve.
  Curve get animationCurve =>
      widget.animationCurve ??
      sonnerTheme.animationCurve ??
      const Cubic(0.215, 0.61, 0.355, 1);

  /// Expands the stack of toasts while the pointer is over it.
  @protected
  late final animationController = AnimationController(
    vsync: this,
    duration: animationDuration,
  );

  /// The expansion of the stack of toasts, from 0 (stacked) to 1 (expanded).
  late final animation = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(curve: animationCurve, parent: animationController),
  );

  /// Whether the pointer is over the toasts.
  @protected
  final hovered = ValueNotifier(false);

  /// The theme published to the toast subtree, memoized on the ambient theme.
  ///
  /// `ShadThemeData.copyWith` re-runs all 54 component-theme merges, and this
  /// wraps the entire app, so recomputing it on every build was wasteful.
  ShadThemeData? _ambientTheme;
  late ShadThemeData _toastSubtreeTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = ShadTheme.of(context);
    if (identical(theme, _ambientTheme)) return;
    _ambientTheme = theme;
    _toastSubtreeTheme = theme.copyWith(
      primaryToastTheme: theme.primaryToastTheme.copyWith(
        closeIcon: const SizedBox.shrink(),
        padding: const EdgeInsets.all(16),
        titleStyle: theme.primaryToastTheme.titleStyle?.copyWith(fontSize: 13),
        descriptionStyle: theme.primaryToastTheme.descriptionStyle?.copyWith(
          fontSize: 13,
        ),
      ),
      destructiveToastTheme: theme.destructiveToastTheme.copyWith(
        closeIcon: const SizedBox.shrink(),
        padding: const EdgeInsets.all(16),
        titleStyle: theme.destructiveToastTheme.titleStyle?.copyWith(
          fontSize: 13,
        ),
        descriptionStyle: theme.destructiveToastTheme.descriptionStyle
            ?.copyWith(fontSize: 13),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    hovered.addListener(() {
      if (hovered.value) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    // Toasts queued beyond [maxVisibleToasts] live in
    // [_temporarelyHiddenToasts], not [_toasts]. Draining only the latter
    // leaked an AnimationController (and its ticker) plus a Timer per queued
    // toast.
    for (final toast in [..._toasts, ..._temporarelyHiddenToasts]) {
      toast.timer?.cancel();
      toast.timer = null;
      toast.controller.dispose();
    }
    _toasts.clear();
    _temporarelyHiddenToasts.clear();
    hovered.dispose();
    super.dispose();
  }

  /// Shows the provided [ShadToast] and returns an identifier for the toast.
  ///
  /// The identifier will match the provided [ShadToast.id] if it is not null,
  /// otherwise it will be a [UniqueKey].
  Object? show(
    ShadToast toast, {
    // Whether to append the toast to the end of the list or insert it at the
    // beginning.
    bool append = true,
  }) {
    final controller = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    final effectiveId = toast.id ?? UniqueKey();
    final toastInfo = ShadToastInfo(
      id: effectiveId,
      toast: toast,
      controller: controller,
    );

    final newToastsLength = _toasts.length + 1;
    if (newToastsLength > maxVisibleToasts) {
      hideTemporarily(_toasts.first.id);
    }
    setState(() {
      append ? _toasts.add(toastInfo) : _toasts.insert(0, toastInfo);
    });

    controller.forward();

    toastInfo.timer = Timer(toast.resolveDisplayDuration(context), () {
      hide(effectiveId);
    });
    return effectiveId;
  }

  /// Hides the toast with the provided [id]entifier.
  Future<void> hide(Object? id) async {
    final toastInfo = _toasts.firstWhereOrNull((toast) => toast.id == id);
    if (toastInfo == null) return;
    setState(() {
      toastInfo.visible = false;
    });
    toastInfo.timer?.cancel();
    toastInfo.timer = null;

    await toastInfo.controller.reverse();
    // The widget can be disposed while the exit animation runs; dispose() has
    // already cancelled the timer and disposed the controller by then, so
    // continuing here would double-dispose and setState after dispose.
    if (!mounted) return;
    toastInfo.controller.dispose();
    setState(() {
      _toasts.remove(toastInfo);
      if (_temporarelyHiddenToasts.isNotEmpty &&
          _toasts.length < maxVisibleToasts) {
        final hiddenToast = _temporarelyHiddenToasts.removeLast();
        // show() mints a fresh controller for the requeued toast, so the one
        // this entry carried while hidden has to go — it is never reachable
        // again, and ShadSonner wraps the whole app, so these accumulate for
        // the entire session.
        hiddenToast.controller.dispose();
        show(hiddenToast.toast, append: false);
      }
    });
  }

  /// The old, misspelled name of [hideTemporarily].
  @Deprecated('Use hideTemporarily. Will be removed in the next major version.')
  Future<void> hideTemporarely(Object? id) => hideTemporarily(id);

  /// Temporarily hides the toast with the provided [id]entifier.
  ///
  /// The toast leaves the screen but stays in the queue, and is shown again
  /// when there is space for it.
  Future<void> hideTemporarily(Object? id) async {
    final toastInfo = _toasts.firstWhereOrNull((toast) => toast.id == id);
    if (toastInfo == null) return;

    toastInfo.controller.reset();
    await toastInfo.controller.forward();
    if (!mounted) return;
    setState(() {
      toastInfo.temporarilyHide = true;
      // A queued toast must not count down while it is off screen; show()
      // gives it a fresh timer when it comes back.
      toastInfo.timer?.cancel();
      toastInfo.timer = null;
      _toasts.remove(toastInfo);
      _temporarelyHiddenToasts.add(toastInfo);
    });
  }

  /// Expands the stack and pauses the timers of the toasts.
  @protected
  void onEnter(PointerEnterEvent event) {
    if (hovered.value) return;
    hovered.value = true;
    for (final toast in _toasts) {
      toast.timer?.cancel();
    }
  }

  /// Collapses the stack and restarts the timers of the toasts.
  @protected
  void onExit(PointerExitEvent event) {
    if (!hovered.value) return;
    hovered.value = false;
    for (final toast in _toasts) {
      toast.timer = Timer(toast.toast.resolveDisplayDuration(context), () {
        hide(toast.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final effectiveAlignment =
        widget.alignment ??
        theme.sonnerTheme.alignment ??
        Alignment.bottomRight;

    final effectivePadding =
        widget.padding ?? theme.sonnerTheme.padding ?? const EdgeInsets.all(16);

    final effectiveExpandedGap =
        widget.expandedGap ?? theme.sonnerTheme.expandedGap ?? 8.0;

    final effectiveCollapsedGap =
        widget.collapsedGap ?? theme.sonnerTheme.collapsedGap ?? 16.0;

    final effectiveScaleFactor =
        widget.scaleFactor ?? theme.sonnerTheme.scaleFactor ?? 0.05;

    return ShadSonnerScope(
      shadMessengerState: this,
      child: ShadTheme(
        data: _toastSubtreeTheme,
        child: ValueListenableBuilder(
          valueListenable: hovered,
          builder: (context, isHovered, child) {
            return Stack(
              alignment: effectiveAlignment,
              children: [
                widget.child,
                ShadResponsiveBuilder(
                  builder: (context, breakpoint) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: breakpoint >= theme.breakpoints.md
                            ? 0
                            : double.infinity,
                        maxWidth: breakpoint >= theme.breakpoints.md
                            ? 420
                            : double.infinity,
                      ),
                      child: ShadMouseArea(
                        onEnter: onEnter,
                        onExit: onExit,
                        child: Padding(
                          padding: effectivePadding,
                          // This ColoredBox keeps the hover working even for
                          // the empty spaces
                          child: ColoredBox(
                            color: const Color(0x00000000),
                            child: CustomBoxy(
                              delegate: _SonnerBoxy(
                                animation: animation,
                                collapsedGap: effectiveCollapsedGap,
                                expandedGap: effectiveExpandedGap,
                              ),
                              children: _toasts.mapIndexed((index, toastInfo) {
                                final x =
                                    effectiveScaleFactor *
                                    (_toasts.length - 1 - index);
                                final scaleX = 1.0 - x;
                                final toast = toastInfo.toast;

                                final effectiveToastTheme =
                                    switch (toast.variant) {
                                      ShadToastVariant.primary =>
                                        theme.primaryToastTheme,
                                      ShadToastVariant.destructive =>
                                        theme.destructiveToastTheme,
                                    };

                                final effectiveToastAlignment =
                                    toast.alignment ??
                                    effectiveToastTheme.alignment ??
                                    Alignment.bottomRight;
                                // ignore: omit_local_variable_types
                                final List<Effect<dynamic>> defaultAnimateIn =
                                    switch (effectiveToastAlignment) {
                                      Alignment.bottomRight ||
                                      Alignment.bottomLeft ||
                                      Alignment.bottomCenter => [
                                        const FadeEffect(),
                                        const SlideEffect(
                                          begin: Offset(0, 1),
                                          end: Offset.zero,
                                        ),
                                      ],
                                      Alignment.topRight ||
                                      Alignment.topLeft ||
                                      Alignment.topCenter => [
                                        const FadeEffect(),
                                        const SlideEffect(
                                          begin: Offset(0, -1),
                                          end: Offset.zero,
                                        ),
                                      ],
                                      Alignment.centerRight ||
                                      Alignment.topRight ||
                                      Alignment.bottomRight => [
                                        const FadeEffect(),
                                        const SlideEffect(
                                          begin: Offset(1, 0),
                                          end: Offset.zero,
                                        ),
                                      ],
                                      Alignment.centerLeft ||
                                      Alignment.topLeft ||
                                      Alignment.bottomLeft => [
                                        const FadeEffect(),
                                        const SlideEffect(
                                          begin: Offset(-1, 0),
                                          end: Offset.zero,
                                        ),
                                      ],
                                      Alignment.center || Alignment() => [
                                        const FadeEffect(),
                                        const ScaleEffect(
                                          begin: Offset(.95, .95),
                                          end: Offset(1, 1),
                                        ),
                                      ],
                                    };

                                // ignore: omit_local_variable_types
                                final List<Effect<dynamic>> defaultAnimateOut =
                                    switch (effectiveToastAlignment) {
                                      Alignment.bottomRight ||
                                      Alignment.topRight ||
                                      Alignment.centerRight => const [
                                        SlideEffect(
                                          begin: Offset.zero,
                                          end: Offset(0, -0.10),
                                        ),
                                        FadeEffect(
                                          begin: 1,
                                          end: 0,
                                        ),
                                      ],
                                      Alignment.topLeft ||
                                      Alignment.centerLeft ||
                                      Alignment.bottomLeft => const [
                                        SlideEffect(
                                          begin: Offset.zero,
                                          end: Offset(-1, 0),
                                        ),
                                      ],
                                      Alignment.topCenter => [
                                        const SlideEffect(
                                          begin: Offset.zero,
                                          end: Offset(0, -1),
                                        ),
                                      ],
                                      Alignment.bottomCenter => [
                                        const SlideEffect(
                                          begin: Offset.zero,
                                          end: Offset(0, 1),
                                        ),
                                      ],
                                      Alignment.center || Alignment() => [
                                        const FadeEffect(begin: 1, end: 0),
                                        const ScaleEffect(
                                          begin: Offset(1, 1),
                                          end: Offset(.95, .95),
                                        ),
                                      ],
                                    };

                                final effectiveAnimateIn =
                                    toast.animateIn ??
                                    effectiveToastTheme.animateIn ??
                                    defaultAnimateIn;
                                final effectiveAnimateOut =
                                    toast.animateOut ??
                                    effectiveToastTheme.animateOut ??
                                    defaultAnimateOut;

                                return ShadAnimate(
                                  autoPlay: false,
                                  controller: animationController,
                                  effects: [
                                    ScaleEffect(
                                      begin: Offset(scaleX, scaleX),
                                      end: const Offset(1, 1),
                                    ),
                                  ],
                                  child: ShadAnimate(
                                    autoPlay: false,
                                    controller: toastInfo.controller,
                                    effects: toastInfo.temporarilyHide
                                        ? effectiveAnimateOut
                                        : effectiveAnimateIn,
                                    child: ClipRect(
                                      child: OverflowBox(
                                        alignment:
                                            AlignmentDirectional.topStart,
                                        maxHeight: double.infinity,
                                        child: toast,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Renders the layout of the toasts, stacking them when animation is at 0, and
/// arranging them like in a column when animation is at 1.
///
/// The [collapsedGap] is the gap between toasts when they are stacked, and the
/// [expandedGap] is the gap between toasts when they expanded.
class _SonnerBoxy extends BoxyDelegate {
  _SonnerBoxy({
    required this.animation,
    this.collapsedGap = 16,
    this.expandedGap = 8,
  }) : super(relayout: animation);

  final Animation<double> animation;
  // Gap between toasts in expanded state
  final double expandedGap;
  // Gap between toasts in collapsed state
  final double collapsedGap;

  @override
  Size layout() {
    if (children.isEmpty) return Size.zero;

    // Step 1: Calculate the intrinsic sizes of all children
    final widths = <double>[];
    final heights = <double>[];
    for (final child in children) {
      final width = child.render.getMaxIntrinsicWidth(double.infinity);
      widths.add(width);
      final height = child.render.getMaxIntrinsicHeight(width);
      heights.add(height);
    }

    // Step 2: Determine the max width of the layout
    final maxWidth = math.max(
      widths.reduce(math.max),
      constraints.maxWidth,
    );

    final frontToastHeight = heights.last;

    // Step 3: Layout children with height normalization in collapsed mode
    // When collapsed, all toasts should match the front toast's height
    // to create a uniform stacked appearance.
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      final naturalHeight = heights[i];
      final isFrontToast = i == children.length - 1;

      // Interpolate height: collapsed uses front toast height, expanded uses
      // natural height
      final targetHeight = isFrontToast
          ? naturalHeight
          : frontToastHeight +
                (naturalHeight - frontToastHeight) * animation.value;

      child.layout(
        constraints.copyWith(
          minHeight: targetHeight,
          maxHeight: targetHeight,
        ),
      );
    }

    final totalHeightExpanded =
        heights.fold<double>(0, (a, b) => a + b) +
        expandedGap * (heights.length - 1);
    // Calculate collapsed height (when all toasts are stacked)
    final totalHeightCollapsed =
        frontToastHeight + (heights.length - 1) * collapsedGap;

    // Interpolate between collapsed and expanded height based on animation
    final currentHeight =
        totalHeightCollapsed +
        (totalHeightExpanded - totalHeightCollapsed) * animation.value;

    // Step 4: Position the children based on the animation value
    final numChildren = children.length;

    for (final (i, child) in children.indexed) {
      double targetY;

      if (i == numChildren - 1) {
        targetY = currentHeight - frontToastHeight;
      } else {
        final expandedY =
            heights.sublist(0, i).fold<double>(0, (a, b) => a + b) +
            expandedGap * i;
        final collapsedY =
            currentHeight -
            frontToastHeight -
            (numChildren - 1 - i) * collapsedGap;
        targetY = collapsedY + (expandedY - collapsedY) * animation.value;
      }
      targetY = math.max(0, targetY);
      child.position(Offset(0, targetY));
    }

    // Step 5: Return the total size of the layout
    return Size(maxWidth, currentHeight);
  }
}
