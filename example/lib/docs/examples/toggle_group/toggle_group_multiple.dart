import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ToggleGroupMultipleExample extends StatefulWidget {
  const ToggleGroupMultipleExample({super.key});

  @override
  State<ToggleGroupMultipleExample> createState() =>
      _ToggleGroupMultipleExampleState();
}

class _ToggleGroupMultipleExampleState
    extends State<ToggleGroupMultipleExample> {
  Set<String> formatting = {'bold'};

  @override
  Widget build(BuildContext context) {
    return ShadToggleGroup<String>.multiple(
      values: formatting,
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
    );
  }
}
