import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/color_scheme/base.dart';

/// The shadcn/ui v3 `gray` colour scheme.
///
/// shadcn/ui v4 no longer ships this palette. It is kept for
/// compatibility.
@immutable
class ShadGrayColorScheme extends ShadColorScheme {
  /// Creates a [ShadGrayColorScheme] from explicit colours.
  ///
  /// Use [ShadGrayColorScheme.light] or [ShadGrayColorScheme.dark] for the
  /// shadcn/ui values.
  const ShadGrayColorScheme({
    required super.background,
    required super.foreground,
    required super.card,
    required super.cardForeground,
    required super.popover,
    required super.popoverForeground,
    required super.primary,
    required super.primaryForeground,
    required super.secondary,
    required super.secondaryForeground,
    required super.muted,
    required super.mutedForeground,
    required super.accent,
    required super.accentForeground,
    required super.destructive,
    required super.destructiveForeground,
    required super.border,
    required super.input,
    required super.ring,
    required super.selection,
    super.custom,
  });

  /// Creates the light variant of [ShadGrayColorScheme].
  ///
  /// Every colour defaults to its light-mode value.
  const ShadGrayColorScheme.light({
    super.background = const Color(0xffffffff),
    super.foreground = const Color(0xff030712),
    super.card = const Color(0xffffffff),
    super.cardForeground = const Color(0xff030712),
    super.popover = const Color(0xffffffff),
    super.popoverForeground = const Color(0xff030712),
    super.primary = const Color(0xff111827),
    super.primaryForeground = const Color(0xfff9fafb),
    super.secondary = const Color(0xfff3f4f6),
    super.secondaryForeground = const Color(0xff111827),
    super.muted = const Color(0xfff3f4f6),
    super.mutedForeground = const Color(0xff6b7280),
    super.accent = const Color(0xfff3f4f6),
    super.accentForeground = const Color(0xff111827),
    super.destructive = const Color(0xffef4444),
    super.destructiveForeground = const Color(0xfff9fafb),
    super.border = const Color(0xffe5e7eb),
    super.input = const Color(0xffe5e7eb),
    super.ring = const Color(0xff030712),
    super.selection = const Color(0xFFB4D7FF),
    super.custom,
  });

  /// Creates the dark variant of [ShadGrayColorScheme].
  ///
  /// Every colour defaults to its dark-mode value.
  const ShadGrayColorScheme.dark({
    super.background = const Color(0xff030712),
    super.foreground = const Color(0xfff9fafb),
    super.card = const Color(0xff030712),
    super.cardForeground = const Color(0xfff9fafb),
    super.popover = const Color(0xff030712),
    super.popoverForeground = const Color(0xfff9fafb),
    super.primary = const Color(0xfff9fafb),
    super.primaryForeground = const Color(0xff111827),
    super.secondary = const Color(0xff1f2937),
    super.secondaryForeground = const Color(0xfff9fafb),
    super.muted = const Color(0xff1f2937),
    super.mutedForeground = const Color(0xff9ca3af),
    super.accent = const Color(0xff1f2937),
    super.accentForeground = const Color(0xfff9fafb),
    super.destructive = const Color(0xffef4444),
    super.destructiveForeground = const Color(0xfff9fafb),
    super.border = const Color(0x1affffff),
    super.input = const Color(0x26ffffff),
    super.ring = const Color(0xffd1d5db),
    super.selection = const Color(0xFF355172),
    super.custom,
  });
}
