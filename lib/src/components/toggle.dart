import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shad/src/components/disabled.dart';
import 'package:shad/src/raw_components/focusable.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/utils/debug_check.dart';
import 'package:shad/src/utils/gesture_detector.dart';
import 'package:shad/src/utils/provider.dart';
import 'package:shad/src/utils/states_controller.dart';

/// Variants available for the [ShadToggle] widget.
enum ShadToggleVariant {
  /// A borderless toggle with a muted fill when pressed.
  default_,

  /// A bordered toggle with a subtle shadow.
  outline,
}

/// {@template ShadToggle}
/// A two-state button that stays pressed when on.
///
/// Mirrors shadcn/ui's `Toggle`. Use it for a single on/off control that reads
/// as a button rather than a checkbox — bold/italic in a text toolbar, for
/// example. For a set of related toggles, use [ShadToggleGroup].
///
/// ```dart
/// ShadToggle(
///   value: bold,
///   onChanged: (v) => setState(() => bold = v),
///   child: const Icon(LucideIcons.bold),
/// )
/// ```
///
/// Prefer `ShadSwitch` when the control turns a *setting* on and off, and
/// `ShadCheckbox` when it selects an item. This is for a formatting-style
/// action.
/// {@endtemplate}
class ShadToggle extends StatefulWidget {
  /// {@macro ShadToggle}
  const ShadToggle({
    super.key,
    required this.value,
    required this.child,
    this.onChanged,
    this.enabled = true,
    this.leading,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.selectedBackgroundColor,
    this.selectedHoverBackgroundColor,
    this.foregroundColor,
    this.hoverForegroundColor,
    this.selectedForegroundColor,
    this.padding,
    this.decoration,
    this.textStyle,
    this.gap,
    this.height,
    this.width,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.statesController,
    this.semanticLabel,
  }) : variant = ShadToggleVariant.default_;

  /// A bordered toggle, matching shadcn/ui's `variant="outline"`.
  const ShadToggle.outline({
    super.key,
    required this.value,
    required this.child,
    this.onChanged,
    this.enabled = true,
    this.leading,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.selectedBackgroundColor,
    this.selectedHoverBackgroundColor,
    this.foregroundColor,
    this.hoverForegroundColor,
    this.selectedForegroundColor,
    this.padding,
    this.decoration,
    this.textStyle,
    this.gap,
    this.height,
    this.width,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.statesController,
    this.semanticLabel,
  }) : variant = ShadToggleVariant.outline;

  /// Creates a toggle with a specified [variant], allowing full control.
  const ShadToggle.raw({
    super.key,
    required this.variant,
    required this.value,
    required this.child,
    this.onChanged,
    this.enabled = true,
    this.leading,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.selectedBackgroundColor,
    this.selectedHoverBackgroundColor,
    this.foregroundColor,
    this.hoverForegroundColor,
    this.selectedForegroundColor,
    this.padding,
    this.decoration,
    this.textStyle,
    this.gap,
    this.height,
    this.width,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.statesController,
    this.semanticLabel,
  });

  final ShadToggleVariant variant;

  /// Whether the toggle is on.
  final bool value;

  /// The content of the toggle, usually an [Icon] or a [Text].
  final Widget child;

  /// An optional widget shown before [child].
  final Widget? leading;

  /// Called with the new value when the toggle is pressed.
  ///
  /// A null callback disables the toggle, matching the rest of the package.
  final ValueChanged<bool>? onChanged;

  /// Whether the toggle responds to input, defaults to `true`.
  final bool enabled;

  /// {@template ShadToggle.backgroundColor}
  /// The background color when off.
  /// {@endtemplate}
  final Color? backgroundColor;

  /// {@template ShadToggle.hoverBackgroundColor}
  /// The background color when off and hovered.
  /// {@endtemplate}
  final Color? hoverBackgroundColor;

  /// {@template ShadToggle.selectedBackgroundColor}
  /// The background color when on.
  /// {@endtemplate}
  final Color? selectedBackgroundColor;

  /// {@template ShadToggle.selectedHoverBackgroundColor}
  /// The background color when on and hovered.
  /// {@endtemplate}
  final Color? selectedHoverBackgroundColor;

