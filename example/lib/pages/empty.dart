import 'package:example/common/base_scaffold.dart';
import 'package:example/common/properties/bool_property.dart';
import 'package:flutter/material.dart';
import 'package:shad/shad.dart';

class EmptyPage extends StatefulWidget {
  const EmptyPage({super.key});

  @override
  State<EmptyPage> createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  bool showIcon = true;
  bool showDescription = true;
  bool showActions = true;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return BaseScaffold(
      appBarTitle: 'Empty',
      editable: [
        MyBoolProperty(
          label: 'icon',
          value: showIcon,
          onChanged: (value) => setState(() => showIcon = value),
        ),
        MyBoolProperty(
          label: 'description',
          value: showDescription,
          onChanged: (value) => setState(() => showDescription = value),
        ),
        MyBoolProperty(
          label: 'actions',
          value: showActions,
          onChanged: (value) => setState(() => showActions = value),
        ),
      ],
      children: [
        Text('Configurable', style: theme.textTheme.h4),
        ShadCard(
          child: ShadEmpty(
            icon: showIcon ? const Icon(LucideIcons.inbox) : null,
            title: const Text('No messages'),
            description: showDescription
                ? const Text('Messages you receive will show up here.')
                : null,
            actions: showActions
                ? [
                    ShadButton.outline(
                      onPressed: () {},
                      child: const Text('Refresh'),
                    ),
                    ShadButton(
                      onPressed: () {},
                      child: const Text('Compose'),
                    ),
                  ]
                : const [],
          ),
        ),
        const SizedBox(height: 16),
        Text('Title only (localized default)', style: theme.textTheme.h4),
        const ShadCard(child: ShadEmpty()),
      ],
    );
  }
}
