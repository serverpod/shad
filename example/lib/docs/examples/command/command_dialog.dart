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
