import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class _User {
  const _User(this.id, this.name, this.age);

  final String id;
  final String name;
  final int age;
}

void main() {
  const users = [
    _User('1', 'Charlie', 30),
    _User('2', 'Alice', 25),
    _User('3', 'Bob', 35),
  ];

  List<ShadDataTableColumn<_User>> columns() => [
    ShadDataTableColumn(
      id: 'name',
      header: 'Name',
      cellBuilder: (context, user) => Text(user.name),
      compare: (a, b) => a.name.compareTo(b.name),
    ),
    ShadDataTableColumn(
      id: 'age',
      header: 'Age',
      cellBuilder: (context, user) => Text('${user.age}'),
      compare: (a, b) => a.age.compareTo(b.age),
    ),
    // Not sortable: no comparator.
    ShadDataTableColumn(
      id: 'id',
      header: 'ID',
      cellBuilder: (context, user) => Text(user.id),
    ),
  ];

  group('ShadDataTableController', () {
    ShadDataTableController<_User> build({int? pageSize}) {
      final controller = ShadDataTableController<_User>(
        rows: users,
        pageSize: pageSize,
      );
      // The table normally injects the columns; do it directly so the
      // controller can be exercised without pumping a widget.
      addTearDown(controller.dispose);
      return controller;
    }

    testWidgets('sorts ascending, descending, then clears', (tester) async {
      final controller = build();
      await tester.pumpWidget(
        ShadApp(
          home: SizedBox(
            height: 400,
            child: ShadDataTable<_User>(
              columns: columns(),
              controller: controller,
              height: 300,
            ),
          ),
        ),
      );

      expect(controller.filteredRows.map((u) => u.name), [
        'Charlie',
        'Alice',
        'Bob',
      ]);

      controller.sortBy('name');
      expect(controller.sortDirection, ShadSortDirection.ascending);
      expect(controller.filteredRows.map((u) => u.name), [
        'Alice',
        'Bob',
        'Charlie',
      ]);

      controller.sortBy('name');
      expect(controller.sortDirection, ShadSortDirection.descending);
      expect(controller.filteredRows.map((u) => u.name), [
        'Charlie',
        'Bob',
        'Alice',
      ]);

      // Third press clears the sort and restores the source order.
      controller.sortBy('name');
      expect(controller.sortColumnId, isNull);
      expect(controller.filteredRows.map((u) => u.name), [
        'Charlie',
        'Alice',
        'Bob',
      ]);
    });

    testWidgets('switching columns restarts at ascending', (tester) async {
      final controller = build();
      await tester.pumpWidget(
        ShadApp(
          home: ShadDataTable<_User>(
            columns: columns(),
            controller: controller,
            height: 300,
          ),
        ),
      );

      controller
        ..sortBy('name')
        ..sortBy('name');
      expect(controller.sortDirection, ShadSortDirection.descending);

      controller.sortBy('age');
      expect(controller.sortColumnId, 'age');
      expect(controller.sortDirection, ShadSortDirection.ascending);
      expect(controller.filteredRows.map((u) => u.age), [25, 30, 35]);
    });

    test('sorting never mutates the source rows', () {
      final controller = ShadDataTableController<_User>(rows: users);
      addTearDown(controller.dispose);
      controller.filteredRows.sort((a, b) => a.name.compareTo(b.name));
      expect(controller.rows.map((u) => u.name), [
        'Charlie',
        'Alice',
        'Bob',
      ]);
    });

    test('filters rows and resets to the first page', () {
      final controller = ShadDataTableController<_User>(
        rows: users,
        pageSize: 1,
      );
      addTearDown(controller.dispose);

      controller.page = 3;
      expect(controller.page, 3);

      controller.filter = (u) => u.age >= 30;
      expect(controller.page, 1);
      expect(controller.filteredRows.map((u) => u.name), [
        'Charlie',
        'Bob',
      ]);
      expect(controller.pageCount, 2);
    });

    test('pages the visible rows', () {
      final controller = ShadDataTableController<_User>(
        rows: users,
        pageSize: 2,
      );
      addTearDown(controller.dispose);

      expect(controller.pageCount, 2);
      expect(controller.visibleRows, hasLength(2));

      controller.page = 2;
      expect(controller.visibleRows, hasLength(1));
      expect(controller.visibleRows.single.name, 'Bob');
    });

    test('clamps the page to the available range', () {
      final controller = ShadDataTableController<_User>(
        rows: users,
        pageSize: 2,
      );
      addTearDown(controller.dispose);

      controller.page = 99;
      expect(controller.page, 2);
      controller.page = 0;
      expect(controller.page, 1);
    });

    test('pageCount is 1 when there are no rows', () {
      final controller = ShadDataTableController<_User>(pageSize: 10);
      addTearDown(controller.dispose);
      expect(controller.pageCount, 1);
      expect(controller.visibleRows, isEmpty);
    });

    test('tracks selection by key', () {
      final controller = ShadDataTableController<_User>(rows: users);
      addTearDown(controller.dispose);

      controller.toggleSelected('1');
      expect(controller.selectedKeys, {'1'});
      controller.toggleSelected('1');
      expect(controller.selectedKeys, isEmpty);

      controller.selectAll(['1', '2']);
      expect(controller.selectedKeys, {'1', '2'});
      controller.clearSelection();
      expect(controller.selectedKeys, isEmpty);
    });

    test('selection survives a re-sort', () {
      final controller = ShadDataTableController<_User>(rows: users);
      addTearDown(controller.dispose);
      controller
        ..toggleSelected('2')
        ..rows = users.reversed.toList();
      expect(controller.selectedKeys, {'2'});
    });
  });

  group('ShadDataTable', () {
    testWidgets('renders headers and cells', (tester) async {
      final controller = ShadDataTableController<_User>(rows: users);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        ShadApp(
          home: ShadDataTable<_User>(
            columns: columns(),
            controller: controller,
            height: 400,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
      expect(find.text('Charlie'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
    });

    testWidgets('tapping a sortable header sorts the table', (tester) async {
      final controller = ShadDataTableController<_User>(rows: users);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        ShadApp(
          home: ShadDataTable<_User>(
            columns: columns(),
            controller: controller,
            height: 400,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Name'));
      await tester.pumpAndSettle();
      expect(controller.sortColumnId, 'name');
      expect(controller.sortDirection, ShadSortDirection.ascending);
    });

    testWidgets('a non-sortable header does not sort', (tester) async {
      final controller = ShadDataTableController<_User>(rows: users);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        ShadApp(
          home: ShadDataTable<_User>(
            columns: columns(),
            controller: controller,
            height: 400,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('ID'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(controller.sortColumnId, isNull);
    });

    testWidgets('shows the empty state when there are no rows', (
      tester,
    ) async {
      final controller = ShadDataTableController<_User>();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        ShadApp(
          home: ShadDataTable<_User>(
            columns: columns(),
            controller: controller,
            height: 400,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ShadEmpty), findsOneWidget);
    });

    testWidgets('hides columns marked invisible', (tester) async {
      final controller = ShadDataTableController<_User>(rows: users);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        ShadApp(
          home: ShadDataTable<_User>(
            columns: [
              ...columns().where((c) => c.id != 'age'),
              ShadDataTableColumn(
                id: 'age',
                header: 'Age',
                visible: false,
                cellBuilder: (context, user) => Text('${user.age}'),
              ),
            ],
            controller: controller,
            height: 400,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Age'), findsNothing);
    });

    testWidgets('selectable renders checkboxes and tracks selection', (
      tester,
    ) async {
      final controller = ShadDataTableController<_User>(rows: users);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        ShadApp(
          home: ShadDataTable<_User>(
            columns: columns(),
            controller: controller,
            keyOf: (user) => user.id,
            selectable: true,
            height: 400,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // One per row plus the select-all in the header.
      expect(find.byType(ShadCheckbox), findsNWidgets(users.length + 1));

      await tester.tap(find.byType(ShadCheckbox).at(1));
      await tester.pumpAndSettle();
      expect(controller.selectedKeys, hasLength(1));
    });

    testWidgets('the header checkbox selects and clears every row', (
      tester,
    ) async {
      final controller = ShadDataTableController<_User>(rows: users);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        ShadApp(
          home: ShadDataTable<_User>(
            columns: columns(),
            controller: controller,
            keyOf: (user) => user.id,
            selectable: true,
            height: 400,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ShadCheckbox).first);
      await tester.pumpAndSettle();
      expect(controller.selectedKeys, {'1', '2', '3'});

      await tester.tap(find.byType(ShadCheckbox).first);
      await tester.pumpAndSettle();
      expect(controller.selectedKeys, isEmpty);
    });

    testWidgets('shows a pagination bar when a pageSize is set', (
      tester,
    ) async {
      final controller = ShadDataTableController<_User>(
        rows: users,
        pageSize: 2,
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        ShadApp(
          home: ShadDataTable<_User>(
            columns: columns(),
            controller: controller,
            height: 300,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ShadPaginationCompact), findsOneWidget);
      expect(find.text('Charlie'), findsOneWidget);
      expect(find.text('Bob'), findsNothing);

      controller.page = 2;
      await tester.pumpAndSettle();
      expect(find.text('Bob'), findsOneWidget);
    });
  });
}
