# Tooltip

A popup that displays information related to an element on hover or focus.

## Basic

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TooltipBasicExample extends StatelessWidget {
  const TooltipBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTooltip(
      builder: (context) => const Text('Add to library'),
      child: ShadButton.outline(
        onPressed: () {},
        child: const Text('Show Tooltip'),
      ),
    );
  }
}
```

## Sides

An anchor places the tooltip on any side of its trigger; the arrow direction follows it.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TooltipSidesExample extends StatelessWidget {
  const TooltipSidesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _SideTooltip(label: 'Left', direction: AxisDirection.left),
        _SideTooltip(label: 'Top', direction: AxisDirection.up),
        _SideTooltip(label: 'Bottom', direction: AxisDirection.down),
        _SideTooltip(label: 'Right', direction: AxisDirection.right),
      ],
    );
  }
}

class _SideTooltip extends StatelessWidget {
  const _SideTooltip({required this.label, required this.direction});

  final String label;

  /// The side of the trigger the tooltip appears on.
  final AxisDirection direction;

  @override
  Widget build(BuildContext context) {
    final anchor = switch (direction) {
      AxisDirection.up => const ShadAnchor(
        childAlignment: Alignment.topCenter,
        overlayAlignment: Alignment.bottomCenter,
        offset: Offset(0, -4),
      ),
      AxisDirection.down => const ShadAnchor(
        childAlignment: Alignment.bottomCenter,
        overlayAlignment: Alignment.topCenter,
        offset: Offset(0, 4),
      ),
      AxisDirection.left => const ShadAnchor(
        childAlignment: Alignment.centerLeft,
        overlayAlignment: Alignment.centerRight,
        offset: Offset(-4, 0),
      ),
      AxisDirection.right => const ShadAnchor(
        childAlignment: Alignment.centerRight,
        overlayAlignment: Alignment.centerLeft,
        offset: Offset(4, 0),
      ),
    };

    return ShadTooltip(
      anchor: anchor,
      // The arrow points back at the trigger, opposite the placement side.
      arrowDirection: switch (direction) {
        AxisDirection.up => AxisDirection.down,
        AxisDirection.down => AxisDirection.up,
        AxisDirection.left => AxisDirection.right,
        AxisDirection.right => AxisDirection.left,
      },
      builder: (context) => const Text('Add to library'),
      child: ShadButton.outline(onPressed: () {}, child: Text(label)),
    );
  }
}
```

## With icon

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TooltipIconExample extends StatelessWidget {
  const TooltipIconExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTooltip(
      builder: (context) => const Text('Additional information'),
      child: ShadIconButton.ghost(
        icon: const Icon(LucideIcons.info),
        onPressed: () {},
      ),
    );
  }
}
```

## Long content

Long content wraps at the tooltip’s max width.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TooltipLongContentExample extends StatelessWidget {
  const TooltipLongContentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTooltip(
      // Long content wraps at the tooltip's max width.
      builder: (context) => const Text(
        'To learn more about how this works, check out the docs. If you '
        'have any questions, please reach out to us.',
      ),
      child: ShadButton.outline(
        onPressed: () {},
        child: const Text('Show Tooltip'),
      ),
    );
  }
}
```

## Disabled

A disabled control absorbs pointer events, so a gesture wrapper reports the hover on its behalf.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TooltipDisabledExample extends StatelessWidget {
  const TooltipDisabledExample({super.key});

  @override
  Widget build(BuildContext context) {
    // A disabled button absorbs pointer events, so a wrapper reports the
    // hover on its behalf — the reference wraps its trigger in a span for
    // the same reason.
    return ShadTooltip(
      builder: (context) => const Text('This feature is currently unavailable'),
      child: ShadGestureDetector(
        child: ShadButton.outline(
          enabled: false,
          onPressed: () {},
          child: const Text('Disabled'),
        ),
      ),
    );
  }
}
```

## With keyboard shortcut

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TooltipKeyboardExample extends StatelessWidget {
  const TooltipKeyboardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTooltip(
      builder: (context) => const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Save Changes'),
          SizedBox(width: 6),
          ShadKbd('S'),
        ],
      ),
      child: ShadIconButton.outline(
        icon: const Icon(LucideIcons.save),
        onPressed: () {},
      ),
    );
  }
}
```

## On link

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TooltipLinkExample extends StatelessWidget {
  const TooltipLinkExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTooltip(
      builder: (context) => const Text('Click to read the documentation'),
      child: ShadButton.link(
        onPressed: () {},
        child: const Text('Learn more'),
      ),
    );
  }
}
```

## Formatted content

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TooltipFormattedExample extends StatelessWidget {
  const TooltipFormattedExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTooltip(
      builder: (context) {
        final style = DefaultTextStyle.of(context).style;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active',
              style: style.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Opacity(
              opacity: .8,
              child: Text('Last updated 2 hours ago', style: style),
            ),
          ],
        );
      },
      child: ShadButton.outline(onPressed: () {}, child: const Text('Status')),
    );
  }
}
```

