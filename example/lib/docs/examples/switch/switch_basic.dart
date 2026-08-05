import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class SwitchBasicExample extends StatefulWidget {
  const SwitchBasicExample({super.key});

  @override
  State<SwitchBasicExample> createState() => _SwitchBasicExampleState();
}

class _SwitchBasicExampleState extends State<SwitchBasicExample> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return ShadSwitch(
      value: value,
      onChanged: (v) => setState(() => value = v),
      label: const Text('Airplane Mode'),
    );
  }
}
