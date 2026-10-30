import 'package:flutter/services.dart';

/// Converts all entered text to upper case. Keeps the selection.
class ShadUpperCaseTextInputFormatter extends TextInputFormatter {
  /// Creates an upper-case formatter.
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

/// Converts all entered text to lower case. Keeps the selection.
class ShadLowerCaseTextInputFormatter extends TextInputFormatter {
  /// Creates a lower-case formatter.
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
