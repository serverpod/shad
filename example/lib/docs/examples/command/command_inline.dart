import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class CommandInlineExample extends StatelessWidget {
  const CommandInlineExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: ShadCard(
        padding: EdgeInsets.zero,
        child: ShadCommand(
          autofocus: false,
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
      ),
    );
  }
}
