import 'package:disco/disco.dart';
import 'package:example/common/app_bar.dart';
import 'package:example/common/extensions.dart';
import 'package:example/pages/accordion.dart';
import 'package:example/pages/alert.dart';
import 'package:example/pages/avatar.dart';
import 'package:example/pages/badge.dart';
import 'package:example/pages/breadcrumb.dart';
import 'package:example/pages/button.dart';
import 'package:example/pages/calendar.dart';
import 'package:example/pages/card.dart';
import 'package:example/pages/checkbox.dart';
import 'package:example/pages/checkbox_form_field.dart';
import 'package:example/pages/collapsible.dart';
import 'package:example/pages/command.dart';
import 'package:example/pages/context_menu.dart';
import 'package:example/pages/data_table.dart';
import 'package:example/pages/date_picker.dart';
import 'package:example/pages/date_picker_form_field.dart';
import 'package:example/pages/dialog.dart';
import 'package:example/pages/empty.dart';
import 'package:example/pages/icon_button.dart';
import 'package:example/pages/input.dart';
import 'package:example/pages/input_form_field.dart';
import 'package:example/pages/input_otp.dart';
import 'package:example/pages/input_otp_form_field.dart';
import 'package:example/pages/kbd.dart';
import 'package:example/pages/layout.dart';
import 'package:example/pages/keyboard_toolbar.dart';
import 'package:example/pages/menubar.dart';
import 'package:example/pages/pagination.dart';
import 'package:example/pages/popover.dart';
import 'package:example/pages/portal.dart';
import 'package:example/pages/progress.dart';
import 'package:example/pages/radio_group.dart';
import 'package:example/pages/radio_group_form_field.dart';
import 'package:example/pages/resizable.dart';
import 'package:example/pages/select.dart';
import 'package:example/pages/select_form_field.dart';
import 'package:example/pages/separator.dart';
import 'package:example/pages/sheet.dart';
import 'package:example/pages/skeleton.dart';
import 'package:example/pages/slider.dart';
import 'package:example/pages/sonner.dart';
import 'package:example/pages/spinner.dart';
import 'package:example/pages/switch.dart';
import 'package:example/pages/switch_form_field.dart';
import 'package:example/pages/table.dart';
import 'package:example/pages/tabs.dart';
import 'package:example/pages/textarea.dart';
import 'package:example/pages/textarea_form_field.dart';
import 'package:example/pages/theme_editor.dart';
import 'package:example/pages/time_picker.dart';
import 'package:example/pages/time_picker_form_field.dart';
import 'package:example/pages/toast.dart';
import 'package:example/pages/toggle.dart';
import 'package:example/pages/toggle_group.dart';
import 'package:example/pages/tooltip.dart';
import 'package:example/pages/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  SolidartConfig.devToolsEnabled = false;
  runApp(const App());
}

// Maps the routes to the specific widget page.
final routes = <String, WidgetBuilder>{
  '/accordion': (_) => const AccordionPage(),
  '/alert': (_) => const AlertPage(),
  '/avatar': (_) => const AvatarPage(),
  '/badge': (_) => const BadgePage(),
  '/breadcrumb': (_) => const BreadcrumbPage(),
  '/button': (_) => const ButtonPage(),
  '/calendar': (_) => const CalendarPage(),
  '/card': (_) => const CardPage(),
  '/checkbox': (_) => const CheckboxPage(),
  '/checkbox-form-field': (_) => const CheckboxFormFieldPage(),
  '/collapsible': (_) => const CollapsiblePage(),
  '/command': (_) => const CommandPage(),
  '/context-menu': (_) => const ContextMenuPage(),
  '/date-picker': (_) => const DatePickerPage(),
  '/date-picker-form-field': (_) => const DatePickerFormFieldPage(),
  '/data-table': (_) => const DataTablePage(),
  '/dialog': (_) => const DialogPage(),
  '/empty': (_) => const EmptyPage(),
  '/divider': (_) => const SeparatorPage(),
  '/icon-button': (_) => const IconButtonPage(),
  '/input': (_) => const InputPage(),
  '/input-OTP': (_) => const InputOTPPage(),
  '/input-OTP-form-field': (_) => const InputOTPFormFieldPage(),
  '/input-form-field': (_) => const InputFormFieldPage(),
  '/kbd': (_) => const KbdPage(),
  '/keyboard-toolbar': (_) => const KeyboardToolbarPage(),
  '/layout': (_) => const LayoutPage(),
  '/menubar': (_) => const MenubarPage(),
  '/popover': (_) => const PopoverPage(),
  '/pagination': (_) => const PaginationPage(),
  '/portal': (_) => const ShadPortalPage(),
  '/progress': (_) => const ProgressPage(),
  '/radio-group': (_) => const RadioPage(),
  '/radio-group-form-field': (_) => const RadioGroupFormFieldPage(),
  '/resizable': (_) => const ResizablePage(),
  '/select': (_) => const SelectPage(),
  '/select-form-field': (_) => const SelectFormFieldPage(),
  '/sheet': (_) => const SheetPage(),
  '/slider': (_) => const SliderPage(),
  '/sonner': (_) => const SonnerPage(),
  '/skeleton': (_) => const SkeletonPage(),
  '/spinner': (_) => const SpinnerPage(),
  '/switch': (_) => const SwitchPage(),
  '/switch-form-field': (_) => const SwitchFormFieldPage(),
  '/table': (_) => const TablePage(),
  '/tabs': (_) => const TabsPage(),
  '/theme-editor': (_) => const ThemeEditorPage(),
  '/textarea': (_) => const TextareaPage(),
  '/textarea-form-field': (_) => const TextareaFormFieldPage(),
  '/time-picker': (_) => const TimePickerPage(),
  '/time-picker-form-field': (_) => const TimePickerFormFieldPage(),
  '/toast': (_) => const ToastPage(),
  '/toggle': (_) => const TogglePage(),
  '/toggle-group': (_) => const ToggleGroupPage(),
  '/tooltip': (_) => const TooltipPage(),
  '/typography': (_) => const TypographyPage(),
};
final routeToNameRegex = RegExp('(?:^/|-)([a-zA-Z])');

