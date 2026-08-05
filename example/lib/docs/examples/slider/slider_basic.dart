import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
