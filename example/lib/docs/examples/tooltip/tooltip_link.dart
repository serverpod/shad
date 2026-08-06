import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TooltipLinkExample extends StatelessWidget {
  const TooltipLinkExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTooltip(
      builder: (context) => const Text('Click to read the documentation'),
      child: ShadButton.link(
        onPressed: () {},
        child: const Text('Learn more'),
      ),
    );
  }
}
