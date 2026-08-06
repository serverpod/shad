import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/src/app.dart';
import 'package:shad/src/components/pagination.dart';

void main() {
  Widget wrap(Widget child) => ShadApp(
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('inactive page buttons match the selected button size', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const ShadPagination(
          page: 2,
          pageCount: 5,
          showEdges: false,
          onPageChanged: _noop,
        ),
      ),
    );

    final selected = tester.getSize(find.text('2'));
    for (final label in ['1', '3', '4', '5']) {
      expect(tester.getSize(find.text(label)), selected);
    }
  });

  testWidgets('changing the selected page does not move edge labels', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const _PaginationHarness()));

    final previousBefore = tester.getTopLeft(find.text('Previous'));
    final nextBefore = tester.getTopLeft(find.text('Next'));

    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.text('Previous')), previousBefore);
    expect(tester.getTopLeft(find.text('Next')), nextBefore);
  });
}

void _noop(int _) {}

class _PaginationHarness extends StatefulWidget {
  const _PaginationHarness();

  @override
  State<_PaginationHarness> createState() => _PaginationHarnessState();
}

class _PaginationHarnessState extends State<_PaginationHarness> {
  int page = 2;

  @override
  Widget build(BuildContext context) {
    return ShadPagination(
      page: page,
      pageCount: 5,
      onPageChanged: (value) => setState(() => page = value),
    );
  }
}
