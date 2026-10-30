import 'package:flutter/widgets.dart';

/// An extension of [TextEditingController] that stores the previous value.
class ShadTextEditingController extends TextEditingController {
  /// Creates a controller with the initial [text].
  ShadTextEditingController({super.text});

  /// Creates a controller from an initial [value].
  ShadTextEditingController.fromValue(TextEditingValue super.value)
    : super.fromValue();

  /// The value before the last change, or null before the first change.
  TextEditingValue? previousValue;

  @override
  set value(TextEditingValue newValue) {
    if (newValue == value) return;
    previousValue = value;
    super.value = newValue;
  }
}
