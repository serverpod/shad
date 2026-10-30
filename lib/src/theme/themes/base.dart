import 'package:flutter/widgets.dart';
import 'package:shad/src/theme/color_scheme/base.dart';
import 'package:shad/src/theme/components/accordion.dart';
import 'package:shad/src/theme/components/alert.dart';
import 'package:shad/src/theme/components/avatar.dart';
import 'package:shad/src/theme/components/badge.dart';
import 'package:shad/src/theme/components/breadcrumb.dart';
import 'package:shad/src/theme/components/button.dart';
import 'package:shad/src/theme/components/button_sizes.dart';
import 'package:shad/src/theme/components/calendar.dart';
import 'package:shad/src/theme/components/card.dart';
import 'package:shad/src/theme/components/checkbox.dart';
import 'package:shad/src/theme/components/collapsible.dart';
import 'package:shad/src/theme/components/command.dart';
import 'package:shad/src/theme/components/context_menu.dart';
import 'package:shad/src/theme/components/date_picker.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:shad/src/theme/components/default_keyboard_toolbar.dart';
import 'package:shad/src/theme/components/dialog.dart';
import 'package:shad/src/theme/components/empty.dart';
import 'package:shad/src/theme/components/input.dart';
import 'package:shad/src/theme/components/input_otp.dart';
import 'package:shad/src/theme/components/kbd.dart';
import 'package:shad/src/theme/components/menubar.dart';
import 'package:shad/src/theme/components/option.dart';
import 'package:shad/src/theme/components/pagination.dart';
import 'package:shad/src/theme/components/popover.dart';
import 'package:shad/src/theme/components/progress.dart';
import 'package:shad/src/theme/components/radio.dart';
import 'package:shad/src/theme/components/resizable.dart';
import 'package:shad/src/theme/components/scroll_area.dart';
import 'package:shad/src/theme/components/select.dart';
import 'package:shad/src/theme/components/separator.dart';
import 'package:shad/src/theme/components/sheet.dart';
import 'package:shad/src/theme/components/sidebar.dart';
import 'package:shad/src/theme/components/skeleton.dart';
import 'package:shad/src/theme/components/slider.dart';
import 'package:shad/src/theme/components/sonner.dart';
import 'package:shad/src/theme/components/spinner.dart';
import 'package:shad/src/theme/components/switch.dart';
import 'package:shad/src/theme/components/table.dart';
import 'package:shad/src/theme/components/tabs.dart';
import 'package:shad/src/theme/components/textarea.dart';
import 'package:shad/src/theme/components/time_picker.dart';
import 'package:shad/src/theme/components/toast.dart';
import 'package:shad/src/theme/components/toggle.dart';
import 'package:shad/src/theme/components/tooltip.dart';
import 'package:shad/src/theme/radii.dart';
import 'package:shad/src/theme/spacing.dart';
import 'package:shad/src/theme/style.dart';
import 'package:shad/src/theme/text_theme/theme.dart';
import 'package:shad/src/utils/gesture_detector.dart';
import 'package:shad/src/utils/responsive.dart';

