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
