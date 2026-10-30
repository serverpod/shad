import 'package:flutter/gestures.dart';

/// Adds [copyWith] to [TapDownDetails].
extension TapDownDetailsExtension on TapDownDetails {
  /// Returns a copy with the given fields replaced.
  TapDownDetails copyWith({
    Offset? globalPosition,
    Offset? localPosition,
    PointerDeviceKind? kind,
  }) {
    return TapDownDetails(
      globalPosition: globalPosition ?? this.globalPosition,
      localPosition: localPosition ?? this.localPosition,
      kind: kind ?? this.kind,
    );
  }
}

/// Adds [copyWith] to [TapUpDetails].
extension TapUpDetailsExtension on TapUpDetails {
  /// Returns a copy with the given fields replaced.
  TapUpDetails copyWith({
    Offset? globalPosition,
    Offset? localPosition,
    PointerDeviceKind? kind,
  }) {
    return TapUpDetails(
      globalPosition: globalPosition ?? this.globalPosition,
      localPosition: localPosition ?? this.localPosition,
      kind: kind ?? this.kind,
    );
  }
}

/// Adds [copyWith] to [LongPressStartDetails].
extension LongPressStartDetailsExtension on LongPressStartDetails {
  /// Returns a copy with the given fields replaced.
  LongPressStartDetails copyWith({
    Offset? globalPosition,
    Offset? localPosition,
  }) {
    return LongPressStartDetails(
      globalPosition: globalPosition ?? this.globalPosition,
      localPosition: localPosition ?? this.localPosition,
    );
  }
}

/// Adds [copyWith] to [LongPressMoveUpdateDetails].
extension LongPressMoveUpdateDetailsExtension on LongPressMoveUpdateDetails {
  /// Returns a copy with the given fields replaced.
  LongPressMoveUpdateDetails copyWith({
    Offset? globalPosition,
    Offset? localPosition,
    Offset? offsetFromOrigin,
    Offset? localOffsetFromOrigin,
  }) {
    return LongPressMoveUpdateDetails(
      globalPosition: globalPosition ?? this.globalPosition,
      localPosition: localPosition ?? this.localPosition,
      offsetFromOrigin: offsetFromOrigin ?? this.offsetFromOrigin,
      localOffsetFromOrigin:
          localOffsetFromOrigin ?? this.localOffsetFromOrigin,
    );
  }
}

/// Adds [copyWith] to [LongPressEndDetails].
extension LongPressEndDetailsExtension on LongPressEndDetails {
  /// Returns a copy with the given fields replaced.
  LongPressEndDetails copyWith({
    Velocity? velocity,
    Offset? globalPosition,
    Offset? localPosition,
  }) {
    return LongPressEndDetails(
      velocity: velocity ?? this.velocity,
      globalPosition: globalPosition ?? this.globalPosition,
      localPosition: localPosition ?? this.localPosition,
    );
  }
}

/// Adds [copyWith] to [LongPressDownDetails].
extension LongPressDownDetailsExtension on LongPressDownDetails {
  /// Returns a copy with the given fields replaced.
  LongPressDownDetails copyWith({
    Offset? globalPosition,
    Offset? localPosition,
    PointerDeviceKind? kind,
  }) {
    return LongPressDownDetails(
      globalPosition: globalPosition ?? this.globalPosition,
      localPosition: localPosition ?? this.localPosition,
      kind: kind ?? this.kind,
    );
  }
}
