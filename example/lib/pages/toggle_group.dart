import 'package:example/common/base_scaffold.dart';
import 'package:example/common/properties/bool_property.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ToggleGroupPage extends StatefulWidget {
  const ToggleGroupPage({super.key});

  @override
  State<ToggleGroupPage> createState() => _ToggleGroupPageState();
}

class _ToggleGroupPageState extends State<ToggleGroupPage> {
  bool enabled = true;
  Set<String> alignment = {'left'};
  Set<String> formatting = {'bold'};
  Set<String> vertical = {};

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return BaseScaffold(
      appBarTitle: 'ToggleGroup',
      editable: [
        MyBoolProperty(
          label: 'enabled',
          value: enabled,
          onChanged: (value) => setState(() => enabled = value),
        ),
      ],
      children: [
        Text('Single', style: theme.textTheme.h4),
        ShadToggleGroup<String>(
          values: alignment,
          enabled: enabled,
          onChanged: (values) => setState(() => alignment = values),
          children: const [
            ShadToggleGroupItem(
              value: 'left',
              semanticLabel: 'Align left',
              child: Icon(LucideIcons.alignLeft),
            ),
            ShadToggleGroupItem(
              value: 'center',
              semanticLabel: 'Align center',
              child: Icon(LucideIcons.alignCenter),
            ),
            ShadToggleGroupItem(
              value: 'right',
              semanticLabel: 'Align right',
              child: Icon(LucideIcons.alignRight),
            ),
          ],
        ),
        Text('selected: ${alignment.join(', ')}', style: theme.textTheme.muted),
        const SizedBox(height: 16),
        Text('Multiple', style: theme.textTheme.h4),
        ShadToggleGroup<String>.multiple(
          values: formatting,
          enabled: enabled,
          onChanged: (values) => setState(() => formatting = values),
          children: const [
            ShadToggleGroupItem(
              value: 'bold',
              semanticLabel: 'Bold',
              child: Icon(LucideIcons.bold),
            ),
            ShadToggleGroupItem(
              value: 'italic',
              semanticLabel: 'Italic',
              child: Icon(LucideIcons.italic),
            ),
            ShadToggleGroupItem(
              value: 'underline',
              semanticLabel: 'Underline',
              child: Icon(LucideIcons.underline),
            ),
          ],
        ),
        Text(
          'selected: ${formatting.isEmpty ? '—' : formatting.join(', ')}',
          style: theme.textTheme.muted,
        ),
        const SizedBox(height: 16),
        Text('Vertical, with labels', style: theme.textTheme.h4),
        ShadToggleGroup<String>.multiple(
          axis: Axis.vertical,
          values: vertical,
          enabled: enabled,
          onChanged: (values) => setState(() => vertical = values),
          children: const [
            ShadToggleGroupItem(value: 'wifi', child: Text('Wi-Fi')),
            ShadToggleGroupItem(value: 'bluetooth', child: Text('Bluetooth')),
            ShadToggleGroupItem(value: 'airplane', child: Text('Airplane')),
          ],
        ),
      ],
    );
  }
}
