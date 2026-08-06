# Radio Group

A set of checkable buttons where only one can be checked at a time.

## Default

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

enum NotifyAbout {
  all('All new messages'),
  mentions('Direct messages and mentions'),
  nothing('Nothing');

  const NotifyAbout(this.message);

  final String message;
}

class RadioGroupBasicExample extends StatelessWidget {
  const RadioGroupBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadRadioGroup<NotifyAbout>(
      initialValue: NotifyAbout.mentions,
      onChanged: (value) {},
      items: [
        for (final option in NotifyAbout.values)
          ShadRadio(value: option, label: Text(option.message)),
      ],
    );
  }
}
```

