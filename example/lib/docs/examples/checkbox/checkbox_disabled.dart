import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CheckboxDisabledExample extends StatelessWidget {
  const CheckboxDisabledExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadCheckbox(
      value: true,
      enabled: false,
      onChanged: (v) {},
      label: const Text('Accept terms and conditions'),
    );
  }
}
