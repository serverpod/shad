# Sonner

An opinionated toast stack: notifications collect and expand on hover.

## Default

```dart
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class SonnerBasicExample extends StatelessWidget {
  const SonnerBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadButton.outline(
      child: const Text('Show Toast'),
      onPressed: () {
        final sonner = ShadSonner.of(context);
        final id = Random().nextInt(1000);
        sonner.show(
          ShadToast(
            id: id,
            title: const Text('Event has been created'),
            description: Text('${DateTime.now()}'),
            action: ShadButton(
              child: const Text('Undo'),
              onPressed: () => sonner.hide(id),
            ),
          ),
        );
      },
    );
  }
}
```

