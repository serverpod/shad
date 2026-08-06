import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/pagination/pagination_basic.dart';
import 'package:example/docs/examples/pagination/pagination_compact.dart';
import 'package:example/docs/examples/pagination/pagination_icons_only.dart';
import 'package:example/docs/examples/pagination/pagination_simple.dart';

final paginationDoc = ComponentDoc(
  slug: 'pagination',
  title: 'Pagination',
  description:
      'Page navigation with previous and next links. '
      '[ShadPagination] shows a windowed run of page numbers; '
      '[ShadPaginationCompact] fits toolbars and table footers.',
  examples: [
    ComponentExample(
      id: 'pagination_basic',
      title: 'Default',
      description:
          'Previous and next labels with a windowed run of page numbers. '
          'An ellipsis marks pages that were skipped.',
      builder: (_) => const PaginationBasicExample(),
    ),
    ComponentExample(
      id: 'pagination_simple',
      title: 'Simple',
      description:
          'Page numbers only — set `showEdges: false` when every page fits '
          'without an ellipsis.',
      builder: (_) => const PaginationSimpleExample(),
    ),
    ComponentExample(
      id: 'pagination_compact',
      title: 'Compact',
      description:
          'Previous and next icon buttons with a `Page n / m` counter, '
          'useful beneath a data table.',
      builder: (_) => const PaginationCompactExample(),
    ),
    ComponentExample(
      id: 'pagination_icons_only',
      title: 'Icons only',
      description:
          'Drop the counter with `labelBuilder` when space is tight, '
          'for example beside a rows-per-page control.',
      builder: (_) => const PaginationIconsOnlyExample(),
    ),
  ],
);
