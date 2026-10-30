import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

/// The distances of a widget from the edges of a [Stack], as in [Positioned].
///
/// Used to place toasts, sheets and dialogs. A null side is not constrained.
@immutable
class ShadPosition {
  /// Creates a position from distances to the top, left, right and bottom
  /// edges.
  const ShadPosition({
    this.top,
    this.left,
    this.right,
    this.bottom,
  });

  /// Creates a position from distances to the start and end edges.
  ///
  /// [textDirection] decides whether start is the left or the right edge.
  factory ShadPosition.directional({
    double? top,
    double? bottom,
    double? start,
    double? end,
    required TextDirection textDirection,
  }) {
    final (double? left, double? right) = switch (textDirection) {
      TextDirection.rtl => (end, start),
      TextDirection.ltr => (start, end),
    };
    return ShadPosition(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
    );
  }

  /// The distance from the top edge.
  final double? top;

  /// The distance from the left edge.
  final double? left;

  /// The distance from the right edge.
  final double? right;

  /// The distance from the bottom edge.
  final double? bottom;

  /// Returns a copy with the given fields replaced.
  ShadPosition copyWith({
    double? top,
    double? left,
    double? right,
    double? bottom,
  }) {
    return ShadPosition(
      top: top ?? this.top,
      left: left ?? this.left,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
    );
  }

  /// Returns [b] for every [t].
  ///
  /// It does not interpolate the distances, so a theme animation jumps to the
  /// new position.
  static ShadPosition? lerp(
    ShadPosition? a,
    ShadPosition? b,
    double t,
  ) {
    if (identical(a, b)) return a;
    // Sides set on both ends interpolate; a side set on only one end cannot,
    // so it switches halfway.
    double? side(double? from, double? to) => from != null && to != null
        ? lerpDouble(from, to, t)
        : (t < .5 ? from : to);
    return ShadPosition(
      top: side(a?.top, b?.top),
      left: side(a?.left, b?.left),
      right: side(a?.right, b?.right),
      bottom: side(a?.bottom, b?.bottom),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShadPosition &&
        other.top == top &&
        other.left == left &&
        other.right == right &&
        other.bottom == bottom;
  }

  @override
  String toString() {
    return 'ShadPosition(top: $top, left: $left, '
        'right: $right, bottom: $bottom)';
  }

  @override
  int get hashCode => Object.hashAll([top, left, right, bottom]);
}

/// Wraps a widget in a [Positioned] widget.
extension PositionedExt on Widget {
  /// Wraps this widget in a [Positioned] with the distances of [position].
  Widget positionedWith(ShadPosition position) {
    return Positioned(
      top: position.top,
      left: position.left,
      right: position.right,
      bottom: position.bottom,
      child: this,
    );
  }
}
