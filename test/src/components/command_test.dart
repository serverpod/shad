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

      expect(find.text('No results found.'), findsOneWidget);
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
      expect(find.text('No results found.'), findsOneWidget);

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

  group('showShadCommandDialog', () {
    Future<void> open(WidgetTester tester) async {
      await tester.pumpWidget(
        ShadApp(
          home: Builder(
            builder: (context) => Center(
              child: ShadButton(
                child: const Text('Open'),
                onPressed: () => showShadCommandDialog<String>(
                  context: context,
                  groups: groups(),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('the top edge pins at a third of the screen and stays there '
        'while filtering', (tester) async {
      await open(tester);

      final screen = tester.getSize(find.byType(ShadApp));
      final openRect = tester.getRect(find.byType(ShadCommand));
      // `.cn-command-dialog top-1/3 translate-y-0`.
      expect(openRect.top, screen.height / 3);

      await tester.enterText(find.byType(EditableText), 'banana');
      await tester.pumpAndSettle();
      final filteredRect = tester.getRect(find.byType(ShadCommand));

      // Fewer results: the palette shrinks from the bottom only.
      expect(filteredRect.top, openRect.top);
      expect(filteredRect.bottom, lessThan(openRect.bottom));
    });

    testWidgets('the palette hugs its content below the list cap', (
      tester,
    ) async {
      await open(tester);

      final rect = tester.getRect(find.byType(ShadCommand));
      // Well under the old fixed 300 — the three items plus the search box.
      expect(rect.height, lessThan(250));

      // And the last item's row sits flush against the bottom padding, not
      // above a run of empty space.
      final lastItem = tester.getRect(resultText('Cherry').first);
      expect(rect.bottom - lastItem.bottom, lessThan(30));
    });

    testWidgets('the search box is the input-group style, not a full-width '
        'underline', (tester) async {
      await open(tester);

      final theme = ShadTheme.of(
        tester.element(find.byType(ShadCommand)),
      );
      final input = tester.widget<ShadInput>(
        find.descendant(
          of: find.byType(ShadCommand),
          matching: find.byType(ShadInput),
        ),
      );
      // `bg-input/30` inside an `--input` outline, no focus ring.
      expect(
        input.decoration?.color,
        theme.colorScheme.input.withValues(alpha: .3),
      );
      expect(input.decoration?.disableSecondaryBorder, true);
      expect(
        input.decoration?.border?.top?.color,
        theme.colorScheme.input.withValues(
          alpha: theme.style.commandSearchBorderOpacity,
        ),
      );
      // Inset from the dialog edge (`p-1` + `p-1 pb-0`), not edge-to-edge.
      final inputRect = tester.getRect(find.byType(ShadInput));
      final commandRect = tester.getRect(find.byType(ShadCommand));
      expect(inputRect.left - commandRect.left, greaterThan(0));
      // `h-8!`.
      expect(inputRect.height, theme.style.commandSearchHeight);
    });

    testWidgets('the dialog casts no shadow', (tester) async {
      await open(tester);
      final dialog = tester.widget<ShadDialog>(find.byType(ShadDialog));
      expect(dialog.shadows, Shadows.none);
    });

    testWidgets('the empty state is a quiet text-sm line, not the ShadEmpty '
        'hero', (tester) async {
      await open(tester);
      await tester.enterText(find.byType(EditableText), 'zzzz');
      await tester.pumpAndSettle();

      // `.cn-command-empty py-6 text-center text-sm` with shadcn's
      // `CommandEmpty` copy.
      final text = tester.widget<Text>(find.text('No results found.'));
      expect(text.style?.fontSize, 14);
      expect(text.textAlign, TextAlign.center);
      expect(find.byType(ShadEmpty), findsNothing);
    });
  });
}
