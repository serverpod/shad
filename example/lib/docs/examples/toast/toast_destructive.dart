import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ToastDestructiveExample extends StatelessWidget {
  const ToastDestructiveExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadButton.outline(
      child: const Text('Show destructive toast'),
      onPressed: () {
        ShadToaster.of(context).show(
          const ShadToast.destructive(
            title: Text('Uh oh! Something went wrong'),
            description: Text('There was a problem with your request'),
          ),
        );
      },
    );
  }
}
