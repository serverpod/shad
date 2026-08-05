import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ToggleBasicExample extends StatefulWidget {
  const ToggleBasicExample({super.key});

  @override
  State<ToggleBasicExample> createState() => _ToggleBasicExampleState();
}

class _ToggleBasicExampleState extends State<ToggleBasicExample> {
  bool bold = false;
  bool underline = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        ShadToggle(
          value: bold,
          semanticLabel: 'Bold',
          onChanged: (value) => setState(() => bold = value),
          child: const Icon(LucideIcons.bold),
        ),
        ShadToggle(
          value: underline,
          leading: const Icon(LucideIcons.underline),
          onChanged: (value) => setState(() => underline = value),
          child: const Text('Underline'),
        ),
      ],
    );
  }
}
