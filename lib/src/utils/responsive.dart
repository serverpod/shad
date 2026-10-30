import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/theme.dart';

/// The screen widths at which the layout changes, as in Tailwind CSS.
///
/// Read the current set from the `breakpoints` of [ShadTheme], and the
/// current breakpoint with [ShadResponsiveBuilder].
@immutable
class ShadBreakpoints {
  /// Creates breakpoints from minimum widths in logical pixels.
  ///
  /// The defaults are the Tailwind CSS values: [sm] 640, [md] 768, [lg] 1024,
  /// [xl] 1280 and [xxl] 1536. [tn] starts at 0.
  ShadBreakpoints({
    double tn = 0,
    double sm = 640,
    double md = 768,
    double lg = 1024,
    double xl = 1280,
    double xxl = 1536,
  }) : tn = ShadBreakpointTN(tn),
       sm = ShadBreakpointSM(sm),
       md = ShadBreakpointMD(md),
       lg = ShadBreakpointLG(lg),
       xl = ShadBreakpointXL(xl),
       xxl = ShadBreakpointXXL(xxl);

  /// The tiny breakpoint, for widths below [sm]. Starts at 0 by default.
  final ShadBreakpoint tn;

  /// The small breakpoint. Starts at 640 by default.
  final ShadBreakpoint sm;

  /// The medium breakpoint. Starts at 768 by default.
  final ShadBreakpoint md;

  /// The large breakpoint. Starts at 1024 by default.
  final ShadBreakpoint lg;

  /// The extra-large breakpoint. Starts at 1280 by default.
  final ShadBreakpoint xl;

  /// The 2xl breakpoint. Starts at 1536 by default.
  final ShadBreakpoint xxl;

  /// Returns the largest breakpoint whose minimum width is not more than
  /// [width].
  ShadBreakpoint fromWidth(double width) {
    if (width < sm.value) return tn;
    if (width < md.value) return sm;
    if (width < lg.value) return md;
    if (width < xl.value) return lg;
    if (width < xxl.value) return xl;
    return xxl;
  }

  /// Interpolates between two sets of breakpoints.
  ///
  /// Both [a] and [b] must be non-null.
  static ShadBreakpoints? lerp(
    ShadBreakpoints? a,
    ShadBreakpoints? b,
    double t,
  ) {
    if (a == null || b == null) return t < .5 ? a : b;
    return ShadBreakpoints(
      tn: ShadBreakpoint.lerp(a.tn, b.tn, t),
      sm: ShadBreakpoint.lerp(a.sm, b.sm, t),
      md: ShadBreakpoint.lerp(a.md, b.md, t),
      lg: ShadBreakpoint.lerp(a.lg, b.lg, t),
      xl: ShadBreakpoint.lerp(a.xl, b.xl, t),
      xxl: ShadBreakpoint.lerp(a.xxl, b.xxl, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ShadBreakpoints &&
        other.tn == tn &&
        other.sm == sm &&
        other.md == md &&
        other.lg == lg &&
        other.xl == xl &&
        other.xxl == xxl;
  }

  @override
  int get hashCode => Object.hash(tn, sm, md, lg, xl, xxl);
}

/// A named minimum screen width.
///
/// Compare breakpoints with the `<`, `>`, `<=` and `>=` operators, which
/// compare their [value]s.
@immutable
sealed class ShadBreakpoint {
  const ShadBreakpoint(this.value);

  /// The minimum width of the breakpoint, in logical pixels.
  final double value;

  /// Whether this breakpoint starts at a smaller width than [other].
  bool operator <(ShadBreakpoint other) {
    return value < other.value;
  }

  /// Whether this breakpoint starts at a larger width than [other].
  bool operator >(ShadBreakpoint other) {
    return value > other.value;
  }

  /// Whether this breakpoint starts at or below the width of [other].
  bool operator <=(ShadBreakpoint other) {
    return value <= other.value;
  }

  /// Whether this breakpoint starts at or above the width of [other].
  bool operator >=(ShadBreakpoint other) {
    return value >= other.value;
  }

  /// Interpolates between the values of two breakpoints.
  static double lerp(ShadBreakpoint a, ShadBreakpoint b, double t) {
    return lerpDouble(a.value, b.value, t)!;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    // The subclasses add no fields, so comparing [runtimeType] and [value] is
    // enough to keep e.g. `ShadBreakpointSM(0) != ShadBreakpointMD(0)`.
    return other is ShadBreakpoint &&
        other.runtimeType == runtimeType &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);
}

/// The tiny breakpoint. See [ShadBreakpoints.tn].
class ShadBreakpointTN extends ShadBreakpoint {
  /// Creates a tiny breakpoint that starts at [value].
  const ShadBreakpointTN(super.value);
}

/// The small breakpoint. See [ShadBreakpoints.sm].
class ShadBreakpointSM extends ShadBreakpoint {
  /// Creates a small breakpoint that starts at [value].
  const ShadBreakpointSM(super.value);
}

/// The medium breakpoint. See [ShadBreakpoints.md].
class ShadBreakpointMD extends ShadBreakpoint {
  /// Creates a medium breakpoint that starts at [value].
  const ShadBreakpointMD(super.value);
}

/// The large breakpoint. See [ShadBreakpoints.lg].
class ShadBreakpointLG extends ShadBreakpoint {
  /// Creates a large breakpoint that starts at [value].
  const ShadBreakpointLG(super.value);
}

/// The extra-large breakpoint. See [ShadBreakpoints.xl].
class ShadBreakpointXL extends ShadBreakpoint {
  /// Creates an extra-large breakpoint that starts at [value].
  const ShadBreakpointXL(super.value);
}

/// The 2xl breakpoint. See [ShadBreakpoints.xxl].
class ShadBreakpointXXL extends ShadBreakpoint {
  /// Creates a 2xl breakpoint that starts at [value].
  const ShadBreakpointXXL(super.value);
}

/// Builds a widget for the current [ShadBreakpoint].
typedef ShadResponsiveWidgetBuilder =
    Widget Function(
      BuildContext context,
      ShadBreakpoint breakpoint,
    );

/// Builds its child for the breakpoint that matches the screen width.
///
/// The width comes from [MediaQuery], so the builder runs again when the
/// screen size changes. The breakpoints come from the theme.
class ShadResponsiveBuilder extends StatelessWidget {
  /// Creates a builder that calls [builder] with the current breakpoint.
  const ShadResponsiveBuilder({
    super.key,
    required this.builder,
  });

  /// Builds the child for the current breakpoint.
  final ShadResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final breakpoints = ShadTheme.of(context).breakpoints;
    final breakpoint = breakpoints.fromWidth(width);
    return builder(context, breakpoint);
  }
}
