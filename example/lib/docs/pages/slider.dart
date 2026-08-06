import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/slider/slider_basic.dart';
import 'package:example/docs/examples/slider/slider_range.dart';
import 'package:example/docs/examples/slider/slider_steps.dart';

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
    ComponentExample(
      id: 'slider_range',
      title: 'Range',
      description:
          'ShadRangeSlider takes one value per thumb. The values stay in '
          'ascending order — a thumb stops where its neighbour is rather '
          'than crossing it.',
      builder: (_) => const SliderRangeExample(),
    ),
    ComponentExample(
      id: 'slider_steps',
      title: 'Steps',
      description:
          'With divisions the slider snaps; set showDivisionMarks to false '
          'to snap without drawing the ticks.',
      builder: (_) => const SliderStepsExample(),
    ),
  ],
);
