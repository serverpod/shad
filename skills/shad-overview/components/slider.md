# Slider

An input where the user selects a value from within a given range.

## Default

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class SliderBasicExample extends StatelessWidget {
  const SliderBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 300,
      child: ShadSlider(
        initialValue: 33,
        max: 100,
      ),
    );
  }
}
```

## Range

ShadRangeSlider takes one value per thumb. The values stay in ascending order — a thumb stops where its neighbour is rather than crossing it.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class SliderRangeExample extends StatefulWidget {
  const SliderRangeExample({super.key});

  @override
  State<SliderRangeExample> createState() => _SliderRangeExampleState();
}

class _SliderRangeExampleState extends State<SliderRangeExample> {
  List<double> values = const [25, 75];

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Text(
            // The values stay ascending, so the ends of the range are always
            // the first and last entry.
            '\$${values.first.round()} – \$${values.last.round()}',
            style: theme.textTheme.small,
          ),
          ShadRangeSlider(
            initialValues: values,
            max: 100,
            onChanged: (next) => setState(() => values = next),
          ),
        ],
      ),
    );
  }
}
```

## Steps

With divisions the slider snaps; set showDivisionMarks to false to snap without drawing the ticks.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class SliderStepsExample extends StatelessWidget {
  const SliderStepsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 24,
        children: [
          ShadSlider(initialValue: 50, max: 100, divisions: 10),
          ShadSlider(
            initialValue: 50,
            max: 100,
            divisions: 10,
            showDivisionMarks: false,
          ),
        ],
      ),
    );
  }
}
```

