# Toast

A succinct message that is displayed temporarily.

## Default

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ToastBasicExample extends StatelessWidget {
  const ToastBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadButton.outline(
      child: const Text('Add to calendar'),
      onPressed: () {
        final toaster = ShadToaster.of(context);
        toaster.show(
          ShadToast(
            title: const Text('Scheduled: Catch up'),
            description: const Text('Friday, February 10, 2023 at 5:57 PM'),
            action: ShadButton.outline(
              child: const Text('Undo'),
              onPressed: () => toaster.hide(),
            ),
          ),
        );
      },
    );
  }
}
```

## Destructive

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ToastDestructiveExample extends StatelessWidget {
  const ToastDestructiveExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadButton.outline(
      child: const Text('Show destructive toast'),
      onPressed: () {
        ShadToaster.of(context).show(
          const ShadToast.destructive(
            title: Text('Uh oh! Something went wrong'),
            description: Text('There was a problem with your request'),
          ),
        );
      },
    );
  }
}
```

