# Layout

Layout widgets measure gaps and padding in theme spacing steps: `ShadRow`, `ShadColumn`, `ShadGap`, and `ShadPadding`. They read `ShadThemeData.spacing` the same way components do (see [styles.md](styles.md#spacing)), so a layout built from them scales with the rest of the theme.

## Row and column spacing

`ShadRow` and `ShadColumn` accept a `spacing` argument in theme steps.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class LayoutSpacingExample extends StatelessWidget {
  const LayoutSpacingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        ShadCard(
          child: ShadRow(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              for (final label in ['One', 'Two', 'Three'])
                ShadBadge.secondary(child: Text(label)),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: ShadCard(
            child: ShadColumn(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              spacing: 3,
              children: [
                const ShadInput(placeholder: Text('Email')),
                const ShadInput(placeholder: Text('Password')),
                ShadButton(onPressed: () {}, child: const Text('Sign in')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
```

## Gaps

Use `ShadGap` in a plain `Row` or `Column` when only some children need space between them.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class LayoutGapExample extends StatelessWidget {
  const LayoutGapExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: ShadCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Account', style: theme.textTheme.h4),
            const ShadGap(1),
            Text(
              'Manage your profile and security settings.',
              style: theme.textTheme.muted,
            ),
            const ShadGap(4),
            ShadButton.outline(
              onPressed: () {},
              child: const Text('Open settings'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Padding

`ShadPadding` mirrors Tailwind's step-based inset utilities. `symmetric(horizontal: 6, vertical: 4)` matches `px-6 py-4`.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class LayoutPaddingExample extends StatelessWidget {
  const LayoutPaddingExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final spacing = theme.spacing;

    return ColoredBox(
      color: theme.colorScheme.muted,
      child: ShadPadding.symmetric(
        horizontal: 6,
        vertical: 4,
        child: ShadCard(
          child: Text(
            'Inset by ${spacing(6)} x ${spacing(4)}',
            style: theme.textTheme.small,
          ),
        ),
      ),
    );
  }
}
```

## Card sections and form actions

`ShadColumn` with `crossAxisAlignment: stretch` lines up full-width children inside a card, with `ShadSeparator` between groups. The same pattern stacks fields and buttons in a form: put the primary action above an outline cancel. See `example/lib/docs/examples/layout/layout_card_sections.dart` and `layout_form_actions.dart` for the full examples.
