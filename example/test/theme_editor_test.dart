import 'package:example/common/app_shell.dart';
import 'package:example/common/theme_editor/editor_config.dart';
import 'package:example/common/theme_editor/fonts.dart';
import 'package:example/common/theme_editor/preview_panel.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shad/shad.dart';

void main() {
  // google_fonts downloads faces on first use; there is no network in tests,
  // so turn that off. The API still resolves, it just falls back to the
  // default face for rendering.
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('ThemeEditorConfig', () {
    test('the default config builds a usable theme', () {
      final theme = const ThemeEditorConfig().build();
      expect(theme.brightness, Brightness.light);
      expect(theme.radius, BorderRadius.circular(8));
    });

    test('accent re-tints primary and ring but not the neutrals', () {
      const base = ThemeEditorConfig();
      final accented = base.copyWith(accentColor: AccentColor.blue);

      expect(
        accented.colorScheme.primary,
        ShadAccentScheme.blueLight.primary,
      );
      expect(
        accented.colorScheme.ring,
        ShadAccentScheme.blueLight.primary,
      );
      // Neutrals are untouched — that is the whole point of separating the
      // base palette from the accent.
      expect(accented.colorScheme.background, base.colorScheme.background);
      expect(accented.colorScheme.border, base.colorScheme.border);
      expect(accented.colorScheme.muted, base.colorScheme.muted);
    });

    test('"base" accent leaves the palette alone', () {
      const config = ThemeEditorConfig(accentColor: AccentColor.base);
      expect(
        config.colorScheme.primary,
        BaseColor.neutral.scheme(Brightness.light).primary,
      );
    });

    test('a custom radius overrides the preset', () {
      const config = ThemeEditorConfig(radius: RadiusPreset.large);
      expect(config.effectiveRadius, RadiusPreset.large.value);
      expect(config.copyWith(customRadius: 3).effectiveRadius, 3);
      expect(
        config
            .copyWith(customRadius: 3)
            .copyWith(clearCustomRadius: true)
            .effectiveRadius,
        RadiusPreset.large.value,
      );
    });

    test('the focus ring comes from the style, not from the editor', () {
      // shadcn has no ring knobs; the style owns it, and so does this editor.
      final lyra = const ThemeEditorConfig(style: StylePreset.lyra).build();
      final vega = const ThemeEditorConfig().build();

      expect(lyra.decoration.secondaryFocusedBorder!.top!.width, 1);
      expect(vega.decoration.secondaryFocusedBorder!.top!.width, 3);
      expect(vega.decoration.secondaryFocusedBorder!.top!.color!.a, .5);
    });

    test('a style changes the text sizes, not just the boxes', () {
      final vega = const ThemeEditorConfig().build();
      final lyra = const ThemeEditorConfig(style: StylePreset.lyra).build();
      final sera = const ThemeEditorConfig(style: StylePreset.sera).build();

      expect(vega.textTheme.small.fontSize, 14);
      expect(lyra.textTheme.small.fontSize, 12);
      expect(sera.textTheme.large.fontSize, 18);
      expect(sera.cardTheme.titleStyle!.fontWeight, FontWeight.w600);
      // The chosen font survives the style's typography.
      expect(lyra.textTheme.small.fontFamily, vega.textTheme.small.fontFamily);
    });

    test('every style builds, and carries its own radii and ring', () {
      for (final preset in StylePreset.values) {
        final theme = ThemeEditorConfig(style: preset).build();
        expect(theme.style, preset.tokens);
        expect(
          theme.decoration.secondaryFocusedBorder!.top!.width,
          preset.tokens.ringWidth,
        );
      }

      // Square styles really are square, all the way out to the card.
      final lyra = ThemeEditorConfig(style: StylePreset.lyra).build();
      expect(lyra.cardTheme.radius, BorderRadius.zero);
      // ...and a rounded one scales the card past the control radius.
      final vega = ThemeEditorConfig(style: StylePreset.vega).build();
      expect(
        vega.cardTheme.radius!.topLeft.x,
        greaterThan(vega.radius.topLeft.x),
      );
    });

    test('every base/accent/brightness combination builds', () {
      for (final brightness in Brightness.values) {
        for (final base in BaseColor.values) {
          for (final accent in AccentColor.values) {
            final theme = ThemeEditorConfig(
              brightness: brightness,
              baseColor: base,
              accentColor: accent,
            ).build();
            expect(theme.colorScheme, isNotNull);
          }
        }
      }
    });

    test('the generated snippet reflects the configuration', () {
      const config = ThemeEditorConfig(
        brightness: Brightness.dark,
        baseColor: BaseColor.zinc,
        accentColor: AccentColor.violet,
      );
      final snippet = config.toDartSnippet();

      expect(snippet, contains('Brightness.dark'));
      expect(snippet, contains('ShadZincColorScheme.dark()'));
      expect(snippet, contains('applyAccentScheme'));
      // The default style, mirroring shadcn's own `DEFAULT_CONFIG.style`.
      expect(snippet, contains('ShadStyleTokens.nova'));
    });

    test('the snippet omits applyAccent when the accent is the base', () {
      const config = ThemeEditorConfig();
      expect(config.toDartSnippet(), isNot(contains('applyAccentScheme')));
    });
  });

  /// The editor's own ShadTheme, not ShadApp's outer one.
  ///
  /// find.ancestor yields nearest-first, so the first match above the preview
  /// panel is the theme the editor is driving.
  ShadThemeData previewTheme(WidgetTester tester) => tester
      .widget<ShadTheme>(
        find
            .ancestor(
              of: find.byType(ThemePreviewPanel),
              matching: find.byType(ShadTheme),
            )
            .first,
      )
      .data;

  group('the customizer panel', () {
    /// Pumps the whole app and opens the editor.
    ///
    /// The app itself is what the panel edits now, so the test drives [App]
    /// rather than a page: that is the wiring under test.
    Future<void> pump(
      WidgetTester tester, {
      Size size = const Size(1600, 1400),
    }) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const App());
      await tester.pump();
      await tester.tap(find.byIcon(LucideIcons.paintbrush).first);
      // The theme animates across 200ms; the preview animates forever, so
      // pump fixed frames rather than settling.
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    /// Opens the picker labelled [label] and chooses [option].
    ///
    /// The value lives inside a popover, so it has to be opened first; the
    /// preview animates forever (spinner, skeletons) so fixed pumps are used
    /// throughout rather than pumpAndSettle.
    Future<void> choose(
      WidgetTester tester,
      String label,
      String option,
    ) async {
      await tester.tap(find.text(label));
      // ShadPopover wraps its content in an IgnorePointer while the entrance
      // animation runs, so the option is not tappable until it finishes.
      // pumpAndSettle is unusable here: the preview's spinner never settles.
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.tap(find.text(option).last);
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    testWidgets('shows every setting shadcn/ui exposes', (tester) async {
      await pump(tester);
      await tester.pump();

      for (final label in [
        'Style',
        'Base Color',
        'Theme',
        'Chart Color',
        'Heading',
        'Font',
        'Radius',
        'Menu',
        'Menu Accent',
      ]) {
        expect(find.text(label), findsOneWidget, reason: 'missing $label');
      }
      // The preview is a dashboard now, not a component gallery.
      expect(find.text('Contribution History'), findsOneWidget);
      expect(find.text('Palette'), findsOneWidget);
      expect(find.text('Typography'), findsOneWidget);
      expect(find.text('Text Scale'), findsOneWidget);
      // Light/dark and direction are app-wide toolbar switches, not settings
      // this panel duplicates.
      expect(find.text('Mode'), findsNothing);
      expect(find.text('Direction'), findsNothing);
      // Radius has a preset picker; the raw px sliders were noise next to it.
      expect(find.text('Spacing Unit'), findsNothing);
      expect(find.text('Corner Radius'), findsNothing);
      // One icon set ships, so the picker was a control with nothing to pick.
      expect(find.text('Icon Library'), findsNothing);
      // shadcn has no focus-ring knobs; neither do we.
      expect(find.text('Ring'), findsNothing);
      expect(find.text('Opacity'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the preview covers the selection controls', (tester) async {
      await pump(tester);
      await tester.pump();

      // A theme is judged on its controls, so the preview has to contain
      // them — checkboxes and radios were missing entirely.
      expect(find.byType(ShadCheckbox), findsWidgets);
      // The radio group is generic over a private enum, so match by name.
      expect(
        find.byWidgetPredicate(
          (w) => w.runtimeType.toString().startsWith('ShadRadio<'),
        ),
        findsWidgets,
      );
      expect(find.byType(ShadSwitch), findsWidgets);
      expect(find.byType(ShadInputOTP), findsWidgets);
      expect(find.byType(ShadProgress), findsWidgets);
      expect(find.byType(ShadSkeleton), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('every shadcn style is offered', (tester) async {
      await pump(tester);
      await tester.pump();

      await tester.tap(find.text('Style'));
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      for (final style in StylePreset.values) {
        expect(
          find.text(style.label),
          findsWidgets,
          reason: 'missing ${style.label}',
        );
      }
    });

    testWidgets('the preview follows the app-wide theme mode', (tester) async {
      await pump(tester);
      await tester.pump();
      expect(previewTheme(tester).brightness, Brightness.light);

      themeModeProvider.of(tester.element(find.byType(AppShell))).value =
          ThemeMode.dark;
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(previewTheme(tester).brightness, Brightness.dark);
      expect(tester.takeException(), isNull);
    });

    testWidgets('picking a theme applies the accent scheme', (tester) async {
      await pump(tester);
      await tester.pump();

      // Picked from near the top of the list: the popover scrolls, and an
      // option below the fold is found but not hit-testable.
      await choose(tester, 'Theme', 'Blue');

      expect(
        previewTheme(tester).colorScheme.primary,
        ShadAccentScheme.blueLight.primary,
      );
    });

    testWidgets('picking a base colour keeps the neutrals separate', (
      tester,
    ) async {
      await pump(tester);
      await tester.pump();

      await choose(tester, 'Base Color', 'Mist');

      expect(
        previewTheme(tester).colorScheme.background,
        const ShadMistColorScheme.light().background,
      );
    });

    testWidgets('chart colour is independent of the main accent', (
      tester,
    ) async {
      await pump(tester);
      await tester.pump();

      await choose(tester, 'Chart Color', 'Green');

      final scheme = previewTheme(tester).colorScheme;
      expect(scheme.chart1, ShadAccentScheme.greenLight.chart1);
      // The primary is untouched by the chart picker.
      expect(scheme.primary, isNot(ShadAccentScheme.greenLight.primary));
    });

    testWidgets('takes over a narrow viewport', (tester) async {
      await pump(tester, size: const Size(600, 1400));
      await tester.pump();

      expect(find.text('Style'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('re-themes the app around it, not just the playground', (
      tester,
    ) async {
      await pump(tester);
      await tester.pump();

      await choose(tester, 'Base Color', 'Mist');

      // The shell's own chrome is themed from the same configuration.
      final shellTheme = ShadTheme.of(tester.element(find.text('Playground')));
      expect(
        shellTheme.colorScheme.background,
        const ShadMistColorScheme.light().background,
      );
    });
  });

  group('menu settings', () {
    // Contrast is judged against what is actually painted: a translucent
    // surface or highlight is composited before its luminance is read.
    Color composite(Color over, Color base) => Color.alphaBlend(over, base);

    test('inverted menus take the whole dark palette in light mode', () {
      // shadcn implements "Inverted" by giving menu surfaces the `dark`
      // class — every token flips, not just the surface and text.
      const config = ThemeEditorConfig(menuColor: MenuSurfaceColor.inverted);
      final theme = config.build();
      final dark = const ThemeEditorConfig(
        brightness: Brightness.dark,
      ).build();

      expect(
        theme.contextMenuTheme.decoration!.color,
        dark.colorScheme.popover,
      );
      expect(
        theme.contextMenuTheme.textStyle!.color,
        dark.colorScheme.popoverForeground,
      );
      expect(
        theme.optionTheme.textStyle!.color,
        dark.colorScheme.popoverForeground,
      );
      // The row highlight is the dark accent pair, icons included.
      expect(
        theme.optionTheme.hoveredBackgroundColor,
        dark.colorScheme.accent,
      );
      // The page's own popover is untouched: plain popovers do not invert.
      expect(theme.popoverTheme.decoration!.color, theme.colorScheme.popover);
    });

    test('inverted is a no-op in dark mode, as in the reference', () {
      // The reference toggles the `dark` class on menu surfaces; when the
      // page is already dark that changes nothing.
      const config = ThemeEditorConfig(
        brightness: Brightness.dark,
        menuColor: MenuSurfaceColor.inverted,
      );
      final theme = config.build();
      expect(
        theme.contextMenuTheme.decoration!.color,
        theme.colorScheme.popover,
      );
    });

    test('translucent lowers the menu surface, not the page popover', () {
      const config = ThemeEditorConfig(
        menuFinish: MenuSurfaceFinish.translucent,
      );
      final theme = config.build();
      // `bg-popover/70` behind a backdrop blur…
      expect(theme.contextMenuTheme.decoration!.color!.a, closeTo(.7, .01));
      expect(theme.selectTheme.popoverDecoration!.color!.a, closeTo(.7, .01));
      expect(theme.contextMenuTheme.filter, isNotNull);
      expect(theme.selectTheme.filter, isNotNull);
      // …with row highlights as a foreground wash so they read through.
      expect(theme.optionTheme.hoveredBackgroundColor!.a, lessThan(.2));
      // The page palette itself stays opaque.
      expect(theme.colorScheme.popover.a, 1);
    });

    test('bold points the accent pair at the primary pair', () {
      // The reference writes `accent = primary` into the generated theme, so
      // it is a scheme transformation, and menus pick it up through their
      // normal accent highlight.
      const config = ThemeEditorConfig(menuAccent: MenuAccent.bold);
      final theme = config.build();

      expect(theme.colorScheme.accent, theme.colorScheme.primary);
      expect(
        theme.colorScheme.accentForeground,
        theme.colorScheme.primaryForeground,
      );
      expect(
        theme.optionTheme.hoveredBackgroundColor,
        theme.colorScheme.primary,
      );
      expect(
        theme.optionTheme.selectedTextStyle!.color,
        theme.colorScheme.primaryForeground,
      );
      expect(
        theme.optionTheme.textStyle!.color,
        theme.colorScheme.popoverForeground,
      );
    });

    test('every mode reads correctly in both brightnesses', () {
      // Walks the whole matrix — brightness x surface x finish x accent — and
      // checks the states a menu row can be in. Guessing at one combination
      // is what kept breaking the others.
      for (final brightness in Brightness.values) {
        for (final color in MenuSurfaceColor.values) {
          for (final finish in MenuSurfaceFinish.values) {
            for (final accent in MenuAccent.values) {
              final config = ThemeEditorConfig(
                brightness: brightness,
                menuColor: color,
                menuFinish: finish,
                menuAccent: accent,
              );
              final theme = config.build();
              final where = '$brightness/$color/$finish/$accent';

              final surface = composite(
                theme.contextMenuTheme.decoration!.color!,
                theme.colorScheme.background,
              );

              double contrast(Color a, Color b) =>
                  (a.computeLuminance() - b.computeLuminance()).abs();

              // Resting row.
              expect(
                contrast(theme.optionTheme.textStyle!.color!, surface),
                greaterThan(.2),
                reason: 'resting row unreadable: $where',
              );
              // Hovered row: the option and the context menu use the same
              // pair, so a menu cannot change colour halfway down.
              final highlight = theme.optionTheme.hoveredBackgroundColor!;
              expect(
                theme.contextMenuTheme.selectedBackgroundColor,
                highlight,
                reason: 'context menu != select: $where',
              );
              final paintedHighlight = composite(highlight, surface);
              expect(
                contrast(
                  theme.optionTheme.selectedTextStyle!.color!,
                  paintedHighlight,
                ),
                greaterThan(.2),
                reason: 'highlighted row unreadable: $where',
              );
              expect(
                contrast(
                  theme.contextMenuTheme.selectedTextStyle!.color!,
                  paintedHighlight,
                ),
                greaterThan(.2),
                reason: 'highlighted menu item unreadable: $where',
              );
              // And the highlight is distinguishable from the surface. The
              // reference's dark accent really is a near-black on near-black
              // wash, so the bar here is visibility, not drama.
              expect(
                contrast(paintedHighlight, surface),
                greaterThan(.005),
                reason: 'highlight invisible: $where',
              );
            }
          }
        }
      }
    });
  });

  group('fonts', () {
    test('every shadcn font is offered', () {
      expect(EditorFont.all.length, greaterThanOrEqualTo(26));
      expect(EditorFont.all.map((f) => f.title), contains('Inter'));
      expect(EditorFont.all.map((f) => f.title), contains('Playfair Display'));
    });

    test('bundled fonts use the asset family, Google fonts use a builder', () {
      // Inter is the package default and is bundled alongside the two Geist
      // faces; the rest come from Google Fonts.
      expect(EditorFont.byTitle('Inter').bundled, isTrue);
      expect(EditorFont.byTitle('Geist').bundled, isTrue);
      expect(EditorFont.byTitle('Roboto').bundled, isFalse);
      // Both kinds must yield a usable text theme.
      expect(EditorFont.byTitle('Inter').textTheme().family, isNotEmpty);
      expect(
        EditorFont.byTitle('Roboto').textTheme().googleFontBuilder,
        isNotNull,
      );
    });

    test('the heading font overrides only h1..h4', () {
      const config = ThemeEditorConfig(
        fontTitle: 'Geist',
        headingFontTitle: 'Playfair Display',
      );
      final text = config.textTheme;
      // Headings take the heading face...
      expect(text.h1.fontFamily, isNot(text.p.fontFamily));
      // ...body styles keep the body face.
      expect(text.p.fontFamily, contains('Geist'));
      expect(text.small.fontFamily, contains('Geist'));
    });

    test('"same as body" leaves the text theme alone', () {
      const config = ThemeEditorConfig(fontTitle: 'Geist');
      expect(config.textTheme.h1.fontFamily, config.textTheme.p.fontFamily);
    });

    test('picking a font changes the theme text', () {
      const inter = ThemeEditorConfig();
      const geist = ThemeEditorConfig(fontTitle: 'Geist');
      expect(inter.textTheme.family, isNot(geist.textTheme.family));
    });
  });
}
