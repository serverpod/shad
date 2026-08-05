import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/src/app.dart';
import 'package:shad/src/components/input.dart';
import 'package:shad/src/components/input_otp.dart';
import 'package:shad/src/theme/data.dart';
import 'package:shad/src/theme/style.dart';

void main() {
  // Switching styles animates every component theme through
  // `ShadAnimatedTheme`. Mid-flight a boxed field's border lerps towards an
  // underlined (`sera`) or borderless (`maia`) one: three sides fade out
  // while the bottom crosses to another colour, so the sides momentarily
  // disagree — which `Border.paint` refuses to combine with a border radius.
  // `ShadBoxBorder` exists to paint exactly that state; this walks every
  // style pair to pin it.
  testWidgets('fields survive animated transitions between all styles', (
    tester,
  ) async {
    Widget app(ShadStyleTokens style) => ShadApp(
      theme: ShadThemeData(style: style),
      home: const Scaffold(
        body: Column(
          children: [
            ShadInput(),
            ShadInputOTP(
              maxLength: 2,
              children: [
                ShadInputOTPGroup(
                  children: [ShadInputOTPSlot(), ShadInputOTPSlot()],
                ),
              ],
            ),
          ],
        ),
      ),
    );

    for (final from in ShadStyleTokens.all) {
      for (final to in ShadStyleTokens.all) {
        if (identical(from, to)) continue;
        await tester.pumpWidget(app(from));
        await tester.pumpAndSettle();
        await tester.pumpWidget(app(to));
        // Paint a handful of frames across the 200ms theme lerp.
        for (var i = 0; i < 4; i++) {
          await tester.pump(const Duration(milliseconds: 50));
          expect(
            tester.takeException(),
            isNull,
            reason: 'painting ${from.name} → ${to.name} at ${(i + 1) * 50}ms',
          );
        }
      }
    }
  });
}
