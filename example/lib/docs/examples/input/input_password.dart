import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class InputPasswordExample extends StatefulWidget {
  const InputPasswordExample({super.key});

  @override
  State<InputPasswordExample> createState() => _InputPasswordExampleState();
}

class _InputPasswordExampleState extends State<InputPasswordExample> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: ShadInput(
        placeholder: const Text('Password'),
        obscureText: obscure,
        leading: Icon(
          LucideIcons.lock,
          size: 16,
          color: theme.colorScheme.mutedForeground,
        ),
        trailing: ShadGestureDetector(
          cursor: SystemMouseCursors.click,
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => obscure = !obscure),
          child: Icon(
            obscure ? LucideIcons.eyeOff : LucideIcons.eye,
            size: 16,
            color: theme.colorScheme.mutedForeground,
          ),
        ),
      ),
    );
  }
}
