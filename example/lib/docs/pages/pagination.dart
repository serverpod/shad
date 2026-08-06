import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/pagination/pagination_basic.dart';

final paginationDoc = ComponentDoc(
  slug: 'pagination',
  title: 'Pagination',
  description: 'Page navigation with previous and next links.',
  examples: [
    ComponentExample(
      id: 'pagination_basic',
      title: 'Default',
      builder: (_) => const PaginationBasicExample(),
    ),
  ],
);
