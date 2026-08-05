import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class InputPasswordExample extends StatefulWidget {
  const InputPasswordExample({super.key});

  @override
  State<InputPasswordExample> createState() => _InputPasswordExampleState();
}

class _InputPasswordExampleState extends State<InputPasswordExample> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: ShadInput(
        placeholder: const Text('Password'),
        obscureText: obscure,
        leading: const Icon(LucideIcons.lock),
        trailing: SizedBox.square(
          dimension: 24,
          child: OverflowBox(
            maxWidth: 28,
            maxHeight: 28,
            child: ShadIconButton(
              iconSize: 20,
              padding: const EdgeInsets.all(2),
              icon: Icon(obscure ? LucideIcons.eyeOff : LucideIcons.eye),
              onPressed: () => setState(() => obscure = !obscure),
            ),
          ),
        ),
      ),
    );
  }
}
