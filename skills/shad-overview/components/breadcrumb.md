# Breadcrumb

Displays the path to the current resource using a hierarchy of links.

## Default

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

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
```

## Collapsed

An ellipsis stands in for the middle of a deep hierarchy.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

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
```

