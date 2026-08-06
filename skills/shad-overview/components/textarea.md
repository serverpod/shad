# Textarea

A multi-line text input, optionally user-resizable.

## Default

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TextareaBasicExample extends StatelessWidget {
  const TextareaBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: ShadTextarea(
        placeholder: const Text('Type your message here...'),
        onChanged: (value) {},
      ),
    );
  }
}
```

