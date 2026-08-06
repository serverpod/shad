# Styles

The eight shadcn styles are complete presets for geometry, typography, and shadows, switchable with one line.

shadcn/ui ships eight named styles, and they are not color variations. Each one is a full geometry set. A `mira` button is 28px tall with 8px of padding where a `sera` button is 40px with 24px, and inputs, menu rows, cards, sliders, and switches move with them. Styles also retype the UI: each one redefines the title, label, body, caption, and field roles, and reshapes it with its own radii and shadows. Every value was read from the shadcn/ui reference CSS.

## Choosing a style

```dart
ShadThemeData(
  style: ShadStyleTokens.maia,
)
```

- `vega`: the classic. 36px controls, moderate radii, subtle shadows.
- `nova`: the default. Vega, condensed to 32px controls and tighter surfaces.
- `maia`: pill-shaped and roomy, with fully rounded controls.
- `lyra`: square. No radii, flat shadows, 12px body text.
- `mira`: the densest. 28px controls on a relaxed 12px line.
- `luma`: soft. Filled fields, large radii, weighty shadows.
- `sera`: editorial. 40px controls, underlined fields, uppercase labels, generous space.
- `rhea`: gently rounded mid-size controls with soft hairlines.

Open the example app's theme editor and switch styles to see them live. The whole app follows.

## Picking at runtime

The presets are values on `ShadStyleTokens`, so a style switcher is a list and a lookup:

```dart
ShadStyleTokens.all;              // the eight presets
ShadStyleTokens.fromName('sera'); // one, by its shadcn name
```

## Custom styles

A style is data, a set of measured tokens. Derive your own from the preset closest to what you want:

```dart
ShadThemeData(
  style: ShadStyleTokens.nova.copyWith(
    buttonRadius: ShadRadiusToken.full,
    buttonHeight: 40,
  ),
)
```

## Spacing

Metrics the reference writes in Tailwind's spacing units follow the theme's `ShadSpacing` step: 4px, like `0.25rem`. Raising it loosens every unit-derived padding and gap in one move:

```dart
ShadThemeData(
  spacing: const ShadSpacing(step: 5),
)
```
