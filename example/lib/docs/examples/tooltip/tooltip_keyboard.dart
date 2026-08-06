import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TooltipKeyboardExample extends StatelessWidget {
  const TooltipKeyboardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTooltip(
      builder: (context) => const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Save Changes'),
          SizedBox(width: 6),
          ShadKbd('S'),
        ],
      ),
      child: ShadIconButton.outline(
        icon: const Icon(LucideIcons.save),
        onPressed: () {},
      ),
    );
  }
}
