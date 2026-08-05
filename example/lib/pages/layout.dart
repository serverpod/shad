import 'package:example/common/base_scaffold.dart';
import 'package:example/common/properties/string_property.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shad/shad.dart';

/// The spacing scale and the widgets that lay out against it.
///
/// Everything on this page is measured in *steps*, so changing the step at the
/// top rescales the gaps, the paddings and the components' own padding
/// together — which is the point of having one scale.
class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  double step = 4;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return BaseScaffold(
      appBarTitle: 'Layout',
      crossAxisAlignment: CrossAxisAlignment.start,
      editable: [
        MyStringProperty(
          label: 'spacing step',
          initialValue: '${step.toInt()}',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            final maybe = double.tryParse(value);
            if (maybe != null && maybe > 0) setState(() => step = maybe);
          },
        ),
      ],
      children: [
        ShadTheme(
          data: ShadThemeData(
            brightness: theme.brightness,
            colorScheme: theme.colorScheme,
            spacing: ShadSpacing(step: step),
          ),
          child: Builder(
            builder: (context) {
              final spacing = ShadTheme.of(context).spacing;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ShadGap', style: theme.textTheme.h4),
                  Text(
                    'A gap sizes itself along the axis of its flex. '
                    'One step is ${spacing(1)}px.',
                    style: theme.textTheme.muted,
                  ),
                  const SizedBox(height: 8),
                  ShadCard(
                    child: ShadRow(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 2,
                      children: [
                        for (final label in ['One', 'Two', 'Three'])
                          ShadBadge.secondary(child: Text(label)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ShadCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Stacked'),
                        const ShadGap(2),
                        const Text('with a two-step gap'),
                        const ShadGap(4),
                        Text(
                          'and a four-step one',
                          style: theme.textTheme.muted,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('ShadPadding', style: theme.textTheme.h4),
                  Text(
                    'shadcn writes px-6 py-4; this is the same thing.',
                    style: theme.textTheme.muted,
                  ),
                  const SizedBox(height: 8),
                  ColoredBox(
                    color: theme.colorScheme.muted,
                    child: ShadPadding.symmetric(
                      horizontal: 6,
                      vertical: 4,
                      child: ShadCard(
                        child: Text(
                          'Inset by ${spacing(6)} x ${spacing(4)}',
                          style: theme.textTheme.small,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('ShadColumn / ShadRow', style: theme.textTheme.h4),
                  Text(
                    'Flex with its spacing expressed in steps.',
                    style: theme.textTheme.muted,
                  ),
                  const SizedBox(height: 8),
                  ShadColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 3,
                    children: [
                      ShadButton(onPressed: () {}, child: const Text('Save')),
                      ShadButton.outline(
                        onPressed: () {},
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
