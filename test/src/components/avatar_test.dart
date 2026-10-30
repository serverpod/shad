import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shad/material.dart';
import 'package:shad/src/app.dart';
import 'package:shad/src/components/avatar.dart'; // Adjust import path based on your project structure

void main() {
  // Helper method to create a test widget wrapped in ShadApp and Scaffold
  Widget createTestWidget(Widget child) {
    return ShadApp(
      builder: (context, child) => ShadMaterial(child: child!),
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('ShadAvatar', () {
    testWidgets('applies custom size correctly', (WidgetTester tester) async {
      const customSize = Size(60, 60);
      await tester.pumpWidget(
        createTestWidget(
          const ShadAvatar(
            'assets/test_image.png',
            size: customSize,
          ),
        ),
      );

      // Check Container applies custom size
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
      final container = tester.widget<Container>(containerFinder);
      expect(container.constraints?.maxWidth, customSize.width);
      expect(container.constraints?.maxHeight, customSize.height);

      // Check the image uses the custom size
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final image = tester.widget<Image>(imageFinder);
      expect(image.width, customSize.width);
      expect(image.height, customSize.height);
    });

    testWidgets('applies custom shape correctly', (WidgetTester tester) async {
      const customShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      );
      await tester.pumpWidget(
        createTestWidget(
          const ShadAvatar(
            'assets/test_image.png',
            shape: customShape,
          ),
        ),
      );

      // Check Container uses ShapeDecoration with custom shape
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as ShapeDecoration?;
      expect(decoration?.shape, customShape);
    });

    testWidgets('applies custom background color correctly', (
      WidgetTester tester,
    ) async {
      const customBackgroundColor = Colors.blue;
      await tester.pumpWidget(
        createTestWidget(
          const ShadAvatar(
            'assets/test_image.png',
            backgroundColor: customBackgroundColor,
          ),
        ),
      );

      // Check Container uses ShapeDecoration with custom background color
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as ShapeDecoration?;
      expect(decoration?.color, customBackgroundColor);
    });

    testWidgets('applies custom fit correctly', (WidgetTester tester) async {
      const customFit = BoxFit.cover;
      await tester.pumpWidget(
        createTestWidget(
          const ShadAvatar(
            'assets/test_image.png',
            fit: customFit,
          ),
        ),
      );

      // Check Image uses custom fit
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final image = tester.widget<Image>(
        imageFinder,
      );
      expect(image.fit, customFit);
    });

    testWidgets('renders with default size when not specified', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadAvatar('assets/test_image.png'),
        ),
      );

      // Check Container applies default size — shadcn's `size-8`.
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
      final container = tester.widget<Container>(containerFinder);
      expect(container.constraints?.maxWidth, 32.0);
      expect(container.constraints?.maxHeight, 32.0);

      // Check Image uses default size
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final image = tester.widget<Image>(
        imageFinder,
      );
      expect(image.width, 32.0);
      expect(image.height, 32.0);
    });

    testWidgets('renders with default circular shape when not specified', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadAvatar('assets/test_image.png'),
        ),
      );

      // Check Container uses ShapeDecoration with default CircleBorder
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as ShapeDecoration?;
      expect(decoration?.shape, isA<CircleBorder>());
    });

    testWidgets('shows the fallback when the source is missing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadAvatar('', fallback: Text('AB')),
        ),
      );

      expect(find.text('AB'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('shows the fallback when the image fails to load', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadAvatar(
            'https://example.invalid/avatar.png',
            fallback: Text('AB'),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('AB'), findsOneWidget);
    });

    testWidgets('resolves a URL, an asset path and a provider', (
      tester,
    ) async {
      ImageProvider? providerOf(Widget avatar) {
        final image = find.descendant(
          of: find.byWidget(avatar),
          matching: find.byType(Image),
        );
        return tester.widget<Image>(image).image;
      }

      const network = ShadAvatar('https://example.invalid/a.png');
      const asset = ShadAvatar('img/a.png', package: 'my_pkg');
      const provider = ShadAvatar.image(AssetImage('img/b.png'));
      await tester.pumpWidget(
        createTestWidget(const Column(children: [network, asset, provider])),
      );

      expect(providerOf(network), isA<NetworkImage>());
      expect(
        providerOf(asset),
        const AssetImage('img/a.png', package: 'my_pkg'),
      );
      expect(providerOf(provider), const AssetImage('img/b.png'));
    });

    testWidgets('ShadAvatar.image with no image shows the fallback', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(const ShadAvatar.image(null, fallback: Text('AB'))),
      );
      expect(find.text('AB'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('placeholder still works as the deprecated name of fallback', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          // ignore: deprecated_member_use_from_same_package
          const ShadAvatar(null, placeholder: Text('XY')),
        ),
      );
      expect(find.text('XY'), findsOneWidget);
    });

    testWidgets('ShadAvatar matches goldens', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadAvatar(null, fallback: Icon(LucideIcons.mail)),
        ),
      );

      await expectLater(
        find.byType(ShadAvatar),
        matchesGoldenFile('goldens/avatar.png'),
      );
    });
  });
}
