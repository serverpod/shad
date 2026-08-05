import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class BreadcrumbEllipsisExample extends StatelessWidget {
  const BreadcrumbEllipsisExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadBreadcrumb(
      children: [
        ShadBreadcrumbLink(
          onPressed: () {},
          child: const Text('Home'),
        ),
        // Collapses the middle of a deep hierarchy.
        const ShadBreadcrumbEllipsis(),
        ShadBreadcrumbLink(
          onPressed: () {},
          child: const Text('Components'),
        ),
        const Text('Breadcrumb'),
      ],
    );
  }
}
