import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shad/src/raw_components/focusable.dart';

import 'package:shad/src/theme/components/slider.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/utils/gesture_detector.dart';
import 'package:shad/src/utils/shadow.dart';

/// Possible ways for a user to interact with a [ShadSlider].
enum ShadSliderInteraction {
  /// Allows the user to interact with a [ShadSlider] by tapping or sliding
  /// anywhere on the track.
  ///
  /// Essentially all possible interactions are allowed.
  ///
  /// This is different from [ShadSliderInteraction.slideOnly] as when you try
  /// to slide anywhere other than the thumb, the thumb will move to the first
  /// point of contact.
  tapAndSlide,

  /// Allows the user to interact with a [ShadSlider] by only tapping anywhere
  /// on the track.
  ///
  /// Sliding interaction is ignored.
  tapOnly,

  /// Allows the user to interact with a [ShadSlider] only by sliding anywhere
  /// on the track.
  ///
  /// Tapping interaction is ignored.
  slideOnly,

  /// Allows the user to interact with a [ShadSlider] only by sliding the thumb.
  ///
  /// Tapping and sliding interactions on the track are ignored.
  slideThumb,
}

/// {@template ShadSliderController}
/// A controller for the [ShadSlider] widget, managing its value.
///
/// Extends [ValueNotifier] to provide reactive updates when the slider value
/// changes.
/// {@endtemplate}
class ShadSliderController extends ValueNotifier<double> {
  /// Creates a [ShadSliderController] with an initial value.
  ShadSliderController({
    required double initialValue,
  }) : super(initialValue);
}

/// {@template ShadRangeSliderController}
/// A controller for the [ShadRangeSlider] widget, managing its values — one
/// per thumb, in ascending order.
///
/// Extends [ValueNotifier] to provide reactive updates when any of the values
/// change.
/// {@endtemplate}
class ShadRangeSliderController extends ValueNotifier<List<double>> {
  /// Creates a [ShadRangeSliderController] with the initial values.
  ShadRangeSliderController({
    required List<double> initialValues,
  }) : super(List<double>.of(initialValues));
}

/// A customizable slider widget styled to match the Shadcn UI design system.
///
/// Allows users to select a value from a continuous range by dragging a thumb
/// along a track.
///
/// See [ShadRangeSlider] for a slider with more than one thumb.
class ShadSlider extends StatefulWidget {
  /// Creates a [ShadSlider].
  ///
  /// Either [initialValue] or [controller] must be provided to determine the
  /// slider's starting value.
  const ShadSlider({
    super.key,
    this.initialValue,
    this.onChanged,
    this.enabled = true,
    this.min,
    this.max,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
    this.mouseCursor,
    this.disabledMouseCursor,
    this.thumbColor,
    this.disabledThumbColor,
    this.thumbBorderColor,
    this.disabledThumbBorderColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.disabledActiveTrackColor,
    this.disabledInactiveTrackColor,
    this.trackHeight,
    this.thumbRadius,
    this.onChangeStart,
    this.onChangeEnd,
    this.divisions,
    this.showDivisionMarks = true,
    this.label,
    this.semanticFormatterCallback,
    this.allowedInteraction,
    this.controller,
  }) : assert(
         (initialValue != null) ^ (controller != null),
         'Either initialValue or controller must be specified',
       );

  /// {@template ShadSlider.initialValue}
  /// The initial value of the slider.
  ///
  /// This value is used only when [controller] is null.
  /// {@endtemplate}
  final double? initialValue;

  /// {@template ShadSlider.onChanged}
  /// Callback that is called when the slider value changes.
  ///
  /// Provides the new value as an argument.
  /// {@endtemplate}
  final ValueChanged<double>? onChanged;

  /// {@template ShadSlider.enabled}
  /// Whether the slider is enabled.
  ///
  /// When disabled, the slider cannot be interacted with and visually appears
  /// disabled. Defaults to true.
  /// {@endtemplate}
  final bool enabled;

  /// {@template ShadSlider.min}
  /// The minimum value the slider can take.
  ///
  /// Defaults to 0.0.
  /// {@endtemplate}
  final double? min;

  /// {@template ShadSlider.max}
  /// The maximum value the slider can take.
  ///
  /// Defaults to 1.0.
  /// {@endtemplate}
  final double? max;

  /// {@template ShadSlider.focusNode}
  /// The focus node to control the focus state of the slider.
  ///
  /// If null, a default [FocusNode] will be created internally.
  /// {@endtemplate}
  final FocusNode? focusNode;

  /// {@template ShadWidget.onFocusChange}
  /// Called when the focus state of this widget changes.
  /// {@endtemplate}
  final ValueChanged<bool>? onFocusChange;

  /// {@template ShadSlider.autofocus}
  /// Whether the slider should automatically focus when it is first built.
  ///
  /// Defaults to false.
  /// {@endtemplate}
  final bool autofocus;

