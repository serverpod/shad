import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/utils/responsive.dart';

/// Reads the current [ShadBreakpoint] from a [BuildContext].
extension ShadBreakpointsExt on BuildContext {
  /// The breakpoint that matches the screen width, from the breakpoints of the
  /// current [ShadTheme].
  ///
  /// Rebuilds the caller when the screen size or the theme changes.
  ShadBreakpoint get breakpoint {
    final width = MediaQuery.sizeOf(this).width;
    final breakpoints = ShadTheme.of(this).breakpoints;
    return breakpoints.fromWidth(width);
  }
}
