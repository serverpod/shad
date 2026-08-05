import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

const _invoices = [
  (
    invoice: 'INV001',
    status: 'Paid',
    method: 'Credit Card',
    amount: r'$250.00',
  ),
  (invoice: 'INV002', status: 'Pending', method: 'PayPal', amount: r'$150.00'),
  (
    invoice: 'INV003',
    status: 'Unpaid',
    method: 'Bank Transfer',
    amount: r'$350.00',
  ),
  (
    invoice: 'INV004',
    status: 'Paid',
    method: 'Credit Card',
    amount: r'$450.00',
  ),
  (invoice: 'INV005', status: 'Paid', method: 'PayPal', amount: r'$550.00'),
];

class TableInvoicesExample extends StatelessWidget {
  const TableInvoicesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 400),
      child: ShadTable.list(
        header: const [
          ShadTableCell.header(child: Text('Invoice')),
          ShadTableCell.header(child: Text('Status')),
          ShadTableCell.header(child: Text('Method')),
          ShadTableCell.header(
            alignment: Alignment.centerRight,
            child: Text('Amount'),
          ),
        ],
        footer: const [
          ShadTableCell.footer(child: Text('Total')),
          ShadTableCell.footer(child: Text('')),
          ShadTableCell.footer(child: Text('')),
          ShadTableCell.footer(
            alignment: Alignment.centerRight,
            child: Text(r'$1750.00'),
          ),
        ],
        children: [
          for (final invoice in _invoices)
            [
              ShadTableCell(child: Text(invoice.invoice)),
              ShadTableCell(child: Text(invoice.status)),
              ShadTableCell(child: Text(invoice.method)),
              ShadTableCell(
                alignment: Alignment.centerRight,
                child: Text(invoice.amount),
              ),
            ],
        ],
      ),
    );
  }
}
