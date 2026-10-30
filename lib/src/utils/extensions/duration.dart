/// Arithmetic helpers on [Duration]. Not used inside the package.
///
/// [Duration] already has `+`, `-` and `*` operators, so the operators of this
/// extension with the same names never apply.
extension ShadDurationExt on Duration {
  /// Returns the sum of the two durations.
  Duration operator +(Duration other) {
    return Duration(
      microseconds: inMicroseconds + other.inMicroseconds,
    );
  }

  /// Returns the difference of the two durations.
  Duration operator -(Duration other) {
    return Duration(
      microseconds: inMicroseconds - other.inMicroseconds,
    );
  }

  /// Returns a duration whose microseconds are the product of the microseconds
  /// of both durations.
  Duration operator *(Duration other) {
    return Duration(
      microseconds: inMicroseconds * other.inMicroseconds,
    );
  }

  /// Returns this duration multiplied by [by].
  Duration times(int by) {
    return Duration(
      microseconds: inMicroseconds * by,
    );
  }

  /// Returns a duration whose microseconds are the microseconds of this
  /// duration divided by those of [other], rounded toward zero.
  Duration operator /(Duration other) {
    return Duration(
      microseconds: inMicroseconds ~/ other.inMicroseconds,
    );
  }

  /// Returns this duration divided by [by], rounded toward zero to the
  /// microsecond.
  Duration divide(int by) {
    return Duration(
      microseconds: inMicroseconds ~/ by,
    );
  }
}
