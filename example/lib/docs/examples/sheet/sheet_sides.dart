import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SheetSidesExample extends StatelessWidget {
  const SheetSidesExample({super.key});

  void _open(BuildContext context, ShadSheetSide side) {
    showShadSheet<void>(
      context: context,
      side: side,
      builder: (context) => ShadSheet(
        title: const Text('Edit Profile'),
        description: const Text(
          "Make changes to your profile here. Click save when you're done.",
        ),
        actions: [
          ShadButton(
            child: const Text('Save changes'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: ShadInput(placeholder: Text('Name')),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final side in ShadSheetSide.values)
          ShadButton.outline(
            onPressed: () => _open(context, side),
            child: Text(side.name),
          ),
      ],
    );
  }
}
