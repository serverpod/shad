import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ButtonLoadingExample extends StatelessWidget {
  const ButtonLoadingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadButton(
      enabled: false,
      leading: const SizedBox.square(
        dimension: 16,
        child: ShadSpinner(),
      ),
      child: const Text('Please wait'),
    );
  }
}
