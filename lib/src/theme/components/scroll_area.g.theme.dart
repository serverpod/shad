// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'scroll_area.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$ShadScrollAreaTheme {
  bool get canMerge => true;

  static ShadScrollAreaTheme? lerp(
    ShadScrollAreaTheme? a,
    ShadScrollAreaTheme? b,
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

    return ShadScrollAreaTheme(
      thickness: lerpDouble$(a.thickness, b.thickness, t),
      crossAxisMargin: lerpDouble$(a.crossAxisMargin, b.crossAxisMargin, t),
      mainAxisMargin: lerpDouble$(a.mainAxisMargin, b.mainAxisMargin, t),
      radius: Radius.lerp(a.radius, b.radius, t),
      thumbColor: Color.lerp(a.thumbColor, b.thumbColor, t),
      thumbVisibility: t < 0.5 ? a.thumbVisibility : b.thumbVisibility,
      fadeDuration: lerpDuration$(a.fadeDuration, b.fadeDuration, t),
      timeToFade: lerpDuration$(a.timeToFade, b.timeToFade, t),
    );
  }

  ShadScrollAreaTheme copyWith({
    double? thickness,
    double? crossAxisMargin,
    double? mainAxisMargin,
    Radius? radius,
    Color? thumbColor,
    bool? thumbVisibility,
    Duration? fadeDuration,
    Duration? timeToFade,
  }) {
    final _this = (this as ShadScrollAreaTheme);

    return ShadScrollAreaTheme(
      thickness: thickness ?? _this.thickness,
      crossAxisMargin: crossAxisMargin ?? _this.crossAxisMargin,
      mainAxisMargin: mainAxisMargin ?? _this.mainAxisMargin,
      radius: radius ?? _this.radius,
      thumbColor: thumbColor ?? _this.thumbColor,
      thumbVisibility: thumbVisibility ?? _this.thumbVisibility,
      fadeDuration: fadeDuration ?? _this.fadeDuration,
      timeToFade: timeToFade ?? _this.timeToFade,
    );
  }

  ShadScrollAreaTheme merge(ShadScrollAreaTheme? other) {
    final _this = (this as ShadScrollAreaTheme);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      thickness: other.thickness,
      crossAxisMargin: other.crossAxisMargin,
      mainAxisMargin: other.mainAxisMargin,
      radius: other.radius,
      thumbColor: other.thumbColor,
      thumbVisibility: other.thumbVisibility,
      fadeDuration: other.fadeDuration,
      timeToFade: other.timeToFade,
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

    final _this = (this as ShadScrollAreaTheme);
    final _other = (other as ShadScrollAreaTheme);

    return _other.thickness == _this.thickness &&
        _other.crossAxisMargin == _this.crossAxisMargin &&
        _other.mainAxisMargin == _this.mainAxisMargin &&
        _other.radius == _this.radius &&
        _other.thumbColor == _this.thumbColor &&
        _other.thumbVisibility == _this.thumbVisibility &&
        _other.fadeDuration == _this.fadeDuration &&
        _other.timeToFade == _this.timeToFade;
  }

  @override
  int get hashCode {
    final _this = (this as ShadScrollAreaTheme);

    return Object.hash(
      runtimeType,
      _this.thickness,
      _this.crossAxisMargin,
      _this.mainAxisMargin,
      _this.radius,
      _this.thumbColor,
      _this.thumbVisibility,
      _this.fadeDuration,
      _this.timeToFade,
    );
  }
}
