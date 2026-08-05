import 'package:example/common/base_scaffold.dart';
import 'package:example/common/properties/bool_property.dart';
import 'package:flutter/material.dart';
import 'package:shad/shad.dart';

class _Payment {
  const _Payment(this.id, this.status, this.email, this.amount);

  final String id;
  final String status;
  final String email;
  final double amount;
}

const _payments = [
  _Payment('m5gr84i9', 'success', 'ken99@example.com', 316),
  _Payment('3u1reuv4', 'success', 'abe45@example.com', 242),
  _Payment('derv1ws0', 'processing', 'monserrat44@example.com', 837),
  _Payment('5kma53ae', 'success', 'silas22@example.com', 874),
  _Payment('bhqecj4p', 'failed', 'carmella@example.com', 721),
  _Payment('a1b2c3d4', 'processing', 'jason@example.com', 128),
  _Payment('e5f6g7h8', 'failed', 'nina@example.com', 455),
];

class DataTablePage extends StatefulWidget {
  const DataTablePage({super.key});

  @override
  State<DataTablePage> createState() => _DataTablePageState();
}

class _DataTablePageState extends State<DataTablePage> {
  final controller = ShadDataTableController<_Payment>(
    rows: _payments,
    pageSize: 5,
  );

  bool selectable = true;
  bool onlySuccess = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return BaseScaffold(
      appBarTitle: 'Data Table',
      // The table needs a bounded height and manages its own scrolling.
      wrapChildrenInScrollable: false,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      editable: [
        MyBoolProperty(
          label: 'selectable',
          value: selectable,
          onChanged: (value) => setState(() => selectable = value),
        ),
        MyBoolProperty(
          label: 'filter: success only',
          value: onlySuccess,
          onChanged: (value) {
            setState(() => onlySuccess = value);
            controller.filter = value
                ? (payment) => payment.status == 'success'
                : null;
          },
        ),
      ],
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tap a column header to sort. A third tap clears the sort.',
                style: theme.textTheme.muted,
              ),
              const SizedBox(height: 12),
              ShadDataTable<_Payment>(
                controller: controller,
                selectable: selectable,
                keyOf: (payment) => payment.id,
                height: 320,
                onRowTap: (payment) => ShadSonner.of(context).show(
                  ShadToast(title: Text('Tapped ${payment.email}')),
                ),
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
                    cellBuilder: (context, payment) => Text(
                      payment.email,
                      overflow: TextOverflow.ellipsis,
                    ),
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
            ],
          ),
        ),
      ],
    );
  }
}
