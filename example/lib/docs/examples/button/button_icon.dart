import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ButtonIconExample extends StatelessWidget {
  const ButtonIconExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ShadButton(
          onPressed: () {},
          leading: const Icon(LucideIcons.mail),
          child: const Text('Login with Email'),
        ),
        ShadButton.outline(
          onPressed: () {},
          trailing: const Icon(LucideIcons.chevronRight),
          child: const Text('Next'),
        ),
      ],
    );
  }
}