  /// {@template ShadSlider.mouseCursor}
  /// The cursor for the slider when it is enabled.
  ///
  /// Defaults to [SystemMouseCursors.click].
  /// {@endtemplate}
  final MouseCursor? mouseCursor;

  /// {@template ShadSlider.disabledMouseCursor}
  /// The cursor for the slider when it is disabled.
  ///
  /// Defaults to [SystemMouseCursors.forbidden].
  /// {@endtemplate}
  final MouseCursor? disabledMouseCursor;

  /// {@template ShadSlider.thumbColor}
  /// The color of the slider thumb when enabled.
  ///
  /// Defaults to the theme's background color.
  /// {@endtemplate}
  final Color? thumbColor;

  /// {@template ShadSlider.disabledThumbColor}
  /// The color of the slider thumb when disabled.
  ///
  /// Defaults to the theme's background color.
  /// {@endtemplate}
  final Color? disabledThumbColor;

  /// {@template ShadSlider.thumbBorderColor}
  /// The border color of the slider thumb when enabled.
  ///
  /// Defaults to the theme's primary color.
  /// {@endtemplate}
  final Color? thumbBorderColor;

  /// {@template ShadSlider.disabledThumbBorderColor}
  /// The border color of the slider thumb when disabled.
  ///
  /// Defaults to a semi-transparent version of the theme's primary color.
  /// {@endtemplate}
  final Color? disabledThumbBorderColor;

  /// {@template ShadSlider.activeTrackColor}
  /// The color of the active portion of the slider track.
  ///
  /// Defaults to the theme's primary color.
  /// {@endtemplate}
  final Color? activeTrackColor;

  /// {@template ShadSlider.inactiveTrackColor}
  /// The color of the inactive portion of the slider track.
  ///
  /// Defaults to the theme's secondary color.
  /// {@endtemplate}
  final Color? inactiveTrackColor;

  /// {@template ShadSlider.disabledActiveTrackColor}
  /// The color of the active track when the slider is disabled.
  ///
  /// Defaults to a semi-transparent version of the theme's primary color.
  /// {@endtemplate}
  final Color? disabledActiveTrackColor;

  /// {@template ShadSlider.disabledInactiveTrackColor}
  /// The color of the inactive track when the slider is disabled.
  ///
  /// Defaults to a semi-transparent version of the theme's secondary color.
  /// {@endtemplate}
  final Color? disabledInactiveTrackColor;

  /// {@template ShadSlider.trackHeight}
  /// The height of the slider track.
  ///
  /// Defaults to 8.0.
  /// {@endtemplate}
  final double? trackHeight;

  /// {@template ShadSlider.thumbRadius}
  /// The radius of the slider thumb.
  ///
  /// Defaults to 10.0.
  /// {@endtemplate}
  final double? thumbRadius;

  /// {@template ShadSlider.onChangeStart}
  /// Callback that is called when the user starts to change the slider value.
  ///
  /// Provides the starting value as an argument.
  /// {@endtemplate}
  final ValueChanged<double>? onChangeStart;

  /// {@template ShadSlider.onChangeEnd}
  /// Callback that is called when the user finishes changing the slider value.
  ///
  /// Provides the ending value as an argument.
  /// {@endtemplate}
  final ValueChanged<double>? onChangeEnd;

  /// {@template ShadSlider.divisions}
  /// The number of discrete divisions the slider has.
  ///
  /// When provided, the slider will snap to these divisions.
  /// {@endtemplate}
  final int? divisions;

  /// {@template ShadSlider.showDivisionMarks}
  /// Whether to draw the tick marks on the track when [divisions] is set.
  ///
  /// Snapping still applies either way; set this to false for a clean track
  /// that snaps. Defaults to true.
  /// {@endtemplate}
  final bool showDivisionMarks;

  /// {@template ShadSlider.label}
  /// A label to display above the slider when the thumb is pressed.
  /// {@endtemplate}
  final String? label;

  /// {@template ShadSlider.semanticFormatterCallback}
  /// A semantic formatter to be called by assistive technologies.
  /// {@endtemplate}
  final String Function(double value)? semanticFormatterCallback;

  /// {@template ShadSlider.allowedInteraction}
  /// Configures how the user can interact with the slider.
  ///
  /// Defaults to `ShadSliderInteraction.tapAndSlide`.
  /// {@endtemplate}
  final ShadSliderInteraction? allowedInteraction;

  /// {@macro ShadSliderController}
  final ShadSliderController? controller;

  @override
  State<ShadSlider> createState() => _ShadSliderState();
}

class _ShadSliderState extends State<ShadSlider> {
  late final controller =
      widget.controller ??
      ShadSliderController(
        initialValue: widget.initialValue!,
      );