/// The resolved values of a theme: the colour scheme, the text theme, the
/// shared settings and one theme per component.
///
/// `ShadThemeData` is the only implementation. Its fields are documented here.
@immutable
abstract class ShadBaseTheme {
  /// Creates a base theme with every value given.
  const ShadBaseTheme({
    required this.colorScheme,
    required this.brightness,
    required this.primaryButtonTheme,
    required this.secondaryButtonTheme,
    required this.destructiveButtonTheme,
    required this.outlineButtonTheme,
    required this.ghostButtonTheme,
    required this.linkButtonTheme,
    required this.primaryBadgeTheme,
    required this.secondaryBadgeTheme,
    required this.destructiveBadgeTheme,
    required this.outlineBadgeTheme,
    required this.breadcrumbTheme,
    required this.radius,
    required this.avatarTheme,
    required this.buttonSizesTheme,
    required this.tooltipTheme,
    required this.popoverTheme,
    required this.decoration,
    required this.textTheme,
    required this.disabledOpacity,
    required this.selectTheme,
    required this.optionTheme,
    required this.cardTheme,
    required this.switchTheme,
    required this.checkboxTheme,
    required this.inputTheme,
    required this.radioTheme,
    required this.primaryToastTheme,
    required this.destructiveToastTheme,
    required this.breakpoints,
    required this.primaryAlertTheme,
    required this.destructiveAlertTheme,
    required this.primaryDialogTheme,
    required this.alertDialogTheme,
    required this.sliderTheme,
    required this.sheetTheme,
    required this.progressTheme,
    required this.accordionTheme,
    required this.tableTheme,
    required this.resizableTheme,
    required this.hoverStrategies,
    required this.disableSecondaryBorder,
    required this.tabsTheme,
    required this.contextMenuTheme,
    required this.calendarTheme,
    required this.datePickerTheme,
    required this.timePickerTheme,
    required this.inputOTPTheme,
    required this.menubarTheme,
    required this.separatorTheme,
    required this.sonnerTheme,
    required this.textareaTheme,
    required this.defaultKeyboardToolbarTheme,
    required this.skeletonTheme,
    required this.kbdTheme,
    required this.scrollAreaTheme,
    required this.spinnerTheme,
    required this.toggleTheme,
    required this.outlineToggleTheme,
    required this.emptyTheme,
    required this.paginationTheme,
    required this.collapsibleTheme,
    required this.commandTheme,
    required this.sidebarTheme,
    required this.variant,
  });

  /// The variant that produced the component theme defaults below.
  ///
  /// Stored so that `ShadThemeData.copyWith` re-derives from the same variant
  /// instead of silently falling back to the default one.
  final ShadThemeVariant variant;

  /// The theme of `ShadCommand`.
  final ShadCommandTheme commandTheme;

  /// The theme of `ShadSidebar` and its menu.
  final ShadSidebarTheme sidebarTheme;

  /// The theme of `ShadSkeleton`.
  final ShadSkeletonTheme skeletonTheme;

  /// The theme of `ShadKbd` keyboard keys.
  final ShadKbdTheme kbdTheme;

  /// The theme of `ShadScrollArea`.
  final ShadScrollAreaTheme scrollAreaTheme;

  /// The theme of `ShadSpinner`.
  final ShadSpinnerTheme spinnerTheme;

  /// The theme of `ShadToggle` in its default variant.
  final ShadToggleTheme toggleTheme;

  /// The theme of outline toggles, `ShadToggle.outline`.
  final ShadToggleTheme outlineToggleTheme;

  /// The theme of `ShadEmpty`.
  final ShadEmptyTheme emptyTheme;

  /// The theme of `ShadPagination`.
  final ShadPaginationTheme paginationTheme;

  /// The theme of `ShadCollapsible`.
  final ShadCollapsibleTheme collapsibleTheme;

  /// The colour tokens every component theme is built from.
  final ShadColorScheme colorScheme;

  /// Whether the theme is light or dark.
  final Brightness brightness;

  /// The theme of primary buttons, `ShadButton`'s default variant.
  final ShadButtonTheme primaryButtonTheme;

  /// The theme of secondary buttons, `ShadButton.secondary`.
  final ShadButtonTheme secondaryButtonTheme;

  /// The theme of destructive buttons, `ShadButton.destructive`.
  final ShadButtonTheme destructiveButtonTheme;

  /// The theme of outline buttons, `ShadButton.outline`.
  final ShadButtonTheme outlineButtonTheme;

  /// The theme of ghost buttons, `ShadButton.ghost`.
  final ShadButtonTheme ghostButtonTheme;

  /// The theme of link buttons, `ShadButton.link`.
  final ShadButtonTheme linkButtonTheme;

  /// The theme of primary badges, `ShadBadge`'s default variant.
  final ShadBadgeTheme primaryBadgeTheme;

  /// The theme of secondary badges, `ShadBadge.secondary`.
  final ShadBadgeTheme secondaryBadgeTheme;

  /// The theme of destructive badges, `ShadBadge.destructive`.
  final ShadBadgeTheme destructiveBadgeTheme;

  /// The theme of outline badges, `ShadBadge.outline`.
  final ShadBadgeTheme outlineBadgeTheme;

  /// The theme of `ShadBreadcrumb`.
  final ShadBreadcrumbTheme breadcrumbTheme;

