import 'package:example/common/base_scaffold.dart';
import 'package:example/common/properties/string_property.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class KbdPage extends StatefulWidget {
  const KbdPage({super.key});

  @override
  State<KbdPage> createState() => _KbdPageState();
}

class _KbdPageState extends State<KbdPage> {
  int gap = 4;
  int minWidth = 20;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return BaseScaffold(
      appBarTitle: 'Kbd',
      editable: [
        MyStringProperty(
          label: 'gap',
          initialValue: '$gap',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            final maybe = int.tryParse(value);
            if (maybe != null) setState(() => gap = maybe);
          },
        ),
        MyStringProperty(
          label: 'minWidth',
          initialValue: '$minWidth',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            final maybe = int.tryParse(value);
            if (maybe != null) setState(() => minWidth = maybe);
          },
        ),
      ],
      children: [
        Text('Single key', style: theme.textTheme.h4),
        ShadKbd('K', minWidth: minWidth.toDouble()),
        const SizedBox(height: 16),
        Text('Chord', style: theme.textTheme.h4),
        ShadKbd.group(
          const ['⌘', 'K'],
          gap: gap.toDouble(),
          minWidth: minWidth.toDouble(),
        ),
        const SizedBox(height: 16),
        Text('In a row of text', style: theme.textTheme.h4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Press '),
            ShadKbd.group(
              const ['Ctrl', 'Shift', 'P'],
              gap: gap.toDouble(),
              minWidth: minWidth.toDouble(),
            ),
            const Text(' to open the palette'),
          ],
        ),
        const SizedBox(height: 16),
        Text('Alongside a menu item', style: theme.textTheme.h4),
        SizedBox(
          width: 260,
          child: ShadButton.ghost(
            onPressed: () {},
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            trailing: ShadKbd.group(
              const ['⌘', 'S'],
              gap: gap.toDouble(),
              minWidth: minWidth.toDouble(),
            ),
            child: const Text('Save'),
          ),
        ),
      ],
    );
  }
}
