import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

/// Stacked primary and secondary actions with `ShadColumn` spacing.
/// the footer pattern used in dialogs and forms.
class LayoutFormActionsExample extends StatelessWidget {
  const LayoutFormActionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: ShadCard(
        title: const Text('Schedule payout'),
        description: const Text('Confirm the transfer details below.'),
        child: ShadColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 3,
          children: [
            const ShadInput(
              placeholder: Text('Amount'),
            ),
            ShadButton(onPressed: () {}, child: const Text('Schedule')),
            ShadButton.outline(
              onPressed: () {},
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
