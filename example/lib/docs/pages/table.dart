import 'package:example/docs/docs.dart';
import 'package:example/docs/examples/table/table_invoices.dart';

final tableDoc = ComponentDoc(
  slug: 'table',
  title: 'Table',
  description: 'A responsive table component with header and footer rows.',
  playgroundRoute: '/table',
  examples: [
    ComponentExample(
      id: 'table_invoices',
      title: 'Invoices',
      minPreviewHeight: 420,
      builder: (_) => const TableInvoicesExample(),
    ),
  ],
);
