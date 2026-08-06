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
