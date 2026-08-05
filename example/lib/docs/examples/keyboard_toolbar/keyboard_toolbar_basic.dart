import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
