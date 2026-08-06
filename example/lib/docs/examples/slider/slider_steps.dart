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
