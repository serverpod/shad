import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

/// `ShadRow` and `ShadColumn` accept a `spacing` argument in theme steps.
class LayoutSpacingExample extends StatelessWidget {
  const LayoutSpacingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        ShadCard(
          child: ShadRow(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              for (final label in ['One', 'Two', 'Three'])
                ShadBadge.secondary(child: Text(label)),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: ShadCard(
            child: ShadColumn(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              spacing: 3,
              children: [
                const ShadInput(placeholder: Text('Email')),
                const ShadInput(placeholder: Text('Password')),
                ShadButton(onPressed: () {}, child: const Text('Sign in')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
