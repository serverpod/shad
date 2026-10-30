import 'package:flutter/widgets.dart';
import 'package:shad/src/components/checkbox.dart';
import 'package:shad/src/components/form/field.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:shad/src/theme/theme.dart';

/// A [ShadCheckbox] that takes part in a `ShadForm`, with a label, a
/// description and validation.
class ShadCheckboxFormField extends ShadFormField<bool> {
  /// Creates a checkbox form field.
  ShadCheckboxFormField({
    super.id,
    super.key,
    super.onSaved,
    super.forceErrorText,
    super.label,
    super.error,
    super.description,
    void Function(bool)? onChanged,
    super.toValueTransformer,
    super.fromValueTransformer,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    required bool super.initialValue,
    super.focusNode,

    /// {@macro ShadCheckbox.decoration}
    ShadDecoration? decoration,

    /// Returns an error message for the value, or null when it is valid.
    String? Function(bool)? validator,

    /// {@macro ShadCheckbox.size}
    double? size,

    /// {@macro ShadCheckbox.duration}
    Duration? duration,

    /// {@macro ShadCheckbox.icon}
    Widget? icon,

    /// {@macro ShadCheckbox.color}
    Color? color,

    /// {@macro ShadCheckbox.label}
    Widget? inputLabel,

    /// {@macro ShadCheckbox.sublabel}
    Widget? inputSublabel,

    /// {@macro ShadCheckbox.padding}
    EdgeInsetsGeometry? padding,

    /// {@macro ShadCheckbox.direction}
    TextDirection? direction,

    /// {@macro ShadCheckbox.crossAxisAlignment}
    CrossAxisAlignment? crossAxisAlignment,

    /// {@macro ShadCheckbox.checkboxPadding}
    EdgeInsetsGeometry? checkboxPadding,
  }) : super(
         onChanged: onChanged == null ? null : (v) => onChanged(v ?? false),
         validator: validator == null ? null : (v) => validator(v ?? false),
         decorationBuilder: (context) =>
             (ShadTheme.of(context).checkboxTheme.decoration ??
                     const ShadDecoration())
                 .merge(decoration),
         builder: (state) {
           state as ShadCheckboxFormFieldState;
           return ShadCheckbox(
             value: state.value!,
             onChanged: state.didChange,
             enabled: state.enabled,
             focusNode: state.focusNode,
             size: size,
             duration: duration,
             icon: icon,
             color: color,
             label: inputLabel,
             sublabel: inputSublabel,
             padding: padding,
             direction: direction,
             decoration: state.decoration,
             crossAxisAlignment: crossAxisAlignment,
             checkboxPadding: checkboxPadding,
           );
         },
       );

  @override
  ShadFormFieldState<ShadCheckboxFormField, bool> createState() =>
      ShadCheckboxFormFieldState();
}

/// The state of a [ShadCheckboxFormField].
class ShadCheckboxFormFieldState
    extends ShadFormFieldState<ShadCheckboxFormField, bool> {}

/// The old name of [ShadCheckboxFormFieldState].
@Deprecated(
  'Use ShadCheckboxFormFieldState. '
  'Will be removed in the next major version.',
)
typedef ShadFormBuilderCheckboxState = ShadCheckboxFormFieldState;
