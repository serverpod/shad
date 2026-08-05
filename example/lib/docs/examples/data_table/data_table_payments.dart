import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 700),
      child: ShadDataTable<Payment>(
        controller: controller,
        selectable: true,
        keyOf: (payment) => payment.id,
        height: 320,
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
    );
  }
}
