import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ToggleOutlineExample extends StatefulWidget {
  const ToggleOutlineExample({super.key});

  @override
  State<ToggleOutlineExample> createState() => _ToggleOutlineExampleState();
}

class _ToggleOutlineExampleState extends State<ToggleOutlineExample> {
  bool bold = false;
  bool italic = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        ShadToggle.outline(
          value: bold,
          semanticLabel: 'Bold',
          onChanged: (value) => setState(() => bold = value),
          child: const Icon(LucideIcons.bold),
        ),
        ShadToggle.outline(
          value: italic,
          semanticLabel: 'Italic',
          onChanged: (value) => setState(() => italic = value),
          child: const Icon(LucideIcons.italic),
        ),
      ],
    );
  }
}
