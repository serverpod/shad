import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  group('ShadRadii', () {
    // shadcn/ui's scale at the default --radius: sm 6, md 8, lg 10, xl 14,
    // 2xl 16, 4xl 32. Pinning the numbers is the only way this stays honest.
    const radii = ShadRadii(BorderRadius.all(Radius.circular(8)));

    test('reproduces the shadcn scale from the md step', () {
      expect(radii.none, BorderRadius.zero);
      expect(radii.sm.topLeft.x, 6);
      expect(radii.md.topLeft.x, 8);
      expect(radii.lg.topLeft.x, 10);
      expect(radii.xl.topLeft.x, 14);
      expect(radii.xl2.topLeft.x, 16);
      expect(radii.xl4.topLeft.x, 32);
      expect(radii.full.topLeft.x, greaterThan(1000));
    });

    test('resolve covers every token', () {
      for (final token in ShadRadiusToken.values) {
        expect(radii.resolve(token), isA<BorderRadius>());
      }
      expect(radii.resolve(ShadRadiusToken.lg), radii.lg);
    });

    test('a zero base radius stays square at every step', () {
      const square = ShadRadii(BorderRadius.zero);
      for (final token in ShadRadiusToken.values) {
        if (token == ShadRadiusToken.full) continue;
        expect(square.resolve(token), BorderRadius.zero, reason: '$token');
      }
    });

    test('scales each corner independently', () {
      const lopsided = ShadRadii(
        BorderRadius.only(
          topLeft: Radius.circular(4),
          bottomRight: Radius.circular(8),
        ),
      );
      expect(lopsided.xl2.topLeft.x, 8);
      expect(lopsided.xl2.bottomRight.x, 16);
      expect(lopsided.xl2.topRight, Radius.zero);
    });

    test('equality is by the base radius', () {
      expect(
        const ShadRadii(BorderRadius.all(Radius.circular(8))),
        const ShadRadii(BorderRadius.all(Radius.circular(8))),
      );
      expect(
        const ShadRadii(BorderRadius.all(Radius.circular(8))).hashCode,
        const ShadRadii(BorderRadius.all(Radius.circular(8))).hashCode,
      );
      expect(
        const ShadRadii(BorderRadius.all(Radius.circular(8))),
        isNot(const ShadRadii(BorderRadius.all(Radius.circular(9)))),
      );
    });
  });

  group('ShadStyleTokens', () {
    test('ships all eight shadcn styles, uniquely named', () {
      expect(ShadStyleTokens.all, hasLength(8));
      expect(
        ShadStyleTokens.all.map((s) => s.name).toSet(),
        hasLength(8),
      );
      for (final style in ShadStyleTokens.all) {
        expect(ShadStyleTokens.fromName(style.name), style);
      }
    });

    test('fromName rejects an unknown name', () {
      expect(() => ShadStyleTokens.fromName('nope'), throwsArgumentError);
    });

    test('the square styles are square everywhere', () {
      for (final style in [ShadStyleTokens.lyra, ShadStyleTokens.sera]) {
        expect(style.buttonRadius, ShadRadiusToken.none, reason: style.name);
        expect(style.cardRadius, ShadRadiusToken.none, reason: style.name);
        expect(style.dialogRadius, ShadRadiusToken.none, reason: style.name);
        expect(style.popoverRadius, ShadRadiusToken.none, reason: style.name);
        expect(style.itemRadius, ShadRadiusToken.none, reason: style.name);
      }
    });

    test('sera upper-cases and letter-spaces its labels', () {
      expect(ShadStyleTokens.sera.label.applyCase('Save'), 'SAVE');
      expect(ShadStyleTokens.vega.label.applyCase('Save'), 'Save');

      const base = TextStyle(fontSize: 14);
      final applied = ShadStyleTokens.sera.label.apply(base);
      expect(applied.fontSize, 12);
      expect(applied.fontWeight, FontWeight.w600);
      expect(applied.letterSpacing, 1.2);
    });

    test('a role keeps the colour and family it is applied to', () {
      const base = TextStyle(
        fontSize: 14,
        color: Color(0xFF00FF00),
        fontFamily: 'Geist',
      );
      final applied = ShadStyleTokens.lyra.body.apply(base);
      expect(applied.fontSize, 12);
      expect(applied.color, const Color(0xFF00FF00));
      expect(applied.fontFamily, 'Geist');
    });

    test('roles size text per style', () {
      // The observation this models: the styles resize text, they do not just
      // reshape boxes.
      expect(ShadStyleTokens.vega.body.fontSize, 14); // text-sm
      expect(ShadStyleTokens.lyra.body.fontSize, 12); // text-xs
      expect(ShadStyleTokens.mira.body.height, 1.625); // text-xs/relaxed
      expect(ShadStyleTokens.vega.title.fontSize, 16); // text-base
      expect(ShadStyleTokens.sera.title.fontSize, 18); // text-lg
      expect(ShadStyleTokens.lyra.title.fontSize, 14); // text-sm
      expect(ShadStyleTokens.sera.caption.fontSize, 10);
      expect(ShadStyleTokens.nova.title.height, 1.375); // leading-snug
    });

    test('line height defaults follow Tailwind', () {
      expect(ShadTextRole.defaultHeightFor(12), 16 / 12);
      expect(ShadTextRole.defaultHeightFor(14), 20 / 14);
      expect(ShadTextRole.defaultHeightFor(16), 24 / 16);
      expect(ShadTextRole.defaultHeightFor(18), 28 / 18);
    });

    test('the style retypes the theme text, not just the components', () {
      // The bug this pins: `ShadThemeData.textTheme` was taken straight from
      // the merged input, bypassing the variant, so a style change left every
      // font size alone and app code reading `theme.textTheme.small` never
      // moved.
      final vega = ShadThemeData(style: ShadStyleTokens.vega);
      final lyra = ShadThemeData(style: ShadStyleTokens.lyra);
      final sera = ShadThemeData(style: ShadStyleTokens.sera);

      expect(vega.textTheme.small.fontSize, 14);
      expect(lyra.textTheme.small.fontSize, 12);
      expect(lyra.textTheme.muted.fontSize, 12);
      expect(sera.textTheme.large.fontSize, 18);
      // Prose headings are the typography scale and stay put.
      expect(lyra.textTheme.h4.fontSize, vega.textTheme.h4.fontSize);
    });

    test('a textarea keeps a moderate radius in the round styles', () {
      // maia has rounded-4xl buttons but a rounded-xl textarea: a 32px radius
      // on a tall box eats into the text.
      final maia = ShadThemeData(style: ShadStyleTokens.maia);
      final buttonRadius =
          (maia.primaryButtonTheme.decoration!.border!.radius! as BorderRadius)
              .topLeft
              .x;
      final textareaRadius =
          (maia.textareaTheme.decoration!.border!.radius! as BorderRadius)
              .topLeft
              .x;

      expect(buttonRadius, 32);
      expect(textareaRadius, 14);
      expect(textareaRadius, lessThan(buttonRadius));
    });

    test(
      'OTP slots round only the ends of the strip, at the control radius',
      () {
        final maia = ShadThemeData(style: ShadStyleTokens.maia);

        expect(maia.inputOTPTheme.middleRadius, BorderRadius.zero);
        expect(maia.inputOTPTheme.firstRadius!.topLeft.x, 32);
        expect(maia.inputOTPTheme.firstRadius!.topRight.x, 0);
        expect(maia.inputOTPTheme.lastRadius!.topRight.x, 32);
        // A slot is the size of a control.
        expect(
          maia.inputOTPTheme.height,
          maia.buttonSizesTheme.regular!.height,
        );
      },
    );

    test('every field ring is concentric with its own shape', () {
      // The ring used to be built once from the control radius, so a textarea
      // — which has a radius of its own — was ringed in the wrong shape.
      final maia = ShadThemeData(style: ShadStyleTokens.maia);

      final controlRing =
          maia.decoration.secondaryFocusedBorder!.radius! as BorderRadius;
      final textareaRing =
          maia.textareaTheme.decoration!.secondaryFocusedBorder!.radius!
              as BorderRadius;

      // Element radius plus ring width, in both cases.
      expect(controlRing.topLeft.x, 32 + maia.style.ringWidth);
      expect(textareaRing.topLeft.x, 14 + maia.style.ringWidth);
    });

    test('OTP slots ring like any other field', () {
      final vega = ShadThemeData(style: ShadStyleTokens.vega);
      final ring = vega.inputOTPTheme.decoration!.secondaryFocusedBorder!.top!;

      expect(ring.width, vega.style.ringWidth);
      expect(ring.color!.a, closeTo(vega.style.ringOpacity, .001));
      // The focused border itself is a hairline in the ring colour, not the
      // opaque 2px box it used to draw.
      expect(vega.inputOTPTheme.decoration!.focusedBorder!.top!.width, 1);
    });

    test('a textarea reads its own theme, not the input theme', () {
      // ShadTextarea resolved padding, alignment and gap from `inputTheme`,
      // which made every textarea-specific value in `textareaTheme` dead —
      // a multi-line field was padded like a single-line one.
      final theme = ShadThemeData();

      expect(
        theme.textareaTheme.padding,
        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      );
      expect(
        theme.inputTheme.padding,
        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      );
    });

    test('a single-line field centres its text in its fixed height', () {
      final theme = ShadThemeData();

      expect(theme.inputTheme.constraints!.minHeight, 36);
      expect(theme.inputTheme.alignment, AlignmentDirectional.centerStart);
      expect(
        theme.inputTheme.placeholderAlignment,
        AlignmentDirectional.centerStart,
      );
    });

    test('checkbox and radio share their unchecked look', () {
      for (final brightness in Brightness.values) {
        final theme = ShadThemeData(brightness: brightness);
        final fill = theme.checkboxTheme.uncheckedColor;

        expect(fill, theme.radioTheme.decoration!.color, reason: '$brightness');
        expect(
          theme.checkboxTheme.decoration!.border!.top!.color,
          theme.colorScheme.input,
        );
        expect(
          theme.radioTheme.decoration!.border!.top!.color,
          theme.colorScheme.input,
        );
      }
    });

    test('overlays are light and blurred, as shadcn draws them', () {
      final theme = ShadThemeData();

      // `bg-black/10` — light enough that the palette behind stays visible,
      // which only works because the barrier is also blurred.
      expect(theme.primaryDialogTheme.barrierColor, const Color(0x1a000000));
      expect(theme.primaryDialogTheme.barrierBlurSigma, 2);
      expect(theme.alertDialogTheme.barrierColor, const Color(0x1a000000));
    });

    test('tabs are as wide as their labels, not the bar', () {
      // shadcn's TabsList is `w-fit`; ours stretched every tab across the
      // whole bar, which read as enormous padding inside it.
      final theme = ShadThemeData();
      expect(theme.tabsTheme.expandTabs ?? false, isFalse);
      expect(theme.tabsTheme.padding, const EdgeInsets.all(3)); // p-[3px]
      expect(
        theme.tabsTheme.tabPadding,
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // px-2 py-1
      );
    });

    test('dark borders are translucent overlays, as shadcn defines them', () {
      // shadcn v4 sets `--border: oklch(1 0 0 / 10%)` and `--input: 15%` in
      // dark mode, so a hairline lightens whatever it sits on. Ours were
      // opaque greys, which vanished on a card of the same value — that is why
      // a checkbox was hard to make out.
      const dark = ShadNeutralColorScheme.dark();
      expect(dark.border, const Color(0x1affffff));
      expect(dark.input, const Color(0x26ffffff));
      // And the dark card is a step lighter than the page, per v4.
      expect(dark.card, isNot(dark.background));

      const light = ShadNeutralColorScheme.light();
      expect(light.border, const Color(0xffe5e5e5)); // oklch(0.922 0 0)
      expect(light.input, const Color(0xffe5e5e5));
    });

    test('fields outline with --input, surfaces with a foreground wash', () {
      final theme = ShadThemeData();

      expect(
        theme.inputTheme.decoration!.border!.top!.color,
        theme.colorScheme.input,
      );
      expect(
        theme.checkboxTheme.decoration!.border!.top!.color,
        theme.colorScheme.input,
      );
      // `ring-foreground/10` rather than the border token.
      expect(
        theme.cardTheme.border!.top!.color,
        theme.colorScheme.foreground.withValues(alpha: .1),
      );
    });

    test('sera underlines its fields instead of boxing them', () {
      final sera = ShadThemeData(style: ShadStyleTokens.sera);
      final vega = ShadThemeData(style: ShadStyleTokens.vega);

      final seraBorder = sera.inputTheme.decoration!.border!;
      expect(seraBorder.bottom, isNotNull);
      expect(seraBorder.top, isNull);
      expect(seraBorder.radius, BorderRadius.zero);

      expect(vega.inputTheme.decoration!.border!.top, isNotNull);
    });

    test('shadows differ per style', () {
      expect(ShadStyleTokens.vega.cardShadow, Shadows.xs);
      expect(ShadStyleTokens.nova.cardShadow, Shadows.none);
      expect(ShadStyleTokens.luma.cardShadow, Shadows.md);
      expect(ShadStyleTokens.maia.popoverShadow, Shadows.xl2);
      expect(ShadStyleTokens.rhea.dialogShadow, Shadows.xl);
    });

    test('copyWith and equality', () {
      final tuned = ShadStyleTokens.vega.copyWith(ringWidth: 1);
      expect(tuned.ringWidth, 1);
      expect(tuned.ringOpacity, ShadStyleTokens.vega.ringOpacity);
      expect(tuned, isNot(ShadStyleTokens.vega));
      expect(
        ShadStyleTokens.vega.copyWith(),
        ShadStyleTokens.vega,
      );
      expect(
        ShadStyleTokens.vega.copyWith().hashCode,
        ShadStyleTokens.vega.hashCode,
      );
    });
  });

  group('ShadSpacing', () {
    const spacing = ShadSpacing();

    test("one step is Tailwind's 0.25rem", () {
      expect(spacing.step, 4);
      expect(spacing(6), 24);
      expect(spacing(1.5), 6);
      expect(spacing.xs, 4);
      expect(spacing.lg, 24);
    });

    test('builds insets in steps', () {
      expect(spacing.all(6), const EdgeInsets.all(24));
      expect(
        spacing.symmetric(horizontal: 4, vertical: 2),
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      );
      expect(spacing.only(top: 2), const EdgeInsets.only(top: 8));
      expect(
        spacing.directional(start: 2),
        const EdgeInsetsDirectional.only(start: 8),
      );
    });

    test('a different step rescales everything', () {
      const tight = ShadSpacing(step: 2);
      expect(tight(6), 12);
      expect(tight.all(6), const EdgeInsets.all(12));
    });

    test('lerp, copyWith and equality', () {
      expect(
        ShadSpacing.lerp(const ShadSpacing(), const ShadSpacing(step: 8), .5),
        const ShadSpacing(step: 6),
      );
      expect(const ShadSpacing().copyWith(step: 8), const ShadSpacing(step: 8));
      // Built at runtime so the analyzer doesn't fold it into the default.
      final explicit = ShadSpacing(step: [4.0].first);
      expect(const ShadSpacing(), explicit);
      expect(const ShadSpacing().hashCode, explicit.hashCode);
    });
  });

  group('ShadThemeData style and spacing', () {
    test('the card radius follows the theme radius', () {
      // The bug this pins: ShadCardTheme.radius was hardcoded to 8, so setting
      // a radius moved buttons and inputs but left cards alone.
      final small = ShadThemeData(
        radius: const BorderRadius.all(Radius.circular(4)),
      );
      final large = ShadThemeData(
        radius: const BorderRadius.all(Radius.circular(16)),
      );

      expect(small.cardTheme.radius!.topLeft.x, 7); // 4 * 1.75
      expect(large.cardTheme.radius!.topLeft.x, 28); // 16 * 1.75
      expect(
        large.cardTheme.radius!.topLeft.x,
        greaterThan(large.radius.topLeft.x),
      );
    });

    test('a style reshapes every radius at once', () {
      final lyra = ShadThemeData(style: ShadStyleTokens.lyra);
      expect(lyra.cardTheme.radius, BorderRadius.zero);
      expect(lyra.primaryDialogTheme.radius, BorderRadius.zero);
      expect(
        lyra.primaryButtonTheme.decoration!.border!.radius,
        BorderRadius.zero,
      );

      final luma = ShadThemeData(style: ShadStyleTokens.luma);
      expect(luma.cardTheme.radius!.topLeft.x, greaterThan(8));
    });

    test('button labels follow the style typography', () {
      final vega = ShadThemeData(style: ShadStyleTokens.vega);
      final sera = ShadThemeData(style: ShadStyleTokens.sera);

      expect(
        vega.primaryButtonTheme.textStyle!.fontSize,
        vega.textTheme.small.fontSize,
      );
      expect(sera.primaryButtonTheme.textStyle!.fontSize, 12);
      expect(sera.primaryButtonTheme.textStyle!.fontWeight, FontWeight.w600);
      expect(sera.primaryButtonTheme.textStyle!.letterSpacing, 1.2);
      // Every variant gets it, not just the primary one.
      expect(sera.ghostButtonTheme.textStyle!.letterSpacing, 1.2);
    });

    test("each style carries shadcn's own metrics", () {
      // Spot-checks against `registry/styles/style-*.css`, converting
      // Tailwind's scale at 4px per unit. These are the numbers that make the
      // styles visibly different sizes rather than just different radii.
      expect(ShadStyleTokens.vega.buttonHeight, 36); // h-9
      expect(ShadStyleTokens.mira.buttonHeight, 28); // h-7
      expect(ShadStyleTokens.sera.buttonHeight, 40); // h-10
      expect(ShadStyleTokens.sera.buttonPaddingX, 24); // px-6
      expect(ShadStyleTokens.mira.buttonPaddingX, 8); // px-2
      expect(ShadStyleTokens.maia.sliderTrackHeight, 12); // h-3
      expect(ShadStyleTokens.sera.sliderTrackHeight, 2); // h-0.5
      expect(ShadStyleTokens.luma.switchWidth, 44); // w-11
      expect(ShadStyleTokens.sera.cardPadding, 32); // --card-spacing: 8
      expect(ShadStyleTokens.nova.cardPadding, 16); // --card-spacing: 4
    });

    test('the metrics reach the component themes', () {
      final mira = ShadThemeData(style: ShadStyleTokens.mira);
      final sera = ShadThemeData(style: ShadStyleTokens.sera);

      expect(mira.buttonSizesTheme.regular!.height, 28);
      expect(sera.buttonSizesTheme.regular!.height, 40);
      expect(
        sera.buttonSizesTheme.regular!.padding,
        const EdgeInsets.symmetric(horizontal: 24),
      );
      expect(mira.cardTheme.padding, const EdgeInsets.all(16));
      expect(sera.cardTheme.padding, const EdgeInsets.all(32));
      expect(mira.sliderTheme.trackHeight, 4);
      expect(mira.sliderTheme.thumbRadius, 6);
      expect(mira.switchTheme.width, 28);
      expect(mira.progressTheme.minHeight, 4);
      expect(
        sera.optionTheme.padding,
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      );
      // The switch thumb is what is left after the inset on both sides.
      expect(
        sera.switchTheme.height! - sera.switchTheme.margin! * 2,
        ShadStyleTokens.sera.switchThumbSize,
      );
    });

    test('the focus ring follows the style', () {
      final lyra = ShadThemeData(style: ShadStyleTokens.lyra);
      final vega = ShadThemeData(style: ShadStyleTokens.vega);

      expect(lyra.decoration.secondaryFocusedBorder!.top!.width, 1);
      expect(vega.decoration.secondaryFocusedBorder!.top!.width, 3);
      // offset == width is what removes the gap between element and ring.
      expect(vega.decoration.secondaryFocusedBorder!.offset, 3);
    });

    test('spacing drives component padding', () {
      final normal = ShadThemeData();
      final tight = ShadThemeData(spacing: const ShadSpacing(step: 2));

      expect(normal.cardTheme.padding, const EdgeInsets.all(24));
      expect(tight.cardTheme.padding, const EdgeInsets.all(12));
      expect(tight.spacing(6), 12);

      // A style's metrics are stored in the pixels they render at the default
      // step, and rescale with it — exactly as Tailwind's `h-9` follows
      // `--spacing`. Its bracketed literals do not.
      expect(tight.buttonSizesTheme.regular!.height, 18);
      expect(tight.switchTheme.width, ShadStyleTokens.vega.switchWidth);
    });

    test('style and spacing survive copyWith', () {
      final theme = ShadThemeData(
        style: ShadStyleTokens.rhea,
        spacing: const ShadSpacing(step: 5),
      );
      final copy = theme.copyWith(disabledOpacity: .3);

      expect(copy.style, ShadStyleTokens.rhea);
      expect(copy.spacing, const ShadSpacing(step: 5));
      expect(copy.cardTheme.radius, theme.cardTheme.radius);
    });

    test('an explicit radius rebuilds a supplied variant', () {
      // A variant bakes the radius into its component themes, so a theme built
      // with both has to push the radius back into the variant — otherwise the
      // theme's `radius` says one thing and every component renders another.
      //
      // Note this is about construction. `copyWith` forwards the already
      // resolved component themes, so it cannot re-derive them; changing the
      // radius of an existing theme means rebuilding it.
      final variant = ShadDefaultThemeVariant(
        colorScheme: const ShadSlateColorScheme.light(),
        radius: const BorderRadius.all(Radius.circular(4)),
        effectiveTextTheme: ShadDefaultThemeVariant.defaultTextTheme,
        style: ShadStyleTokens.rhea,
      );
      final theme = ShadThemeData(
        variant: variant,
        radius: const BorderRadius.all(Radius.circular(16)),
      );

      expect(theme.radius.topLeft.x, 16);
      expect(theme.variant.radius.topLeft.x, 16);
      // rhea cards are `rounded-[min(var(--radius-4xl),24px)]`: the 4xl step
      // (64 at an md of 16) hits the 24px cap.
      expect(theme.cardTheme.radius!.topLeft.x, 24);
      // Rebuilding keeps everything the caller did not override.
      expect(theme.style, ShadStyleTokens.rhea);
    });

    test('a variant supplies the radius when none is given', () {
      final variant = ShadDefaultThemeVariant(
        colorScheme: const ShadSlateColorScheme.light(),
        radius: const BorderRadius.all(Radius.circular(6)),
        effectiveTextTheme: ShadDefaultThemeVariant.defaultTextTheme,
      );
      final theme = ShadThemeData(variant: variant);

      expect(theme.variant, same(variant));
      // The theme's own radius agrees with the variant rather than defaulting
      // to 8 behind its back.
      expect(theme.radius.topLeft.x, 6);
    });
  });
}
