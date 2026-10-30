import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

void main() {
  test('toggle and badge icon sizes follow the style', () {
    ShadThemeData of(ShadStyleTokens style) => ShadThemeData(style: style);
    // `.cn-toggle` `size-4`, sera `size-3.5`.
    expect(of(ShadStyleTokens.vega).toggleTheme.iconSize, 16);
    expect(of(ShadStyleTokens.sera).toggleTheme.iconSize, 14);
    expect(of(ShadStyleTokens.vega).outlineToggleTheme.iconSize, 16);
    // `.cn-badge` `[&>svg]:size-3`, mira `size-2.5`.
    expect(of(ShadStyleTokens.vega).primaryBadgeTheme.iconSize, 12);
    expect(of(ShadStyleTokens.mira).primaryBadgeTheme.iconSize, 10);
    expect(of(ShadStyleTokens.vega).outlineBadgeTheme.iconSize, 12);
  });

  testWidgets('a badge hands its icon size down', (tester) async {
    await tester.pumpWidget(
      ShadApp(
        theme: ShadThemeData(style: ShadStyleTokens.mira),
        home: const Center(
          child: ShadBadge(child: Icon(IconData(0x41))),
        ),
      ),
    );
    final icon = find.byType(Icon);
    expect(IconTheme.of(tester.element(icon)).size, 10);
  });
}
