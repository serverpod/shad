import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/slider/slider_basic.dart';

final sliderDoc = ComponentDoc(
  slug: 'slider',
  title: 'Slider',
  description:
      'An input where the user selects a value from within a given range.',
  examples: [
    ComponentExample(
      id: 'slider_basic',
      title: 'Default',
      builder: (_) => const SliderBasicExample(),
    ),
  ],
);
