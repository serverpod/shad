// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'pagination.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$ShadPaginationTheme {
  bool get canMerge => true;

  static ShadPaginationTheme? lerp(
    ShadPaginationTheme? a,
    ShadPaginationTheme? b,
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

    return ShadPaginationTheme(
      gap: lerpDouble$(a.gap, b.gap, t),
      mainAxisAlignment: t < 0.5 ? a.mainAxisAlignment : b.mainAxisAlignment,
      siblingCount: t < 0.5 ? a.siblingCount : b.siblingCount,
      boundaryCount: t < 0.5 ? a.boundaryCount : b.boundaryCount,
      showEdges: t < 0.5 ? a.showEdges : b.showEdges,
      ellipsisTextStyle: TextStyle.lerp(
        a.ellipsisTextStyle,
        b.ellipsisTextStyle,
        t,
      ),
    );
  }

  ShadPaginationTheme copyWith({
    double? gap,
    MainAxisAlignment? mainAxisAlignment,
    int? siblingCount,
    int? boundaryCount,
    bool? showEdges,
    TextStyle? ellipsisTextStyle,
  }) {
    final _this = (this as ShadPaginationTheme);

    return ShadPaginationTheme(
      gap: gap ?? _this.gap,
      mainAxisAlignment: mainAxisAlignment ?? _this.mainAxisAlignment,
      siblingCount: siblingCount ?? _this.siblingCount,
      boundaryCount: boundaryCount ?? _this.boundaryCount,
      showEdges: showEdges ?? _this.showEdges,
      ellipsisTextStyle: ellipsisTextStyle ?? _this.ellipsisTextStyle,
    );
  }

  ShadPaginationTheme merge(ShadPaginationTheme? other) {
    final _this = (this as ShadPaginationTheme);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      gap: other.gap,
      mainAxisAlignment: other.mainAxisAlignment,
      siblingCount: other.siblingCount,
      boundaryCount: other.boundaryCount,
      showEdges: other.showEdges,
      ellipsisTextStyle:
          _this.ellipsisTextStyle?.merge(other.ellipsisTextStyle) ??
          other.ellipsisTextStyle,
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

    final _this = (this as ShadPaginationTheme);
    final _other = (other as ShadPaginationTheme);

    return _other.gap == _this.gap &&
        _other.mainAxisAlignment == _this.mainAxisAlignment &&
        _other.siblingCount == _this.siblingCount &&
        _other.boundaryCount == _this.boundaryCount &&
        _other.showEdges == _this.showEdges &&
        _other.ellipsisTextStyle == _this.ellipsisTextStyle;
  }

  @override
  int get hashCode {
    final _this = (this as ShadPaginationTheme);

    return Object.hash(
      runtimeType,
      _this.gap,
      _this.mainAxisAlignment,
      _this.siblingCount,
      _this.boundaryCount,
      _this.showEdges,
      _this.ellipsisTextStyle,
    );
  }
}