  /// The component radius, the `md` step of [ShadRadii]. Defaults to 8.
  final BorderRadius radius;

  /// The theme of `ShadAvatar`.
  final ShadAvatarTheme avatarTheme;

  /// The metrics of each `ShadButton` size.
  final ShadButtonSizesTheme buttonSizesTheme;

  /// The theme of `ShadTooltip`.
  final ShadTooltipTheme tooltipTheme;

  /// The theme of `ShadPopover`.
  final ShadPopoverTheme popoverTheme;

  /// The default border and label styling of controls. Component decorations
  /// are merged over it.
  final ShadDecoration decoration;

  /// The text styles. These have the style's text roles applied, so they can
  /// differ from the text theme passed in.
  final ShadTextTheme textTheme;

  /// The opacity of disabled components. Defaults to 0.5.
  final double disabledOpacity;

  /// The theme of `ShadSelect`.
  final ShadSelectTheme selectTheme;

  /// The theme of `ShadOption`, the rows of a select.
  final ShadOptionTheme optionTheme;

  /// The theme of `ShadCard`.
  final ShadCardTheme cardTheme;

  /// The theme of `ShadSwitch`.
  final ShadSwitchTheme switchTheme;

  /// The theme of `ShadCheckbox`.
  final ShadCheckboxTheme checkboxTheme;

  /// The theme of `ShadInput`.
  final ShadInputTheme inputTheme;

  /// The theme of `ShadRadio`.
  final ShadRadioTheme radioTheme;

  /// The theme of default toasts, `ShadToast`.
  final ShadToastTheme primaryToastTheme;

  /// The theme of destructive toasts, `ShadToast.destructive`.
  final ShadToastTheme destructiveToastTheme;

  /// The screen widths at which the layout changes.
  final ShadBreakpoints breakpoints;

  /// The theme of default alerts, `ShadAlert`.
  final ShadAlertTheme primaryAlertTheme;

  /// The theme of destructive alerts, `ShadAlert.destructive`.
  final ShadAlertTheme destructiveAlertTheme;

  /// The theme of `ShadDialog`.
  final ShadDialogTheme primaryDialogTheme;

  /// The theme of alert dialogs, `ShadDialog.alert`.
  final ShadDialogTheme alertDialogTheme;

  /// The theme of `ShadSlider`.
  final ShadSliderTheme sliderTheme;

  /// The theme of `ShadSheet`.
  final ShadSheetTheme sheetTheme;

  /// The theme of `ShadProgress`.
  final ShadProgressTheme progressTheme;

  /// The theme of `ShadAccordion`.
  final ShadAccordionTheme accordionTheme;

  /// The theme of `ShadTable`.
  final ShadTableTheme tableTheme;

  /// The theme of `ShadResizablePanelGroup`.
  final ShadResizableTheme resizableTheme;

  /// The gestures that give touch devices a hover state.
  final ShadHoverStrategies hoverStrategies;

  /// Whether controls show focus without the outward ring. Defaults to false.
  ///
  /// When true, `ShadThemeData` uses
  /// `ShadDefaultThemeNoSecondaryBorderVariant`.
  final bool disableSecondaryBorder;

  /// The theme of `ShadTabs`.
  final ShadTabsTheme tabsTheme;

  /// The theme of `ShadContextMenu`.
  final ShadContextMenuTheme contextMenuTheme;

  /// The theme of `ShadCalendar`.
  final ShadCalendarTheme calendarTheme;

  /// The theme of `ShadDatePicker`.
  final ShadDatePickerTheme datePickerTheme;

  /// The theme of `ShadTimePicker`.
  final ShadTimePickerTheme timePickerTheme;

  /// The theme of `ShadInputOTP`.
  final ShadInputOTPTheme inputOTPTheme;

  /// The theme of `ShadMenubar`.
  final ShadMenubarTheme menubarTheme;

  /// The theme of `ShadSeparator`.
  final ShadSeparatorTheme separatorTheme;

  /// The theme of `ShadSonner`.
  final ShadSonnerTheme sonnerTheme;

  /// The theme of `ShadTextarea`.
  final ShadTextareaTheme textareaTheme;

