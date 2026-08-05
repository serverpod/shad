import 'package:example/common/base_scaffold.dart';
import 'package:example/common/properties/bool_property.dart';
import 'package:example/common/properties/string_property.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shad/shad.dart';

class SkeletonPage extends StatefulWidget {
  const SkeletonPage({super.key});

  @override
  State<SkeletonPage> createState() => _SkeletonPageState();
}

class _SkeletonPageState extends State<SkeletonPage> {
  bool animate = true;
  int duration = 1500;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return BaseScaffold(
      appBarTitle: 'Skeleton',
      editable: [
        MyBoolProperty(
          label: 'animate',
          value: animate,
          onChanged: (value) => setState(() => animate = value),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bars', style: theme.textTheme.h4),
        ShadSkeleton(
          width: 250,
          height: 20,
          animate: animate,
          duration: Duration(milliseconds: duration),
        ),
        ShadSkeleton(
          width: 200,
          height: 20,
          animate: animate,
          duration: Duration(milliseconds: duration),
        ),
        const SizedBox(height: 16),
        Text('Card placeholder', style: theme.textTheme.h4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadSkeleton.circle(
              size: 48,
              animate: animate,
              duration: Duration(milliseconds: duration),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShadSkeleton(
                  width: 180,
                  height: 14,
                  animate: animate,
                  duration: Duration(milliseconds: duration),
                ),
                const SizedBox(height: 8),
                ShadSkeleton(
                  width: 120,
                  height: 14,
                  animate: animate,
                  duration: Duration(milliseconds: duration),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Sized by a hidden child', style: theme.textTheme.h4),
        ShadSkeleton(
          animate: animate,
          duration: Duration(milliseconds: duration),
          child: const Text('This text only provides the size'),
        ),
      ],
    );
  }
}
