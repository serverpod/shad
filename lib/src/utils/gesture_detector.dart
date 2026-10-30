import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/utils/extensions/tap_details.dart';

/// Decides which gestures turn the hover state on and off on devices without
/// a mouse.
///
/// [ShadGestureDetector] uses it to give touch devices a hover state. When a
/// mouse pointer is inside the detector, the strategies are ignored.
@immutable
class ShadHoverStrategies {
  /// Creates a set of hover strategies.
  const ShadHoverStrategies({
    this.hover = const {},
    this.unhover = const {},
    this.longPressDuration,
    this.onHoverChange,
  });

  /// The gestures that turn the hover state on. Defaults to none.
  ///
  /// A gesture that is in both [hover] and [unhover] toggles the state.
  final Set<ShadHoverStrategy> hover;

  /// The gestures that turn the hover state off. Defaults to none.
  final Set<ShadHoverStrategy> unhover;

  /// How long a press must last to count as a long press.
  ///
  /// [ShadGestureDetector.longPressDuration] takes precedence. When both are
  /// null, the detector uses [kLongPressTimeout].
  final Duration? longPressDuration;

  /// Called with the new hover state each time it changes.
  final ValueChanged<bool>? onHoverChange;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShadHoverStrategies &&
        setEquals(other.hover, hover) &&
        setEquals(other.unhover, unhover) &&
        other.longPressDuration == longPressDuration &&
        other.onHoverChange == onHoverChange;
  }

  @override
  int get hashCode {
    return hover.hashCode ^
        unhover.hashCode ^
        longPressDuration.hashCode ^
        onHoverChange.hashCode;
  }

  /// Returns a copy with the given fields replaced.
  ShadHoverStrategies copyWith({
    Set<ShadHoverStrategy>? hover,
    Set<ShadHoverStrategy>? unhover,
    Duration? longPressDuration,
    ValueChanged<bool>? onHoverChange,
  }) {
    return ShadHoverStrategies(
      hover: hover ?? this.hover,
      unhover: unhover ?? this.unhover,
      longPressDuration: longPressDuration ?? this.longPressDuration,
      onHoverChange: onHoverChange ?? this.onHoverChange,
    );
  }
}

/// A gesture that can change the hover state of a [ShadGestureDetector].
///
/// Use these values in [ShadHoverStrategies.hover] and
/// [ShadHoverStrategies.unhover].
enum ShadHoverStrategy {
  /// A primary pointer touches down for a tap.
  onTapDown,

  /// A primary pointer lifts up after a tap.
  onTapUp,

  /// A tap does not complete.
  onTapCancel,

  /// A long press starts.
  onLongPressStart,

  /// A long press does not complete.
  onLongPressCancel,

  /// The pointer lifts up after a long press.
  onLongPressUp,

  /// A pointer touches down that can become a long press.
  onLongPressDown,

  /// A long press ends.
  onLongPressEnd,

  /// A pointer touches down for a second tap.
  onDoubleTapDown,

  /// A double tap does not complete.
  onDoubleTapCancel,

  /// A force press starts.
  ///
  /// [ShadGestureDetector] does not read this value at the moment.
  onForcePressStart,

  /// A force press ends.
  ///
  /// [ShadGestureDetector] does not read this value at the moment.
  onForcePressEnd,

  /// A tap completes.
  onTap,

  /// The user taps outside the widget.
  onTapOutside,
}

