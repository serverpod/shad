import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class TypographyRolesExample extends StatelessWidget {
  const TypographyRolesExample({super.key});

  static const _textThemeStyles = <(String label, String styleKey, String sample)>[
    ('h1Large', 'h1Large', 'Taxing Laughter'),
    ('h1', 'h1', 'Taxing Laughter: The Joke Tax Chronicles'),
    ('h2', 'h2', 'The People of the Kingdom'),
    ('h3', 'h3', 'The Joke Tax'),
    ('h4', 'h4', 'People stopped telling jokes'),
    (
      'p',
      'p',
      'The king, seeing how much happier his subjects were, realized '
      'the error of his ways and repealed the joke tax.',
    ),
    (
      'blockquote',
      'blockquote',
      '"After all," he said, "everyone enjoys a good joke, so it\'s '
      'only fair that they should pay for the privilege."',
    ),
    ('table', 'table', "King's Treasury"),
    ('list', 'list', '1st level of puns: 5 gold coins'),
    (
      'lead',
      'lead',
      'A modal dialog that interrupts the user with important content '
      'and expects a response.',
    ),
    ('large', 'large', 'Are you absolutely sure?'),
    ('small', 'small', 'Email address'),
    ('muted', 'muted', 'Enter your email address.'),
  ];

  static const _minContrast = 3.0;
  static const _proseLabelWidth = 104.0;
  static const _componentLabelWidth = 300.0;

  static TextStyle _textThemeStyle(ShadTextTheme text, String key) =>
      switch (key) {
        'h1Large' => text.h1Large,
        'h1' => text.h1,
        'h2' => text.h2,
        'h3' => text.h3,
        'h4' => text.h4,
        'p' => text.p,
        'blockquote' => text.blockquote,
        'table' => text.table,
        'list' => text.list,
        'lead' => text.lead,
        'large' => text.large,
        'small' => text.small,
        'muted' => text.muted,
        _ => text.p,
      };

  static List<(String label, TextStyle style)> _componentThemeStyles(
    ShadThemeData theme,
  ) {
    final entries = <(String, TextStyle?)>[
      ('button.primary.textStyle', theme.primaryButtonTheme.textStyle),
      ('button.secondary.textStyle', theme.secondaryButtonTheme.textStyle),
      ('button.destructive.textStyle', theme.destructiveButtonTheme.textStyle),
      ('button.outline.textStyle', theme.outlineButtonTheme.textStyle),
      ('button.ghost.textStyle', theme.ghostButtonTheme.textStyle),
      ('button.link.textStyle', theme.linkButtonTheme.textStyle),
      ('badge.primary.textStyle', theme.primaryBadgeTheme.textStyle),
      ('badge.secondary.textStyle', theme.secondaryBadgeTheme.textStyle),
      ('badge.destructive.textStyle', theme.destructiveBadgeTheme.textStyle),
      ('badge.outline.textStyle', theme.outlineBadgeTheme.textStyle),
      ('breadcrumb.itemTextStyle', theme.breadcrumbTheme.itemTextStyle),
      ('breadcrumb.linkTextStyle', theme.breadcrumbTheme.linkTextStyle),
      (
        'breadcrumb.dropdownTextStyle',
        theme.breadcrumbTheme.dropdownTextStyle,
      ),
      ('popover.textStyle', theme.popoverTheme.textStyle),
      ('decorator.labelStyle', theme.decoration.labelStyle),
      ('decorator.errorStyle', theme.decoration.errorStyle),
      (
        'decorator.descriptionStyle',
        theme.decoration.descriptionStyle,
      ),
      ('decorator.errorLabelStyle', theme.decoration.errorLabelStyle),
      ('option.textStyle', theme.optionTheme.textStyle),
      ('option.selectedTextStyle', theme.optionTheme.selectedTextStyle),
      ('card.titleStyle', theme.cardTheme.titleStyle),
      ('card.descriptionStyle', theme.cardTheme.descriptionStyle),
      ('input.style', theme.inputTheme.style),
      ('input.placeholderStyle', theme.inputTheme.placeholderStyle),
      ('textarea.style', theme.textareaTheme.style),
      ('textarea.placeholderStyle', theme.textareaTheme.placeholderStyle),
      ('toast.primary.titleStyle', theme.primaryToastTheme.titleStyle),
      (
        'toast.primary.descriptionStyle',
        theme.primaryToastTheme.descriptionStyle,
      ),
      ('toast.destructive.titleStyle', theme.destructiveToastTheme.titleStyle),
      (
        'toast.destructive.descriptionStyle',
        theme.destructiveToastTheme.descriptionStyle,
      ),
      ('alert.primary.titleStyle', theme.primaryAlertTheme.titleStyle),
      (
        'alert.primary.descriptionStyle',
        theme.primaryAlertTheme.descriptionStyle,
      ),
      ('alert.destructive.titleStyle', theme.destructiveAlertTheme.titleStyle),
      (
        'alert.destructive.descriptionStyle',
        theme.destructiveAlertTheme.descriptionStyle,
      ),
      ('dialog.titleStyle', theme.primaryDialogTheme.titleStyle),
      ('dialog.descriptionStyle', theme.primaryDialogTheme.descriptionStyle),
      ('alertDialog.titleStyle', theme.alertDialogTheme.titleStyle),
      (
        'alertDialog.descriptionStyle',
        theme.alertDialogTheme.descriptionStyle,
      ),
      ('accordion.titleStyle', theme.accordionTheme.titleStyle),
      ('table.cellStyle', theme.tableTheme.cellStyle),
      ('table.cellHeaderStyle', theme.tableTheme.cellHeaderStyle),
      ('table.cellFooterStyle', theme.tableTheme.cellFooterStyle),
      ('tabs.tabTextStyle', theme.tabsTheme.tabTextStyle),
      ('contextMenu.textStyle', theme.contextMenuTheme.textStyle),
      (
        'contextMenu.selectedTextStyle',
        theme.contextMenuTheme.selectedTextStyle,
      ),
      (
        'contextMenu.trailingTextStyle',
        theme.contextMenuTheme.trailingTextStyle,
      ),
      (
        'contextMenu.selectedTrailingTextStyle',
        theme.contextMenuTheme.selectedTrailingTextStyle,
      ),
      ('calendar.headerTextStyle', theme.calendarTheme.headerTextStyle),
      ('calendar.weekdaysTextStyle', theme.calendarTheme.weekdaysTextStyle),
      (
        'calendar.weekNumbersHeaderTextStyle',
        theme.calendarTheme.weekNumbersHeaderTextStyle,
      ),
      (
        'calendar.weekNumbersTextStyle',
        theme.calendarTheme.weekNumbersTextStyle,
      ),
      (
        'calendar.dayButtonTextStyle',
        theme.calendarTheme.dayButtonTextStyle,
      ),
      (
        'calendar.selectedDayButtonTextStyle',
        theme.calendarTheme.selectedDayButtonTextStyle,
      ),
      (
        'calendar.insideRangeDayButtonTextStyle',
        theme.calendarTheme.insideRangeDayButtonTextStyle,
      ),
      (
        'calendar.dayButtonOutsideMonthTextStyle',
        theme.calendarTheme.dayButtonOutsideMonthTextStyle,
      ),
      ('timePicker.style', theme.timePickerTheme.style),
      ('timePicker.placeholderStyle', theme.timePickerTheme.placeholderStyle),
      ('timePicker.labelStyle', theme.timePickerTheme.labelStyle),
      ('inputOTP.style', theme.inputOTPTheme.style),
      ('kbd.textStyle', theme.kbdTheme.textStyle),
      ('toggle.textStyle', theme.toggleTheme.textStyle),
      ('toggle.outline.textStyle', theme.outlineToggleTheme.textStyle),
      ('empty.titleStyle', theme.emptyTheme.titleStyle),
      ('empty.descriptionStyle', theme.emptyTheme.descriptionStyle),
      ('pagination.ellipsisTextStyle', theme.paginationTheme.ellipsisTextStyle),
      ('sidebar.groupLabelTextStyle', theme.sidebarTheme.groupLabelTextStyle),
      ('sidebar.menuButtonTextStyle', theme.sidebarTheme.menuButtonTextStyle),
      (
        'sidebar.menuButtonTextStyleSm',
        theme.sidebarTheme.menuButtonTextStyleSm,
      ),
      ('sidebar.subButtonTextStyle', theme.sidebarTheme.subButtonTextStyle),
      ('sidebar.badgeTextStyle', theme.sidebarTheme.badgeTextStyle),
      ('command.groupHeadingStyle', theme.commandTheme.groupHeadingStyle),
      ('command.itemTextStyle', theme.commandTheme.itemTextStyle),
      ('command.emptyTextStyle', theme.commandTheme.emptyTextStyle),
      ('select.placeholderStyle', theme.selectTheme.placeholderStyle),
    ];

    return [
      for (final (label, style) in entries)
        if (style != null) (label, style),
    ];
  }

  static double _contrastRatio(Color foreground, Color background) {
    final fg = foreground.a < 1
        ? Color.alphaBlend(foreground, background)
        : foreground;
    final bg = background.a < 1
        ? Color.alphaBlend(background, const Color(0xffffffff))
        : background;
    final l1 = fg.computeLuminance();
    final l2 = bg.computeLuminance();
    final lighter = math.max(l1, l2);
    final darker = math.min(l1, l2);
    return (lighter + 0.05) / (darker + 0.05);
  }

  static Color _effectiveColor(TextStyle style, ShadColorScheme scheme) {
    return style.color ?? scheme.foreground;
  }

  static Color? _inferredSurface(String label, ShadColorScheme scheme) {
    return switch (label) {
      'button.primary.textStyle' ||
      'badge.primary.textStyle' ||
      'calendar.selectedDayButtonTextStyle' => scheme.primary,
      'button.secondary.textStyle' || 'badge.secondary.textStyle' =>
        scheme.secondary,
      'toast.destructive.titleStyle' ||
      'toast.destructive.descriptionStyle' => scheme.destructive,
      'sidebar.groupLabelTextStyle' ||
      'sidebar.menuButtonTextStyle' ||
      'sidebar.menuButtonTextStyleSm' ||
      'sidebar.subButtonTextStyle' ||
      'sidebar.badgeTextStyle' => scheme.sidebar,
      'kbd.textStyle' => scheme.muted,
      'card.titleStyle' || 'card.descriptionStyle' => scheme.card,
      'alert.primary.titleStyle' ||
      'alert.primary.descriptionStyle' ||
      'alert.destructive.titleStyle' ||
      'alert.destructive.descriptionStyle' => scheme.card,
      'popover.textStyle' ||
      'option.textStyle' ||
      'option.selectedTextStyle' ||
      'dialog.titleStyle' ||
      'dialog.descriptionStyle' ||
      'alertDialog.titleStyle' ||
      'alertDialog.descriptionStyle' ||
      'command.groupHeadingStyle' ||
      'command.itemTextStyle' ||
      'command.emptyTextStyle' =>
        scheme.popover,
      'contextMenu.textStyle' ||
      'contextMenu.trailingTextStyle' => scheme.popover,
      'contextMenu.selectedTextStyle' ||
      'contextMenu.selectedTrailingTextStyle' => scheme.accent,
      _ => null,
    };
  }

  static Color _fallbackSurface(Color textColor, ShadColorScheme scheme) {
    return textColor.computeLuminance() > 0.5 ? scheme.foreground : scheme.muted;
  }

  static Color? _backgroundForSample(
    String label,
    TextStyle style,
    ShadColorScheme scheme,
  ) {
    final textColor = _effectiveColor(style, scheme);

    if (_contrastRatio(textColor, scheme.background) >= _minContrast) {
      return null;
    }

    final inferred = _inferredSurface(label, scheme);
    if (inferred != null &&
        _contrastRatio(textColor, inferred) >= _minContrast) {
      return inferred;
    }

    final fallback = _fallbackSurface(textColor, scheme);
    if (_contrastRatio(textColor, fallback) >= _minContrast) {
      return fallback;
    }

    return scheme.foreground;
  }

  static const _narrowBreakpoint = 560.0;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final proseLabelWidth = _proseLabelWidth * textScale;
        final componentLabelWidth = _componentLabelWidth * textScale;
        final wideMaxWidth = math.max(
          840.0,
          proseLabelWidth + componentLabelWidth + 320,
        );
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : wideMaxWidth;
        final maxWidth = math.min(wideMaxWidth, availableWidth);
        final stacked = availableWidth < _narrowBreakpoint * textScale;

        final labelStyle = text.muted.copyWith(
          color: scheme.mutedForeground,
        );

        Widget sample(String label, String text, TextStyle style) {
          final background = _backgroundForSample(label, style, scheme);
          final child = Text(text, style: style);

          if (background == null) return child;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: background,
              borderRadius: theme.radii.sm,
            ),
            child: child,
          );
        }

        Widget row(
          String label,
          TextStyle style,
          String sampleText, {
          required double labelWidth,
        }) {
          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 4,
              children: [
                Text(label, style: labelStyle, softWrap: true),
                sample(label, sampleText, style),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: labelWidth,
                child: Text(
                  label,
                  style: labelStyle,
                  softWrap: true,
                ),
              ),
              Expanded(
                child: sample(label, sampleText, style),
              ),
            ],
          );
        }

        final componentStyles = _componentThemeStyles(theme);

        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              for (final (label, styleKey, sampleText) in _textThemeStyles)
                row(
                  label,
                  _textThemeStyle(text, styleKey),
                  sampleText,
                  labelWidth: proseLabelWidth,
                ),
              const ShadSeparator.horizontal(
                margin: EdgeInsets.symmetric(vertical: 8),
              ),
              for (final (label, style) in componentStyles)
                row(
                  label,
                  style,
                  'Sample text',
                  labelWidth: componentLabelWidth,
                ),
            ],
          ),
        );
      },
    );
  }
}
