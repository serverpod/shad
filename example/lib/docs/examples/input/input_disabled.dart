import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class InputDisabledExample extends StatelessWidget {
  const InputDisabledExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: const ShadInput(
        enabled: false,
        placeholder: Text('Email'),
      ),
    );
  }
}