  @override
  void didUpdateWidget(covariant ShadSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      // Dispose the old controller if it was internally created
      if (oldWidget.controller == null) {
        oldWidget.controller?.dispose();
      }
      // Initialize the new controller if it's null
      if (widget.controller == null) {
        controller.value = widget.initialValue!;
      }
    }
  }

  @override
  void dispose() {
    // dispose the internal controller
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        return _ShadSliderCore(
          // One thumb: the multi-thumb core collapses to exactly the
          // single-value slider when handed a one-element list.
          values: [value],
          onValuesChanged: (values) {
            controller.value = values.first;
            widget.onChanged?.call(values.first);
          },
          enabled: widget.enabled,
          min: widget.min,
          max: widget.max,
          focusNode: widget.focusNode,
          onFocusChange: widget.onFocusChange,
          autofocus: widget.autofocus,
          mouseCursor: widget.mouseCursor,
          disabledMouseCursor: widget.disabledMouseCursor,
          thumbColor: widget.thumbColor,
          disabledThumbColor: widget.disabledThumbColor,
          thumbBorderColor: widget.thumbBorderColor,
          disabledThumbBorderColor: widget.disabledThumbBorderColor,
          activeTrackColor: widget.activeTrackColor,
          inactiveTrackColor: widget.inactiveTrackColor,
          disabledActiveTrackColor: widget.disabledActiveTrackColor,
          disabledInactiveTrackColor: widget.disabledInactiveTrackColor,
          trackHeight: widget.trackHeight,
          thumbRadius: widget.thumbRadius,
          onChangeStart: (values) => widget.onChangeStart?.call(values.first),
          onChangeEnd: (values) => widget.onChangeEnd?.call(values.first),
          divisions: widget.divisions,
          showDivisionMarks: widget.showDivisionMarks,
          allowedInteraction: widget.allowedInteraction,
          semanticFormatter: widget.semanticFormatterCallback == null
              ? null
              : (value, _) => widget.semanticFormatterCallback!(value),
        );
      },
    );
  }
}

/// A slider with more than one thumb, styled to match the Shadcn UI design
/// system — shadcn/ui's `Slider` given an array of values.
///
/// Two thumbs select a range; any number is supported. The active track spans
/// the selected range rather than starting at the minimum, and each thumb is
/// focusable and adjustable with the arrow keys on its own.
///
/// The values stay in ascending order: a thumb stops when it meets its
/// neighbour rather than crossing it, so `values.first` and `values.last` are
/// always the ends of the range.
///
/// ```dart
/// ShadRangeSlider(
///   initialValues: const [20, 80],
///   max: 100,
///   onChanged: (values) => print('${values.first}..${values.last}'),
/// )
/// ```
class ShadRangeSlider extends StatefulWidget {
  /// Creates a [ShadRangeSlider].
  ///
  /// Either [initialValues] or [controller] must be provided to determine the
  /// slider's starting values, one per thumb.
  const ShadRangeSlider({
    super.key,
    this.initialValues,
    this.onChanged,
    this.enabled = true,
    this.min,
    this.max,
    this.autofocus = false,
    this.mouseCursor,
    this.disabledMouseCursor,
    this.thumbColor,
    this.disabledThumbColor,
    this.thumbBorderColor,
    this.disabledThumbBorderColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.disabledActiveTrackColor,
    this.disabledInactiveTrackColor,
    this.trackHeight,
    this.thumbRadius,
    this.onChangeStart,
    this.onChangeEnd,
    this.divisions,
    this.showDivisionMarks = true,
    this.semanticFormatterCallback,
    this.allowedInteraction,
    this.controller,
  }) : assert(
         (initialValues != null) ^ (controller != null),
         'Either initialValues or controller must be specified',
       );

  /// {@template ShadRangeSlider.initialValues}
  /// The initial values of the slider, one per thumb, in ascending order.
  ///
  /// These values are used only when [controller] is null.
  /// {@endtemplate}
  final List<double>? initialValues;

  /// {@template ShadRangeSlider.onChanged}
  /// Callback that is called when any of the slider values change.
  ///
  /// Provides the full list of values as an argument.
  /// {@endtemplate}
  final ValueChanged<List<double>>? onChanged;

  /// {@macro ShadSlider.enabled}
  final bool enabled;

  /// {@macro ShadSlider.min}
  final double? min;

  /// {@macro ShadSlider.max}
  final double? max;

  /// {@template ShadRangeSlider.autofocus}
  /// Whether the lowest thumb should automatically focus when the slider is
  /// first built.
  ///
  /// Defaults to false.
  /// {@endtemplate}
  final bool autofocus;

  /// {@macro ShadSlider.mouseCursor}
  final MouseCursor? mouseCursor;

  /// {@macro ShadSlider.disabledMouseCursor}
  final MouseCursor? disabledMouseCursor;

  /// {@macro ShadSlider.thumbColor}
  final Color? thumbColor;

  /// {@macro ShadSlider.disabledThumbColor}
  final Color? disabledThumbColor;

