// App
// ignore: no_leading_underscores_for_library_prefixes
import 'package:flutter_animate/flutter_animate.dart' as _animate show Effect;
import 'package:intl/intl.dart' as intl show TextDirection;

// External libraries.
//
// Only what the package's own public API requires is re-exported. `boxy`,
// `flutter_svg` and `universal_image` used to be re-exported wholesale even
// though they appear nowhere in a Shad* signature; importing shad dumped
// several hundred unrelated symbols (BoxyDelegate, RenderBoxy, SvgPicture, …)
// into the caller's namespace. Depend on those packages directly if you need
// them.

// Required by the `effects:` parameter on ShadPopover, ShadSelect,
// ShadAccordion, ShadMenubar and friends.
export 'package:flutter_animate/flutter_animate.dart' hide Effect;
// DateFormat/NumberFormat are what the calendar, date picker and pagination
// docs use. The rest of `intl` (Intl, Bidi, plural/gender helpers, …) is not
// part of this package's API.
export 'package:intl/intl.dart' show DateFormat, NumberFormat;
export 'package:lucide_icons_flutter/lucide_icons.dart';
// Required by ShadTable's public signature; ShadTableCell extends
// TableViewCell.
export 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart'
    show
        FixedTableSpanExtent,
        FractionalTableSpanExtent,
        MaxTableSpanExtent,
        MinTableSpanExtent,
        RemainingTableSpanExtent,
        SpanDecoration,
        SpanPadding,
        TableSpan,
        TableSpanBuilder,
        TableSpanDecoration,
        TableSpanExtent,
        TableVicinity,
        TableViewCell;

