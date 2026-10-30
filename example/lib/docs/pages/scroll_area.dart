import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/scroll_area/scroll_area_basic.dart';
import 'package:example/docs/examples/scroll_area/scroll_area_list.dart';

final scrollAreaDoc = ComponentDoc(
  slug: 'scroll_area',
  title: 'Scroll Area',
  description:
      'Scrolls its content with a thin themed scrollbar. ShadScrollbar puts '
      'the same scrollbar on any scrollable.',
  examples: [
    ComponentExample(
      id: 'scroll_area_basic',
      title: 'Default',
      minPreviewHeight: 340,
      builder: (_) => const ScrollAreaBasicExample(),
    ),
    ComponentExample(
      id: 'scroll_area_list',
      title: 'Any scrollable',
      description:
          'Wrap a ListView, GridView or CustomScrollView in ShadScrollbar.',
      minPreviewHeight: 300,
      builder: (_) => const ScrollAreaListExample(),
    ),
  ],
);
