# Responsive

Tailwind's breakpoint scale, carried on the theme: a builder widget and a context extension.

## Breakpoints

The theme carries six breakpoints matching Tailwind's scale. Override any of them on `ShadThemeData`:

```dart
ShadThemeData(
  breakpoints: ShadBreakpoints(
    tn: 0,     // tiny
    sm: 640,
    md: 768,
    lg: 1024,
    xl: 1280,
    xxl: 1536,
  ),
)
```

## Reading the current breakpoint

`ShadResponsiveBuilder` rebuilds with the breakpoint for the current width. `context.breakpoint` reads the same value inline.

```dart
ShadResponsiveBuilder(
  builder: (context, breakpoint) {
    final sm = breakpoint >= ShadTheme.of(context).breakpoints.sm;
    return sm ? const WideLayout() : const NarrowLayout();
  },
)
```

Comparisons follow Tailwind's semantics. `sm` means "small and up", so test with `>=`. Use `==` only to target exactly one band.

## Switching on the band

Each band is its own type on a sealed class, so a `switch` covers the scale exhaustively:

```dart
return switch (context.breakpoint) {
  ShadBreakpointTN() => const Text('Tiny'),
  ShadBreakpointSM() => const Text('Small'),
  ShadBreakpointMD() => const Text('Medium'),
  ShadBreakpointLG() => const Text('Large'),
  ShadBreakpointXL() => const Text('Extra large'),
  ShadBreakpointXXL() => const Text('Extra extra large'),
};
```
