import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CheckboxBasicExample extends StatefulWidget {
  const CheckboxBasicExample({super.key});

  @override
  State<CheckboxBasicExample> createState() => _CheckboxBasicExampleState();
}

class _CheckboxBasicExampleState extends State<CheckboxBasicExample> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return ShadCheckbox(
      value: value,
      onChanged: (v) => setState(() => value = v),
      label: const Text('Accept terms and conditions'),
      sublabel: const Text(
        'You agree to our Terms of Service and Privacy Policy.',
      ),
    );
  }
}
