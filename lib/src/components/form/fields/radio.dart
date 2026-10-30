import 'package:flutter/widgets.dart';
import 'package:shad/src/components/form/field.dart';
import 'package:shad/src/components/radio.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:shad/src/theme/theme.dart';

/// A [ShadRadioGroup] that takes part in a `ShadForm`, with a label, a
/// description and validation.
class ShadRadioGroupFormField<T> extends ShadFormField<T> {
  /// Creates a radio group form field.
  ShadRadioGroupFormField({
    super.id,
    super.key,
    super.onSaved,
    super.forceErrorText,
    super.label,
    super.error,
    super.description,
    super.onChanged,
    super.toValueTransformer,
    super.fromValueTransformer,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    T? initialValue,
    super.focusNode,
    super.validator,
    required Iterable<Widget> items,

    /// {@macro ShadRadioGroup.axis}
    Axis? axis,

    /// {@macro ShadRadioGroup.spacing}
    double? spacing,

    /// {@macro ShadRadioGroup.runSpacing}
    double? runSpacing,

    /// {@macro ShadRadioGroup.alignment}
    WrapAlignment? alignment,

    /// {@macro ShadRadioGroup.runAlignment}
    WrapAlignment? runAlignment,

    /// {@macro ShadRadioGroup.crossAxisAlignment}
    WrapCrossAlignment? crossAxisAlignment,

    /// {@macro ShadRadioGroup.controller}
    this.controller,
  }) : super(
         decorationBuilder: (context) =>
             ShadTheme.of(context).radioTheme.decoration ??
             const ShadDecoration(),
         initialValue: controller?.value ?? initialValue,
         builder: (state) {
           state as ShadRadioGroupFormFieldState<T>;
           return ShadRadioGroup(
             items: items,
             onChanged: state.didChange,
             enabled: state.enabled,
             initialValue: initialValue,
             axis: axis,
             spacing: spacing,
             runSpacing: runSpacing,
             alignment: alignment,
             runAlignment: runAlignment,
             crossAxisAlignment: crossAxisAlignment,
             controller: state.controller,
           );
         },
       );

  /// {@macro ShadRadioGroup.controller}
  final ShadRadioController<T>? controller;

  @override
  ShadFormFieldState<ShadRadioGroupFormField<T>, T> createState() =>
      ShadRadioGroupFormFieldState<T>();
}

/// The state of a [ShadRadioGroupFormField].
class ShadRadioGroupFormFieldState<T>
    extends ShadFormFieldState<ShadRadioGroupFormField<T>, T> {
  ShadRadioController<T>? _controller;

  /// The controller in use: [ShadRadioGroupFormField.controller] when given,
  /// otherwise an internal one.
  ShadRadioController<T> get controller => widget.controller ?? _controller!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = ShadRadioController<T>(
        value: initialValue,
        enabled: enabled,
      );
    }
    controller.addListener(onControllerChanged);
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    if (controller.value != value) {
      controller.value = value;
    }
  }

  @override
  void didUpdateWidget(covariant ShadRadioGroupFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == oldWidget.controller) return;
    // Move the listener with the controller. It used to stay on the old one,
    // and dispose() then removed it from the wrong controller.
    (oldWidget.controller ?? _controller)?.removeListener(onControllerChanged);
    if (widget.controller != null) {
      _controller?.dispose();
      _controller = null;
    } else {
      _controller = ShadRadioController<T>(value: value, enabled: enabled);
    }
    controller.addListener(onControllerChanged);
  }

  @override
  void reset() {
    super.reset();
    controller.value = initialValue;
  }

  @override
  void dispose() {
    controller.removeListener(onControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  /// Copies the controller's value into the field's value and calls
  /// [ShadFormField.onChanged].
  void onControllerChanged() {
    if (controller.value != value) {
      didChange(controller.value);
      widget.onChanged?.call(controller.value);
    }
  }
}

/// The old name of [ShadRadioGroupFormFieldState].
@Deprecated(
  'Use ShadRadioGroupFormFieldState. '
  'Will be removed in the next major version.',
)
typedef ShadFormBuilderRadioGroupState<T> = ShadRadioGroupFormFieldState<T>;
