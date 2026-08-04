import 'package:example/common/base_scaffold.dart';
import 'package:example/common/properties/string_property.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SpinnerPage extends StatefulWidget {
  const SpinnerPage({super.key});

  @override
  State<SpinnerPage> createState() => _SpinnerPageState();
}

class _SpinnerPageState extends State<SpinnerPage> {
  int size = 24;
  int strokeWidth = 2;
  int duration = 900;
  bool submitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return BaseScaffold(
      appBarTitle: 'Spinner',
      editable: [
        MyStringProperty(
          label: 'size',
          initialValue: '$size',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            final maybe = int.tryParse(value);
            if (maybe != null && maybe > 0) setState(() => size = maybe);
          },
        ),
        MyStringProperty(
          label: 'strokeWidth',
          initialValue: '$strokeWidth',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            final maybe = int.tryParse(value);
            if (maybe != null && maybe > 0) {
              setState(() => strokeWidth = maybe);
            }
          },
        ),
        MyStringProperty(
          label: 'duration (ms)',
          initialValue: '$duration',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            final maybe = int.tryParse(value);
            if (maybe != null && maybe > 0) {
              setState(() => duration = maybe);
            }
          },
        ),
      ],
      children: [
        Text('Default', style: theme.textTheme.h4),
        ShadSpinner(
          size: size.toDouble(),
          strokeWidth: strokeWidth.toDouble(),
          duration: Duration(milliseconds: duration),
        ),
        const SizedBox(height: 16),
        Text('Colored, no track', style: theme.textTheme.h4),
        ShadSpinner(
          size: size.toDouble(),
          strokeWidth: strokeWidth.toDouble(),
          duration: Duration(milliseconds: duration),
          color: theme.colorScheme.destructive,
          trackColor: const Color(0x00000000),
        ),
        const SizedBox(height: 16),
        Text('Inside a button', style: theme.textTheme.h4),
        ShadButton(
          onPressed: submitting
              ? null
              : () async {
                  setState(() => submitting = true);
                  await Future<void>.delayed(const Duration(seconds: 2));
                  if (mounted) setState(() => submitting = false);
                },
          leading: submitting
              ? ShadSpinner(
                  size: 16,
                  color: theme.colorScheme.primaryForeground,
                  trackColor: theme.colorScheme.primaryForeground.withValues(
                    alpha: .3,
                  ),
                )
              : null,
          child: Text(submitting ? 'Saving…' : 'Save'),
        ),
      ],
    );
  }
}
