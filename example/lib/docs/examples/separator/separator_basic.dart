import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class SeparatorBasicExample extends StatelessWidget {
  const SeparatorBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Radix Primitives', style: theme.textTheme.small),
          const SizedBox(height: 4),
          Text(
            'An open-source UI component library.',
            style: theme.textTheme.muted,
          ),
          const ShadSeparator.horizontal(
            margin: EdgeInsets.symmetric(vertical: 16),
          ),
          const SizedBox(
            height: 20,
            child: Row(
              children: [
                Text('Blog'),
                ShadSeparator.vertical(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                ),
                Text('Docs'),
                ShadSeparator.vertical(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                ),
                Text('Source'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
