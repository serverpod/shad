import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class BreadcrumbBasicExample extends StatelessWidget {
  const BreadcrumbBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadBreadcrumb(
      children: [
        ShadBreadcrumbLink(
          onPressed: () {},
          child: const Text('Home'),
        ),
        ShadBreadcrumbLink(
          onPressed: () {},
          child: const Text('Components'),
        ),
        const Text('Breadcrumb'),
      ],
    );
  }
}
