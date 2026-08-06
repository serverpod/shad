# Data Table

A table with sorting, selection, filtering, and pagination, driven by a controller.

## Payments

Tap a column header to sort. A third tap clears the sort.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class Payment {
  const Payment(this.id, this.status, this.email, this.amount);

  final String id;
  final String status;
  final String email;
  final double amount;
}

const _payments = [
  Payment('m5gr84i9', 'success', 'ken99@example.com', 316),
  Payment('3u1reuv4', 'success', 'abe45@example.com', 242),
  Payment('derv1ws0', 'processing', 'monserrat44@example.com', 837),
  Payment('5kma53ae', 'success', 'silas22@example.com', 874),
  Payment('bhqecj4p', 'failed', 'carmella@example.com', 721),
  Payment('a1b2c3d4', 'processing', 'jason@example.com', 128),
  Payment('e5f6g7h8', 'failed', 'nina@example.com', 455),
];

class DataTablePaymentsExample extends StatefulWidget {
  const DataTablePaymentsExample({super.key});

  @override
  State<DataTablePaymentsExample> createState() =>
      _DataTablePaymentsExampleState();
}

class _DataTablePaymentsExampleState extends State<DataTablePaymentsExample> {
  final controller = ShadDataTableController<Payment>(
    rows: _payments,
    pageSize: 5,
  );

  @override
  void initState() {
    super.initState();
    controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final total = controller.filteredRows.length;
    final rowHeight = theme.tableTheme.cellHeight ?? 48;
    final visibleRowCount = controller.visibleRows.length;
    // TableView does not shrink-wrap, so height tracks the pinned header
    // plus the rows on the current page.
    final tableHeight = visibleRowCount == 0
        ? rowHeight * 3
        : rowHeight * (visibleRowCount + 1);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 700),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadCard(
              padding: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: ShadDataTable<Payment>(
                controller: controller,
                selectable: true,
                keyOf: (payment) => payment.id,
                height: tableHeight,
                showPagination: false,
                showSelectionCount: false,
                columns: [
                  ShadDataTableColumn(
                    id: 'status',
                    header: 'Status',
                    extent: const FixedTableSpanExtent(140),
                    compare: (a, b) => a.status.compareTo(b.status),
                    cellBuilder: (context, payment) => ShadBadge.raw(
                      variant: switch (payment.status) {
                        'success' => ShadBadgeVariant.primary,
                        'failed' => ShadBadgeVariant.destructive,
                        _ => ShadBadgeVariant.secondary,
                      },
                      child: Text(payment.status),
                    ),
                  ),
                  ShadDataTableColumn(
                    id: 'email',
                    header: 'Email',
                    compare: (a, b) => a.email.compareTo(b.email),
                    cellBuilder: (context, payment) =>
                        Text(payment.email, overflow: TextOverflow.ellipsis),
                  ),
                  ShadDataTableColumn(
                    id: 'amount',
                    header: 'Amount',
                    extent: const FixedTableSpanExtent(120),
                    alignment: Alignment.centerRight,
                    compare: (a, b) => a.amount.compareTo(b.amount),
                    cellBuilder: (context, payment) =>
                        Text('\$${payment.amount.toStringAsFixed(2)}'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${controller.selectedKeys.length} of $total row(s) selected.',
                  style: theme.textTheme.muted,
                ),
                const Spacer(),
                ShadPaginationCompact(
                  page: controller.page,
                  pageCount: controller.pageCount,
                  onPageChanged: (page) => controller.page = page,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

