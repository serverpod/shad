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
