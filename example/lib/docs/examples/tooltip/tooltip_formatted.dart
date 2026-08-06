import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TooltipFormattedExample extends StatelessWidget {
  const TooltipFormattedExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTooltip(
      builder: (context) {
        final style = DefaultTextStyle.of(context).style;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active',
              style: style.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Opacity(
              opacity: .8,
              child: Text('Last updated 2 hours ago', style: style),
            ),
          ],
        );
      },
      child: ShadButton.outline(onPressed: () {}, child: const Text('Status')),
    );
  }
}
