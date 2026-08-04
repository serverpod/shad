import 'package:example/common/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CommandPage extends StatefulWidget {
  const CommandPage({super.key});

  @override
  State<CommandPage> createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {
  String? lastSelected;

  List<ShadCommandGroup> buildGroups() => [
    ShadCommandGroup(
      heading: 'Suggestions',
      items: [
        ShadCommandItem(
          label: 'Calendar',
          value: 'calendar',
          leading: const Icon(LucideIcons.calendar),
          onSelected: () => setState(() => lastSelected = 'Calendar'),
        ),
        ShadCommandItem(
          label: 'Search Emoji',
          value: 'emoji',
          keywords: const ['smiley', 'face'],
          leading: const Icon(LucideIcons.smile),
          onSelected: () => setState(() => lastSelected = 'Search Emoji'),
        ),
        ShadCommandItem(
          label: 'Calculator',
          value: 'calculator',
          leading: const Icon(LucideIcons.calculator),
          enabled: false,
          onSelected: () => setState(() => lastSelected = 'Calculator'),
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
          onSelected: () => setState(() => lastSelected = 'Profile'),
        ),
        ShadCommandItem(
          label: 'Billing',
          value: 'billing',
          leading: const Icon(LucideIcons.creditCard),
          trailing: const ShadKbd.group(['⌘', 'B']),
          onSelected: () => setState(() => lastSelected = 'Billing'),
        ),
        ShadCommandItem(
          label: 'Sign out',
          value: 'signout',
          // Matched by the filter even though the label says "Sign out".
          keywords: const ['logout', 'exit'],
          leading: const Icon(LucideIcons.logOut),
          onSelected: () => setState(() => lastSelected = 'Sign out'),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return BaseScaffold(
      appBarTitle: 'Command',
      children: [
        Text('Inline', style: theme.textTheme.h4),
        Text(
          'Arrow keys move the highlight, Enter selects. '
          'Try searching for "logout".',
          style: theme.textTheme.muted,
        ),
        const SizedBox(height: 8),
        ShadCard(
          padding: EdgeInsets.zero,
          child: ShadCommand(
            groups: buildGroups(),
            autofocus: false,
            placeholder: const Text('Type a command or search…'),
          ),
        ),
        const SizedBox(height: 16),
        Text('As a dialog', style: theme.textTheme.h4),
        ShadButton.outline(
          onPressed: () async {
            final result = await showShadCommandDialog<String>(
              context: context,
              groups: buildGroups(),
              placeholder: const Text('Type a command or search…'),
            );
            if (result != null && mounted) {
              setState(() => lastSelected = result);
            }
          },
          trailing: const ShadKbd.group(['⌘', 'K']),
          child: const Text('Open command palette'),
        ),
        const SizedBox(height: 16),
        Text(
          lastSelected == null
              ? 'Nothing selected yet'
              : 'Last selected: $lastSelected',
          style: theme.textTheme.muted,
        ),
      ],
    );
  }
}