/// A special [GestureDetector] that handles the hovering state of the [child]
/// on devices where the hover is not supported (eg mobile) with the help of
/// [hoverStrategies].
///
/// If the device supports mouse, the [hoverStrategies] will be ignored and
/// [MouseRegion] will be used instead.
class ShadGestureDetector extends StatefulWidget {
  /// Creates a gesture detector that also tracks the hover state.
  const ShadGestureDetector({
    super.key,
    required this.child,
    this.cursor = MouseCursor.defer,
    this.hoverStrategies,
    this.behavior,
    this.onHoverChange,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTap,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressCancel,
    this.onLongPressMoveUpdate,
    this.onLongPressUp,
    this.onLongPressDown,
    this.onLongPressEnd,
    this.onDoubleTap,
    this.onDoubleTapDown,
    this.onDoubleTapCancel,
    this.longPressDuration,
    this.supportedDevices,
    this.onForcePressStart,
    this.onForcePressPeak,
    this.onForcePressUpdate,
    this.onForcePressEnd,
    this.forceStartPressure = 0.4,
    this.forcePeakPressure = 0.85,
    this.excludeFromSemantics = false,
    this.groupId,
    this.onTapOutside,
    this.onPanDown,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
    this.dragStartBehavior = DragStartBehavior.start,
  });

  /// The strategies that set the hover state on devices without a mouse.
  ///
  /// Defaults to the `hoverStrategies` of the current [ShadTheme].
  final ShadHoverStrategies? hoverStrategies;

  /// Called with the new hover state each time it changes.
  ///
  /// The hover state comes from the mouse when there is one, and from
  /// [hoverStrategies] when there is not.
  final ValueChanged<bool>? onHoverChange;

  /// The mouse cursor shown over the widget. Defaults to [MouseCursor.defer].
  final MouseCursor cursor;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Called when a tap with the primary button completes.
  final VoidCallback? onTap;

  /// Called when the user taps outside the widget.
  final VoidCallback? onTapOutside;

  /// Called when a pointer touches down for a primary tap.
  ///
  /// The global position in the details is relative to the nearest
  /// [Navigator]'s overlay when that is not the root overlay.
  final ValueChanged<TapDownDetails>? onTapDown;

  /// Called when a pointer lifts up after a primary tap.
  ///
  /// The global position follows the same rule as in [onTapDown].
  final ValueChanged<TapUpDetails>? onTapUp;

  /// Called when a primary tap does not complete.
  final VoidCallback? onTapCancel;

  /// Called when a tap with the secondary button completes.
  final VoidCallback? onSecondaryTap;

  /// Called when a pointer touches down for a secondary tap.
  final ValueChanged<TapDownDetails>? onSecondaryTapDown;

  /// Called when a pointer lifts up after a secondary tap.
  final ValueChanged<TapUpDetails>? onSecondaryTapUp;

  /// Called when a secondary tap does not complete.
  final VoidCallback? onSecondaryTapCancel;

  /// Called when a long press is recognized.
  final VoidCallback? onLongPress;

  /// Called when a long press starts, with the pointer position.
  final ValueChanged<LongPressStartDetails>? onLongPressStart;

  /// Called when a long press does not complete.
  final VoidCallback? onLongPressCancel;

  /// Called when the pointer lifts up after a long press.
  final VoidCallback? onLongPressUp;

  /// Called when the pointer moves during a long press.
  final ValueChanged<LongPressMoveUpdateDetails>? onLongPressMoveUpdate;

  /// Called when a pointer touches down that can become a long press.
  final ValueChanged<LongPressDownDetails>? onLongPressDown;

  /// Called when a long press ends, with the pointer position and velocity.
  final ValueChanged<LongPressEndDetails>? onLongPressEnd;

  /// Called when a double tap completes.
  final VoidCallback? onDoubleTap;

  /// Called when a pointer touches down for the second tap of a double tap.
  final ValueChanged<TapDownDetails>? onDoubleTapDown;

  /// Called when a double tap does not complete.
  final VoidCallback? onDoubleTapCancel;

  /// How long a press must last to count as a long press.
  ///
  /// When null, uses [ShadHoverStrategies.longPressDuration], then
  /// [kLongPressTimeout].
  final Duration? longPressDuration;

  /// The kind of devices that are allowed to be recognized.
  ///
  /// If set to null, events from all device types will be recognized. Defaults
  /// to null.
  final Set<PointerDeviceKind>? supportedDevices;