  /// {@macro ShadSlider.thumbBorderColor}
  final Color? thumbBorderColor;

  /// {@macro ShadSlider.disabledThumbBorderColor}
  final Color? disabledThumbBorderColor;

  /// {@macro ShadSlider.activeTrackColor}
  final Color? activeTrackColor;

  /// {@macro ShadSlider.inactiveTrackColor}
  final Color? inactiveTrackColor;

  /// {@macro ShadSlider.disabledActiveTrackColor}
  final Color? disabledActiveTrackColor;

  /// {@macro ShadSlider.disabledInactiveTrackColor}
  final Color? disabledInactiveTrackColor;

  /// {@macro ShadSlider.trackHeight}
  final double? trackHeight;

  /// {@macro ShadSlider.thumbRadius}
  final double? thumbRadius;

  /// {@template ShadRangeSlider.onChangeStart}
  /// Callback that is called when the user starts to change a value.
  ///
  /// Provides the values as they were when the gesture started.
  /// {@endtemplate}
  final ValueChanged<List<double>>? onChangeStart;

  /// {@template ShadRangeSlider.onChangeEnd}
  /// Callback that is called when the user finishes changing a value.
  ///
  /// Provides the final values as an argument.
  /// {@endtemplate}
  final ValueChanged<List<double>>? onChangeEnd;

  /// {@macro ShadSlider.divisions}
  final int? divisions;

  /// {@macro ShadSlider.showDivisionMarks}
  final bool showDivisionMarks;

  /// {@template ShadRangeSlider.semanticFormatterCallback}
  /// A semantic formatter to be called by assistive technologies, with the
  /// value of one thumb and its index.
  /// {@endtemplate}
  final String Function(double value, int index)? semanticFormatterCallback;

  /// {@macro ShadSlider.allowedInteraction}
  final ShadSliderInteraction? allowedInteraction;

  /// {@macro ShadRangeSliderController}
  final ShadRangeSliderController? controller;

  @override
  State<ShadRangeSlider> createState() => _ShadRangeSliderState();
}

class _ShadRangeSliderState extends State<ShadRangeSlider> {
  late final controller =
      widget.controller ??
      ShadRangeSliderController(initialValues: widget.initialValues!);

  @override
  void didUpdateWidget(covariant ShadRangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller &&
        widget.controller == null) {
      controller.value = List<double>.of(widget.initialValues!);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, values, child) {
        return _ShadSliderCore(
          values: values,
          onValuesChanged: (next) {
            controller.value = next;
            widget.onChanged?.call(next);
          },
          enabled: widget.enabled,
          min: widget.min,
          max: widget.max,
          autofocus: widget.autofocus,
          mouseCursor: widget.mouseCursor,
          disabledMouseCursor: widget.disabledMouseCursor,
          thumbColor: widget.thumbColor,
          disabledThumbColor: widget.disabledThumbColor,
          thumbBorderColor: widget.thumbBorderColor,
          disabledThumbBorderColor: widget.disabledThumbBorderColor,
          activeTrackColor: widget.activeTrackColor,
          inactiveTrackColor: widget.inactiveTrackColor,
          disabledActiveTrackColor: widget.disabledActiveTrackColor,
          disabledInactiveTrackColor: widget.disabledInactiveTrackColor,
          trackHeight: widget.trackHeight,
          thumbRadius: widget.thumbRadius,
          onChangeStart: widget.onChangeStart,
          onChangeEnd: widget.onChangeEnd,
          divisions: widget.divisions,
          showDivisionMarks: widget.showDivisionMarks,
          allowedInteraction: widget.allowedInteraction,
          semanticFormatter: widget.semanticFormatterCallback,
        );
      },
    );
  }
}

/// The slider implementation both [ShadSlider] and [ShadRangeSlider] render.
///
/// Holds no value of its own — the values come down from the wrapper's
/// controller and go back up through [onValuesChanged] — so there is exactly
/// one source of truth however many thumbs there are. A single-thumb core is
/// pixel-for-pixel the old single-value slider: the active track simply starts
/// at the minimum instead of at the lowest thumb.
class _ShadSliderCore extends StatefulWidget {
  const _ShadSliderCore({
    required this.values,
    required this.onValuesChanged,
    required this.enabled,
    required this.autofocus,
    required this.min,
    required this.max,
    required this.mouseCursor,
    required this.disabledMouseCursor,
    required this.thumbColor,
    required this.disabledThumbColor,
    required this.thumbBorderColor,
    required this.disabledThumbBorderColor,
    required this.activeTrackColor,
    required this.inactiveTrackColor,
    required this.disabledActiveTrackColor,
    required this.disabledInactiveTrackColor,
    required this.trackHeight,
    required this.thumbRadius,
    required this.onChangeStart,
    required this.onChangeEnd,
    required this.divisions,
    required this.showDivisionMarks,
    required this.allowedInteraction,
    required this.semanticFormatter,
    this.focusNode,
    this.onFocusChange,
  });

