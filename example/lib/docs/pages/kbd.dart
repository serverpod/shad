import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/kbd/kbd_basic.dart';

final kbdDoc = ComponentDoc(
  slug: 'kbd',
  title: 'Kbd',
  description: 'Displays a keyboard key or chord.',
  examples: [
    ComponentExample(
      id: 'kbd_basic',
      title: 'Default',
      builder: (_) => const KbdBasicExample(),
    ),
  ],
);
