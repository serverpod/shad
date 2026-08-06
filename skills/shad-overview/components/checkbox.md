# Checkbox

A control that allows the user to toggle between checked and not checked.

## With label

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class CheckboxBasicExample extends StatefulWidget {
  const CheckboxBasicExample({super.key});

  @override
  State<CheckboxBasicExample> createState() => _CheckboxBasicExampleState();
}

class _CheckboxBasicExampleState extends State<CheckboxBasicExample> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return ShadCheckbox(
      value: value,
      onChanged: (v) => setState(() => value = v),
      label: const Text('Accept terms and conditions'),
      sublabel: const Text(
        'You agree to our Terms of Service and Privacy Policy.',
      ),
    );
  }
}
```

## Disabled

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class CheckboxDisabledExample extends StatelessWidget {
  const CheckboxDisabledExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadCheckbox(
      value: true,
      enabled: false,
      onChanged: (v) {},
      label: const Text('Accept terms and conditions'),
    );
  }
}
```