  /// The theme of `ShadDefaultKeyboardToolbar`.
  final ShadDefaultKeyboardToolbarTheme defaultKeyboardToolbarTheme;
}

/// Derives every component theme from one colour scheme, radius, text theme,
/// style and spacing scale.
///
/// A variant bakes its inputs into the themes it returns, so call [rebuild] to
/// change one of them. `ShadThemeData` calls the builder methods when it is
/// created, and an explicit component theme is merged over the result. See
/// `ShadDefaultThemeVariant` and `ShadDefaultThemeNoSecondaryBorderVariant`.
@immutable
abstract class ShadThemeVariant {
  /// The palette every component theme is built from.
  ShadColorScheme get colorScheme;

  /// The base ("md") radius the rest of the scale derives from.
  BorderRadius get radius;

  /// The already-merged text theme.
  ShadTextTheme get effectiveTextTheme;

  /// Returns a variant of the same kind with the given inputs replaced.
  ///
  /// A variant bakes its inputs into the component themes when it is
  /// constructed, so changing one of them means building a new variant.
  /// `ShadThemeData.copyWith` relies on this: without it, `copyWith(radius:)`
  /// on a theme that carries a variant would update the theme's `radius` field
  /// and leave every component at the old one.
  ShadThemeVariant rebuild({
    ShadColorScheme? colorScheme,
    BorderRadius? radius,
    ShadTextTheme? effectiveTextTheme,
    ShadStyleTokens? style,
    ShadSpacing? spacing,
  });

  /// The shadcn/ui style this variant renders — the radius, focus-ring and
  /// label knobs that distinguish one style from another.
  ShadStyleTokens get style;

  /// The corner-radius scale, derived from the variant's base radius.
  ShadRadii get radii;

  /// The spacing scale every padding and gap is a multiple of.
  ShadSpacing get spacing;

  /// Builds the theme of primary buttons, `ShadButton`'s default variant.
  ShadButtonTheme primaryButtonTheme();

  /// Builds the theme of secondary buttons, `ShadButton.secondary`.
  ShadButtonTheme secondaryButtonTheme();

  /// Builds the theme of destructive buttons, `ShadButton.destructive`.
  ShadButtonTheme destructiveButtonTheme();

  /// Builds the theme of outline buttons, `ShadButton.outline`.
  ShadButtonTheme outlineButtonTheme();

  /// Builds the theme of ghost buttons, `ShadButton.ghost`.
  ShadButtonTheme ghostButtonTheme();

  /// Builds the theme of link buttons, `ShadButton.link`.
  ShadButtonTheme linkButtonTheme();

  /// Builds the metrics of each `ShadButton` size.
  ShadButtonSizesTheme buttonSizesTheme();

  /// Builds the theme of primary badges, `ShadBadge`'s default variant.
  ShadBadgeTheme primaryBadgeTheme();

  /// Builds the theme of secondary badges, `ShadBadge.secondary`.
  ShadBadgeTheme secondaryBadgeTheme();

  /// Builds the theme of destructive badges, `ShadBadge.destructive`.
  ShadBadgeTheme destructiveBadgeTheme();

  /// Builds the theme of outline badges, `ShadBadge.outline`.
  ShadBadgeTheme outlineBadgeTheme();

  /// Builds the theme of `ShadAvatar`.
  ShadAvatarTheme avatarTheme();

  /// Builds the theme of `ShadBreadcrumb`.
  ShadBreadcrumbTheme breadcrumbTheme();

  /// Builds the theme of `ShadTooltip`.
  ShadTooltipTheme tooltipTheme();

  /// Builds the theme of `ShadPopover`.
  ShadPopoverTheme popoverTheme();

  /// Builds the default [ShadDecoration] of controls.
  ShadDecoration decorationTheme();

  /// Builds the text theme: [effectiveTextTheme] with the style's text roles
  /// applied to `small`, `muted`, `p`, `list` and `large`.
  ShadTextTheme textTheme();

  /// Builds the theme of `ShadSelect`.
  ShadSelectTheme selectTheme();

  /// Builds the theme of `ShadOption`, the rows of a select.
  ShadOptionTheme optionTheme();

  /// Builds the theme of `ShadCard`.
  ShadCardTheme cardTheme();

