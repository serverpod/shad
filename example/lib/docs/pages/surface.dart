import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/surface/surface_anchored.dart';
import 'package:example/docs/examples/surface/surface_basic.dart';

final surfaceDoc = ComponentDoc(
  slug: 'surface',
  title: 'Surface',
  description:
      'The popover and menu chrome as a widget, for floating UI shad has no '
      'component for, and a popover anchored to any rectangle.',
  examples: [
    ComponentExample(
      id: 'surface_basic',
      title: 'Popover and menu surfaces',
      builder: (_) => const SurfaceBasicExample(),
    ),
    ComponentExample(
      id: 'surface_anchored',
      title: 'Anchored to a rectangle',
      description:
          'showShadPopover takes a global Rect: a text selection, a table '
          'cell, a point on a canvas.',
      minPreviewHeight: 260,
      builder: (_) => const SurfaceAnchoredExample(),
    ),
  ],
);
