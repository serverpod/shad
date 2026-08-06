---
name: shad-overview
description: A Flutter UI library that ports shadcn/ui's components, styles, and theming. Provides accessible, fully customizable widgets (Button, Card, Form, Sidebar, and more) plus theming, layout, and typography guides. Use this skill when building a Flutter UI, implementing a design system, or looking up how to use a specific `shad` component.
---

# Shad: shadcn/ui for Flutter

`shad` ports shadcn/ui's components and design system to Flutter. Every widget is a plain, fully customizable Flutter widget, themed by one `ShadThemeData`.

Import everything through one file:

```dart
import 'package:shad/shad.dart';
```

The least obvious part of the API: use `ShadPadding` instead of Flutter's `Padding` inside a `shad`-themed page. It has no plain constructor, only `ShadPadding.all`, `.symmetric`, `.only`, and `.directional`, and their arguments are steps on the theme's spacing scale, not logical pixels — `ShadPadding.symmetric(horizontal: 6, vertical: 4)` is shadcn's `px-6 py-4`, not 6px/4px. See [layout.md](guides/layout.md#padding) for a full example.

## Guides

- [Installation](guides/installation.md): add the package, set up `ShadApp`, use a component.
- [Theming](guides/theming.md): color schemes, component theme overrides, radius, focus rings, Material/Cupertino interop.
- [Styles](guides/styles.md): the eight shadcn geometry presets (`vega`, `nova`, `maia`, `lyra`, `mira`, `luma`, `sera`, `rhea`).
- [Typography](guides/typography.md): the text role scale and how to change the font.
- [Layout](guides/layout.md): `ShadRow`, `ShadColumn`, `ShadGap`, `ShadPadding`.
- [Form](guides/form.md): `ShadForm` and the `*FormField` widgets.
- [Responsive](guides/responsive.md): the breakpoint scale, `ShadResponsiveBuilder`, `context.breakpoint`.
- [Portal](guides/portal.md): the overlay primitive behind popovers, selects, and menus.

## Components

