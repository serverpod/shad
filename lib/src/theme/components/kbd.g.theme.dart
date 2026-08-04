// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'kbd.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$ShadKbdTheme {
  bool get canMerge => true;

  static ShadKbdTheme? lerp(ShadKbdTheme? a, ShadKbdTheme? b, double t) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null) {
      return t == 1.0 ? b : null;
    }

    if (b == null) {
      return t == 0.0 ? a : null;
    }

    return ShadKbdTheme(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
      border: ShadBorder.lerp(a.border, b.border, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      gap: lerpDouble$(a.gap, b.gap, t),
      minWidth: lerpDouble$(a.minWidth, b.minWidth, t),
      height: lerpDouble$(a.height, b.height, t),
    );
  }

  ShadKbdTheme copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    ShadBorder? border,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    double? gap,
    double? minWidth,
    double? height,
  }) {
    final _this = (this as ShadKbdTheme);

    return ShadKbdTheme(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      foregroundColor: foregroundColor ?? _this.foregroundColor,
      border: border ?? _this.border,
      padding: padding ?? _this.padding,
      textStyle: textStyle ?? _this.textStyle,
      gap: gap ?? _this.gap,
      minWidth: minWidth ?? _this.minWidth,
      height: height ?? _this.height,
    );
  }

  ShadKbdTheme merge(ShadKbdTheme? other) {
    final _this = (this as ShadKbdTheme);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      backgroundColor: other.backgroundColor,
      foregroundColor: other.foregroundColor,
      border: _this.border?.merge(other.border) ?? other.border,
      padding: other.padding,
      textStyle: _this.textStyle?.merge(other.textStyle) ?? other.textStyle,
      gap: other.gap,
      minWidth: other.minWidth,
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

    final _this = (this as ShadKbdTheme);
    final _other = (other as ShadKbdTheme);

    return _other.backgroundColor == _this.backgroundColor &&
        _other.foregroundColor == _this.foregroundColor &&
        _other.border == _this.border &&
        _other.padding == _this.padding &&
        _other.textStyle == _this.textStyle &&
        _other.gap == _this.gap &&
        _other.minWidth == _this.minWidth &&
        _other.height == _this.height;
  }

  @override
  int get hashCode {
    final _this = (this as ShadKbdTheme);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.foregroundColor,
      _this.border,
      _this.padding,
      _this.textStyle,
      _this.gap,
      _this.minWidth,
      _this.height,
    );
  }
}
