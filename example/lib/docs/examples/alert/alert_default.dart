import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AlertDefaultExample extends StatelessWidget {
  const AlertDefaultExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: ShadAlert(
        icon: Icon(LucideIcons.terminal),
        title: Text('Heads up!'),
        description: Text('You can add components to your app using the cli.'),
      ),
    );
  }
}