final themeModeProvider = Provider((_) => Signal(ThemeMode.light));

final directionalityProvider = Provider((context) => Signal(TextDirection.ltr));

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      providers: [themeModeProvider, directionalityProvider],
      child: SignalBuilder(
        builder: (context, _) {
          final themeMode = themeModeProvider.of(context).value;
          final directionality = directionalityProvider.of(context).value;
          // Custom App example
          // return ShadApp.custom(
          //   themeMode: themeMode,
          //   darkTheme: ShadThemeData(
          //     brightness: Brightness.dark,
          //     colorScheme: const ShadSlateColorScheme.dark(),
          //   ),
          //   appBuilder: (context) {
          //     return MaterialApp(
          //       routes: routes,
          //       theme: Theme.of(context),
          //       home: const MainPage(),
          //       localizationsDelegates: const [
          //         GlobalShadLocalizations.delegate,
          //       ],
          //       builder: (context, child) {
          //         return Directionality(
          //           textDirection: directionality,
          //           child: ShadAppBuilder(child: child!),
          //         );
          //       },
          //     );
          //   },
          // );
          return ShadApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            routes: routes,
            theme: ShadThemeData(
              brightness: Brightness.light,
              colorScheme: const ShadZincColorScheme.light(
                // Example of adding a custom color to the color scheme
                /* 
                  custom: {
                     'myCustomColor': Color.fromARGB(255, 177, 4, 196),
                   },
                  */
              ),
              // Example with google fonts
              // textTheme: ShadTextTheme.fromGoogleFont(
              //   GoogleFonts.lavishlyYours,
              // ),

              // Example of custom font family
              // textTheme: ShadTextTheme(family: 'UbuntuMono'),

              // Example to disable the secondary border
              // disableSecondaryBorder: true,

              // Example of extending the ShadTextTheme with a new custom style and name (see `/typography` page for usage example).
              textTheme: ShadTextTheme(
                custom: {
                  'myCustomStyle': const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue,
                  ),
                },
              ),
            ),
            darkTheme: ShadThemeData(
              brightness: Brightness.dark,
              colorScheme: const ShadZincColorScheme.dark(),
              // Example of custom font family
              // textTheme: ShadTextTheme(family: 'UbuntuMono'),

              // Example of extending the ShadTextTheme with a new custom style and name (see `/typography` page for usage example).
              textTheme: ShadTextTheme(
                custom: {
                  'myCustomStyle': const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.green,
                  ),
                },
              ),
            ),
            home: const MainPage(),
            builder: (context, child) {
              return Directionality(
                textDirection: directionality,
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}

/// A featured entry point for the theme editor.
///
/// The editor is not a component demo, so it would otherwise sit unnoticed
/// between "Textarea" and "TimePicker" in the alphabetical list. It stays in
/// that list too, so searching for it still works.
class _ThemeEditorBanner extends StatelessWidget {
  const _ThemeEditorBanner();

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ShadCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: theme.radius,
              ),
              child: Icon(
                LucideIcons.palette,
                size: 20,
                color: theme.colorScheme.primaryForeground,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Theme Editor', style: theme.textTheme.large),
                  Text(
                    'Configure colours, radius, focus ring and typography '
                    'with a live preview.',
                    style: theme.textTheme.muted,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ShadButton(
              onPressed: () => Navigator.of(context).pushNamed('/theme-editor'),
              trailing: const Icon(LucideIcons.arrowRight, size: 16),
              child: const Text('Open'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final search = Signal('');

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        titleWidget: ShadInput(
          placeholder: const Text('Search ShadcnUI component'),
          onChanged: search.set,
        ),
      ),
      body: Column(
        children: [
          const _ThemeEditorBanner(),
          Expanded(child: _buildRoutesList(context)),
        ],
      ),
    );
  }

  Widget _buildRoutesList(BuildContext context) {
    return SignalBuilder(
      builder: (context, child) {
        final filteredRoutes = {
          for (final k in routes.keys.where(
            (k) => k.toLowerCase().contains(search().toLowerCase()),
          ))
            k: routes[k]!,
        };

        return ListView.builder(
          itemCount: filteredRoutes.length,
          itemBuilder: (BuildContext context, int index) {
            final route = filteredRoutes.keys.elementAt(index);

            final name = route.replaceAllMapped(
              routeToNameRegex,
              (match) => match.group(0)!.substring(1).toUpperCase(),
            );

            return Material(
              child: ListTile(
                title: Text(name),
                onTap: () {
                  Navigator.of(context).pushNamed(route);
                },
              ),
            );
          },
        );
      },
    );
  }
}
