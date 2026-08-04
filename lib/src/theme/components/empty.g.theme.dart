// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'empty.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$ShadEmptyTheme {
  bool get canMerge => true;

  static ShadEmptyTheme? lerp(ShadEmptyTheme? a, ShadEmptyTheme? b, double t) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null) {
      return t == 1.0 ? b : null;
    }

    if (b == null) {
      return t == 0.0 ? a : null;
    }

    return ShadEmptyTheme(
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      gap: lerpDouble$(a.gap, b.gap, t),
      iconSize: lerpDouble$(a.iconSize, b.iconSize, t),
      iconColor: Color.lerp(a.iconColor, b.iconColor, t),
      titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
      descriptionStyle: TextStyle.lerp(
        a.descriptionStyle,
        b.descriptionStyle,
        t,
      ),
      crossAxisAlignment: t < 0.5 ? a.crossAxisAlignment : b.crossAxisAlignment,
      mainAxisAlignment: t < 0.5 ? a.mainAxisAlignment : b.mainAxisAlignment,
    );
  }

  ShadEmptyTheme copyWith({
    EdgeInsetsGeometry? padding,
    double? gap,
    double? iconSize,
    Color? iconColor,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisAlignment? mainAxisAlignment,
  }) {
    final _this = (this as ShadEmptyTheme);

    return ShadEmptyTheme(
      padding: padding ?? _this.padding,
      gap: gap ?? _this.gap,
      iconSize: iconSize ?? _this.iconSize,
      iconColor: iconColor ?? _this.iconColor,
      titleStyle: titleStyle ?? _this.titleStyle,
      descriptionStyle: descriptionStyle ?? _this.descriptionStyle,
      crossAxisAlignment: crossAxisAlignment ?? _this.crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment ?? _this.mainAxisAlignment,
    );
  }

  ShadEmptyTheme merge(ShadEmptyTheme? other) {
    final _this = (this as ShadEmptyTheme);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      padding: other.padding,
      gap: other.gap,
      iconSize: other.iconSize,
      iconColor: other.iconColor,
      titleStyle: _this.titleStyle?.merge(other.titleStyle) ?? other.titleStyle,
      descriptionStyle:
          _this.descriptionStyle?.merge(other.descriptionStyle) ??
          other.descriptionStyle,
      crossAxisAlignment: other.crossAxisAlignment,
      mainAxisAlignment: other.mainAxisAlignment,
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

    final _this = (this as ShadEmptyTheme);
    final _other = (other as ShadEmptyTheme);

    return _other.padding == _this.padding &&
        _other.gap == _this.gap &&
        _other.iconSize == _this.iconSize &&
        _other.iconColor == _this.iconColor &&
        _other.titleStyle == _this.titleStyle &&
        _other.descriptionStyle == _this.descriptionStyle &&
        _other.crossAxisAlignment == _this.crossAxisAlignment &&
        _other.mainAxisAlignment == _this.mainAxisAlignment;
  }

  @override
  int get hashCode {
    final _this = (this as ShadEmptyTheme);

    return Object.hash(
      runtimeType,
      _this.padding,
      _this.gap,
      _this.iconSize,
      _this.iconColor,
      _this.titleStyle,
      _this.descriptionStyle,
      _this.crossAxisAlignment,
      _this.mainAxisAlignment,
    );
  }
}
