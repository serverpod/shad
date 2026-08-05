import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shad/src/app.dart';
import 'package:shad/src/components/input.dart';
import 'package:shad/src/components/input_otp.dart';
import 'package:shad/src/theme/data.dart';
import 'package:shad/src/theme/theme.dart';

void main() {
  // Helper method to create a test widget wrapped in ShadApp and Scaffold
  Widget createTestWidget(Widget child) {
    return ShadApp(home: Scaffold(body: child));
  }

  group('ShadInputOTP', () {
    testWidgets('ShadInputOTP matches goldens', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const ShadInputOTP(
            maxLength: 6,
            children: [
              ShadInputOTPGroup(
                children: [
                  ShadInputOTPSlot(),
                  ShadInputOTPSlot(),
                  ShadInputOTPSlot(),
                ],
              ),
              Icon(LucideIcons.dot),
              ShadInputOTPGroup(
                children: [
                  ShadInputOTPSlot(),
                  ShadInputOTPSlot(),
                  ShadInputOTPSlot(),
                ],
              ),
            ],
          ),
        ),
      );

      expect(
        find.byType(ShadInputOTP),
        matchesGoldenFile('goldens/input_otp.png'),
      );
    });
  });

  group('slot rendering', () {
    const strip = ShadInputOTP(
      maxLength: 6,
      initialValue: 'ABC',
      children: [
        ShadInputOTPGroup(
          children: [
            ShadInputOTPSlot(),
            ShadInputOTPSlot(),
            ShadInputOTPSlot(),
          ],
        ),
        // A fixed-width separator keeps every slot at an integer offset so
        // the pixel samples below never land on an anti-aliased edge.
        SizedBox(width: 16),
        ShadInputOTPGroup(
          children: [
            ShadInputOTPSlot(),
            ShadInputOTPSlot(),
            ShadInputOTPSlot(),
          ],
        ),
      ],
    );

    testWidgets('glyphs are centred and unclipped in their slots', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(strip));
      await tester.pump();

      final slotRect = tester.getRect(find.byType(ShadInputOTPSlot).first);
      final editable = tester.allRenderObjects
          .whereType<RenderEditable>()
          .first;
      final points = editable.getEndpointsForSelection(
        const TextSelection(baseOffset: 0, extentOffset: 1),
      );
      final glyphLeft = editable.localToGlobal(points.first.point).dx;
      final glyphRight = editable.localToGlobal(points.last.point).dx;

      // Inside the slot — the 12px field padding used to leave the glyph
      // less horizontal room than its own width, which clipped it.
      expect(glyphLeft, greaterThanOrEqualTo(slotRect.left));
      expect(glyphRight, lessThanOrEqualTo(slotRect.right));

      // And centred on the slot's midline, caret reservation compensated.
      final glyphCenter = (glyphLeft + glyphRight) / 2;
      expect(glyphCenter, closeTo(slotRect.center.dx, 1));
    });

    testWidgets('focused ring paints above the neighbouring slots', (
      tester,
    ) async {
      final boundaryKey = GlobalKey();
      await tester.pumpWidget(
        createTestWidget(
          RepaintBoundary(
            key: boundaryKey,
            child: const ColoredBox(
              color: Color(0xFFFFFFFF),
              child: Padding(padding: EdgeInsets.all(16), child: strip),
            ),
          ),
        ),
      );
      // The first slot of the second group: its ring overlaps the next
      // slot, whose hairlines used to be painted across it.
      await tester.tap(find.byType(ShadInputOTPSlot).at(3));
      await tester.pump();

      late final ui.Image image;
      await tester.runAsync(() async {
        final boundary =
            boundaryKey.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        image = await boundary.toImage();
      });
      final data = (await tester.runAsync(() => image.toByteData()))!;

      final boundaryRect = tester.getRect(find.byKey(boundaryKey));
      Color pixel(Offset global) {
        final local = global - boundaryRect.topLeft;
        final index =
            (local.dy.floor() * image.width + local.dx.floor()) * 4;
        return Color.fromARGB(
          data.getUint8(index + 3),
          data.getUint8(index),
          data.getUint8(index + 1),
          data.getUint8(index + 2),
        );
      }

      void expectColor(Color actual, Color expected, String reason) {
        for (final (a, b) in [
          (actual.r, expected.r),
          (actual.g, expected.g),
          (actual.b, expected.b),
        ]) {
          expect((a - b).abs(), lessThan(3 / 255), reason: reason);
        }
      }

      final theme = ShadTheme.of(tester.element(find.byType(ShadInputOTP)));
      final ringWidth = theme.style.ringWidth;
      final ring = theme.colorScheme.ring.withValues(
        alpha: theme.style.ringOpacity,
      );
      const white = Color(0xFFFFFFFF);
      final hairline = Color.alphaBlend(theme.colorScheme.input, white);

      final slotRect = tester.getRect(find.byType(ShadInputOTPSlot).at(3));

      // Mid-height of the ring's overhang into the next slot: the ring over
      // the white background.
      expectColor(
        pixel(Offset(slotRect.right + ringWidth / 2, slotRect.center.dy)),
        Color.alphaBlend(ring, white),
        'ring should overhang into the neighbouring slot',
      );

      // The same overhang where the neighbour's top hairline runs: the ring
      // must be painted over the hairline, not the other way round.
      expectColor(
        pixel(Offset(slotRect.right + ringWidth / 2, slotRect.top + 0.5)),
        Color.alphaBlend(ring, hairline),
        "the neighbour's hairline should sit under the ring",
      );

      // The ring's outer corner is rounded (the slot radius grown by the
      // ring width), so the corner of its bounding box stays unpainted.
      expectColor(
        pixel(
          Offset(
            slotRect.left - ringWidth + 0.5,
            slotRect.top - ringWidth + 0.5,
          ),
        ),
        white,
        'the ring should follow the rounded corner',
      );
    });

    testWidgets(
      'no-secondary-border variant leaves the ring to the decorator',
      (tester) async {
        await tester.pumpWidget(
          ShadApp(
            theme: ShadThemeData(disableSecondaryBorder: true),
            home: const Scaffold(body: strip),
          ),
        );
        await tester.pump();
        await tester.tap(find.byType(ShadInputOTPSlot).at(3));
        await tester.pump();

        // This variant focuses with an inner 2px border instead of an
        // outward ring, so the strip must not paint one: the slot's
        // decoration reaches the input with the secondary border still
        // enabled (the theme-wide flag is what disables it), and no custom
        // paint in the strip draws outside the focused slot.
        final input = tester.widget<ShadInput>(
          find.descendant(
            of: find.byType(ShadInputOTPSlot).at(3),
            matching: find.byType(ShadInput),
          ),
        );
        expect(input.decoration?.disableSecondaryBorder, isNot(true));
      },
    );
  });

  testWidgets('slots grow with the text scale', (tester) async {
    // A slot is a fixed box around one glyph, so it has to follow the text
    // scaler or the digit is clipped.
    Future<Size> slotSize(double scale) async {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: createTestWidget(
            const ShadInputOTP(
              maxLength: 2,
              children: [
                ShadInputOTPGroup(
                  children: [ShadInputOTPSlot(), ShadInputOTPSlot()],
                ),
              ],
            ),
          ),
        ),
      );
      return tester.getSize(find.byType(ShadInputOTPSlot).first);
    }

    final normal = await slotSize(1);
    final large = await slotSize(2);

    expect(large.width, normal.width * 2);
    expect(large.height, normal.height * 2);
  });
}
