// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'sidebar.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$ShadSidebarTheme {
  bool get canMerge => true;

  static ShadSidebarTheme? lerp(
    ShadSidebarTheme? a,
    ShadSidebarTheme? b,
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

    return ShadSidebarTheme(
      width: lerpDouble$(a.width, b.width, t),
      collapsedWidth: lerpDouble$(a.collapsedWidth, b.collapsedWidth, t),
      mobileWidth: lerpDouble$(a.mobileWidth, b.mobileWidth, t),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      accentColor: Color.lerp(a.accentColor, b.accentColor, t),
      accentForegroundColor: Color.lerp(
        a.accentForegroundColor,
        b.accentForegroundColor,
        t,
      ),
      ringColor: Color.lerp(a.ringColor, b.ringColor, t),
      ringWidth: lerpDouble$(a.ringWidth, b.ringWidth, t),
      headerPadding: EdgeInsetsGeometry.lerp(
        a.headerPadding,
        b.headerPadding,
        t,
      ),
      footerPadding: EdgeInsetsGeometry.lerp(
        a.footerPadding,
        b.footerPadding,
        t,
      ),
      groupPadding: EdgeInsetsGeometry.lerp(a.groupPadding, b.groupPadding, t),
      contentGap: lerpDouble$(a.contentGap, b.contentGap, t),
      menuGap: lerpDouble$(a.menuGap, b.menuGap, t),
      groupLabelHeight: lerpDouble$(a.groupLabelHeight, b.groupLabelHeight, t),
      groupLabelPadding: EdgeInsetsGeometry.lerp(
        a.groupLabelPadding,
        b.groupLabelPadding,
        t,
      ),
      groupLabelTextStyle: TextStyle.lerp(
        a.groupLabelTextStyle,
        b.groupLabelTextStyle,
        t,
      ),
      menuButtonHeight: lerpDouble$(a.menuButtonHeight, b.menuButtonHeight, t),
      menuButtonHeightSm: lerpDouble$(
        a.menuButtonHeightSm,
        b.menuButtonHeightSm,
        t,
      ),
      menuButtonHeightLg: lerpDouble$(
        a.menuButtonHeightLg,
        b.menuButtonHeightLg,
        t,
      ),
      menuButtonPadding: EdgeInsetsGeometry.lerp(
        a.menuButtonPadding,
        b.menuButtonPadding,
        t,
      ),
      menuButtonGap: lerpDouble$(a.menuButtonGap, b.menuButtonGap, t),
      menuButtonRadius: BorderRadius.lerp(
        a.menuButtonRadius,
        b.menuButtonRadius,
        t,
      ),
      menuButtonTextStyle: TextStyle.lerp(
        a.menuButtonTextStyle,
        b.menuButtonTextStyle,
        t,
      ),
      menuButtonTextStyleSm: TextStyle.lerp(
        a.menuButtonTextStyleSm,
        b.menuButtonTextStyleSm,
        t,
      ),
      iconSize: lerpDouble$(a.iconSize, b.iconSize, t),
      subMenuMargin: EdgeInsetsGeometry.lerp(
        a.subMenuMargin,
        b.subMenuMargin,
        t,
      ),
      subMenuPadding: EdgeInsetsGeometry.lerp(
        a.subMenuPadding,
        b.subMenuPadding,
        t,
      ),
      subButtonHeight: lerpDouble$(a.subButtonHeight, b.subButtonHeight, t),
      subButtonPadding: EdgeInsetsGeometry.lerp(
        a.subButtonPadding,
        b.subButtonPadding,
        t,
      ),
      subButtonTextStyle: TextStyle.lerp(
        a.subButtonTextStyle,
        b.subButtonTextStyle,
        t,
      ),
      badgeTextStyle: TextStyle.lerp(a.badgeTextStyle, b.badgeTextStyle, t),
      duration: lerpDuration$(a.duration, b.duration, t),
      curve: t < 0.5 ? a.curve : b.curve,
      floatingMargin: EdgeInsetsGeometry.lerp(
        a.floatingMargin,
        b.floatingMargin,
        t,
      ),
      floatingRadius: BorderRadius.lerp(a.floatingRadius, b.floatingRadius, t),
      floatingShadows: t < 0.5 ? a.floatingShadows : b.floatingShadows,
      insetMargin: EdgeInsetsGeometry.lerp(a.insetMargin, b.insetMargin, t),
      insetRadius: BorderRadius.lerp(a.insetRadius, b.insetRadius, t),
      insetShadows: t < 0.5 ? a.insetShadows : b.insetShadows,
    );
  }

  ShadSidebarTheme copyWith({
    double? width,
    double? collapsedWidth,
    double? mobileWidth,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    Color? accentColor,
    Color? accentForegroundColor,
    Color? ringColor,
    double? ringWidth,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? footerPadding,
    EdgeInsetsGeometry? groupPadding,
    double? contentGap,
    double? menuGap,
    double? groupLabelHeight,
    EdgeInsetsGeometry? groupLabelPadding,
    TextStyle? groupLabelTextStyle,
    double? menuButtonHeight,
    double? menuButtonHeightSm,
    double? menuButtonHeightLg,
    EdgeInsetsGeometry? menuButtonPadding,
    double? menuButtonGap,
    BorderRadius? menuButtonRadius,
    TextStyle? menuButtonTextStyle,
    TextStyle? menuButtonTextStyleSm,
    double? iconSize,
    EdgeInsetsGeometry? subMenuMargin,
    EdgeInsetsGeometry? subMenuPadding,
    double? subButtonHeight,
    EdgeInsetsGeometry? subButtonPadding,
    TextStyle? subButtonTextStyle,
    TextStyle? badgeTextStyle,
    Duration? duration,
    Curve? curve,
    EdgeInsetsGeometry? floatingMargin,
    BorderRadius? floatingRadius,
    List<BoxShadow>? floatingShadows,
    EdgeInsetsGeometry? insetMargin,
    BorderRadius? insetRadius,
    List<BoxShadow>? insetShadows,
  }) {
    final _this = (this as ShadSidebarTheme);

    return ShadSidebarTheme(
      width: width ?? _this.width,
      collapsedWidth: collapsedWidth ?? _this.collapsedWidth,
      mobileWidth: mobileWidth ?? _this.mobileWidth,
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      foregroundColor: foregroundColor ?? _this.foregroundColor,
      borderColor: borderColor ?? _this.borderColor,
      accentColor: accentColor ?? _this.accentColor,
      accentForegroundColor:
          accentForegroundColor ?? _this.accentForegroundColor,
      ringColor: ringColor ?? _this.ringColor,
      ringWidth: ringWidth ?? _this.ringWidth,
      headerPadding: headerPadding ?? _this.headerPadding,
      footerPadding: footerPadding ?? _this.footerPadding,
      groupPadding: groupPadding ?? _this.groupPadding,
      contentGap: contentGap ?? _this.contentGap,
      menuGap: menuGap ?? _this.menuGap,
      groupLabelHeight: groupLabelHeight ?? _this.groupLabelHeight,
      groupLabelPadding: groupLabelPadding ?? _this.groupLabelPadding,
      groupLabelTextStyle: groupLabelTextStyle ?? _this.groupLabelTextStyle,
      menuButtonHeight: menuButtonHeight ?? _this.menuButtonHeight,
      menuButtonHeightSm: menuButtonHeightSm ?? _this.menuButtonHeightSm,
      menuButtonHeightLg: menuButtonHeightLg ?? _this.menuButtonHeightLg,
      menuButtonPadding: menuButtonPadding ?? _this.menuButtonPadding,
      menuButtonGap: menuButtonGap ?? _this.menuButtonGap,
      menuButtonRadius: menuButtonRadius ?? _this.menuButtonRadius,
      menuButtonTextStyle: menuButtonTextStyle ?? _this.menuButtonTextStyle,
      menuButtonTextStyleSm:
          menuButtonTextStyleSm ?? _this.menuButtonTextStyleSm,
      iconSize: iconSize ?? _this.iconSize,
      subMenuMargin: subMenuMargin ?? _this.subMenuMargin,
      subMenuPadding: subMenuPadding ?? _this.subMenuPadding,
      subButtonHeight: subButtonHeight ?? _this.subButtonHeight,
      subButtonPadding: subButtonPadding ?? _this.subButtonPadding,
      subButtonTextStyle: subButtonTextStyle ?? _this.subButtonTextStyle,
      badgeTextStyle: badgeTextStyle ?? _this.badgeTextStyle,
      duration: duration ?? _this.duration,
      curve: curve ?? _this.curve,
      floatingMargin: floatingMargin ?? _this.floatingMargin,
      floatingRadius: floatingRadius ?? _this.floatingRadius,
      floatingShadows: floatingShadows ?? _this.floatingShadows,
      insetMargin: insetMargin ?? _this.insetMargin,
      insetRadius: insetRadius ?? _this.insetRadius,
      insetShadows: insetShadows ?? _this.insetShadows,
    );
  }

  ShadSidebarTheme merge(ShadSidebarTheme? other) {
    final _this = (this as ShadSidebarTheme);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      width: other.width,
      collapsedWidth: other.collapsedWidth,
      mobileWidth: other.mobileWidth,
      backgroundColor: other.backgroundColor,
      foregroundColor: other.foregroundColor,
      borderColor: other.borderColor,
      accentColor: other.accentColor,
      accentForegroundColor: other.accentForegroundColor,
      ringColor: other.ringColor,
      ringWidth: other.ringWidth,
      headerPadding: other.headerPadding,
      footerPadding: other.footerPadding,
      groupPadding: other.groupPadding,
      contentGap: other.contentGap,
      menuGap: other.menuGap,
      groupLabelHeight: other.groupLabelHeight,
      groupLabelPadding: other.groupLabelPadding,
      groupLabelTextStyle:
          _this.groupLabelTextStyle?.merge(other.groupLabelTextStyle) ??
          other.groupLabelTextStyle,
      menuButtonHeight: other.menuButtonHeight,
      menuButtonHeightSm: other.menuButtonHeightSm,
      menuButtonHeightLg: other.menuButtonHeightLg,
      menuButtonPadding: other.menuButtonPadding,
      menuButtonGap: other.menuButtonGap,
      menuButtonRadius: other.menuButtonRadius,
      menuButtonTextStyle:
          _this.menuButtonTextStyle?.merge(other.menuButtonTextStyle) ??
          other.menuButtonTextStyle,
      menuButtonTextStyleSm:
          _this.menuButtonTextStyleSm?.merge(other.menuButtonTextStyleSm) ??
          other.menuButtonTextStyleSm,
      iconSize: other.iconSize,
      subMenuMargin: other.subMenuMargin,
      subMenuPadding: other.subMenuPadding,
      subButtonHeight: other.subButtonHeight,
      subButtonPadding: other.subButtonPadding,
      subButtonTextStyle:
          _this.subButtonTextStyle?.merge(other.subButtonTextStyle) ??
          other.subButtonTextStyle,
      badgeTextStyle:
          _this.badgeTextStyle?.merge(other.badgeTextStyle) ??
          other.badgeTextStyle,
      duration: other.duration,
      curve: other.curve,
      floatingMargin: other.floatingMargin,
      floatingRadius: other.floatingRadius,
      floatingShadows: other.floatingShadows,
      insetMargin: other.insetMargin,
      insetRadius: other.insetRadius,
      insetShadows: other.insetShadows,
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

    final _this = (this as ShadSidebarTheme);
    final _other = (other as ShadSidebarTheme);

    return _other.width == _this.width &&
        _other.collapsedWidth == _this.collapsedWidth &&
        _other.mobileWidth == _this.mobileWidth &&
        _other.backgroundColor == _this.backgroundColor &&
        _other.foregroundColor == _this.foregroundColor &&
        _other.borderColor == _this.borderColor &&
        _other.accentColor == _this.accentColor &&
        _other.accentForegroundColor == _this.accentForegroundColor &&
        _other.ringColor == _this.ringColor &&
        _other.ringWidth == _this.ringWidth &&
        _other.headerPadding == _this.headerPadding &&
        _other.footerPadding == _this.footerPadding &&
        _other.groupPadding == _this.groupPadding &&
        _other.contentGap == _this.contentGap &&
        _other.menuGap == _this.menuGap &&
        _other.groupLabelHeight == _this.groupLabelHeight &&
        _other.groupLabelPadding == _this.groupLabelPadding &&
        _other.groupLabelTextStyle == _this.groupLabelTextStyle &&
        _other.menuButtonHeight == _this.menuButtonHeight &&
        _other.menuButtonHeightSm == _this.menuButtonHeightSm &&
        _other.menuButtonHeightLg == _this.menuButtonHeightLg &&
        _other.menuButtonPadding == _this.menuButtonPadding &&
        _other.menuButtonGap == _this.menuButtonGap &&
        _other.menuButtonRadius == _this.menuButtonRadius &&
        _other.menuButtonTextStyle == _this.menuButtonTextStyle &&
        _other.menuButtonTextStyleSm == _this.menuButtonTextStyleSm &&
        _other.iconSize == _this.iconSize &&
        _other.subMenuMargin == _this.subMenuMargin &&
        _other.subMenuPadding == _this.subMenuPadding &&
        _other.subButtonHeight == _this.subButtonHeight &&
        _other.subButtonPadding == _this.subButtonPadding &&
        _other.subButtonTextStyle == _this.subButtonTextStyle &&
        _other.badgeTextStyle == _this.badgeTextStyle &&
        _other.duration == _this.duration &&
        _other.curve == _this.curve &&
        _other.floatingMargin == _this.floatingMargin &&
        _other.floatingRadius == _this.floatingRadius &&
        _other.floatingShadows == _this.floatingShadows &&
        _other.insetMargin == _this.insetMargin &&
        _other.insetRadius == _this.insetRadius &&
        _other.insetShadows == _this.insetShadows;
  }

  @override
  int get hashCode {
    final _this = (this as ShadSidebarTheme);

    return Object.hashAll([
      runtimeType,
      _this.width,
      _this.collapsedWidth,
      _this.mobileWidth,
      _this.backgroundColor,
      _this.foregroundColor,
      _this.borderColor,
      _this.accentColor,
      _this.accentForegroundColor,
      _this.ringColor,
      _this.ringWidth,
      _this.headerPadding,
      _this.footerPadding,
      _this.groupPadding,
      _this.contentGap,
      _this.menuGap,
      _this.groupLabelHeight,
      _this.groupLabelPadding,
      _this.groupLabelTextStyle,
      _this.menuButtonHeight,
      _this.menuButtonHeightSm,
      _this.menuButtonHeightLg,
      _this.menuButtonPadding,
      _this.menuButtonGap,
      _this.menuButtonRadius,
      _this.menuButtonTextStyle,
      _this.menuButtonTextStyleSm,
      _this.iconSize,
      _this.subMenuMargin,
      _this.subMenuPadding,
      _this.subButtonHeight,
      _this.subButtonPadding,
      _this.subButtonTextStyle,
      _this.badgeTextStyle,
      _this.duration,
      _this.curve,
      _this.floatingMargin,
      _this.floatingRadius,
      _this.floatingShadows,
      _this.insetMargin,
      _this.insetRadius,
      _this.insetShadows,
    ]);
  }
}