  /// {@template ShadToggle.foregroundColor}
  /// The content color when off.
  /// {@endtemplate}
  final Color? foregroundColor;

  /// {@template ShadToggle.hoverForegroundColor}
  /// The content color when off and hovered.
  /// {@endtemplate}
  final Color? hoverForegroundColor;

  /// {@template ShadToggle.selectedForegroundColor}
  /// The content color when on.
  /// {@endtemplate}
  final Color? selectedForegroundColor;

  /// {@template ShadToggle.padding}
  /// The padding inside the toggle.
  /// {@endtemplate}
  final EdgeInsetsGeometry? padding;

  /// {@template ShadToggle.decoration}
  /// The decoration of the toggle.
  /// {@endtemplate}
  final ShadDecoration? decoration;

  /// {@template ShadToggle.textStyle}
  /// The text style of the label.
  /// {@endtemplate}
  final TextStyle? textStyle;

  /// The gap between [leading] and [child].
  final double? gap;

  /// The height of the toggle.
  final double? height;

  /// The width of the toggle. Null sizes to the content.
  final double? width;

  final FocusNode? focusNode;
  final bool autofocus;
  final ValueChanged<bool>? onFocusChange;
  final ShadStatesController? statesController;

  /// The accessible name, needed when [child] is icon-only.
  final String? semanticLabel;

  @override
  State<ShadToggle> createState() => _ShadToggleState();
}

class _ShadToggleState extends State<ShadToggle> {
  ShadStatesController? _internalStatesController;

  ShadStatesController get statesController =>
      widget.statesController ?? _internalStatesController!;

