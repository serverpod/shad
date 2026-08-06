# Popover

Displays rich content in a portal, triggered by a button.

## Default

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

const _layer = [
  (name: 'Width', initialValue: '100%'),
  (name: 'Max. width', initialValue: '300px'),
  (name: 'Height', initialValue: '25px'),
  (name: 'Max. height', initialValue: 'none'),
];

class PopoverBasicExample extends StatefulWidget {
  const PopoverBasicExample({super.key});

  @override
  State<PopoverBasicExample> createState() => _PopoverBasicExampleState();
}

class _PopoverBasicExampleState extends State<PopoverBasicExample> {
  final controller = ShadPopoverController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = ShadTheme.of(context).textTheme;
    return ShadPopover(
      controller: controller,
      popover: (_) => SizedBox(
        width: 288,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Text('Dimensions', style: textTheme.h4),
            Text('Set the dimensions for the layer.', style: textTheme.p),
            for (final field in _layer)
              Row(
                children: [
                  Expanded(child: Text(field.name)),
                  Expanded(
                    flex: 2,
                    child: ShadInput(initialValue: field.initialValue),
                  ),
                ],
              ),
          ],
        ),
      ),
      child: ShadButton.outline(
        onPressed: controller.toggle,
        child: const Text('Open popover'),
      ),
    );
  }
}
```

