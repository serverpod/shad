# Empty

A placeholder for an empty state: icon, title, description, and actions.

## Default

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class EmptyBasicExample extends StatelessWidget {
  const EmptyBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      width: 400,
      height: 320,
      columnMainAxisSize: MainAxisSize.max,
      child: ShadEmpty(
        icon: const Icon(LucideIcons.inbox),
        title: const Text('No messages'),
        description: const Text('Messages you receive will show up here.'),
        actions: [
          ShadButton.outline(
            onPressed: () {},
            child: const Text('Refresh'),
          ),
          ShadButton(
            onPressed: () {},
            child: const Text('Compose'),
          ),
        ],
      ),
    );
  }
}
```

