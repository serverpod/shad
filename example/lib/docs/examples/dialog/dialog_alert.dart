import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DialogAlertExample extends StatelessWidget {
  const DialogAlertExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadButton.outline(
      child: const Text('Delete account'),
      onPressed: () {
        showShadDialog<bool>(
          context: context,
          builder: (context) => ShadDialog.alert(
            title: const Text('Are you absolutely sure?'),
            description: const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'This action cannot be undone. This will permanently delete '
                'your account and remove your data from our servers.',
              ),
            ),
            actions: [
              ShadButton.outline(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              ShadButton(
                child: const Text('Continue'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );
      },
    );
  }
}
