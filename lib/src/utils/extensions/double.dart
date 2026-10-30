/// Rounds a [double] to a number of decimal places.
extension DoubleToPrecision on double {
  /// Returns this value rounded to [fractionDigits] decimal places.
  double asFixed(int fractionDigits) {
    return double.parse(toStringAsFixed(fractionDigits));
  }
}
