import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  List<ShadCommandGroup> groups({
    void Function(String)? onSelected,
    bool cherryEnabled = true,
  }) => [
    ShadCommandGroup(
      heading: 'Fruit',
      items: [
        ShadCommandItem(
          label: 'Apple',
          value: 'apple',
          onSelected: () => onSelected?.call('Apple'),
        ),
        ShadCommandItem(
          label: 'Banana',
          value: 'banana',
          keywords: const ['yellow'],
          onSelected: () => onSelected?.call('Banana'),
        ),
      ],
    ),
    ShadCommandGroup(
      heading: 'Berries',
      items: [
        ShadCommandItem(
          label: 'Cherry',
          value: 'cherry',
          enabled: cherryEnabled,
          onSelected: () => onSelected?.call('Cherry'),
        ),
      ],
    ),
  ];

  Widget wrap(Widget child) => ShadApp(home: Center(child: child));

  /// Matches a rendered item label only.
  ///
  /// A bare `find.text` also matches the search field's EditableText whenever
  /// the query happens to equal an item's label; an EditableText is not a
  /// [Text], so this predicate excludes it.
  Finder resultText(String label) =>
      find.byWidgetPredicate((w) => w is Text && w.data == label);

  group('ShadCommand.defaultFilter', () {
    final items = groups().expand((g) => g.items).toList();

    test('returns everything for an empty query', () {
      expect(ShadCommand.defaultFilter(items, ''), hasLength(3));
      expect(ShadCommand.defaultFilter(items, '   '), hasLength(3));
    });

    test('matches case-insensitively on the label', () {
      final result = ShadCommand.defaultFilter(items, 'aPp');
      expect(result.map((i) => i.label), ['Apple']);
    });

    test('matches on keywords too', () {
      final result = ShadCommand.defaultFilter(items, 'yellow');
      expect(result.map((i) => i.label), ['Banana']);
    });

    test('preserves the declared order', () {
      final result = ShadCommand.defaultFilter(items, 'a');
      expect(result.map((i) => i.label), ['Apple', 'Banana']);
    });

    test('returns nothing when there is no match', () {
      expect(ShadCommand.defaultFilter(items, 'zzz'), isEmpty);
    });
  });

  group('ShadCommand', () {
    testWidgets('renders every group and item', (tester) async {
      await tester.pumpWidget(wrap(ShadCommand(groups: groups())));
      await tester.pump();

      expect(find.text('Fruit'), findsOneWidget);
      expect(find.text('Berries'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Cherry'), findsOneWidget);
    });

    testWidgets('typing filters items and hides emptied groups', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(ShadCommand(groups: groups())));
      await tester.pump();

      await tester.enterText(find.byType(ShadInput), 'cher');
      await tester.pumpAndSettle();

      expect(find.text('Cherry'), findsOneWidget);
      expect(find.text('Apple'), findsNothing);
      // The heading of the emptied group goes with it.
      expect(find.text('Fruit'), findsNothing);
      expect(find.text('Berries'), findsOneWidget);
    });

    testWidgets('shows the empty state when nothing matches', (tester) async {
      await tester.pumpWidget(wrap(ShadCommand(groups: groups())));
      await tester.pump();

      await tester.enterText(find.byType(ShadInput), 'zzzz');
      await tester.pumpAndSettle();

      expect(find.byType(ShadEmpty), findsOneWidget);
      expect(find.text('No results'), findsOneWidget);
    });

    testWidgets('a custom emptyBuilder replaces the default', (tester) async {
      await tester.pumpWidget(
        wrap(
          ShadCommand(
            groups: groups(),
            emptyBuilder: (context, query) => Text('nothing for "$query"'),
          ),
        ),
      );
      await tester.pump();

      await tester.enterText(find.byType(ShadInput), 'zzzz');
      await tester.pumpAndSettle();
      expect(find.text('nothing for "zzzz"'), findsOneWidget);
    });

    testWidgets('a custom filter is used', (tester) async {
      await tester.pumpWidget(
        wrap(
          ShadCommand(
            groups: groups(),
            // Exact match only.
            filter: (items, query) => query.isEmpty
                ? items
                : items.where((i) => i.label == query).toList(),
          ),
        ),
      );
      await tester.pump();

      await tester.enterText(find.byType(ShadInput), 'App');
      await tester.pumpAndSettle();
      expect(find.byType(ShadEmpty), findsOneWidget);

      await tester.enterText(find.byType(ShadInput), 'Apple');
      await tester.pumpAndSettle();
      expect(resultText('Apple'), findsOneWidget);
    });

    testWidgets('tapping an item selects it', (tester) async {
      final chosen = <String>[];
      await tester.pumpWidget(
        wrap(ShadCommand(groups: groups(onSelected: chosen.add))),
      );
      await tester.pump();

      await tester.tap(find.text('Banana'));
      await tester.pumpAndSettle();
      expect(chosen, ['Banana']);
    });

    testWidgets('a disabled item cannot be selected', (tester) async {
      final chosen = <String>[];
      await tester.pumpWidget(
        wrap(
          ShadCommand(
            groups: groups(onSelected: chosen.add, cherryEnabled: false),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Cherry'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(chosen, isEmpty);
    });

    testWidgets('arrow down then Enter selects across group boundaries', (
      tester,
    ) async {
      final chosen = <String>[];
      await tester.pumpWidget(
        wrap(ShadCommand(groups: groups(onSelected: chosen.add))),
      );
      await tester.pumpAndSettle();

      // Highlight starts at index 0 (Apple). Two downs reach Cherry, which is
      // in the second group — the highlight is flat across groups.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(chosen, ['Cherry']);
    });

    testWidgets('End jumps to the last item', (tester) async {
      final chosen = <String>[];
      await tester.pumpWidget(
        wrap(ShadCommand(groups: groups(onSelected: chosen.add))),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(chosen, ['Cherry']);
    });

    testWidgets('Escape invokes onEscape', (tester) async {
      var escaped = false;
      await tester.pumpWidget(
        wrap(
          ShadCommand(groups: groups(), onEscape: () => escaped = true),
        ),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(escaped, isTrue);
    });

    testWidgets('onItemSelected reports the chosen item', (tester) async {
      ShadCommandItem? selected;
      await tester.pumpWidget(
        wrap(
          ShadCommand(
            groups: groups(),
            onItemSelected: (item) => selected = item,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Apple'));
      await tester.pumpAndSettle();
      expect(selected?.value, 'apple');
    });

    testWidgets('an external controller drives the query', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(ShadCommand(groups: groups(), controller: controller)),
      );
      await tester.pump();

      controller.text = 'banana';
      await tester.pumpAndSettle();
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Apple'), findsNothing);
    });
  });
}