  final List<double> values;
  final ValueChanged<List<double>> onValuesChanged;
  final bool enabled;
  final bool autofocus;
  final double? min;
  final double? max;

  /// The focus node of the first thumb, when the caller supplies one.
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChange;

  final MouseCursor? mouseCursor;
  final MouseCursor? disabledMouseCursor;
  final Color? thumbColor;
  final Color? disabledThumbColor;
  final Color? thumbBorderColor;
  final Color? disabledThumbBorderColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? disabledActiveTrackColor;
  final Color? disabledInactiveTrackColor;
  final double? trackHeight;
  final double? thumbRadius;
  final ValueChanged<List<double>>? onChangeStart;
  final ValueChanged<List<double>>? onChangeEnd;
  final int? divisions;
  final bool showDivisionMarks;
  final ShadSliderInteraction? allowedInteraction;
  final String Function(double value, int index)? semanticFormatter;

  @override
  State<_ShadSliderCore> createState() => _ShadSliderCoreState();
}

class _ShadSliderCoreState extends State<_ShadSliderCore> {
  /// The focus nodes this state owns, by thumb index.
  ///
  /// Thumb 0 uses the caller's node when there is one, so
  /// [ShadSlider.focusNode] still addresses the thumb it always did.
  final _ownedFocusNodes = <int, FocusNode>{};

  FocusNode _focusNodeFor(int index) {
    if (index == 0 && widget.focusNode != null) return widget.focusNode!;
    return _ownedFocusNodes.putIfAbsent(
      index,
      () => FocusNode(debugLabel: 'ShadSlider thumb $index'),
    );
  }

  /// The thumb the pointer is over.
  ///
  /// shadcn shows the thumb's ring on `hover:` as well as `focus-visible:`,
  /// so the control tells you it is grabbable before you touch it.
  int? hoveredThumb;

  void _setHovered(int? index) {
    if (hoveredThumb == index) return;
    setState(() => hoveredThumb = index);
  }

  /// The thumb being dragged.
  ///
  /// Tracked separately from [hoveredThumb]: a drag routinely takes the
  /// pointer outside the slider, and the ring has to stay up for the whole
  /// gesture.
  int? draggingThumb;

  void _setDragging(int? index) {
    if (draggingThumb == index) return;
    setState(() => draggingThumb = index);
  }

  @override
  void didUpdateWidget(covariant _ShadSliderCore oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Drop the nodes of thumbs that no longer exist.
    if (widget.values.length < oldWidget.values.length) {
      for (final index in _ownedFocusNodes.keys.toList()) {
        if (index >= widget.values.length) {
          _ownedFocusNodes.remove(index)!.dispose();
        }
      }
    }
  }

  @override
  void dispose() {
    for (final node in _ownedFocusNodes.values) {
      node.dispose();
    }
    _ownedFocusNodes.clear();
    super.dispose();
  }

  // The bounds are read through the theme here as well as in build, so a
  // theme-level min/max reaches the interaction maths and not just the paint.
  ShadSliderTheme get _sliderTheme =>
      ShadTheme.of(context, listen: false).sliderTheme;

  double get _min => widget.min ?? _sliderTheme.min ?? 0;

  double get _max => widget.max ?? _sliderTheme.max ?? 1;

  /// [value] clamped into the slider's bounds and snapped to its divisions.
  double _clampAndSnap(double value) {
    final min = _min;
    final max = _max;
    var result = value.clamp(min, max);

    final divisions = widget.divisions;
    if (divisions != null && divisions > 0) {
      final step = (max - min) / divisions;
      result = ((result - min) / step).round() * step + min;
    }
    return result;
  }

  /// Moves thumb [index] to [rawValue], keeping the values in ascending
  /// order: a thumb stops where its neighbour is rather than crossing it.
  void _updateThumb(int index, double rawValue) {
    final values = widget.values;
    if (index < 0 || index >= values.length) return;

    var value = _clampAndSnap(rawValue);
    if (index > 0) value = math.max(value, values[index - 1]);
    if (index < values.length - 1) value = math.min(value, values[index + 1]);

    if (values[index] == value) return;
    widget.onValuesChanged(List<double>.of(values)..[index] = value);
  }

  /// The value the given horizontal offset into the track represents.
  double _valueFromDx(double dx, double trackWidth) {
    if (trackWidth == 0) return _min;
    return _min + (dx / trackWidth) * (_max - _min);
  }

  /// The thumb a pointer at [value] should grab.
  int _nearestThumb(double value) {
    final values = widget.values;
    var best = 0;
    var bestDistance = (values[0] - value).abs();
    for (var i = 1; i < values.length; i++) {
      final distance = (values[i] - value).abs();
      // On a tie the later thumb wins only when the pointer is past it, so
      // thumbs resting on the same value can be pulled apart either way.
      if (distance < bestDistance ||
          (distance == bestDistance && value > values[i])) {
        bestDistance = distance;
        best = i;
      }
    }
    return best;
  }

