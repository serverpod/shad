import 'package:example/common/base_scaffold.dart';
import 'package:example/common/properties/bool_property.dart';
import 'package:flutter/material.dart';
import 'package:shad/shad.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  bool enabled = true;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBarTitle: 'Input',
      editable: [
        MyBoolProperty(
          label: 'Enabled',
          value: enabled,
          onChanged: (value) => setState(() => enabled = value),
        ),
        MyBoolProperty(
          label: 'Obscure',
          value: obscure,
          onChanged: (value) => setState(() => obscure = value),
        ),
      ],
      children: [
        ShadInput(
          placeholder: const Text('Email'),
          enabled: enabled,
          keyboardType: TextInputType.emailAddress,
        ),
        Builder(
          builder: (context) {
            final theme = ShadTheme.of(context);
            return ShadInput(
              placeholder: const Text('Password'),
              enabled: enabled,
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
          },
        ),
      ],
    );
  }
}
