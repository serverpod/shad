import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class PaginationBasicExample extends StatefulWidget {
  const PaginationBasicExample({super.key});

  @override
  State<PaginationBasicExample> createState() => _PaginationBasicExampleState();
}

class _PaginationBasicExampleState extends State<PaginationBasicExample> {
  int page = 5;

  @override
  Widget build(BuildContext context) {
    return ShadPagination(
      page: page,
      pageCount: 20,
      onPageChanged: (value) => setState(() => page = value),
    );
  }
}
