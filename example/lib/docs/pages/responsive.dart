import 'package:example/docs/docs.dart';

final responsiveDoc = ComponentDoc(
  slug: 'responsive',
  title: 'Responsive',
  description:
      "Tailwind's breakpoint scale, carried on the theme: a builder widget "
      'and a context extension.',
  body: (context) => const DocProse(
    children: [
      DocSection(
        title: 'Breakpoints',
        children: [
          DocParagraph(
            "The theme carries six breakpoints matching Tailwind's "
            'scale. Override any of them on `ShadThemeData`:',
          ),
          CodeBlock(
            code: '''
ShadThemeData(
  breakpoints: ShadBreakpoints(
    tn: 0,     // tiny
    sm: 640,
    md: 768,
    lg: 1024,
    xl: 1280,
    xxl: 1536,
  ),
)''',
          ),
        ],
      ),
      DocSection(
        title: 'Reading the current breakpoint',
        children: [
          DocParagraph(
            '`ShadResponsiveBuilder` rebuilds with the breakpoint for the '
            'current width; `context.breakpoint` reads the same value '
            'inline.',
          ),
          CodeBlock(
            code: '''
ShadResponsiveBuilder(
  builder: (context, breakpoint) {
    final sm = breakpoint >= ShadTheme.of(context).breakpoints.sm;
    return sm ? const WideLayout() : const NarrowLayout();
  },
)''',
          ),
          DocParagraph(
            "Comparisons follow Tailwind's semantics. `sm` means "
            '"small *and up*", so test with `>=`. Use `==` only to target '
            'exactly one band.',
          ),
        ],
      ),
      DocSection(
        title: 'Switching on the band',
        children: [
          DocParagraph(
            'Each band is its own type on a sealed class, so a `switch` '
            'covers the scale exhaustively:',
          ),
          CodeBlock(
            code: '''
return switch (context.breakpoint) {
  ShadBreakpointTN() => const Text('Tiny'),
  ShadBreakpointSM() => const Text('Small'),
  ShadBreakpointMD() => const Text('Medium'),
  ShadBreakpointLG() => const Text('Large'),
  ShadBreakpointXL() => const Text('Extra large'),
  ShadBreakpointXXL() => const Text('Extra extra large'),
};''',
          ),
        ],
      ),
    ],
  ),
);
