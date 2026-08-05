import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shad/src/app.dart';
import 'package:shad/src/components/alert.dart';
import 'package:shad/src/theme/data.dart';
import 'package:shad/src/theme/style.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ShadApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('alert theme resolution', () {
    // The values `.cn-alert` prescribes: `bg-card` behind both variants, a
    // plain `border` outline even on destructive (only the *text* turns
    // red), a `text-muted-foreground` description that destructive tints at
    // 90% (`text-destructive/90`), and sera's accent bar on the left edge.
    test('both variants sit on bg-card inside a plain border', () {
      final theme = ShadThemeData();
      for (final alert in [
        theme.primaryAlertTheme,
        theme.destructiveAlertTheme,
      ]) {
        expect(alert.decoration?.color, theme.colorScheme.card);
        expect(alert.decoration?.border?.top?.color, theme.colorScheme.border);
      }
      expect(
        theme.primaryAlertTheme.descriptionStyle?.color,
        theme.colorScheme.mutedForeground,
      );
      expect(
        theme.destructiveAlertTheme.descriptionStyle?.color,
        theme.colorScheme.destructive.withValues(alpha: 0.9),
      );
    });

    test('sera draws its accent bar as a thick left side', () {
      final theme = ShadThemeData(style: ShadStyleTokens.sera);
      final primary = theme.primaryAlertTheme.decoration?.border;
      final destructive = theme.destructiveAlertTheme.decoration?.border;
      expect(primary?.left?.width, 2);
      expect(primary?.left?.color, theme.colorScheme.foreground);
      expect(destructive?.left?.color, theme.colorScheme.destructive);
      // The other sides stay on the regular hairline.
      expect(primary?.top?.width, 1);
      expect(primary?.top?.color, theme.colorScheme.border);
    });

    test('mira compacts the icon, vega keeps size-4', () {
      expect(ShadThemeData().primaryAlertTheme.iconSize, 16);
      expect(
        ShadThemeData(
          style: ShadStyleTokens.mira,
        ).primaryAlertTheme.iconSize,
        14,
      );
    });
  });

  group('ShadAlert', () {
    testWidgets('renders primary variant correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadAlert(
            title: Text('Primary Alert'),
            description: Text('This is a primary alert'),
            icon: Icon(Icons.info),
          ),
        ),
      );

      // Check if components render
      expect(find.text('Primary Alert'), findsOneWidget);
      expect(find.text('This is a primary alert'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);

      // Check basic layout
      final rowFinder = find.byType(Row);
      expect(rowFinder, findsOneWidget);
    });

    testWidgets('renders destructive variant correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadAlert.destructive(
            title: Text('Error Alert'),
            description: Text('This is a destructive alert'),
            icon: Icon(Icons.error),
          ),
        ),
      );

      // Check if components render
      expect(find.text('Error Alert'), findsOneWidget);
      expect(find.text('This is a destructive alert'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('renders without icon when not provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadAlert(
            title: Text('No Icon Alert'),
            description: Text('This alert has no icon'),
          ),
        ),
      );

      // Check text renders
      expect(find.text('No Icon Alert'), findsOneWidget);
      expect(find.text('This alert has no icon'), findsOneWidget);

      // Check no icon is present
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('applies custom styles correctly', (WidgetTester tester) async {
      const customColor = Colors.red;
      const customPadding = EdgeInsets.all(20);

      await tester.pumpWidget(
        createTestWidget(
          const ShadAlert(
            title: Text('Styled Alert'),
            icon: Icon(Icons.info),
            iconColor: customColor,
            iconPadding: customPadding,
            titleStyle: TextStyle(fontSize: 20),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the specific ShadAlert widget
      final alertFinder = find.byType(ShadAlert);
      expect(alertFinder, findsOneWidget);

      // Find the IconTheme within the ShadAlert and check its color
      final iconThemeFinder = find.descendant(
        of: alertFinder,
        matching: find.byType(IconTheme),
      );
      expect(iconThemeFinder, findsOneWidget);
      final iconTheme = tester.widget<IconTheme>(iconThemeFinder);
      expect(iconTheme.data.color, customColor);

      // Find the specific padding that wraps the icon
      final paddingFinder = find.ancestor(
        of: find.byIcon(Icons.info),
        matching: find.byType(Padding),
      );
      final padding = tester.widget<Padding>(paddingFinder.first);
      expect(padding.padding, customPadding);

      // Find the DefaultTextStyle within the ShadAlert that styles the title
      final defaultTextStyleFinder = find.descendant(
        of: alertFinder,
        matching: find.byWidgetPredicate(
          (widget) => widget is DefaultTextStyle,
        ),
      );
      expect(defaultTextStyleFinder, findsOneWidget);
      final defaultTextStyle = tester.widget<DefaultTextStyle>(
        defaultTextStyleFinder,
      );
      expect(defaultTextStyle.style.fontSize, 20);
    });

    testWidgets('handles text direction correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadAlert(
            title: Text('RTL Alert'),
            textDirection: TextDirection.rtl,
          ),
        ),
      );

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.textDirection, TextDirection.rtl);
    });

    testWidgets('handles null title and description', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(const ShadAlert(icon: Icon(Icons.info))),
      );

      // Check icon renders
      expect(find.byIcon(Icons.info), findsOneWidget);

      // Check no text widgets are present
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('ShardAlert matches goldens', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadAlert(
            icon: Icon(LucideIcons.mail),
            title: Text('Title'),
            description: Text('Description'),
          ),
        ),
      );

      expect(
        find.byType(ShadAlert),
        matchesGoldenFile('goldens/alert.png'),
      );
    });

    testWidgets('ShardAlert.destructive matches goldens', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadAlert.destructive(
            icon: Icon(LucideIcons.mail),
            title: Text('Title'),
            description: Text('Description'),
          ),
        ),
      );

      expect(
        find.byType(ShadAlert),
        matchesGoldenFile('goldens/alert_destructive.png'),
      );
    });
  });
}