  /// The slider's own box, which every pointer position is measured against.
  RenderBox? _sliderBox(BuildContext layoutContext) =>
      layoutContext.findRenderObject() as RenderBox?;

  double? _localDx(BuildContext layoutContext, Offset globalPosition) {
    final box = _sliderBox(layoutContext);
    if (box == null || !box.hasSize) return null;
    return box.globalToLocal(globalPosition).dx;
  }

  bool _handleKeyEvent(int index, KeyEvent event) {
    if (!widget.enabled ||
        (event is! KeyDownEvent && event is! KeyRepeatEvent)) {
      return false;
    }

    final range = _max - _min;

    double increment;
    if (widget.divisions != null && widget.divisions! > 0) {
      increment = range / widget.divisions!;
    } else {
      increment = range * 0.01; // 1% of range for smooth movement
    }

    if (HardwareKeyboard.instance.isShiftPressed) {
      increment *= 10;
    }

    if (index < 0 || index >= widget.values.length) return false;
    var newValue = widget.values[index];

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.arrowDown:
        newValue -= increment;
      case LogicalKeyboardKey.arrowRight:
      case LogicalKeyboardKey.arrowUp:
        newValue += increment;
      default:
        return false;
    }

    _updateThumb(index, newValue);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final effectiveMouseCursor =
        widget.mouseCursor ??
        theme.sliderTheme.mouseCursor ??
        SystemMouseCursors.click;
    final effectiveDisabledMouseCursor =
        widget.disabledMouseCursor ??
        theme.sliderTheme.disabledMouseCursor ??
        SystemMouseCursors.forbidden;

    final effectiveMin = widget.min ?? theme.sliderTheme.min ?? 0;
    final effectiveMax = widget.max ?? theme.sliderTheme.max ?? 1;

    final effectiveThumbColor =
        widget.thumbColor ??
        theme.sliderTheme.thumbColor ??
        theme.colorScheme.background;

    final effectiveThumbBorderColor =
        widget.thumbBorderColor ??
        theme.sliderTheme.thumbBorderColor ??
        theme.colorScheme.primary;

    final effectiveDisabledThumbColor =
        widget.disabledThumbColor ??
        theme.sliderTheme.disabledThumbColor ??
        theme.colorScheme.background;

    final effectiveDisabledThumbBorderColor =
        widget.disabledThumbBorderColor ??
        theme.sliderTheme.disabledThumbBorderColor ??
        theme.colorScheme.primary.withValues(alpha: .5);

    // Resolved here rather than inline: the ternaries sat six levels deep in
    // the widget tree and no longer fit on a line.
    final resolvedThumbColor = widget.enabled
        ? effectiveThumbColor
        : effectiveDisabledThumbColor;
    final resolvedThumbBorderColor = widget.enabled
        ? effectiveThumbBorderColor
        : effectiveDisabledThumbBorderColor;

    final effectiveActiveTrackColor =
        widget.activeTrackColor ??
        theme.sliderTheme.activeTrackColor ??
        theme.colorScheme.primary;

    final effectiveInactiveTrackColor =
        widget.inactiveTrackColor ??
        theme.sliderTheme.inactiveTrackColor ??
        theme.colorScheme.secondary;

    final effectiveDisabledActiveTrackColor =
        widget.disabledActiveTrackColor ??
        theme.sliderTheme.disabledActiveTrackColor ??
        theme.colorScheme.primary.withValues(alpha: .5);

    final effectiveDisabledInactiveTrackColor =
        widget.disabledInactiveTrackColor ??
        theme.sliderTheme.disabledInactiveTrackColor ??
        theme.colorScheme.secondary.withValues(alpha: .5);

    final effectiveTrackHeight =
        widget.trackHeight ?? theme.sliderTheme.trackHeight ?? 8;

    final effectiveThumbRadius =
        widget.thumbRadius ?? theme.sliderTheme.thumbRadius ?? 10.0;

    final effectiveAllowedInteraction =
        widget.allowedInteraction ?? ShadSliderInteraction.tapAndSlide;

    final canTap =
        widget.enabled &&
        (effectiveAllowedInteraction == ShadSliderInteraction.tapAndSlide ||
            effectiveAllowedInteraction == ShadSliderInteraction.tapOnly);
    final canSlideTrack =
        widget.enabled &&
        (effectiveAllowedInteraction == ShadSliderInteraction.tapAndSlide ||
            effectiveAllowedInteraction == ShadSliderInteraction.slideOnly);
    final canSlideThumb =
        widget.enabled &&
        effectiveAllowedInteraction != ShadSliderInteraction.tapOnly;

