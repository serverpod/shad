import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class PaginationIconsOnlyExample extends StatefulWidget {
  const PaginationIconsOnlyExample({super.key});

  @override
  State<PaginationIconsOnlyExample> createState() =>
      _PaginationIconsOnlyExampleState();
}

class _PaginationIconsOnlyExampleState extends State<PaginationIconsOnlyExample> {
  int page = 4;

  @override
  Widget build(BuildContext context) {
    return ShadPaginationCompact(
      page: page,
      pageCount: 12,
      onPageChanged: (value) => setState(() => page = value),
      labelBuilder: (_, _, _) => const SizedBox.shrink(),
    );
  }
}
