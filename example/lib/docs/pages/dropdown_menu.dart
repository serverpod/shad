import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/dropdown_menu/dropdown_menu_basic.dart';

final dropdownMenuDoc = ComponentDoc(
  slug: 'dropdown_menu',
  title: 'Dropdown Menu',
  description:
      'A menu that opens from a trigger. It flips to stay on screen, scrolls '
      'when long, and supports keyboard navigation and type-ahead.',
  examples: [
    ComponentExample(
      id: 'dropdown_menu_basic',
      title: 'Default',
      minPreviewHeight: 320,
      builder: (_) => const DropdownMenuBasicExample(),
    ),
  ],
);
