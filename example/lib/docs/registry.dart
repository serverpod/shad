import 'package:example/docs/docs.dart';
import 'package:example/docs/pages/accordion.dart';
import 'package:example/docs/pages/installation.dart';
import 'package:example/docs/pages/introduction.dart';
import 'package:example/docs/pages/responsive.dart';
import 'package:example/docs/pages/styles.dart';
import 'package:example/docs/pages/theming.dart';
import 'package:example/docs/pages/alert.dart';
import 'package:example/docs/pages/avatar.dart';
import 'package:example/docs/pages/badge.dart';
import 'package:example/docs/pages/breadcrumb.dart';
import 'package:example/docs/pages/button.dart';
import 'package:example/docs/pages/calendar.dart';
import 'package:example/docs/pages/card.dart';
import 'package:example/docs/pages/checkbox.dart';
import 'package:example/docs/pages/collapsible.dart';
import 'package:example/docs/pages/command.dart';
import 'package:example/docs/pages/context_menu.dart';
import 'package:example/docs/pages/data_table.dart';
import 'package:example/docs/pages/date_picker.dart';
import 'package:example/docs/pages/dialog.dart';
import 'package:example/docs/pages/empty.dart';
import 'package:example/docs/pages/form.dart';
import 'package:example/docs/pages/icon_button.dart';
import 'package:example/docs/pages/input.dart';
import 'package:example/docs/pages/input_otp.dart';
import 'package:example/docs/pages/kbd.dart';
import 'package:example/docs/pages/keyboard_toolbar.dart';
import 'package:example/docs/pages/layout.dart';
import 'package:example/docs/pages/menubar.dart';
import 'package:example/docs/pages/pagination.dart';
import 'package:example/docs/pages/popover.dart';
import 'package:example/docs/pages/portal.dart';
import 'package:example/docs/pages/progress.dart';
import 'package:example/docs/pages/radio_group.dart';
import 'package:example/docs/pages/resizable.dart';
import 'package:example/docs/pages/select.dart';
import 'package:example/docs/pages/separator.dart';
import 'package:example/docs/pages/sheet.dart';
import 'package:example/docs/pages/sidebar.dart';
import 'package:example/docs/pages/skeleton.dart';
import 'package:example/docs/pages/slider.dart';
import 'package:example/docs/pages/sonner.dart';
import 'package:example/docs/pages/spinner.dart';
import 'package:example/docs/pages/switch.dart';
import 'package:example/docs/pages/table.dart';
import 'package:example/docs/pages/tabs.dart';
import 'package:example/docs/pages/textarea.dart';
import 'package:example/docs/pages/time_picker.dart';
import 'package:example/docs/pages/toast.dart';
import 'package:example/docs/pages/toggle.dart';
import 'package:example/docs/pages/toggle_group.dart';
import 'package:example/docs/pages/tooltip.dart';
import 'package:example/docs/pages/typography.dart';

/// Every documented page, in the order the sidebar shows them.
final docGroups = <DocGroup>[
  DocGroup(
    title: 'Getting started',
    items: [
      introductionDoc,
      installationDoc,
      themingDoc,
      stylesDoc,
    ],
  ),
  DocGroup(
    title: 'Foundations',
    items: [
      typographyDoc,
      layoutDoc,
      responsiveDoc,
      formDoc,
      portalDoc,
    ],
  ),
  DocGroup(
    title: 'Components',
    items: [
      accordionDoc,
      alertDoc,
      avatarDoc,
      badgeDoc,
      breadcrumbDoc,
      buttonDoc,
      calendarDoc,
      cardDoc,
      checkboxDoc,
      collapsibleDoc,
      commandDoc,
      contextMenuDoc,
      dataTableDoc,
      datePickerDoc,
      dialogDoc,
      emptyDoc,
      iconButtonDoc,
      inputDoc,
      inputOtpDoc,
      kbdDoc,
      keyboardToolbarDoc,
      menubarDoc,
      paginationDoc,
      popoverDoc,
      progressDoc,
      radioGroupDoc,
      resizableDoc,
      selectDoc,
      separatorDoc,
      sheetDoc,
      sidebarDoc,
      skeletonDoc,
      sliderDoc,
      sonnerDoc,
      spinnerDoc,
      switchDoc,
      tableDoc,
      tabsDoc,
      textareaDoc,
      timePickerDoc,
      toastDoc,
      toggleDoc,
      toggleGroupDoc,
      tooltipDoc,
    ],
  ),
];
