import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SpinnerBasicExample extends StatelessWidget {
  const SpinnerBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 24,
      children: [
        ShadSpinner(size: 16),
        ShadSpinner(),
        ShadSpinner(size: 32),
      ],
    );
  }
}
