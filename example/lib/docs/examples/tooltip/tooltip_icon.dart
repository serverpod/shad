import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TooltipIconExample extends StatelessWidget {
  const TooltipIconExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTooltip(
      builder: (context) => const Text('Additional information'),
      child: ShadIconButton.ghost(
        icon: const Icon(LucideIcons.info),
        onPressed: () {},
      ),
    );
  }
}
