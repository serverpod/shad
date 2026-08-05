import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProgressBasicExample extends StatelessWidget {
  const ProgressBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 24,
        children: [
          // Determinate: pass a value between 0 and 1.
          ShadProgress(value: .5),
          // Indeterminate: leave the value out.
          const ShadProgress(),
        ],
      ),
    );
  }
}
