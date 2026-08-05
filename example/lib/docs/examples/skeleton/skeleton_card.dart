import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class SkeletonCardExample extends StatelessWidget {
  const SkeletonCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShadSkeleton.circle(size: 48),
        SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShadSkeleton(width: 250, height: 16),
            SizedBox(height: 8),
            ShadSkeleton(width: 200, height: 16),
          ],
        ),
      ],
    );
  }
}
