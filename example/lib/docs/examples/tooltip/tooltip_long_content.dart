import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TooltipLongContentExample extends StatelessWidget {
  const TooltipLongContentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTooltip(
      // Long content wraps at the tooltip's max width.
      builder: (context) => const Text(
        'To learn more about how this works, check out the docs. If you '
        'have any questions, please reach out to us.',
      ),
      child: ShadButton.outline(
        onPressed: () {},
        child: const Text('Show Tooltip'),
      ),
    );
  }
}
