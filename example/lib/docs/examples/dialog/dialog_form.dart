import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

const _profile = [
  (title: 'Name', value: 'Alexandru'),
  (title: 'Username', value: 'nank1ro'),
];

class DialogFormExample extends StatelessWidget {
  const DialogFormExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return ShadButton.outline(
      child: const Text('Edit Profile'),
      onPressed: () {
        showShadDialog<void>(
          context: context,
          builder: (context) => ShadDialog(
            title: const Text('Edit Profile'),
            description: const Text(
              "Make changes to your profile here. Click save when you're "
              'done.',
            ),
            actions: const [ShadButton(child: Text('Save changes'))],
            crossAxisAlignment: CrossAxisAlignment.stretch,
            child: Container(
              width: 375,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  for (final field in _profile)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            field.title,
                            textAlign: TextAlign.end,
                            style: theme.textTheme.small,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: ShadInput(initialValue: field.value),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
