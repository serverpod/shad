import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';

/// The reference gives fields, select triggers and every button variant the
/// same border-box height per style (`h-9`/`h-8`/`h-7`/`h-10`), which is what
/// lets them sit level on a single row. These renders lock that in: the
/// border — and the no-secondary-border variant's focus reserve — must be
/// counted *inside* the height, not added around it.
void main() {
  testWidgets('controls share the style height on a row', (tester) async {
    for (final disableSecondaryBorder in [false, true]) {
      for (final style in ShadStyleTokens.all) {
        final theme = ShadThemeData(
          brightness: Brightness.light,
          colorScheme: const ShadSlateColorScheme.light(),
          style: style,
          disableSecondaryBorder: disableSecondaryBorder,
        );
        await tester.pumpWidget(
          ShadApp(
            theme: theme,
            home: Scaffold(
              // A Wrap rather than a Row: the roster is wider than the test
              // surface, and an overflowing Row throws in tests. The heights
              // are asserted per widget, not from the row geometry.
              body: Center(
                child: Wrap(
                  children: [
                    const SizedBox(
                      width: 140,
                      child: ShadInput(placeholder: Text('Email')),
                    ),
                    SizedBox(
                      width: 140,
                      child: ShadSelect<String>(
                        placeholder: const Text('Pick'),
                        options: const [
                          ShadOption(value: 'a', child: Text('A')),
                        ],
                        selectedOptionBuilder: (context, value) => Text(value),
                      ),
                    ),
                    ShadButton(onPressed: () {}, child: const Text('Go')),
                    ShadButton.outline(
                      onPressed: () {},
                      child: const Text('Go'),
                    ),
                    ShadButton.secondary(
                      onPressed: () {},
                      child: const Text('Go'),
                    ),
                    ShadButton.ghost(onPressed: () {}, child: const Text('Go')),
                    ShadToggle(
                      value: false,
                      onChanged: (_) {},
                      child: const Text('Tg'),
                    ),
                    ShadToggle.outline(
                      value: false,
                      onChanged: (_) {},
                      child: const Text('Tg'),
                    ),
                    const ShadDatePicker(),
                    const ShadInputOTP(
                      maxLength: 2,
                      children: [
                        ShadInputOTPGroup(
                          children: [ShadInputOTPSlot(), ShadInputOTPSlot()],
                        ),
                      ],
                    ),
                    const ShadTimePicker(),
                    const ShadMenubar(
                      items: [
                        ShadMenubarItem(
                          items: [ShadContextMenuItem(child: Text('New'))],
                          child: Text('File'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        // Let the implicit theme animation from the previous iteration's
        // theme finish before measuring.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));

        final label =
            '${style.name} '
            '(disableSecondaryBorder: $disableSecondaryBorder)';
        final expected = style.inputHeight;
        // `.first` — the time picker contributes ShadInputs of its own.
        expect(
          tester.getSize(find.byType(ShadInput).first).height,
          expected,
          reason: 'input height in $label',
        );
        expect(
          tester.getSize(find.byType(ShadSelect<String>)).height,
          expected,
          reason: 'select trigger height in $label',
        );
        // The date picker trigger is itself a ShadButton, so it is covered by
        // the loop.
        final buttons = find.byType(ShadButton, skipOffstage: false);
        for (var i = 0; i < 5; i++) {
          expect(
            tester.getSize(buttons.at(i)).height,
            style.buttonHeight,
            reason: 'button #$i height in $label',
          );
        }
        final toggles = find.byType(ShadToggle);
        for (var i = 0; i < 2; i++) {
          expect(
            tester.getSize(toggles.at(i)).height,
            style.buttonHeight,
            reason: 'toggle #$i height in $label',
          );
        }
        expect(
          tester.getSize(find.byType(ShadInputOTPSlot).first),
          Size.square(style.inputHeight),
          reason: 'OTP slot size in $label',
        );
        expect(
          tester
              .getSize(
                find
                    .descendant(
                      of: find.byType(ShadTimePicker),
                      matching: find.byType(ShadInput),
                    )
                    .first,
              )
              .height,
          expected,
          reason: 'time picker field height in $label',
        );
        expect(
          tester.getSize(find.byType(ShadMenubar)).height,
          style.menubarHeight,
          reason: 'menubar strip height in $label',
        );
      }
    }
  });

  testWidgets('calendar geometry follows the style tokens', (tester) async {
    for (final disableSecondaryBorder in [false, true]) {
      for (final style in ShadStyleTokens.all) {
        final theme = ShadThemeData(
          brightness: Brightness.light,
          colorScheme: const ShadSlateColorScheme.light(),
          style: style,
          disableSecondaryBorder: disableSecondaryBorder,
        );
        await tester.pumpWidget(
          ShadApp(
            theme: theme,
            home: Scaffold(
              body: Center(
                child: ShadCalendar(
                  selected: DateTime(2024, 5, 15),
                  captionLayout: ShadCalendarCaptionLayout.dropdown,
                  // Single-glyph captions: the test font (Ahem) renders every
                  // glyph a full em wide, so a real month name wraps to two
                  // lines inside the trigger and inflates its height.
                  dropdownFormatMonth: (date) => 'M',
                  dropdownFormatYear: (date) => 'Y',
                  // Ditto for the day numbers: two Ahem digits are wider than
                  // mira's 24px cell, though half that wide in a real font.
                  // Every day state resolves its own style, so all four are
                  // pinned.
                  dayButtonTextStyle: const TextStyle(fontSize: 8),
                  selectedDayButtonTextStyle: const TextStyle(fontSize: 8),
                  insideRangeDayButtonTextStyle: const TextStyle(fontSize: 8),
                  dayButtonOutsideMonthTextStyle: const TextStyle(fontSize: 8),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));

        final label =
            '${style.name} '
            '(disableSecondaryBorder: $disableSecondaryBorder)';
        // A mid-month day cell: `size-(--cell-size)`.
        expect(
          tester.getSize(
            find.widgetWithText(ShadButton, '15', skipOffstage: false).first,
          ),
          Size.square(style.calendarCellSize),
          reason: 'day cell size in $label',
        );
        // The navigation chevrons share the cell size.
        expect(
          tester.getSize(find.byType(ShadIconButton).first),
          Size.square(style.calendarCellSize),
          reason: 'navigation button size in $label',
        );
        // The month/year dropdown triggers take the caption height
        // (`.cn-calendar-caption-label`), not the field height.
        expect(
          tester.getSize(find.byType(ShadSelect<int>).first).height,
          style.calendarCaptionHeight,
          reason: 'caption dropdown trigger height in $label',
        );
      }
    }
  });
}
