import 'package:flutter/widgets.dart';

/// Tailwind's shadow scale.
///
/// These are the CSS values as written; the clipping CSS does on top of them —
/// an outer shadow is never visible through the element it belongs to — is
/// `ShadShadowDecoration`'s job, and every Shad component paints its shadows
/// through one. Handing these to a plain [BoxDecoration] instead gives
/// Flutter's own behaviour, which paints the whole blurred shape behind the
/// box and so washes a transparent or translucent fill grey.
abstract class Shadows {
  /// Tailwind's `shadow-none`.
  static const none = <BoxShadow>[];

  /// Tailwind's `shadow-xs`.
  static const xs = [
    BoxShadow(
      color: Color(0x0d000000),
      offset: Offset(0, 1),
      blurRadius: 1,
    ),
  ];

  static const sm = [
    BoxShadow(
      color: Color(0x0d000000),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static const regular = [
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: -1,
    ),
  ];

  static const md = [
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
    ),
  ];

  static const lg = [
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -4,
    ),
  ];

  static const xl = [
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 8),
      blurRadius: 10,
      spreadRadius: -6,
    ),
  ];

  static const xl2 = [
    BoxShadow(
      color: Color(0x40000000),
      offset: Offset(0, 25),
      blurRadius: 50,
      spreadRadius: -12,
    ),
  ];

  static const inner = [
    BoxShadow(
      color: Color(0x0d000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      blurStyle: BlurStyle.inner,
    ),
  ];
}
