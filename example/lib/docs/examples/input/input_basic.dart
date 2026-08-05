import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class InputBasicExample extends StatelessWidget {
  const InputBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: const ShadInput(
        placeholder: Text('Email'),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}
