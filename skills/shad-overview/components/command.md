# Command

A composable command menu with filtering and full keyboard navigation.

## Inline

Arrow keys move the highlight, Enter selects. Keywords let items match terms their label does not contain.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class CommandInlineExample extends StatelessWidget {
  const CommandInlineExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: ShadCommand(
        autofocus: false,
        decoration: const ShadDecoration(shadows: Shadows.md),
        placeholder: const Text('Type a command or search…'),
        groups: [
          ShadCommandGroup(
            heading: 'Suggestions',
            items: [
              ShadCommandItem(
                label: 'Calendar',
                value: 'calendar',
                leading: const Icon(LucideIcons.calendar),
                onSelected: () {},
              ),
              ShadCommandItem(
                label: 'Search Emoji',
                value: 'emoji',
                keywords: const ['smiley', 'face'],
                leading: const Icon(LucideIcons.smile),
                onSelected: () {},
              ),
            ],
          ),
          ShadCommandGroup(
            heading: 'Settings',
            items: [
              ShadCommandItem(
                label: 'Profile',
                value: 'profile',
                leading: const Icon(LucideIcons.user),
                trailing: const ShadKbd.group(['⌘', 'P']),
                onSelected: () {},
              ),
              ShadCommandItem(
                label: 'Billing',
                value: 'billing',
                leading: const Icon(LucideIcons.creditCard),
                trailing: const ShadKbd.group(['⌘', 'B']),
                onSelected: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

## Dialog

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class CommandDialogExample extends StatelessWidget {
  const CommandDialogExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadButton.outline(
      trailing: const ShadKbd.group(['⌘', 'K']),
      child: const Text('Open command palette'),
      onPressed: () {
        showShadCommandDialog<String>(
          context: context,
          placeholder: const Text('Type a command or search…'),
          groups: [
            ShadCommandGroup(
              heading: 'Suggestions',
              items: [
                ShadCommandItem(
                  label: 'Calendar',
                  value: 'calendar',
                  leading: const Icon(LucideIcons.calendar),
                  onSelected: () {},
                ),
                ShadCommandItem(
                  label: 'Sign out',
                  value: 'signout',
                  keywords: const ['logout', 'exit'],
                  leading: const Icon(LucideIcons.logOut),
                  onSelected: () {},
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
```

