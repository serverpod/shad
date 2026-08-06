import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ToggleGroupOutlineExample extends StatefulWidget {
  const ToggleGroupOutlineExample({super.key});

  @override
  State<ToggleGroupOutlineExample> createState() =>
      _ToggleGroupOutlineExampleState();
}

class _ToggleGroupOutlineExampleState extends State<ToggleGroupOutlineExample> {
  Set<String> values = const {'bold'};

  @override
  Widget build(BuildContext context) {
    return ShadToggleGroup<String>(
      values: values,
      toggleVariant: ShadToggleVariant.outline,
      onChanged: (next) => setState(() => values = next),
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
