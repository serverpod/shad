import 'package:flutter/services.dart';

class ShadUpperCaseTextInputFormatter extends TextInputFormatter {
  const ShadUpperCaseTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class ShadLowerCaseTextInputFormatter extends TextInputFormatter {
  const ShadLowerCaseTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

@Deprecated(
  'Renamed to ShadUpperCaseTextInputFormatter. '
  'This name will be removed in v1.0.0.',
)
typedef UpperCaseTextInputFormatter = ShadUpperCaseTextInputFormatter;

@Deprecated(
  'Renamed to ShadLowerCaseTextInputFormatter. '
  'This name will be removed in v1.0.0.',
)
typedef LowerCaseTextInputFormatter = ShadLowerCaseTextInputFormatter;
