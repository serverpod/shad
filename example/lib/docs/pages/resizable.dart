import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/resizable/resizable_basic.dart';

final resizableDoc = ComponentDoc(
  slug: 'resizable',
  title: 'Resizable',
  description:
      'Resizable panel groups and layouts, with nesting and drag handles.',
  playgroundRoute: '/resizable',
  examples: [
    ComponentExample(
      id: 'resizable_basic',
      title: 'Default',
      builder: (_) => const ResizableBasicExample(),
    ),
  ],
);
