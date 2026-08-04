// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'toggle.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$ShadToggleTheme {
  bool get canMerge => true;

  static ShadToggleTheme? lerp(
    ShadToggleTheme? a,
    ShadToggleTheme? b,
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

    return ShadToggleTheme(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      hoverBackgroundColor: Color.lerp(
        a.hoverBackgroundColor,
        b.hoverBackgroundColor,
        t,
      ),
      selectedBackgroundColor: Color.lerp(
        a.selectedBackgroundColor,
        b.selectedBackgroundColor,
        t,
      ),
      selectedHoverBackgroundColor: Color.lerp(
        a.selectedHoverBackgroundColor,
        b.selectedHoverBackgroundColor,
        t,
      ),
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
      hoverForegroundColor: Color.lerp(
        a.hoverForegroundColor,
        b.hoverForegroundColor,
        t,
      ),
      selectedForegroundColor: Color.lerp(
        a.selectedForegroundColor,
        b.selectedForegroundColor,
        t,
      ),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      decoration: ShadDecoration.lerp(a.decoration, b.decoration, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      gap: lerpDouble$(a.gap, b.gap, t),
      height: lerpDouble$(a.height, b.height, t),
    );
  }

  ShadToggleTheme copyWith({
    Color? backgroundColor,
    Color? hoverBackgroundColor,
    Color? selectedBackgroundColor,
    Color? selectedHoverBackgroundColor,
    Color? foregroundColor,
    Color? hoverForegroundColor,
    Color? selectedForegroundColor,
    EdgeInsetsGeometry? padding,
    ShadDecoration? decoration,
    TextStyle? textStyle,
    double? gap,
    double? height,
  }) {
    final _this = (this as ShadToggleTheme);

    return ShadToggleTheme(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      hoverBackgroundColor: hoverBackgroundColor ?? _this.hoverBackgroundColor,
      selectedBackgroundColor:
          selectedBackgroundColor ?? _this.selectedBackgroundColor,
      selectedHoverBackgroundColor:
          selectedHoverBackgroundColor ?? _this.selectedHoverBackgroundColor,
      foregroundColor: foregroundColor ?? _this.foregroundColor,
      hoverForegroundColor: hoverForegroundColor ?? _this.hoverForegroundColor,
      selectedForegroundColor:
          selectedForegroundColor ?? _this.selectedForegroundColor,
      padding: padding ?? _this.padding,
      decoration: decoration ?? _this.decoration,
      textStyle: textStyle ?? _this.textStyle,
      gap: gap ?? _this.gap,
      height: height ?? _this.height,
    );
  }

  ShadToggleTheme merge(ShadToggleTheme? other) {
    final _this = (this as ShadToggleTheme);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      backgroundColor: other.backgroundColor,
      hoverBackgroundColor: other.hoverBackgroundColor,
      selectedBackgroundColor: other.selectedBackgroundColor,
      selectedHoverBackgroundColor: other.selectedHoverBackgroundColor,
      foregroundColor: other.foregroundColor,
      hoverForegroundColor: other.hoverForegroundColor,
      selectedForegroundColor: other.selectedForegroundColor,
      padding: other.padding,
      decoration: _this.decoration?.merge(other.decoration) ?? other.decoration,
      textStyle: _this.textStyle?.merge(other.textStyle) ?? other.textStyle,
      gap: other.gap,
      height: other.height,
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

    final _this = (this as ShadToggleTheme);
    final _other = (other as ShadToggleTheme);

    return _other.backgroundColor == _this.backgroundColor &&
        _other.hoverBackgroundColor == _this.hoverBackgroundColor &&
        _other.selectedBackgroundColor == _this.selectedBackgroundColor &&
        _other.selectedHoverBackgroundColor ==
            _this.selectedHoverBackgroundColor &&
        _other.foregroundColor == _this.foregroundColor &&
        _other.hoverForegroundColor == _this.hoverForegroundColor &&
        _other.selectedForegroundColor == _this.selectedForegroundColor &&
        _other.padding == _this.padding &&
        _other.decoration == _this.decoration &&
        _other.textStyle == _this.textStyle &&
        _other.gap == _this.gap &&
        _other.height == _this.height;
  }

  @override
  int get hashCode {
    final _this = (this as ShadToggleTheme);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.hoverBackgroundColor,
      _this.selectedBackgroundColor,
      _this.selectedHoverBackgroundColor,
      _this.foregroundColor,
      _this.hoverForegroundColor,
      _this.selectedForegroundColor,
      _this.padding,
      _this.decoration,
      _this.textStyle,
      _this.gap,
      _this.height,
    );
  }
}
