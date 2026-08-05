import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/menubar/menubar_basic.dart';

final menubarDoc = ComponentDoc(
  slug: 'menubar',
  title: 'Menubar',
  description: 'A visually persistent menu, common in desktop applications.',
  playgroundRoute: '/menubar',
  examples: [
    ComponentExample(
      id: 'menubar_basic',
      title: 'Default',
      minPreviewHeight: 320,
      builder: (_) => const MenubarBasicExample(),
    ),
  ],
);