    // The thumb's ring is the same one fields draw: colour, opacity and width
    // all come from the theme's focus ring rather than being invented here.
    final ringSide = theme.decoration.secondaryFocusedBorder?.top;
    final ringColor =
        ringSide?.color ?? theme.colorScheme.ring.withValues(alpha: .5);
    final ringWidth = ringSide?.width ?? 3.0;

    const thumbBorderWidth = 2.0;

    // Division marks configuration
    const divisionMarkWidth = 2.0;
    const divisionMarkHeight = 6.0;
    const divisionMarkOffset = 1.0;
    const divisionMarkBorderRadius = 1.0;

    final values = widget.values;
    final range = effectiveMax - effectiveMin;
    double fractionOf(double value) =>
        range == 0 ? 0.0 : ((value - effectiveMin) / range).clamp(0.0, 1.0);

    // A single thumb fills the track from the minimum; two or more fill the
    // span between the outermost thumbs, shadcn's `SliderIndicator`.
    final lowFraction = values.length < 2
        ? 0.0
        : fractionOf(values.reduce(math.min));
    final highFraction = values.isEmpty
        ? 0.0
        : fractionOf(
            values.length < 2 ? values.first : values.reduce(math.max),
          );

    return LayoutBuilder(
      builder: (layoutContext, constraints) {
        assert(
          constraints.hasBoundedWidth,
          'ShadSlider requires a bounded width',
        );
        // Calculate the effective width available for the track
        final effectiveTrackWidth = constraints.maxWidth;
        // The thumb is usually taller than the track, so the slider
        // has to reserve room for it. Sizing to the track alone let
        // the thumb spill over whatever sat above and below, which
        // read as a slider with no vertical padding at all.
        //
        // The focus ring is deliberately excluded: it is allowed to
        // overflow (the Stack does not clip) so that focusing a
        // slider never reflows the layout around it.
        final effectiveHeight = math.max(
          effectiveTrackHeight,
          effectiveThumbRadius * 2,
        );

        Widget buildThumb(int index) {
          final value = values[index];
          return Positioned(
            key: ValueKey<int>(index),
            left:
                (fractionOf(value) * effectiveTrackWidth - effectiveThumbRadius)
                    .clamp(
                      -effectiveThumbRadius,
                      effectiveTrackWidth - effectiveThumbRadius,
                    ),
            top: (effectiveHeight - effectiveThumbRadius * 2) / 2,
            child: ShadFocusable(
              focusNode: _focusNodeFor(index),
              canRequestFocus: widget.enabled,
              // Only the first thumb reports focus to the caller: it is the
              // one [ShadSlider.focusNode] addresses.
              onFocusChange: index == 0 ? widget.onFocusChange : null,
              autofocus: widget.autofocus && index == 0,
              onKeyEvent: (node, event) {
                return _handleKeyEvent(index, event)
                    ? KeyEventResult.handled
                    : KeyEventResult.ignored;
              },
              builder: (context, focused, child) {
                final ringVisible =
                    widget.enabled &&
                    (focused ||
                        hoveredThumb == index ||
                        draggingThumb == index);
                return Semantics(
                  slider: true,
                  value:
                      widget.semanticFormatter?.call(value, index) ??
                      value.toString(),
                  child: SizedBox(
                    width: effectiveThumbRadius * 2,
                    height: effectiveThumbRadius * 2,
                    child: ShadGestureDetector(
                      cursor: widget.enabled
                          ? effectiveMouseCursor
                          : effectiveDisabledMouseCursor,
                      onPanUpdate: canSlideThumb
                          ? (details) {
                              final dx = _localDx(
                                layoutContext,
                                details.globalPosition,
                              );
                              if (dx == null) return;
                              _updateThumb(
                                index,
                                _valueFromDx(dx, effectiveTrackWidth),
                              );
                            }
                          : null,
                      onPanDown: widget.enabled
                          ? (_) => _setDragging(index)
                          : null,
                      onPanCancel: widget.enabled
                          ? () => _setDragging(null)
                          : null,
                      onPanStart: widget.enabled
                          ? (details) {
                              _setDragging(index);
                              widget.onChangeStart?.call(widget.values);
                            }
                          : null,
                      onPanEnd: widget.enabled
                          ? (details) {
                              _setDragging(null);
                              widget.onChangeEnd?.call(widget.values);
                            }
                          : null,
                      child: MouseRegion(
                        onEnter: (_) => _setHovered(index),
                        onExit: (_) => _setHovered(null),
                        child: Container(
                          decoration: ShadShadowDecoration.box(
                            shape: BoxShape.circle,
                            color: resolvedThumbColor,
                            border: Border.all(
                              color: resolvedThumbBorderColor,
                              width: thumbBorderWidth,
                            ),
                            // A spread-only shadow is a ring: it grows
                            // outward without moving anything, which is
                            // what `hover:ring-4` does.
                            shadows: ringVisible
                                ? [
                                    BoxShadow(
                                      color: ringColor,
                                      spreadRadius: ringWidth,
                                    ),
                                  ]
                                : const <BoxShadow>[],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        // Painted — and therefore traversed — in value order, so tabbing
        // through the thumbs runs left to right however the values are
        // ordered in the list.
        final thumbOrder = List<int>.generate(values.length, (i) => i)
          ..sort((a, b) {
            final byValue = values[a].compareTo(values[b]);
            if (byValue != 0) return byValue;
            // Tied thumbs stack with the highest index on top, so a tie at
            // the minimum still surfaces the one thumb able to move (the
            // others are pinned below by a same-valued lower neighbour).
            // At the maximum that same rule pins every higher-index thumb
            // in the tied run in place instead, so it is inverted there:
            // the lowest index — the only one still free to move — goes on
            // top. Without this a range dragged fully to one side can
            // never be pulled back with the pointer.
            if (values[a] == effectiveMax) return b.compareTo(a);
            return a.compareTo(b);
          });

        return SizedBox(
          height: effectiveHeight,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              // Track with gesture handling based on interaction mode
              ShadGestureDetector(
                cursor: widget.enabled
                    ? effectiveMouseCursor
                    : effectiveDisabledMouseCursor,
                onTapDown: canTap && values.isNotEmpty
                    ? (details) {
                        final dx = _localDx(
                          layoutContext,
                          details.globalPosition,
                        );
                        if (dx == null) return;
                        final value = _valueFromDx(dx, effectiveTrackWidth);
                        _updateThumb(_nearestThumb(value), value);
                      }
                    : null,
                onPanUpdate: canSlideTrack
                    ? (details) {
                        final index = draggingThumb;
                        if (index == null) return;
                        final dx = _localDx(
                          layoutContext,
                          details.globalPosition,
                        );
                        if (dx == null) return;
                        _updateThumb(
                          index,
                          _valueFromDx(dx, effectiveTrackWidth),
                        );
                      }
                    : null,
                // The thumb the gesture grabs is decided once, when it
                // starts: a drag that runs past another thumb keeps moving
                // the one it picked up rather than swapping mid-gesture.
                onPanDown: widget.enabled && values.isNotEmpty
                    ? (details) {
                        final dx = _localDx(
                          layoutContext,
                          details.globalPosition,
                        );
                        if (dx == null) return;
                        _setDragging(
                          _nearestThumb(
                            _valueFromDx(dx, effectiveTrackWidth),
                          ),
                        );
                      }
                    : null,
                onPanCancel: widget.enabled ? () => _setDragging(null) : null,
                onPanStart: widget.enabled
                    ? (details) => widget.onChangeStart?.call(widget.values)
                    : null,
                onPanEnd: widget.enabled
                    ? (details) {
                        _setDragging(null);
                        widget.onChangeEnd?.call(widget.values);
                      }
                    : null,
                // `.cn-slider-track` is `overflow-hidden`, so the active
                // range takes the track's own rounded ends and nothing else:
                // square where it stops mid-track, rounded where it reaches
                // an end.
                child: ClipRRect(
                  borderRadius: theme.radius,
                  child: Stack(
                    children: [
                      // whole track
                      SizedBox(
                        width: effectiveTrackWidth,
                        height: effectiveTrackHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: theme.radius,
                            color: widget.enabled
                                ? effectiveInactiveTrackColor
                                : effectiveDisabledInactiveTrackColor,
                          ),
                        ),
                      ),
                      // active track
                      Positioned(
                        left: lowFraction * effectiveTrackWidth,
                        top: 0,
                        width:
                            (highFraction - lowFraction).clamp(0.0, 1.0) *
                            effectiveTrackWidth,
                        height: effectiveTrackHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: widget.enabled
                                ? effectiveActiveTrackColor
                                : effectiveDisabledActiveTrackColor,
                          ),
                        ),
                      ),
                      // division marks
                      if (widget.divisions != null &&
                          widget.divisions! > 0 &&
                          widget.showDivisionMarks)
                        ...List.generate(widget.divisions! + 1, (index) {
                          final position = index / widget.divisions!;
                          return Positioned(
                            left:
                                position * effectiveTrackWidth -
                                divisionMarkOffset,
                            top:
                                (effectiveTrackHeight - divisionMarkHeight) / 2,
                            child: Container(
                              width: divisionMarkWidth,
                              height: divisionMarkHeight,
                              decoration: BoxDecoration(
                                color: widget.enabled
                                    ? theme.colorScheme.border
                                    : theme.colorScheme.border.withValues(
                                        alpha: 0.5,
                                      ),
                                borderRadius: BorderRadius.circular(
                                  divisionMarkBorderRadius,
                                ),
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
              // thumbs
              for (final index in thumbOrder) buildThumb(index),
            ],
          ),
        );
      },
    );
  }
}
