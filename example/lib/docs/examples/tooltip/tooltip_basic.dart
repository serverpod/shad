import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TooltipBasicExample extends StatelessWidget {
  const TooltipBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTooltip(
      builder: (context) => const Text('Add to library'),
      child: ShadButton.outline(
        onPressed: () {},
        child: const Text('Show Tooltip'),
      ),
    );
  }
}
