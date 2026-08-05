import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shad/src/app.dart';
import 'package:shad/src/components/input_otp.dart';

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