| Name | Description | Reference |
| :--- | :--- | :--- |
| Accordion | A vertically stacked set of interactive headings that each reveal a section of content. | [accordion.md](components/accordion.md) |
| Alert | Displays a callout for user attention. | [alert.md](components/alert.md) |
| Avatar | An image element with a fallback for representing the user. | [avatar.md](components/avatar.md) |
| Badge | Displays a badge or a component that looks like a badge. | [badge.md](components/badge.md) |
| Breadcrumb | Displays the path to the current resource using a hierarchy of links. | [breadcrumb.md](components/breadcrumb.md) |
| Button | Displays a button or a component that looks like a button. Six variants share one API. | [button.md](components/button.md) |
| Calendar | A component that allows users to select dates: single, multiple, or a range. | [calendar.md](components/calendar.md) |
| Card | Displays a card with title, description, content, and footer. | [card.md](components/card.md) |
| Checkbox | A control that allows the user to toggle between checked and not checked. | [checkbox.md](components/checkbox.md) |
| Collapsible | An interactive component that expands and collapses a panel. | [collapsible.md](components/collapsible.md) |
| Command | A composable command menu with filtering and full keyboard navigation. | [command.md](components/command.md) |
| Context Menu | Displays a menu at the pointer, triggered by a right click or a long press. | [context-menu.md](components/context-menu.md) |
| Data Table | A table with sorting, selection, filtering, and pagination, driven by a controller. | [data-table.md](components/data-table.md) |
| Date Picker | A date picker with the calendar in a popover. | [date-picker.md](components/date-picker.md) |
| Dialog | A modal window overlaid on the page, rendering the content underneath inert. | [dialog.md](components/dialog.md) |
| Empty | A placeholder for an empty state: icon, title, description, and actions. | [empty.md](components/empty.md) |
| Icon Button | A square button holding a single icon. | [icon-button.md](components/icon-button.md) |
| Input | Displays a form input field. | [input.md](components/input.md) |
| Input OTP | A one-time password input with copy-paste support. | [input-otp.md](components/input-otp.md) |
| Kbd | Displays a keyboard key or chord. | [kbd.md](components/kbd.md) |
| Keyboard Toolbar | A toolbar shown above the software keyboard on mobile, with focus navigation and a done button. | [keyboard-toolbar.md](components/keyboard-toolbar.md) |
| Menubar | A visually persistent menu, common in desktop applications. | [menubar.md](components/menubar.md) |
| Pagination | Page navigation with previous and next links, plus a compact variant for toolbars and table footers. | [pagination.md](components/pagination.md) |
| Popover | Displays rich content in a portal, triggered by a button. | [popover.md](components/popover.md) |
| Progress | An indicator that shows how much of a task is complete. | [progress.md](components/progress.md) |
| Radio Group | A set of checkable buttons where only one can be checked at a time. | [radio-group.md](components/radio-group.md) |
| Resizable | Resizable panel groups and layouts, with nesting and drag handles. | [resizable.md](components/resizable.md) |
| Select | Displays a list of options for the user to pick from, triggered by a button. | [select.md](components/select.md) |
| Separator | Visually or semantically separates content. | [separator.md](components/separator.md) |
| Sheet | Extends the dialog to display content that complements the main content of the screen, sliding in from any edge. | [sheet.md](components/sheet.md) |
| Sidebar | A composable, collapsible side navigation panel: icon rail, off-canvas, floating, or inset, with a mobile sheet fallback. | [sidebar.md](components/sidebar.md) |
| Skeleton | A placeholder to show while content is loading. | [skeleton.md](components/skeleton.md) |
| Slider | An input where the user selects a value from within a given range. | [slider.md](components/slider.md) |
| Sonner | An opinionated toast stack: notifications collect and expand on hover. | [sonner.md](components/sonner.md) |
| Spinner | An animated loading indicator. | [spinner.md](components/spinner.md) |
| Switch | A control that allows the user to toggle between checked and not checked. | [switch.md](components/switch.md) |
| Table | A responsive table component with header and footer rows. | [table.md](components/table.md) |
| Tabs | A set of layered sections of content displayed one at a time. | [tabs.md](components/tabs.md) |
| Textarea | A multi-line text input, optionally user-resizable. | [textarea.md](components/textarea.md) |
| Time Picker | A field for entering a time of day. | [time-picker.md](components/time-picker.md) |
| Toast | A succinct message that is displayed temporarily. | [toast.md](components/toast.md) |
| Toggle | A two-state button that can be either on or off. | [toggle.md](components/toggle.md) |
| Toggle Group | A set of two-state buttons that can be toggled on or off. | [toggle-group.md](components/toggle-group.md) |
| Tooltip | A popup that displays information related to an element on hover or focus. | [tooltip.md](components/tooltip.md) |

Each component page shows the actual example source bundled with the example app, so it cannot drift from the code that runs.

## Basic setup

A complete counter app with light and dark theme support:

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadZincColorScheme.light(),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadZincColorScheme.dark(),
      ),
      themeMode: ThemeMode.system,
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have pushed the button this many times:',
              style: theme.textTheme.muted,
            ),
            Text('$_counter', style: theme.textTheme.h1),
            const SizedBox(height: 16),
            ShadButton(
              onPressed: () => setState(() => _counter++),
              child: const Icon(LucideIcons.plus),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Packages re-exported by shad

`shad`'s public API (`package:shad/shad.dart`) re-exports the parts of a few libraries that its own component signatures depend on, so callers do not need a second dependency just to pass an argument `shad` asks for.

- [flutter_animate](https://pub.dev/packages/flutter_animate): the `effects:` parameter on `ShadPopover`, `ShadSelect`, `ShadAccordion`, `ShadMenubar`, and similar components takes a `List<Effect>` (aliased as `AnimateEffect`).
- [lucide_icons_flutter](https://pub.dev/packages/lucide_icons_flutter): the icon set used throughout the library and its examples, exposed as `LucideIcons.*`. Browse the icons [here](https://lucide.dev/icons/).
- [two_dimensional_scrollables](https://pub.dev/packages/two_dimensional_scrollables): `ShadTable` builds on `TableView`, so `ShadTableCell` extends its `TableViewCell`.
- [intl](https://pub.dev/packages/intl): `DateFormat` and `NumberFormat` are used by the calendar, date picker, and pagination widgets.