  /// The pointer is in contact with the screen and has pressed with sufficient
  /// force to initiate a force press. The amount of force is at least
  /// [ForcePressGestureRecognizer.startPressure].
  ///
  /// This callback will only be fired on devices with pressure
  /// detecting screens.
  final GestureForcePressStartCallback? onForcePressStart;

  /// The pointer is in contact with the screen and has pressed with the maximum
  /// force. The amount of force is at least
  /// [ForcePressGestureRecognizer.peakPressure].
  ///
  /// This callback will only be fired on devices with pressure
  /// detecting screens.
  final GestureForcePressPeakCallback? onForcePressPeak;

  /// A pointer is in contact with the screen, has previously passed the
  /// [ForcePressGestureRecognizer.startPressure] and is either moving on the
  /// plane of the screen, pressing the screen with varying forces or both
  /// simultaneously.
  ///
  /// This callback will only be fired on devices with pressure
  /// detecting screens.
  final GestureForcePressUpdateCallback? onForcePressUpdate;

  /// The pointer tracked by [onForcePressStart] is no longer in contact with
  /// the screen.
  ///
  /// This callback will only be fired on devices with pressure
  /// detecting screens.
  final GestureForcePressEndCallback? onForcePressEnd;

  /// The pressure at which a force press starts. Defaults to 0.4.
  ///
  /// See [ForcePressGestureRecognizer.startPressure].
  final double forceStartPressure;

  /// The pressure at which a force press reaches its peak. Defaults to 0.85.
  ///
  /// See [ForcePressGestureRecognizer.peakPressure].
  final double forcePeakPressure;

  /// How the detector behaves during hit testing.
  ///
  /// When null, uses the default of [RawGestureDetector].
  final HitTestBehavior? behavior;

  /// Whether to exclude these gestures from the semantics tree. For
  /// example, the long-press gesture for showing a tooltip is
  /// excluded because the tooltip itself is included in the semantics
  /// tree directly and so having a gesture to show it would result in
  /// duplication of information.
  final bool excludeFromSemantics;

  /// A pointer has contacted the screen with a primary button and might begin
  /// to move.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final GestureDragDownCallback? onPanDown;

  /// A pointer has contacted the screen with a primary button and has begun to
  /// move.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final GestureDragStartCallback? onPanStart;

  /// A pointer that is in contact with the screen with a primary button and
  /// moving has moved again.
  ///
  /// See also:
  ///
  ///  * [kPrimaryButton], the button this callback responds to.
  final GestureDragUpdateCallback? onPanUpdate;

  /// A pointer that was previously in contact with the screen with a primary
  /// button and moving is no longer in contact with the screen and was moving
  /// at a specific velocity when it stopped contacting the screen.
  final GestureDragEndCallback? onPanEnd;

  /// The pointer that previously triggered [onPanDown] did not complete.
  final GestureDragCancelCallback? onPanCancel;

  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], gesture drag behavior will
  /// begin at the position where the drag gesture won the arena. If set to
  /// [DragStartBehavior.down] it will begin at the position where a down event
  /// is first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  ///
  /// Only the [DragGestureRecognizer.onStart] callbacks for the
  /// [VerticalDragGestureRecognizer], [HorizontalDragGestureRecognizer] and
  /// [PanGestureRecognizer] are affected by this setting.
  final DragStartBehavior dragStartBehavior;

  /// {@macro ShadMouseArea.groupId}
  final Object? groupId;

  @override
  State<ShadGestureDetector> createState() => _ShadGestureDetectorState();
}

class _ShadGestureDetectorState extends State<ShadGestureDetector> {
  bool hovered = false;

  /// Whether a mouse pointer is currently inside this detector.
  ///
  /// [ShadHoverStrategies] exists for devices with no real hover: it
  /// synthesises a hover state from tap/long-press gestures. On a device that
  /// *does* hover, applying them fights the MouseRegion — `unhover:
  /// {onTapUp, ...}` would clear the highlight the moment a click completes,
  /// even though the cursor has not moved. The class doc already promised the
  /// strategies are ignored when a mouse is present; this enforces it.
  bool mouseInside = false;

