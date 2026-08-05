import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class IconButtonVariantsExample extends StatelessWidget {
  const IconButtonVariantsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ShadIconButton(
          onPressed: () {},
          icon: const Icon(LucideIcons.rocket),
        ),
        ShadIconButton.secondary(
          onPressed: () {},
          icon: const Icon(LucideIcons.rocket),
        ),
        ShadIconButton.destructive(
          onPressed: () {},
          icon: const Icon(LucideIcons.rocket),
        ),
        ShadIconButton.outline(
          onPressed: () {},
          icon: const Icon(LucideIcons.rocket),
        ),
        ShadIconButton.ghost(
          onPressed: () {},
          icon: const Icon(LucideIcons.rocket),
        ),
      ],
    );
  }
}
