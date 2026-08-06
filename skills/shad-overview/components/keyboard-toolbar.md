# Keyboard Toolbar

A toolbar shown above the software keyboard on mobile, with focus navigation and a done button.

## Default

Run on a mobile device to see the toolbar.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class KeyboardToolbarBasicExample extends StatelessWidget {
  const KeyboardToolbarBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: ShadInput(
        placeholder: const Text('Focus on mobile to show the toolbar'),
        keyboardType: TextInputType.emailAddress,
        keyboardToolbarBuilder: (context) => const ShadDefaultKeyboardToolbar(),
      ),
    );
  }
}
```

