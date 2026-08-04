// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'spinner.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$ShadSpinnerTheme {
  bool get canMerge => true;

  static ShadSpinnerTheme? lerp(
    ShadSpinnerTheme? a,
    ShadSpinnerTheme? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null) {
      return t == 1.0 ? b : null;
    }

    if (b == null) {
      return t == 0.0 ? a : null;
    }

    return ShadSpinnerTheme(
      color: Color.lerp(a.color, b.color, t),
      trackColor: Color.lerp(a.trackColor, b.trackColor, t),
      size: lerpDouble$(a.size, b.size, t),
      strokeWidth: lerpDouble$(a.strokeWidth, b.strokeWidth, t),
      duration: lerpDuration$(a.duration, b.duration, t),
    );
  }

  ShadSpinnerTheme copyWith({
    Color? color,
    Color? trackColor,
    double? size,
    double? strokeWidth,
    Duration? duration,
  }) {
    final _this = (this as ShadSpinnerTheme);

    return ShadSpinnerTheme(
      color: color ?? _this.color,
      trackColor: trackColor ?? _this.trackColor,
      size: size ?? _this.size,
      strokeWidth: strokeWidth ?? _this.strokeWidth,
      duration: duration ?? _this.duration,
    );
  }

  ShadSpinnerTheme merge(ShadSpinnerTheme? other) {
    final _this = (this as ShadSpinnerTheme);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      color: other.color,
      trackColor: other.trackColor,
      size: other.size,
      strokeWidth: other.strokeWidth,
      duration: other.duration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as ShadSpinnerTheme);
    final _other = (other as ShadSpinnerTheme);

    return _other.color == _this.color &&
        _other.trackColor == _this.trackColor &&
        _other.size == _this.size &&
        _other.strokeWidth == _this.strokeWidth &&
        _other.duration == _this.duration;
  }

  @override
  int get hashCode {
    final _this = (this as ShadSpinnerTheme);

    return Object.hash(
      runtimeType,
      _this.color,
      _this.trackColor,
      _this.size,
      _this.strokeWidth,
      _this.duration,
    );
  }
}
