import 'package:flutter/material.dart';
import 'package:shad/shad.dart';

enum InputStyle { email, password }

class InputPage extends StatelessWidget {
  const InputPage({super.key, required this.style});

  final InputStyle style;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: switch (style) {
            InputStyle.email => const EmailInput(),
            InputStyle.password => const PasswordInput(),
          },
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadInput(
      placeholder: Text('Email'),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class PasswordInput extends StatefulWidget {
  const PasswordInput({super.key});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadInput(
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
    );
  }
}
