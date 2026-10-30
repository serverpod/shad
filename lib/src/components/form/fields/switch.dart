import 'package:flutter/widgets.dart';
import 'package:shad/src/components/form/field.dart';
import 'package:shad/src/components/switch.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:shad/src/theme/theme.dart';

/// A [ShadSwitch] that takes part in a `ShadForm`, with a label, a
/// description and validation.
class ShadSwitchFormField extends ShadFormField<bool> {
  /// Creates a switch form field.
  ShadSwitchFormField({
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

    /// Whether the switch starts on.
    required bool initialValue,

    /// {@macro ShadSwitch.decoration}
    ShadDecoration? decoration,
    super.focusNode,

    /// Returns an error message for the value, or null when it is valid.
    String? Function(bool)? validator,

    /// {@macro ShadSwitch.thumbColor}
    Color? thumbColor,

    /// {@macro ShadSwitch.uncheckedTrackColor}
    Color? uncheckedTrackColor,

    /// {@macro ShadSwitch.checkedTrackColor}
    Color? checkedTrackColor,

    /// {@macro ShadSwitch.width}
    double? width,

    /// {@macro ShadSwitch.margin}
    double? margin,

    /// {@macro ShadSwitch.duration}
    Duration? duration,

    /// {@macro ShadSwitch.label}
    Widget? inputLabel,

    /// {@macro ShadSwitch.sublabel}
    Widget? inputSublabel,

    /// {@macro ShadSwitch.padding}
    EdgeInsetsGeometry? padding,

    /// {@macro ShadSwitch.direction}
    TextDirection? direction,
  }) : super(
         initialValue: initialValue,
         onChanged: (!enabled || onChanged == null)
             ? null
             : (v) => onChanged(v ?? false),
         validator: validator == null
             ? null
             : (v) {
                 return validator(v ?? false);
               },
         decorationBuilder: (context) =>
             (ShadTheme.of(context).switchTheme.decoration ??
                     const ShadDecoration())
                 .merge(decoration),
         builder: (state) {
           state as ShadSwitchFormFieldState;

           return ShadSwitch(
             value: state.value!,
             onChanged: state.didChange,
             enabled: state.enabled,
             focusNode: state.focusNode,
             decoration: state.decoration,
             duration: duration,
             label: inputLabel,
             sublabel: inputSublabel,
             padding: padding,
             direction: direction,
             width: width,
             margin: margin,
             thumbColor: thumbColor,
             uncheckedTrackColor: uncheckedTrackColor,
             checkedTrackColor: checkedTrackColor,
           );
         },
       );

  @override
  ShadFormFieldState<ShadSwitchFormField, bool> createState() =>
      ShadSwitchFormFieldState();
}

/// The state of a [ShadSwitchFormField].
class ShadSwitchFormFieldState
    extends ShadFormFieldState<ShadSwitchFormField, bool> {}

/// The old name of [ShadSwitchFormFieldState].
@Deprecated(
  'Use ShadSwitchFormFieldState. '
  'Will be removed in the next major version.',
)
typedef ShadFormBuilderSwitchState = ShadSwitchFormFieldState;