  // See https://github.com/nank1ro/flutter-shadcn-ui/issues/319
  Offset correctGlobalPosition(BuildContext context, Offset globalPosition) {
    // Get the root navigator's overlay (screen coordinates)
    final rootNavigator = Navigator.maybeOf(context, rootNavigator: true);
    final rootOverlay = rootNavigator?.overlay;
    if (rootOverlay == null) return globalPosition;

    // Get the shell navigator's overlay (nearest Navigator)
    final shellNavigator = Navigator.maybeOf(context);
    final shellOverlay = shellNavigator?.overlay;
    if (shellOverlay == null || shellOverlay == rootOverlay) {
      return globalPosition;
    }

    final shellRenderObject = shellOverlay.context.findRenderObject();
    if (shellRenderObject is! RenderBox) {
      return globalPosition;
    }

    final shellOffset = shellRenderObject.localToGlobal(Offset.zero);
    final correctedPosition = globalPosition - shellOffset;

    return correctedPosition;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final configuration = ScrollConfiguration.of(context);

    final effectiveHoverStrategies =
        widget.hoverStrategies ?? theme.hoverStrategies;
    final gestures = <Type, GestureRecognizerFactory>{};
    final gestureSettings = MediaQuery.maybeGestureSettingsOf(context);

    void setHover(ShadHoverStrategy strategy) {
      // A real hover is already being tracked by the MouseRegion below.
      if (mouseInside) return;

      final presentInHover = effectiveHoverStrategies.hover.contains(strategy);
      final presentInUnhover = effectiveHoverStrategies.unhover.contains(
        strategy,
      );

      // Toggle the hover state if the strategy is present in both hover and
      // unhover sets.
      if (presentInHover && presentInUnhover) {
        hovered = !hovered;
        widget.onHoverChange?.call(hovered);
        effectiveHoverStrategies.onHoverChange?.call(hovered);
        return;
      }

      if (presentInHover) {
        widget.onHoverChange?.call(true);
        effectiveHoverStrategies.onHoverChange?.call(true);
        hovered = true;
      } else if (presentInUnhover) {
        widget.onHoverChange?.call(false);
        effectiveHoverStrategies.onHoverChange?.call(false);
        hovered = false;
      }
    }

    void effectiveOnTapDown(TapDownDetails d) {
      setHover(ShadHoverStrategy.onTapDown);
      final correctedGlobalPosition = correctGlobalPosition(
        context,
        d.globalPosition,
      );
      widget.onTapDown?.call(
        d.copyWith(globalPosition: correctedGlobalPosition),
      );
    }

    void effectiveOnTap() {
      setHover(ShadHoverStrategy.onTap);
      widget.onTap?.call();
    }

    void effectiveOnTapOutside(PointerDownEvent event) {
      setHover(ShadHoverStrategy.onTapOutside);
      widget.onTapOutside?.call();
    }

    void effectiveOnSecondaryTapDown(TapDownDetails d) {
      final correctedGlobalPosition = correctGlobalPosition(
        context,
        d.globalPosition,
      );
      widget.onSecondaryTapDown?.call(
        d.copyWith(globalPosition: correctedGlobalPosition),
      );
    }

    void effectiveOnSecondaryTapUp(TapUpDetails d) {
      final correctedGlobalPosition = correctGlobalPosition(
        context,
        d.globalPosition,
      );
      widget.onSecondaryTapUp?.call(
        d.copyWith(globalPosition: correctedGlobalPosition),
      );
    }

    void effectiveOnSecondaryTapCancel() {
      widget.onSecondaryTapCancel?.call();
    }

    void effectiveOnSecondaryTap() {
      widget.onSecondaryTap?.call();
    }

    void effectiveOnTapUp(TapUpDetails d) {
      setHover(ShadHoverStrategy.onTapUp);
      final correctedGlobalPosition = correctGlobalPosition(
        context,
        d.globalPosition,
      );
      widget.onTapUp?.call(d.copyWith(globalPosition: correctedGlobalPosition));
    }

    void effectiveOnTapCancel() {
      setHover(ShadHoverStrategy.onTapCancel);
      widget.onTapCancel?.call();
    }

    void effectiveOnDoubleTapDown(TapDownDetails d) {
      setHover(ShadHoverStrategy.onDoubleTapDown);
      final correctedGlobalPosition = correctGlobalPosition(
        context,
        d.globalPosition,
      );
      widget.onDoubleTapDown?.call(
        d.copyWith(globalPosition: correctedGlobalPosition),
      );
    }

    void effectiveOnDoubleTapCancel() {
      setHover(ShadHoverStrategy.onDoubleTapCancel);
      widget.onDoubleTapCancel?.call();
    }

    void effectiveOnLongPressStart(LongPressStartDetails d) {
      setHover(ShadHoverStrategy.onLongPressStart);
      final correctedGlobalPosition = correctGlobalPosition(
        context,
        d.globalPosition,
      );
      widget.onLongPressStart?.call(
        d.copyWith(globalPosition: correctedGlobalPosition),
      );
    }

    void effectiveOnLongPressCancel() {
      setHover(ShadHoverStrategy.onLongPressCancel);
      widget.onLongPressCancel?.call();
    }

    void effectiveOnLongPressUp() {
      setHover(ShadHoverStrategy.onLongPressUp);
      widget.onLongPressUp?.call();
    }

    void effectiveOnLongPressDown(LongPressDownDetails d) {
      setHover(ShadHoverStrategy.onLongPressDown);
      final correctedGlobalPosition = correctGlobalPosition(
        context,
        d.globalPosition,
      );
      widget.onLongPressDown?.call(
        d.copyWith(globalPosition: correctedGlobalPosition),
      );
    }

    void effectiveOnLongPressEnd(LongPressEndDetails d) {
      setHover(ShadHoverStrategy.onLongPressEnd);
      final correctedGlobalPosition = correctGlobalPosition(
        context,
        d.globalPosition,
      );
      widget.onLongPressEnd?.call(
        d.copyWith(globalPosition: correctedGlobalPosition),
      );
    }

    gestures[TapGestureRecognizer] =
        GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(
            debugOwner: this,
            supportedDevices: widget.supportedDevices,
          ),
          (TapGestureRecognizer instance) {
            instance
              ..onTapDown = effectiveOnTapDown
              ..onTapUp = effectiveOnTapUp
              ..onTap = effectiveOnTap
              ..onTapCancel = effectiveOnTapCancel
              ..onSecondaryTapDown = effectiveOnSecondaryTapDown
              ..onSecondaryTapUp = effectiveOnSecondaryTapUp
              ..onSecondaryTap = effectiveOnSecondaryTap
              ..onSecondaryTapCancel = effectiveOnSecondaryTapCancel
              ..gestureSettings = gestureSettings
              ..supportedDevices = widget.supportedDevices;
          },
        );

