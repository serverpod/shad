import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/src/theme/theme.dart';

@immutable
class ShadBreakpoints {
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

  final ShadBreakpoint tn;
  final ShadBreakpoint sm;
  final ShadBreakpoint md;
  final ShadBreakpoint lg;
  final ShadBreakpoint xl;
  final ShadBreakpoint xxl;

  ShadBreakpoint fromWidth(double width) {
    if (width < sm.value) return tn;
    if (width < md.value) return sm;
    if (width < lg.value) return md;
    if (width < xl.value) return lg;
    if (width < xxl.value) return xl;
    return xxl;
  }

  static ShadBreakpoints? lerp(
    ShadBreakpoints? a,
    ShadBreakpoints? b,
    double t,
  ) {
    return ShadBreakpoints(
      tn: ShadBreakpoint.lerp(a!.tn, b!.tn, t),
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

@immutable
sealed class ShadBreakpoint {
  const ShadBreakpoint(this.value);

  final double value;

  bool operator <(ShadBreakpoint other) {
    return value < other.value;
  }

  bool operator >(ShadBreakpoint other) {
    return value > other.value;
  }

  bool operator <=(ShadBreakpoint other) {
    return value <= other.value;
  }

  bool operator >=(ShadBreakpoint other) {
    return value >= other.value;
  }

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

class ShadBreakpointTN extends ShadBreakpoint {
  const ShadBreakpointTN(super.value);
}

class ShadBreakpointSM extends ShadBreakpoint {
  const ShadBreakpointSM(super.value);
}

class ShadBreakpointMD extends ShadBreakpoint {
  const ShadBreakpointMD(super.value);
}

class ShadBreakpointLG extends ShadBreakpoint {
  const ShadBreakpointLG(super.value);
}

class ShadBreakpointXL extends ShadBreakpoint {
  const ShadBreakpointXL(super.value);
}

class ShadBreakpointXXL extends ShadBreakpoint {
  const ShadBreakpointXXL(super.value);
}

typedef ShadResponsiveWidgetBuilder =
    Widget Function(
      BuildContext context,
      ShadBreakpoint breakpoint,
    );

class ShadResponsiveBuilder extends StatelessWidget {
  const ShadResponsiveBuilder({
    super.key,
    required this.builder,
  });

  final ShadResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final breakpoints = ShadTheme.of(context).breakpoints;
    final breakpoint = breakpoints.fromWidth(width);
    return builder(context, breakpoint);
  }
}

@Deprecated(
  'Renamed to ShadResponsiveWidgetBuilder. '
  'This name will be removed in v1.0.0.',
)
typedef ResponsiveWidgetBuilder = ShadResponsiveWidgetBuilder;
