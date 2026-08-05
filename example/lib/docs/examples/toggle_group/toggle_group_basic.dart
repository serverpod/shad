import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ToggleGroupBasicExample extends StatefulWidget {
  const ToggleGroupBasicExample({super.key});

  @override
  State<ToggleGroupBasicExample> createState() =>
      _ToggleGroupBasicExampleState();
}

class _ToggleGroupBasicExampleState extends State<ToggleGroupBasicExample> {
  Set<String> alignment = {'left'};

  @override
  Widget build(BuildContext context) {
    return ShadToggleGroup<String>(
      values: alignment,
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
    );
  }
}
