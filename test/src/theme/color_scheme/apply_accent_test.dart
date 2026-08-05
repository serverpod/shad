import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  const base = ShadZincColorScheme.light();
  const accent = Color(0xff3b82f6);

  group('ShadColorScheme.applyAccent', () {
    test('re-tints primary, ring and selection', () {
      final result = base.applyAccent(accent);

      expect(result.primary, accent);
      expect(result.ring, accent);
      expect(result.selection.r, accent.r);
    });

    test('leaves the neutral palette untouched', () {
      final result = base.applyAccent(accent);

      expect(result.background, base.background);
      expect(result.foreground, base.foreground);
      expect(result.card, base.card);
      expect(result.border, base.border);
      expect(result.input, base.input);
      expect(result.muted, base.muted);
      expect(result.mutedForeground, base.mutedForeground);
      expect(result.destructive, base.destructive);
    });

    test('derives a readable foreground from luminance', () {
      // A dark accent needs light text...
      expect(
        base.applyAccent(const Color(0xff1e1b4b)).primaryForeground,
        const Color(0xfffafafa),
      );
      // ...and a bright one needs dark text. A naive channel average would
      // get yellow wrong, which is why luminance is used.
      expect(
        base.applyAccent(const Color(0xfffacc15)).primaryForeground,
        const Color(0xff09090b),
      );
    });

    test('an explicit foreground wins over the derived one', () {
      final result = base.applyAccent(
        accent,
        accentForeground: const Color(0xff00ff00),
      );
      expect(result.primaryForeground, const Color(0xff00ff00));
    });

    test('selection tinting can be turned off', () {
      final result = base.applyAccent(accent, tintSelection: false);
      expect(result.selection, base.selection);
    });

    test('the result is still a value type', () {
      expect(base.applyAccent(accent), base.applyAccent(accent));
      expect(
        base.applyAccent(accent).hashCode,
        base.applyAccent(accent).hashCode,
      );
    });
  });
}
