import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

/// Every outward shadow has to go through [ShadShadowDecoration] so it is
/// clipped to the element it belongs to. A shadow left on a plain
/// [BoxDecoration] paints behind the whole box — a grey wash under anything
/// translucent — and one wearing [BlurStyle.outer] instead is cut out along its
/// own displaced rectangle, which leaves a hard-edged gap beside the element.
///
/// The styles disagree about which surfaces are shadowed at all — nova shadows
/// only its popovers, sera nearly everything — so this walks all eight rather
/// than trusting the default.
///
/// See `lib/src/utils/shadow.dart`.
void main() {
  final surfaces = <Widget>[
    const ShadCard(title: Text('Card'), child: Text('Body')),
    const ShadInput(placeholder: Text('Input')),
    const ShadTextarea(placeholder: Text('Textarea')),
    ShadButton(onPressed: () {}, child: const Text('Button')),
    ShadButton.outline(onPressed: () {}, child: const Text('Button')),
    ShadCheckbox(value: true, onChanged: (_) {}),
    ShadSwitch(value: true, onChanged: (_) {}),
    const ShadSlider(initialValue: 50, max: 100),
    ShadSelect<String>(
      options: const [ShadOption(value: 'a', child: Text('A'))],
      selectedOptionBuilder: (context, value) => Text(value),
      placeholder: const Text('Select'),
    ),
    const ShadTabs<String>(
      value: 'a',
      tabs: [ShadTab(value: 'a', child: Text('A'))],
    ),
    const ShadMenubar(
      items: [ShadMenubarItem(items: [], child: Text('File'))],
    ),
    const ShadToast(title: Text('Toast')),
    const ShadDialog(title: Text('Dialog'), child: Text('Body')),
    const ShadBadge(child: Text('Badge')),
    const ShadProgress(value: 0.5),
  ];

  for (final style in ShadStyleTokens.all) {
    testWidgets('${style.name} paints no shadow on a raw BoxDecoration', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ShadApp(
          theme: ShadThemeData(
            colorScheme: const ShadSlateColorScheme.light(),
            style: style,
          ),
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [for (final surface in surfaces) surface],
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      final offenders = <String>{};
      // `tester.allWidgets`, not `find.byType(Widget)` — byType matches the
      // exact runtime type, so it finds nothing at all for Widget itself.
      for (final widget in tester.allWidgets) {
        final decoration = switch (widget) {
          Container(:final decoration) => decoration,
          DecoratedBox(:final decoration) => decoration,
          AnimatedContainer(:final decoration) => decoration,
          _ => null,
        };
        if (decoration case BoxDecoration(
          boxShadow: final shadows?,
        ) when shadows.isNotEmpty) {
          offenders.add('${widget.runtimeType}: $shadows');
        }
      }

      expect(
        offenders,
        isEmpty,
        reason: 'wrap these in ShadShadowDecoration:\n${offenders.join('\n')}',
      );
    });
  }
}
