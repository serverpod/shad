# Dialog

A modal window overlaid on the page, rendering the content underneath inert.

## With a form

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

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
```

## Alert dialog

Interrupts the user with an important question and explicit actions.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

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
```

