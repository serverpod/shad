# Badge

Displays a badge or a component that looks like a badge.

## Variants

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class BadgeVariantsExample extends StatelessWidget {
  const BadgeVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ShadBadge(child: Text('Primary')),
        ShadBadge.secondary(child: Text('Secondary')),
        ShadBadge.destructive(child: Text('Destructive')),
        ShadBadge.outline(child: Text('Outline')),
      ],
    );
  }
}
```

