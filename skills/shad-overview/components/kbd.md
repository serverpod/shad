# Kbd

Displays a keyboard key or chord.

## Default

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class KbdBasicExample extends StatelessWidget {
  const KbdBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        ShadKbd('K'),
        ShadKbd.group(['⌘', 'K']),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Press '),
            ShadKbd.group(['Ctrl', 'Shift', 'P']),
            Text(' to open the palette'),
          ],
        ),
      ],
    );
  }
}
```

