import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shad/src/components/form/field.dart';
import 'package:shad/src/components/input_otp.dart';

/// A [ShadInputOTP] that takes part in a `ShadForm`, with a label, a
/// description and validation.
class ShadInputOTPFormField extends ShadFormField<String> {
  /// Creates a one-time password form field with [maxLength] characters.
  ShadInputOTPFormField({
    super.id,
    super.key,
    super.onSaved,
    super.forceErrorText,

    /// Returns an error message for the value, or null when it is valid.
    String? Function(String)? validator,

    /// {@macro ShadInputOTP.initialValue}
    super.initialValue,

    /// {@macro ShadInputOTP.enabled}
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.label,
    super.error,
    super.description,

    /// {@macro ShadInputOTP.onChanged}
    void Function(String)? onChanged,
    super.toValueTransformer,
    super.fromValueTransformer,
    super.onReset,
    super.readOnly,

    /// {@macro ShadInputOTP.maxLength}
    required int maxLength,

    /// {@macro ShadInputOTP.gap}
    double? gap,

    /// {@macro ShadInputOTP.children}
    required List<Widget> children,

    /// {@macro ShadInputOTP.jumpToNextWhenFilled}
    bool jumpToNextWhenFilled = true,

    /// {@macro ShadInputOTP.inputFormatters}
    List<TextInputFormatter>? inputFormatters,

    /// {@macro ShadInputOTP.keyboardType}
    TextInputType? keyboardType,
  }) : super(
         validator: validator == null
             ? null
             : (v) => validator(v ?? ''.padRight(maxLength)),
         onChanged: onChanged == null
             ? null
             : (v) => onChanged(v ?? ''.padRight(maxLength)),
         builder: (state) {
           state as ShadInputOTPFormFieldState;
           return ShadInputOTP(
             enabled: state.enabled,
             keyboardType: keyboardType,
             inputFormatters: inputFormatters,
             gap: gap,
             maxLength: maxLength,
             jumpToNextWhenFilled: jumpToNextWhenFilled,
             onChanged: state.didChange,
             initialValue: state.initialValue,
             children: children,
           );
         },
       );

  @override
  ShadFormFieldState<ShadInputOTPFormField, String> createState() =>
      ShadInputOTPFormFieldState();
}

/// The state of a [ShadInputOTPFormField].
class ShadInputOTPFormFieldState
    extends ShadFormFieldState<ShadInputOTPFormField, String> {}

/// The old name of [ShadInputOTPFormFieldState].
@Deprecated(
  'Use ShadInputOTPFormFieldState. '
  'Will be removed in the next major version.',
)
typedef ShadFormBuilderInputOTPState = ShadInputOTPFormFieldState;