  /// Builds the theme of `ShadSwitch`.
  ShadSwitchTheme switchTheme();

  /// Builds the theme of `ShadCheckbox`.
  ShadCheckboxTheme checkboxTheme();

  /// Builds the theme of `ShadInput`.
  ShadInputTheme inputTheme();

  /// Builds the theme of `ShadRadio`.
  ShadRadioTheme radioTheme();

  /// Builds the theme of default toasts, `ShadToast`.
  ShadToastTheme primaryToastTheme();

  /// Builds the theme of destructive toasts, `ShadToast.destructive`.
  ShadToastTheme destructiveToastTheme();

  /// Builds the theme of default alerts, `ShadAlert`.
  ShadAlertTheme primaryAlertTheme();

  /// Builds the theme of destructive alerts, `ShadAlert.destructive`.
  ShadAlertTheme destructiveAlertTheme();

  /// Builds the theme of `ShadDialog`.
  ShadDialogTheme primaryDialogTheme();

  /// Builds the theme of alert dialogs, `ShadDialog.alert`.
  ShadDialogTheme alertDialogTheme();

  /// Builds the theme of `ShadSlider`.
  ShadSliderTheme sliderTheme();

  /// Builds the theme of `ShadSheet`.
  ShadSheetTheme sheetTheme();

  /// Builds the theme of `ShadProgress`.
  ShadProgressTheme progressTheme();

  /// Builds the theme of `ShadAccordion`.
  ShadAccordionTheme accordionTheme();

  /// Builds the theme of `ShadTable`.
  ShadTableTheme tableTheme();

  /// Builds the theme of `ShadResizablePanelGroup`.
  ShadResizableTheme resizableTheme();

  /// Builds the gestures that give touch devices a hover state.
  ShadHoverStrategies hoverStrategies();

  /// Builds the theme of `ShadTabs`.
  ShadTabsTheme tabsTheme();

  /// Builds the theme of `ShadContextMenu`.
  ShadContextMenuTheme contextMenuTheme();

  /// Builds the theme of `ShadCalendar`.
  ShadCalendarTheme calendarTheme();

  /// Builds the theme of `ShadDatePicker`.
  ShadDatePickerTheme datePickerTheme();

  /// Builds the theme of `ShadTimePicker`.
  ShadTimePickerTheme timePickerTheme();

  /// Builds the theme of `ShadInputOTP`.
  ShadInputOTPTheme inputOTPTheme();

  /// Builds the theme of `ShadMenubar`.
  ShadMenubarTheme menubarTheme();

  /// Builds the theme of `ShadSeparator`.
  ShadSeparatorTheme separatorTheme();

  /// Builds the theme of `ShadSonner`.
  ShadSonnerTheme sonnerTheme();

  /// Builds the theme of `ShadTextarea`.
  ShadTextareaTheme textareaTheme();

  /// Builds the theme of `ShadDefaultKeyboardToolbar`.
  ShadDefaultKeyboardToolbarTheme defaultKeyboardToolbarTheme();

  /// Builds the theme of `ShadCommand`.
  ShadCommandTheme commandTheme();

  /// Builds the theme of `ShadSkeleton`.
  ShadSkeletonTheme skeletonTheme();

  /// Builds the theme of `ShadKbd` keyboard keys.
  ShadKbdTheme kbdTheme();

  /// Builds the theme of `ShadScrollArea`.
  ShadScrollAreaTheme scrollAreaTheme();

  /// Builds the theme of `ShadSpinner`.
  ShadSpinnerTheme spinnerTheme();

  /// Builds the theme of `ShadToggle` in its default variant.
  ShadToggleTheme toggleTheme();

  /// Builds the theme of outline toggles, `ShadToggle.outline`.
  ShadToggleTheme outlineToggleTheme();

  /// Builds the theme of `ShadEmpty`.
  ShadEmptyTheme emptyTheme();

  /// Builds the theme of `ShadPagination`.
  ShadPaginationTheme paginationTheme();

  /// Builds the theme of `ShadCollapsible`.
  ShadCollapsibleTheme collapsibleTheme();

  /// Builds the theme of `ShadSidebar` and its menu.
  ShadSidebarTheme sidebarTheme();
}
