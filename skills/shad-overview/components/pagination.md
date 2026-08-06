# Pagination

Page navigation with previous and next links. [ShadPagination] shows a windowed run of page numbers; [ShadPaginationCompact] fits toolbars and table footers.

## Default

Previous and next labels with a windowed run of page numbers. An ellipsis marks pages that were skipped.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class PaginationBasicExample extends StatefulWidget {
  const PaginationBasicExample({super.key});

  @override
  State<PaginationBasicExample> createState() => _PaginationBasicExampleState();
}

class _PaginationBasicExampleState extends State<PaginationBasicExample> {
  int page = 5;

  @override
  Widget build(BuildContext context) {
    return ShadPagination(
      page: page,
      pageCount: 20,
      onPageChanged: (value) => setState(() => page = value),
    );
  }
}
```

## Simple

Page numbers only — set `showEdges: false` when every page fits without an ellipsis.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class PaginationSimpleExample extends StatefulWidget {
  const PaginationSimpleExample({super.key});

  @override
  State<PaginationSimpleExample> createState() =>
      _PaginationSimpleExampleState();
}

class _PaginationSimpleExampleState extends State<PaginationSimpleExample> {
  int page = 2;

  @override
  Widget build(BuildContext context) {
    return ShadPagination(
      page: page,
      pageCount: 5,
      showEdges: false,
      onPageChanged: (value) => setState(() => page = value),
    );
  }
}
```

## Compact

Previous and next icon buttons with a `Page n / m` counter, useful beneath a data table.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class PaginationCompactExample extends StatefulWidget {
  const PaginationCompactExample({super.key});

  @override
  State<PaginationCompactExample> createState() =>
      _PaginationCompactExampleState();
}

class _PaginationCompactExampleState extends State<PaginationCompactExample> {
  int page = 3;

  @override
  Widget build(BuildContext context) {
    return ShadPaginationCompact(
      page: page,
      pageCount: 10,
      onPageChanged: (value) => setState(() => page = value),
    );
  }
}
```

## Icons only

Drop the counter with `labelBuilder` when space is tight, for example beside a rows-per-page control.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class PaginationIconsOnlyExample extends StatefulWidget {
  const PaginationIconsOnlyExample({super.key});

  @override
  State<PaginationIconsOnlyExample> createState() =>
      _PaginationIconsOnlyExampleState();
}

class _PaginationIconsOnlyExampleState
    extends State<PaginationIconsOnlyExample> {
  int page = 4;

  @override
  Widget build(BuildContext context) {
    return ShadPaginationCompact(
      page: page,
      pageCount: 12,
      onPageChanged: (value) => setState(() => page = value),
      labelBuilder: (_, _, _) => const SizedBox.shrink(),
    );
  }
}
```

