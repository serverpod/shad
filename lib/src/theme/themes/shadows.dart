import 'package:flutter/widgets.dart';

/// Tailwind's shadow scale.
///
/// Every outward shadow uses [BlurStyle.outer]: CSS clips a box-shadow to
/// *outside* the border box, so it is never visible through a transparent or
/// translucent element. Flutter's default blur paints the whole shadow rect
/// behind the box, which turned every transparent-filled control (checkboxes,
/// fields, translucent menus) slightly grey.
abstract class Shadows {
  /// Tailwind's `shadow-none`.
  static const none = <BoxShadow>[];

  /// Tailwind's `shadow-xs`.
  static const xs = [
    BoxShadow(
      color: Color(0x0d000000),
      offset: Offset(0, 1),
      blurRadius: 1,
      blurStyle: BlurStyle.outer,
    ),
  ];

  static const sm = [
    BoxShadow(
      color: Color(0x0d000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      blurStyle: BlurStyle.outer,
    ),
  ];

  static const regular = [
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      blurStyle: BlurStyle.outer,
    ),
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: -1,
      blurStyle: BlurStyle.outer,
    ),
  ];

  static const md = [
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
      blurStyle: BlurStyle.outer,
    ),
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
      blurStyle: BlurStyle.outer,
    ),
  ];

  static const lg = [
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
      blurStyle: BlurStyle.outer,
    ),
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -4,
      blurStyle: BlurStyle.outer,
    ),
  ];

  static const xl = [
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
      blurStyle: BlurStyle.outer,
    ),
    BoxShadow(
      color: Color(0x1a000000),
      offset: Offset(0, 8),
      blurRadius: 10,
      spreadRadius: -6,
      blurStyle: BlurStyle.outer,
    ),
  ];

  static const xl2 = [
    BoxShadow(
      color: Color(0x40000000),
      offset: Offset(0, 25),
      blurRadius: 50,
      spreadRadius: -12,
      blurStyle: BlurStyle.outer,
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