    if (widget.onDoubleTap != null ||
        widget.onDoubleTapDown != null ||
        widget.onDoubleTapCancel != null) {
      gestures[DoubleTapGestureRecognizer] =
          GestureRecognizerFactoryWithHandlers<DoubleTapGestureRecognizer>(
            () => DoubleTapGestureRecognizer(
              debugOwner: this,
              supportedDevices: widget.supportedDevices,
            ),
            (DoubleTapGestureRecognizer instance) {
              instance
                ..onDoubleTapDown = effectiveOnDoubleTapDown
                ..onDoubleTap = widget.onDoubleTap
                ..onDoubleTapCancel = effectiveOnDoubleTapCancel
                ..gestureSettings = gestureSettings
                ..supportedDevices = widget.supportedDevices;
            },
          );
    }

    if (widget.onLongPressDown != null ||
        widget.onLongPressCancel != null ||
        widget.onLongPress != null ||
        widget.onLongPressStart != null ||
        widget.onLongPressMoveUpdate != null ||
        widget.onLongPressUp != null ||
        widget.onLongPressEnd != null) {
      gestures[LongPressGestureRecognizer] =
          GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
            () => LongPressGestureRecognizer(
              duration:
                  widget.longPressDuration ??
                  effectiveHoverStrategies.longPressDuration ??
                  kLongPressTimeout,
              debugOwner: this,
              supportedDevices: widget.supportedDevices,
            ),
            (LongPressGestureRecognizer instance) {
              instance
                ..onLongPressDown = effectiveOnLongPressDown
                ..onLongPressCancel = effectiveOnLongPressCancel
                ..onLongPress = widget.onLongPress
                ..onLongPressStart = effectiveOnLongPressStart
                ..onLongPressMoveUpdate = widget.onLongPressMoveUpdate
                ..onLongPressUp = effectiveOnLongPressUp
                ..onLongPressEnd = effectiveOnLongPressEnd
                ..gestureSettings = gestureSettings
                ..supportedDevices = widget.supportedDevices;
            },
          );
    }

    if (widget.onForcePressStart != null ||
        widget.onForcePressPeak != null ||
        widget.onForcePressUpdate != null ||
        widget.onForcePressEnd != null) {
      gestures[ForcePressGestureRecognizer] =
          GestureRecognizerFactoryWithHandlers<ForcePressGestureRecognizer>(
            () => ForcePressGestureRecognizer(
              debugOwner: this,
              supportedDevices: widget.supportedDevices,
              startPressure: widget.forceStartPressure,
              peakPressure: widget.forcePeakPressure,
            ),
            (ForcePressGestureRecognizer instance) {
              instance
                ..onStart = widget.onForcePressStart
                ..onPeak = widget.onForcePressPeak
                ..onUpdate = widget.onForcePressUpdate
                ..onEnd = widget.onForcePressEnd
                ..gestureSettings = gestureSettings
                ..supportedDevices = widget.supportedDevices;
            },
          );
    }

    if (widget.onPanDown != null ||
        widget.onPanStart != null ||
        widget.onPanUpdate != null ||
        widget.onPanEnd != null ||
        widget.onPanCancel != null) {
      gestures[PanGestureRecognizer] =
          GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
            () => PanGestureRecognizer(
              debugOwner: this,
              supportedDevices: widget.supportedDevices,
            ),
            (PanGestureRecognizer instance) {
              instance
                ..onDown = widget.onPanDown
                ..onStart = widget.onPanStart
                ..onUpdate = widget.onPanUpdate
                ..onEnd = widget.onPanEnd
                ..onCancel = widget.onPanCancel
                ..dragStartBehavior = widget.dragStartBehavior
                ..multitouchDragStrategy = configuration
                    .getMultitouchDragStrategy(context)
                ..gestureSettings = gestureSettings
                ..supportedDevices = widget.supportedDevices;
            },
          );
    }

    return TapRegion(
      onTapOutside: effectiveOnTapOutside,
      groupId: widget.groupId,
      child: MouseRegion(
        cursor: widget.cursor,
        onEnter: (_) {
          mouseInside = true;
          hovered = true;
          widget.onHoverChange?.call(true);
          effectiveHoverStrategies.onHoverChange?.call(true);
        },
        onExit: (_) {
          mouseInside = false;
          hovered = false;
          widget.onHoverChange?.call(false);
          effectiveHoverStrategies.onHoverChange?.call(false);
        },
        child: RawGestureDetector(
          gestures: gestures,
          behavior: widget.behavior,
          excludeFromSemantics: widget.excludeFromSemantics,
          child: widget.child,
        ),
      ),
    );
  }
}
