import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ButtonSizesExample extends StatelessWidget {
  const ButtonSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ShadButton.outline(
          size: ShadButtonSize.sm,
          onPressed: () {},
          child: const Text('Small'),
        ),
        ShadButton.outline(
          onPressed: () {},
          child: const Text('Regular'),
        ),
        ShadButton.outline(
          size: ShadButtonSize.lg,
          onPressed: () {},
          child: const Text('Large'),
        ),
      ],
    );
  }
}
