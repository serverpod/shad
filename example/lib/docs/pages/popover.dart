import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/popover/popover_basic.dart';

final popoverDoc = ComponentDoc(
  slug: 'popover',
  title: 'Popover',
  description: 'Displays rich content in a portal, triggered by a button.',
  examples: [
    ComponentExample(
      id: 'popover_basic',
      title: 'Default',
      builder: (_) => const PopoverBasicExample(),
    ),
  ],
);
