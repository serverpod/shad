import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class AlertDestructiveExample extends StatelessWidget {
  const AlertDestructiveExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: ShadAlert.destructive(
        icon: Icon(LucideIcons.circleAlert),
        title: Text('Error'),
        description: Text('Your session has expired. Please log in again.'),
      ),
    );
  }
}
