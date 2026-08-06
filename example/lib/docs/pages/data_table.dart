import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/data_table/data_table_payments.dart';

final dataTableDoc = ComponentDoc(
  slug: 'data_table',
  title: 'Data Table',
  description:
      'A table with sorting, selection, filtering, and pagination, driven '
      'by a controller.',
  examples: [
    ComponentExample(
      id: 'data_table_payments',
      title: 'Payments',
      description: 'Tap a column header to sort. A third tap clears the sort.',
      minPreviewHeight: 420,
      builder: (_) => const DataTablePaymentsExample(),
    ),
  ],
);