export 'src/app.dart';
// Components
export 'src/components/accordion.dart';
export 'src/components/alert.dart';
export 'src/components/avatar.dart';
export 'src/components/badge.dart';
export 'src/components/breadcrumb.dart';
export 'src/components/button.dart';
export 'src/components/calendar.dart';
export 'src/components/card.dart';
export 'src/components/checkbox.dart';
export 'src/components/collapsible.dart';
export 'src/components/command.dart';
export 'src/components/context_menu.dart';
export 'src/components/data_table.dart';
export 'src/components/date_picker.dart';
export 'src/components/default_keyboard_toolbar.dart';
export 'src/components/dialog.dart';
export 'src/components/disabled.dart';
export 'src/components/empty.dart';
export 'src/components/form/field.dart';
export 'src/components/form/fields/checkbox.dart';
export 'src/components/form/fields/date_picker.dart';
export 'src/components/form/fields/date_range_picker.dart';
export 'src/components/form/fields/input.dart';
export 'src/components/form/fields/input_otp.dart';
export 'src/components/form/fields/radio.dart';
export 'src/components/form/fields/select.dart';
export 'src/components/form/fields/switch.dart';
export 'src/components/form/fields/textarea.dart';
export 'src/components/form/fields/time_picker.dart';
export 'src/components/form/form.dart';
export 'src/components/icon_button.dart';
export 'src/components/input.dart';
export 'src/components/input_otp.dart';
export 'src/components/kbd.dart';
export 'src/components/layout.dart';
export 'src/components/menubar.dart';
export 'src/components/pagination.dart';
export 'src/components/popover.dart';
export 'src/components/progress.dart';
export 'src/components/radio.dart';
export 'src/components/resizable.dart';
export 'src/components/select.dart';
export 'src/components/separator.dart';
export 'src/components/sheet.dart' hide RenderSheetLayoutWithSizeListener;
export 'src/components/sidebar.dart';
export 'src/components/skeleton.dart';
export 'src/components/slider.dart';
export 'src/components/sonner.dart';
export 'src/components/spinner.dart';
export 'src/components/switch.dart';
export 'src/components/table.dart';
export 'src/components/tabs.dart';
export 'src/components/textarea.dart' hide ShadResizeGripPainter;
export 'src/components/time_picker.dart';
export 'src/components/toast.dart';
export 'src/components/toggle.dart';
export 'src/components/tooltip.dart';
// Localizations
export 'src/i18n/localizations_delegate.dart';
export 'src/i18n/strings.g.dart';
// Raw Components
export 'src/raw_components/focusable.dart';
export 'src/raw_components/keyboard_toolbar.dart';
export 'src/raw_components/portal.dart' hide ShadPositionDelegate;
export 'src/raw_components/roving_focus.dart';
// App Themes & Color Schemes
export 'src/theme/color_scheme/accent.dart';
export 'src/theme/color_scheme/base.dart';
export 'src/theme/color_scheme/blue.dart';
export 'src/theme/color_scheme/gray.dart';
export 'src/theme/color_scheme/green.dart';
export 'src/theme/color_scheme/mauve.dart';
export 'src/theme/color_scheme/mist.dart';
export 'src/theme/color_scheme/neutral.dart';
export 'src/theme/color_scheme/olive.dart';
export 'src/theme/color_scheme/orange.dart';
export 'src/theme/color_scheme/red.dart';
export 'src/theme/color_scheme/rose.dart';
export 'src/theme/color_scheme/slate.dart';
export 'src/theme/color_scheme/stone.dart';
export 'src/theme/color_scheme/taupe.dart';
export 'src/theme/color_scheme/violet.dart';
export 'src/theme/color_scheme/yellow.dart';
export 'src/theme/color_scheme/zinc.dart';
// Component Themes
export 'src/theme/components/accordion.dart';
export 'src/theme/components/alert.dart';
export 'src/theme/components/avatar.dart';
export 'src/theme/components/badge.dart';
export 'src/theme/components/breadcrumb.dart';
export 'src/theme/components/button.dart';
export 'src/theme/components/button_sizes.dart';
export 'src/theme/components/calendar.dart';
export 'src/theme/components/card.dart';
export 'src/theme/components/checkbox.dart';
export 'src/theme/components/collapsible.dart';
export 'src/theme/components/command.dart';
export 'src/theme/components/context_menu.dart';
export 'src/theme/components/date_picker.dart';
export 'src/theme/components/decorator.dart' hide ShadOutwardBorderPainter;
export 'src/theme/components/default_keyboard_toolbar.dart';
export 'src/theme/components/dialog.dart';
export 'src/theme/components/empty.dart';
export 'src/theme/components/input.dart';
export 'src/theme/components/input_decorator.dart';
export 'src/theme/components/input_otp.dart';
export 'src/theme/components/kbd.dart';
export 'src/theme/components/menubar.dart';
export 'src/theme/components/option.dart';
export 'src/theme/components/pagination.dart';
export 'src/theme/components/popover.dart';
export 'src/theme/components/progress.dart';
export 'src/theme/components/radio.dart';
export 'src/theme/components/resizable.dart';
export 'src/theme/components/select.dart';
export 'src/theme/components/separator.dart';
export 'src/theme/components/sheet.dart';
export 'src/theme/components/sidebar.dart';
export 'src/theme/components/skeleton.dart';
export 'src/theme/components/slider.dart';
export 'src/theme/components/sonner.dart';
export 'src/theme/components/spinner.dart';
export 'src/theme/components/switch.dart';
export 'src/theme/components/table.dart';
export 'src/theme/components/tabs.dart';
export 'src/theme/components/textarea.dart';
export 'src/theme/components/time_picker.dart';
export 'src/theme/components/toast.dart';
export 'src/theme/components/toggle.dart';
export 'src/theme/components/tooltip.dart';
export 'src/theme/data.dart';
export 'src/theme/radii.dart';
export 'src/theme/spacing.dart';
export 'src/theme/style.dart';
export 'src/theme/text_role.dart';
export 'src/theme/text_theme/text_styles_default.dart';
export 'src/theme/text_theme/theme.dart';
export 'src/theme/theme.dart';
export 'src/theme/theme_scope.dart';
export 'src/theme/themes/base.dart';
export 'src/theme/themes/default_theme_no_secondary_border_variant.dart';
export 'src/theme/themes/default_theme_variant.dart';
export 'src/theme/themes/shadows.dart';
// Utils
export 'src/utils/animate.dart';
export 'src/utils/animation_builder.dart';
export 'src/utils/border.dart';
export 'src/utils/clipboard/clipboard_service.dart';
export 'src/utils/effects.dart';
// Extensions on core Dart/Flutter types (double, Duration, List, Map, Set,
// TextStyle, TapDownDetails) are no longer re-exported. They silently added
// methods — and, for Duration, `+ - * /` operator overloads — to every type in
// every file that imported this package. They remain internal.
export 'src/utils/extensions/breakpoints.dart';
export 'src/utils/extensions/date_time.dart';
export 'src/utils/gesture_detector.dart';
export 'src/utils/input_formatters.dart';
export 'src/utils/mouse_area.dart' show ShadMouseArea, ShadMouseAreaSurface;
export 'src/utils/mouse_cursor_provider.dart';
export 'src/utils/position.dart';
export 'src/utils/provider.dart' hide ProviderReadExt, ProviderWatchExt;
export 'src/utils/provider_index.dart';
export 'src/utils/responsive.dart';
export 'src/utils/states_controller.dart';
export 'src/utils/text_editing_controller.dart';

typedef AnimateEffect<T> = _animate.Effect<T>;
typedef IntlTextDirection = intl.TextDirection;
