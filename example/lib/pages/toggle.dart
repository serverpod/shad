import 'package:example/common/base_scaffold.dart';
import 'package:example/common/properties/bool_property.dart';
import 'package:flutter/material.dart';
import 'package:shad/shad.dart';

class TogglePage extends StatefulWidget {
  const TogglePage({super.key});

  @override
  State<TogglePage> createState() => _TogglePageState();
}

class _TogglePageState extends State<TogglePage> {
  bool enabled = true;
  bool bold = false;
  bool italic = true;
  bool withLabel = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return BaseScaffold(
      appBarTitle: 'Toggle',
      editable: [
        MyBoolProperty(
          label: 'enabled',
          value: enabled,
          onChanged: (value) => setState(() => enabled = value),
        ),
      ],
      children: [
        Text('Icon only', style: theme.textTheme.h4),
        ShadToggle(
          value: bold,
          enabled: enabled,
          semanticLabel: 'Bold',
          onChanged: (value) => setState(() => bold = value),
          child: const Icon(LucideIcons.bold),
        ),
        const SizedBox(height: 16),
        Text('Selected by default', style: theme.textTheme.h4),
        ShadToggle(
          value: italic,
          enabled: enabled,
          semanticLabel: 'Italic',
          onChanged: (value) => setState(() => italic = value),
          child: const Icon(LucideIcons.italic),
        ),
        const SizedBox(height: 16),
        Text('With a label', style: theme.textTheme.h4),
        ShadToggle(
          value: withLabel,
          enabled: enabled,
          leading: const Icon(LucideIcons.underline),
          onChanged: (value) => setState(() => withLabel = value),
          child: const Text('Underline'),
        ),
      ],
    );
  }
}
