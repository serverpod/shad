import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/utils/responsive.dart';

extension ShadBreakpointsExt on BuildContext {
  ShadBreakpoint get breakpoint {
    final width = MediaQuery.sizeOf(this).width;
    final breakpoints = ShadTheme.of(this).breakpoints;
    return breakpoints.fromWidth(width);
  }
}
