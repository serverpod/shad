# Button

Displays a button or a component that looks like a button. Six variants share one API: pick the one matching the action's weight.

## Variants

Primary for the main action, secondary and outline for everything else, destructive for irreversible actions, ghost for toolbars, and link for inline navigation.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ButtonVariantsExample extends StatelessWidget {
  const ButtonVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ShadButton(
          onPressed: () {},
          child: const Text('Primary'),
        ),
        ShadButton.secondary(
          onPressed: () {},
          child: const Text('Secondary'),
        ),
        ShadButton.destructive(
          onPressed: () {},
          child: const Text('Destructive'),
        ),
        ShadButton.outline(
          onPressed: () {},
          child: const Text('Outline'),
        ),
        ShadButton.ghost(
          onPressed: () {},
          child: const Text('Ghost'),
        ),
        ShadButton.link(
          onPressed: () {},
          child: const Text('Link'),
        ),
      ],
    );
  }
}
```

## Sizes

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ButtonSizesExample extends StatelessWidget {
  const ButtonSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ShadButton.outline(
          size: ShadButtonSize.sm,
          onPressed: () {},
          child: const Text('Small'),
        ),
        ShadButton.outline(
          onPressed: () {},
          child: const Text('Regular'),
        ),
        ShadButton.outline(
          size: ShadButtonSize.lg,
          onPressed: () {},
          child: const Text('Large'),
        ),
      ],
    );
  }
}
```

## With icon

Use leading and trailing to place icons around the label.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ButtonIconExample extends StatelessWidget {
  const ButtonIconExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ShadButton(
          onPressed: () {},
          leading: const Icon(LucideIcons.mail),
          child: const Text('Login with Email'),
        ),
        ShadButton.outline(
          onPressed: () {},
          trailing: const Icon(LucideIcons.chevronRight),
          child: const Text('Next'),
        ),
      ],
    );
  }
}
```

## Loading

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ButtonLoadingExample extends StatelessWidget {
  const ButtonLoadingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadButton(
      enabled: false,
      leading: const SizedBox.square(
        dimension: 16,
        child: ShadSpinner(),
      ),
      child: const Text('Please wait'),
    );
  }
}
```

