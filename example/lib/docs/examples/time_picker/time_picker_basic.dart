import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TimePickerBasicExample extends StatelessWidget {
  const TimePickerBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTimePicker(
      trailing: const Padding(
        padding: EdgeInsets.only(left: 8, top: 14),
        child: Icon(LucideIcons.clock4),
      ),
      onChanged: (time) {},
    );
  }
}
