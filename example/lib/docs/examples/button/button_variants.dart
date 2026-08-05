import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ButtonVariantsExample extends StatelessWidget {
  const ButtonVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ShadButton(
          onPressed: () {},
          child: const Text('Primary'),
        ),
        ShadButton.secondary(
          onPressed: () {},
          child: const Text('Secondary'),
        ),
        ShadButton.destructive(
          onPressed: () {},
          child: const Text('Destructive'),
        ),
        ShadButton.outline(
          onPressed: () {},
          child: const Text('Outline'),
        ),
        ShadButton.ghost(
          onPressed: () {},
          child: const Text('Ghost'),
        ),
        ShadButton.link(
          onPressed: () {},
          child: const Text('Link'),
        ),
      ],
    );
  }
}
