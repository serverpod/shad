import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class AlertDefaultExample extends StatelessWidget {
  const AlertDefaultExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 576),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          ShadAlert(
            icon: Icon(LucideIcons.circleCheck),
            title: Text('Success! Your changes have been saved'),
            description: Text(
              'This is an alert with icon, title and description.',
            ),
          ),
          ShadAlert(
            icon: Icon(LucideIcons.popcorn),
            title: Text('This Alert has a title and an icon. No description.'),
          ),
          ShadAlert.destructive(
            icon: Icon(LucideIcons.circleAlert),
            title: Text('Unable to process your payment.'),
            description: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text('Please verify your billing information and try again.'),
                Text('• Check your card details'),
                Text('• Ensure sufficient funds'),
                Text('• Verify billing address'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