  bool get enabled => widget.enabled && widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    if (widget.statesController == null) {
      _internalStatesController = ShadStatesController();
    }
  }

  @override
  void dispose() {
    _internalStatesController?.dispose();
    super.dispose();
  }

  void _toggle() {
    if (!enabled) return;
    widget.onChanged!(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasShadTheme(context));
    final theme = ShadTheme.of(context);
    final toggleTheme = switch (widget.variant) {
      ShadToggleVariant.default_ => theme.toggleTheme,
      ShadToggleVariant.outline => theme.outlineToggleTheme,
    };

    final selected = widget.value;

    final effectivePadding =
        widget.padding ??
        toggleTheme.padding ??
        const EdgeInsets.symmetric(horizontal: 12);
    final effectiveHeight = widget.height ?? toggleTheme.height ?? 40.0;
    final effectiveGap = widget.gap ?? toggleTheme.gap ?? 8.0;
    final effectiveDecoration =
        (toggleTheme.decoration ?? const ShadDecoration()).merge(
          widget.decoration,
        );

    Color? backgroundFor({required bool hovered}) {
      if (selected) {
        return hovered
            ? widget.selectedHoverBackgroundColor ??
                  toggleTheme.selectedHoverBackgroundColor ??
                  theme.colorScheme.accent
            : widget.selectedBackgroundColor ??
                  toggleTheme.selectedBackgroundColor ??
                  theme.colorScheme.accent;
      }
      return hovered
          ? widget.hoverBackgroundColor ??
                toggleTheme.hoverBackgroundColor ??
                theme.colorScheme.muted
          : widget.backgroundColor ?? toggleTheme.backgroundColor;
    }

    Color foregroundFor({required bool hovered}) {
      if (selected) {
        return widget.selectedForegroundColor ??
            toggleTheme.selectedForegroundColor ??
            theme.colorScheme.accentForeground;
      }
      return hovered
          ? widget.hoverForegroundColor ??
                toggleTheme.hoverForegroundColor ??
                theme.colorScheme.mutedForeground
          : widget.foregroundColor ??
                toggleTheme.foregroundColor ??
                theme.colorScheme.foreground;
    }

    final effectiveTextStyle = (toggleTheme.textStyle ?? theme.textTheme.small)
        .merge(widget.textStyle);

    Widget toggle = ShadFocusable(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: widget.onFocusChange,
      canRequestFocus: enabled,
      builder: (context, focused, child) {
        return ShadDecorator(
          focused: focused,
          decoration: effectiveDecoration,
          child: child,
        );
      },
      child: ShadGestureDetector(
        cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        behavior: HitTestBehavior.opaque,
        onTap: _toggle,
        onHoverChange: (hovered) =>
            statesController.update(ShadState.hovered, hovered),
        child: ValueListenableBuilder(
          valueListenable: statesController,
          builder: (context, states, _) {
            final hovered = enabled && states.contains(ShadState.hovered);
            final foreground = foregroundFor(hovered: hovered);
            return Container(
              height: effectiveHeight,
              width: widget.width,
              padding: effectivePadding,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundFor(hovered: hovered),
                borderRadius:
                    effectiveDecoration.border?.radius ?? theme.radius,
              ),
              child: IconTheme(
                data: IconThemeData(size: 16, color: foreground),
                child: DefaultTextStyle(
                  style: effectiveTextStyle.copyWith(color: foreground),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.leading != null) ...[
                        widget.leading!,
                        SizedBox(width: effectiveGap),
                      ],
                      widget.child,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    toggle = Semantics(
      label: widget.semanticLabel,
      button: true,
      toggled: selected,
      enabled: enabled,
      container: true,
      // With an explicit label, drop the child's own semantics rather than
      // merging — otherwise an icon-only toggle announces "Bold B".
      child: widget.semanticLabel == null
          ? toggle
          : ExcludeSemantics(child: toggle),
    );

    if (!enabled) {
      toggle = ShadDisabled(disabled: true, child: toggle);
    }
    return toggle;
  }
}

/// Whether a [ShadToggleGroup] allows one or many selections.
enum ShadToggleGroupVariant {
  /// At most one item may be selected.
  single,

  /// Any number of items may be selected.
  multiple,
}

/// A controller for the selection of a [ShadToggleGroup].
class ShadToggleGroupController<T> extends ChangeNotifier {
  ShadToggleGroupController({
    required this.variant,
    Set<T>? initialValue,
    this.allowDeselection = true,
  }) : _value = {...?initialValue} {
    assert(
      variant == ShadToggleGroupVariant.multiple || _value.length <= 1,
      'A single-variant ShadToggleGroup cannot start with more than one '
      'selected value',
    );
  }

  final ShadToggleGroupVariant variant;

  /// Whether tapping the selected item in a [ShadToggleGroupVariant.single]
  /// group clears the selection. Defaults to `true`, matching Radix.
  final bool allowDeselection;

  Set<T> _value;

  /// The currently selected values.
  Set<T> get value => Set.unmodifiable(_value);

  set value(Set<T> newValue) {
    if (setEquals(_value, newValue)) return;
    _value = {...newValue};
    notifyListeners();
  }

  bool isSelected(T item) => _value.contains(item);

  void toggle(T item) {
    final selected = _value.contains(item);
    switch (variant) {
      case ShadToggleGroupVariant.single:
        if (selected) {
          if (!allowDeselection) return;
          value = {};
        } else {
          value = {item};
        }
      case ShadToggleGroupVariant.multiple:
        value = selected ? ({..._value}..remove(item)) : {..._value, item};
    }
  }
}

/// {@template ShadToggleGroup}
/// A set of [ShadToggle]s sharing a selection.
///
/// Mirrors shadcn/ui's `ToggleGroup`, in `single` or `multiple` mode.
///
/// ```dart
/// ShadToggleGroup<String>(
///   values: const {'bold'},
///   onChanged: (values) => setState(() => selected = values),
///   children: const [
///     ShadToggleGroupItem(value: 'bold', child: Icon(LucideIcons.bold)),
///     ShadToggleGroupItem(value: 'italic', child: Icon(LucideIcons.italic)),
///   ],
/// )
/// ```
/// {@endtemplate}
class ShadToggleGroup<T> extends StatefulWidget {
  /// {@macro ShadToggleGroup}
  const ShadToggleGroup({
    super.key,
    required this.children,
    this.values,
    this.onChanged,
    this.controller,
    this.allowDeselection = true,
    this.enabled = true,
    this.toggleVariant = ShadToggleVariant.default_,
    this.gap,
    this.axis = Axis.horizontal,
    this.mainAxisSize = MainAxisSize.min,
  }) : variant = ShadToggleGroupVariant.single;

  /// A group where any number of items may be selected.
  const ShadToggleGroup.multiple({
    super.key,
    required this.children,
    this.values,
    this.onChanged,
    this.controller,
    this.enabled = true,
    this.toggleVariant = ShadToggleVariant.default_,
    this.gap,
    this.axis = Axis.horizontal,
    this.mainAxisSize = MainAxisSize.min,
  }) : variant = ShadToggleGroupVariant.multiple,
       allowDeselection = true;

  final ShadToggleGroupVariant variant;

  /// The visual style shared by every toggle in the group.
  final ShadToggleVariant toggleVariant;

  /// The items in the group.
  final List<ShadToggleGroupItem<T>> children;

  /// The selected values. Ignored when [controller] is provided.
  final Set<T>? values;

  /// Called with the new selection whenever it changes.
  final ValueChanged<Set<T>>? onChanged;

  /// An external controller for the selection.
  final ShadToggleGroupController<T>? controller;

  /// Whether tapping the selected item of a single-variant group clears it.
  final bool allowDeselection;

  /// Whether the whole group responds to input.
  final bool enabled;

  /// The gap between items.
  final double? gap;

  /// The direction the items are laid out in.
  final Axis axis;

  final MainAxisSize mainAxisSize;

  @override
  State<ShadToggleGroup<T>> createState() => _ShadToggleGroupState<T>();
}

class _ShadToggleGroupState<T> extends State<ShadToggleGroup<T>> {
  ShadToggleGroupController<T>? _internalController;

  ShadToggleGroupController<T> get controller =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = ShadToggleGroupController<T>(
        variant: widget.variant,
        initialValue: widget.values,
        allowDeselection: widget.allowDeselection,
      );
    }
    controller.addListener(_onSelectionChanged);
  }

  @override
  void didUpdateWidget(ShadToggleGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      (oldWidget.controller ?? _internalController)?.removeListener(
        _onSelectionChanged,
      );
      controller.addListener(_onSelectionChanged);
    }
    if (widget.controller == null &&
        widget.values != null &&
        !setEquals(widget.values, controller.value)) {
      controller.value = widget.values!;
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onSelectionChanged);
    _internalController?.dispose();
    super.dispose();
  }

  void _onSelectionChanged() {
    widget.onChanged?.call(controller.value);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasShadTheme(context));
    final effectiveGap = widget.gap ?? 4.0;

    final items = <Widget>[];
    for (var i = 0; i < widget.children.length; i++) {
      if (i > 0) {
        items.add(
          widget.axis == Axis.horizontal
              ? SizedBox(width: effectiveGap)
              : SizedBox(height: effectiveGap),
        );
      }
      final item = widget.children[i];
      items.add(
        ShadToggle.raw(
          variant: widget.toggleVariant,
          value: controller.isSelected(item.value),
          enabled: widget.enabled && item.enabled,
          onChanged: (_) => controller.toggle(item.value),
          leading: item.leading,
          semanticLabel: item.semanticLabel,
          child: item.child,
        ),
      );
    }

    return ShadProvider(
      data: this as _ShadToggleGroupState<dynamic>,
      child: Semantics(
        container: true,
        child: widget.axis == Axis.horizontal
            ? Row(mainAxisSize: widget.mainAxisSize, children: items)
            : Column(mainAxisSize: widget.mainAxisSize, children: items),
      ),
    );
  }
}

/// A single item within a [ShadToggleGroup].
///
/// This is a description, not a widget that builds itself — the group renders
/// a [ShadToggle] from it so that selection stays in one place.
@immutable
class ShadToggleGroupItem<T> {
  const ShadToggleGroupItem({
    required this.value,
    required this.child,
    this.leading,
    this.enabled = true,
    this.semanticLabel,
  });

  /// The value this item contributes to the group's selection.
  final T value;

  /// The content of the item.
  final Widget child;

  /// An optional widget shown before [child].
  final Widget? leading;

  /// Whether this individual item responds to input.
  final bool enabled;

  /// The accessible name, needed when [child] is icon-only.
  final String? semanticLabel;
}
