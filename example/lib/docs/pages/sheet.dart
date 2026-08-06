import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/sheet/sheet_sides.dart';

final sheetDoc = ComponentDoc(
  slug: 'sheet',
  title: 'Sheet',
  description:
      'Extends the dialog to display content that complements the main '
      'content of the screen, sliding in from any edge.',
  examples: [
    ComponentExample(
      id: 'sheet_sides',
      title: 'Sides',
      builder: (_) => const SheetSidesExample(),
    ),
  ],
);
