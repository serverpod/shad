import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shad/src/components/separator.dart';
import 'package:shad/src/components/sheet.dart';
import 'package:shad/src/components/skeleton.dart';
import 'package:shad/src/components/tooltip.dart';
import 'package:shad/src/raw_components/focusable.dart';
import 'package:shad/src/raw_components/portal.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/utils/border.dart';
import 'package:shad/src/utils/debug_check.dart';
import 'package:shad/src/utils/gesture_detector.dart';

/// Which edge of the layout the sidebar sits on.
///
/// Directional: `start` is the left edge in LTR and the right edge in RTL.
enum ShadSidebarSide { start, end }

/// The visual treatment of a [ShadSidebar], mirroring shadcn/ui's `variant`.
enum ShadSidebarVariant {
  /// A full-height panel separated from the content by a hairline.
  sidebar,

  /// A detached, rounded panel floating inside the page.
  floating,

  /// The sidebar owns the page background and the *content* floats on it as
  /// a rounded card.
  inset,
}

/// How a [ShadSidebar] collapses, mirroring shadcn/ui's `collapsible`.
enum ShadSidebarCollapsible {
  /// Slides fully off-screen.
  offcanvas,

  /// Shrinks to a rail of icons.
  icon,

  /// Does not collapse.
  none,
}

/// The size of a [ShadSidebarMenuButton].
enum ShadSidebarMenuButtonSize { sm, regular, lg }

/// The visual variant of a [ShadSidebarMenuButton].
enum ShadSidebarMenuButtonVariant {
  /// Transparent until hovered.
  standard,

  /// Outlined against the page background.
  outline,
}

/// Controls the open state of a [ShadSidebar].
///
/// Desktop and mobile are independent, exactly as in shadcn/ui: [open] drives
/// the inline sidebar, [openMobile] the modal sheet shown under the
/// breakpoint.
class ShadSidebarController extends ChangeNotifier {
  ShadSidebarController({bool open = true}) : _open = open;

  bool _open;

  /// Whether the inline (desktop) sidebar is expanded.
  bool get open => _open;

  set open(bool value) {
    if (_open == value) return;
    _open = value;
    notifyListeners();
  }

  bool _openMobile = false;

  /// Whether the mobile sheet is shown.
  bool get openMobile => _openMobile;

  set openMobile(bool value) {
    if (_openMobile == value) return;
    _openMobile = value;
    notifyListeners();
  }

  /// Flips the state for the given form factor.
  void toggle({required bool isMobile}) {
    isMobile ? openMobile = !openMobile : open = !open;
  }
}

/// What a sidebar descendant needs to know about its host: the controller,
/// the form factor and the configuration of the [ShadSidebar] it sits in.
///
/// Obtained with [ShadSidebarScope.of] — [ShadSidebarTrigger] uses it to
/// toggle, menu widgets use it to render their collapsed (icon-rail) form.
class ShadSidebarScope extends InheritedWidget {
  const ShadSidebarScope({
    super.key,
    required this.controller,
    required this.isMobile,
    required this.inSheet,
    required this.open,
    required this.side,
    required this.variant,
    required this.collapsible,
    required this.collapsedWidth,
    required super.child,
  });

  final ShadSidebarController controller;

  /// Whether the host layout is below the mobile breakpoint.
  final bool isMobile;

  /// Whether this subtree renders inside the mobile sheet.
  final bool inSheet;

  /// The open state this scope was built with.
  final bool open;

  final ShadSidebarSide side;
  final ShadSidebarVariant variant;
  final ShadSidebarCollapsible collapsible;

  /// The resolved icon-rail width, so descendants shrink to the same rail the
  /// sidebar animates to even when [ShadSidebar.collapsedWidth] overrides the
  /// theme.
  final double collapsedWidth;

  /// Whether descendants should render their icon-rail form.
  bool get collapsed =>
      !inSheet && !open && collapsible == ShadSidebarCollapsible.icon;

  /// Flips the sidebar for the current form factor.
  void toggle() => controller.toggle(isMobile: isMobile);

  static ShadSidebarScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShadSidebarScope>();

  static ShadSidebarScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(
      scope != null,
      'ShadSidebarScope.of() called outside of a ShadSidebarScaffold',
    );
    return scope!;
  }

  @override
  bool updateShouldNotify(ShadSidebarScope oldWidget) =>
      controller != oldWidget.controller ||
      isMobile != oldWidget.isMobile ||
      inSheet != oldWidget.inSheet ||
      open != oldWidget.open ||
      side != oldWidget.side ||
      variant != oldWidget.variant ||
      collapsible != oldWidget.collapsible ||
      collapsedWidth != oldWidget.collapsedWidth;
}

/// {@template ShadSidebarScaffold}
/// Lays out a [ShadSidebar] next to the page content, mirroring shadcn/ui's
/// `SidebarProvider` + `SidebarInset`.
///
/// Above the `md` breakpoint the sidebar renders inline and collapses
/// according to its `collapsible` mode; below it the sidebar disappears and
/// [ShadSidebarTrigger] (or the controller) presents it as a modal sheet.
/// `⌘B`/`Ctrl+B` toggles it.
///
/// ```dart
/// ShadSidebarScaffold(
///   sidebar: ShadSidebar(
///     header: ...,
///     children: [ShadSidebarGroup(...)],
///   ),
///   child: page,
/// )
/// ```
/// {@endtemplate}
class ShadSidebarScaffold extends StatefulWidget {
  /// {@macro ShadSidebarScaffold}
  const ShadSidebarScaffold({
    super.key,
    required this.sidebar,
    required this.child,
    this.controller,
    this.defaultOpen = true,
    this.onOpenChange,
    this.keyboardShortcut = true,
    this.borderRadius,
  });

  /// The sidebar configuration and content.
  final ShadSidebar sidebar;

  /// The page content next to the sidebar.
  final Widget child;

  /// An external controller for the open state.
  ///
  /// When null an internal one is created, seeded from [defaultOpen].
  final ShadSidebarController? controller;

  /// Whether the sidebar starts open. Ignored when [controller] is set.
  final bool defaultOpen;

  /// Called whenever the desktop open state changes.
  final ValueChanged<bool>? onOpenChange;

  /// Whether `⌘B`/`Ctrl+B` toggles the sidebar.
  final bool keyboardShortcut;

  /// Rounds and clips the scaffold's corners.
  ///
  /// A scaffold usually fills the page, but one embedded in a rounded
  /// container (a demo, a card) needs its own clip or the sidebar's square
  /// surface covers the host's corners. Null means no clip at all.
  final BorderRadiusGeometry? borderRadius;

  @override
  State<ShadSidebarScaffold> createState() => _ShadSidebarScaffoldState();
}

class _ShadSidebarScaffoldState extends State<ShadSidebarScaffold> {
  ShadSidebarController? _internalController;

  ShadSidebarController get controller =>
      widget.controller ?? _internalController!;

  late bool _lastOpen;
  bool _sheetShowing = false;

  /// The mobile drawer's route, captured when it is shown so it can be
  /// dismissed precisely — popping blindly would take down whatever the user
  /// pushed on top of it — and removed if this scaffold is disposed first.
  ModalRoute<void>? _sheetRoute;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = ShadSidebarController(open: widget.defaultOpen);
    }
    _lastOpen = controller.open;
    controller.addListener(_onControllerChanged);
    if (widget.keyboardShortcut) {
      HardwareKeyboard.instance.addHandler(_onKeyEvent);
    }
  }

  @override
  void didUpdateWidget(ShadSidebarScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      (oldWidget.controller ?? _internalController)?.removeListener(
        _onControllerChanged,
      );
      controller.addListener(_onControllerChanged);
    }
    if (widget.keyboardShortcut != oldWidget.keyboardShortcut) {
      widget.keyboardShortcut
          ? HardwareKeyboard.instance.addHandler(_onKeyEvent)
          : HardwareKeyboard.instance.removeHandler(_onKeyEvent);
    }
  }

  @override
  void dispose() {
    if (widget.keyboardShortcut) {
      HardwareKeyboard.instance.removeHandler(_onKeyEvent);
    }
    controller.removeListener(_onControllerChanged);
    // The drawer is a pushed route, so it would outlive its scaffold — the
    // reference unmounts it with the provider. Removed post-frame, since
    // dispose runs mid-teardown when the navigator cannot be mutated.
    final route = _sheetRoute;
    if (route != null && route.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (route.isActive) route.navigator?.removeRoute(route);
      });
    }
    _internalController?.dispose();
    super.dispose();
  }

  bool get _isMobile {
    final breakpoints = ShadTheme.of(context).breakpoints;
    return MediaQuery.sizeOf(context).width < breakpoints.md.value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The reference renders the sheet only in its mobile branch, so growing
    // past the breakpoint unmounts it. Here it is a pushed route, which has
    // to be popped explicitly — after the frame, since this runs mid-build.
    if (!_isMobile && controller.openMobile) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_isMobile && controller.openMobile) {
          controller.openMobile = false;
        }
      });
    }
  }

  /// The icon-rail width, resolved the same way [ShadSidebar] resolves it.
  double get _collapsedWidth =>
      widget.sidebar.collapsedWidth ??
      ShadTheme.of(context).sidebarTheme.collapsedWidth ??
      48;

  bool _onKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (event.logicalKey != LogicalKeyboardKey.keyB) return false;
    final pressed = HardwareKeyboard.instance;
    if (!pressed.isMetaPressed && !pressed.isControlPressed) return false;
    controller.toggle(isMobile: _isMobile);
    return true;
  }

  void _onControllerChanged() {
    if (controller.open != _lastOpen) {
      _lastOpen = controller.open;
      widget.onOpenChange?.call(controller.open);
    }
    _syncMobileSheet();
    if (mounted) setState(() {});
  }

  void _syncMobileSheet() {
    if (!mounted) return;
    if (controller.openMobile && !_sheetShowing) {
      _sheetShowing = true;
      _showMobileSheet();
    } else if (!controller.openMobile && _sheetShowing) {
      _sheetShowing = false;
      final route = _sheetRoute;
      if (route != null && route.isActive) {
        // Animate out when the drawer is on top; remove silently when
        // something else is (its exit animation would play under the
        // covering route anyway).
        route.isCurrent
            ? route.navigator!.pop()
            : route.navigator!.removeRoute(route);
      }
    }
  }

  void _showMobileSheet() {
    final sidebar = widget.sidebar;
    final theme = ShadTheme.of(context).sidebarTheme;
    final effectiveMobileWidth =
        sidebar.mobileWidth ?? theme.mobileWidth ?? 288;
    final textDirection = Directionality.of(context);
    final sheetSide = switch ((sidebar.side, textDirection)) {
      (ShadSidebarSide.start, TextDirection.ltr) => ShadSheetSide.left,
      (ShadSidebarSide.start, TextDirection.rtl) => ShadSheetSide.right,
      (ShadSidebarSide.end, TextDirection.ltr) => ShadSheetSide.right,
      (ShadSidebarSide.end, TextDirection.rtl) => ShadSheetSide.left,
    };
    // The route can outlive this State (dispose removes it a frame later),
    // and its builder re-runs on MediaQuery changes in the meantime — so
    // everything it needs is captured here rather than read through `this`,
    // whose `context` and `widget` are gone after unmount.
    final controller = this.controller;
    final collapsedWidth = _collapsedWidth;
    showShadSheet<void>(
      context: context,
      side: sheetSide,
      builder: (sheetContext) {
        _sheetRoute = ModalRoute.of(sheetContext);
        return ShadSidebarScope(
          controller: controller,
          isMobile: true,
          inSheet: true,
          open: true,
          side: sidebar.side,
          variant: sidebar.variant,
          collapsible: sidebar.collapsible,
          collapsedWidth: collapsedWidth,
          child: ShadSheet(
            padding: EdgeInsets.zero,
            gap: 0,
            closeIcon: const SizedBox.shrink(),
            // The sidebar owns its scrolling; the sheet's own scroll view
            // would hand it unbounded height and break its Expanded column.
            scrollable: false,
            backgroundColor:
                sidebar.backgroundColor ??
                ShadTheme.of(sheetContext).sidebarTheme.backgroundColor,
            constraints: BoxConstraints.tightFor(width: effectiveMobileWidth),
            child: sidebar,
          ),
        );
      },
    ).whenComplete(() {
      // Runs for every way the route can go away — barrier tap, system back,
      // controller, dispose cleanup — so this is where the state resyncs.
      _sheetShowing = false;
      _sheetRoute = null;
      if (mounted && controller.openMobile) controller.openMobile = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasShadTheme(context));
    final theme = ShadTheme.of(context);
    final sidebarTheme = theme.sidebarTheme;
    final sidebar = widget.sidebar;
    final isMobile = _isMobile;
    final open = controller.open;

    var content = widget.child;

    if (sidebar.variant == ShadSidebarVariant.inset && !isMobile) {
      final margin = (sidebarTheme.insetMargin ?? const EdgeInsets.all(8))
          .resolve(
            Directionality.of(context),
          );
      final collapsed = !open;
      // `m-2 ml-0`, except the start margin comes back when the sidebar is
      // fully collapsed (`peer-data-[state=collapsed]:ml-2` with offcanvas).
      final restoreStart =
          collapsed && sidebar.collapsible == ShadSidebarCollapsible.offcanvas;
      content = Container(
        margin: EdgeInsetsDirectional.only(
          start: restoreStart ? margin.left : 0,
          end: margin.right,
          top: margin.top,
          bottom: margin.bottom,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: sidebarTheme.insetRadius,
          boxShadow: sidebarTheme.insetShadows,
        ),
        child: content,
      );
      content = ColoredBox(
        color: sidebarTheme.backgroundColor ?? theme.colorScheme.sidebar,
        child: content,
      );
    }

    // The rail only accompanies the icon collapse: with offcanvas the edge
    // disappears along with the panel, so there is nothing to grab.
    if (!isMobile &&
        sidebar.rail &&
        sidebar.collapsible == ShadSidebarCollapsible.icon) {
      content = Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: content),
          PositionedDirectional(
            top: 0,
            bottom: 0,
            start: sidebar.side == ShadSidebarSide.start ? -8 : null,
            end: sidebar.side == ShadSidebarSide.end ? -8 : null,
            width: 16,
            child: const _ShadSidebarRail(),
          ),
        ],
      );
    }

    Widget body;
    if (isMobile) {
      body = content;
    } else {
      body = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: switch (sidebar.side) {
          ShadSidebarSide.start => [sidebar, Expanded(child: content)],
          ShadSidebarSide.end => [Expanded(child: content), sidebar],
        },
      );
    }

    if (widget.borderRadius != null) {
      body = ClipRRect(borderRadius: widget.borderRadius!, child: body);
    }

    return ShadSidebarScope(
      controller: controller,
      isMobile: isMobile,
      inSheet: false,
      open: open,
      side: sidebar.side,
      variant: sidebar.variant,
      collapsible: sidebar.collapsible,
      collapsedWidth: _collapsedWidth,
      child: body,
    );
  }
}

/// {@template ShadSidebar}
/// A composable, collapsible side navigation panel.
///
/// Mirrors shadcn/ui's `Sidebar`. Always used inside a [ShadSidebarScaffold],
/// which owns the open state and the responsive behaviour. Content is composed
/// from [ShadSidebarGroup]s of [ShadSidebarMenu]s, with optional [header] and
/// [footer] slots pinned outside the scrollable area.
/// {@endtemplate}
class ShadSidebar extends StatelessWidget {
  /// {@macro ShadSidebar}
  const ShadSidebar({
    super.key,
    this.side = ShadSidebarSide.start,
    this.variant = ShadSidebarVariant.sidebar,
    this.collapsible = ShadSidebarCollapsible.offcanvas,
    this.header,
    this.footer,
    this.children = const [],
    this.rail = false,
    this.width,
    this.collapsedWidth,
    this.mobileWidth,
    this.backgroundColor,
    this.borderColor,
    this.scrollController,
  });

  final ShadSidebarSide side;
  final ShadSidebarVariant variant;
  final ShadSidebarCollapsible collapsible;

  /// Pinned above the scrollable content, shadcn's `SidebarHeader`.
  final Widget? header;

  /// Pinned below the scrollable content, shadcn's `SidebarFooter`.
  final Widget? footer;

  /// The scrollable content, typically [ShadSidebarGroup]s.
  final List<Widget> children;

  /// Whether the sidebar shows a grab rail on its inner edge that toggles
  /// it, shadcn/ui's `SidebarRail`: the edge highlights under the pointer,
  /// shows a resize cursor, and a click collapses or expands the sidebar.
  ///
  /// Only takes effect with [ShadSidebarCollapsible.icon] — with the other
  /// modes the edge leaves the screen together with the panel.
  final bool rail;

  /// {@template ShadSidebar.width}
  /// The expanded width, shadcn's `--sidebar-width` (16rem).
  /// {@endtemplate}
  final double? width;

  /// {@template ShadSidebar.collapsedWidth}
  /// The icon-rail width, shadcn's `--sidebar-width-icon` (3rem).
  /// {@endtemplate}
  final double? collapsedWidth;

  /// {@template ShadSidebar.mobileWidth}
  /// The width of the mobile sheet, shadcn's 18rem.
  /// {@endtemplate}
  final double? mobileWidth;

  /// {@template ShadSidebar.backgroundColor}
  /// The surface colour, defaults to the scheme's `sidebar`.
  /// {@endtemplate}
  final Color? backgroundColor;

  /// {@template ShadSidebar.borderColor}
  /// The hairline colour, defaults to the scheme's `sidebarBorder`.
  /// {@endtemplate}
  final Color? borderColor;

  /// {@template ShadSidebar.scrollController}
  /// Controls the scrollable content area — the region holding [children],
  /// between [header] and [footer].
  ///
  /// Attach one to drive the sidebar's scroll position from outside: restore
  /// it, jump to the top, or bring a section into view (pairs with
  /// `Scrollable.ensureVisible` on a key inside the content).
  /// {@endtemplate}
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasShadTheme(context));
    final theme = ShadTheme.of(context);
    final sidebarTheme = theme.sidebarTheme;
    final scope = ShadSidebarScope.of(context);

    final effectiveBackgroundColor =
        backgroundColor ??
        sidebarTheme.backgroundColor ??
        theme.colorScheme.sidebar;
    final effectiveForegroundColor =
        sidebarTheme.foregroundColor ?? theme.colorScheme.sidebarForeground;
    final effectiveBorderColor =
        borderColor ??
        sidebarTheme.borderColor ??
        theme.colorScheme.sidebarBorder;
    final effectiveWidth = width ?? sidebarTheme.width ?? 256;
    final effectiveCollapsedWidth =
        collapsedWidth ?? sidebarTheme.collapsedWidth ?? 48;
    final duration = sidebarTheme.duration ?? const Duration(milliseconds: 200);
    final curve = sidebarTheme.curve ?? Curves.linear;

    final column = _SidebarColumn(
      header: header,
      footer: footer,
      scrollController: scrollController,
      children: children,
    );

    // Base text and icon treatment for everything inside.
    var content = DefaultTextStyle.merge(
      style: TextStyle(color: effectiveForegroundColor),
      child: IconTheme.merge(
        data: IconThemeData(
          size: sidebarTheme.iconSize ?? 16,
          color: effectiveForegroundColor,
        ),
        child: column,
      ),
    );

    // Inside the mobile sheet the sidebar is just its column on its surface.
    if (scope.inSheet) {
      return ColoredBox(color: effectiveBackgroundColor, child: content);
    }

    final floating = variant == ShadSidebarVariant.floating;
    final floatingMargin =
        (sidebarTheme.floatingMargin ?? const EdgeInsets.all(8)).resolve(
          Directionality.of(context),
        );

    // The icon rail keeps the content laid out at the expanded width and lets
    // the animated container clip it — the same overflow-hidden semantics the
    // reference gets from CSS. A header that doesn't fit the rail truncates
    // at the clip edge instead of throwing a RenderFlex overflow; the widgets
    // that *should* shrink (menu buttons) do so themselves via
    // `scope.collapsed`, independent of the width they are laid out at.
    if (collapsible == ShadSidebarCollapsible.icon) {
      final innerWidth =
          effectiveWidth - (floating ? floatingMargin.horizontal : 0);
      content = OverflowBox(
        minWidth: innerWidth,
        maxWidth: innerWidth,
        alignment: AlignmentDirectional.centerStart,
        child: content,
      );
    }

    switch (variant) {
      case ShadSidebarVariant.sidebar:
        content = DecoratedBox(
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            border: BorderDirectional(
              start: side == ShadSidebarSide.end
                  ? BorderSide(color: effectiveBorderColor)
                  : BorderSide.none,
              end: side == ShadSidebarSide.start
                  ? BorderSide(color: effectiveBorderColor)
                  : BorderSide.none,
            ),
          ),
          child: content,
        );
      case ShadSidebarVariant.floating:
        content = Padding(
          padding: floatingMargin,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: effectiveBackgroundColor,
              borderRadius: sidebarTheme.floatingRadius,
              border: Border.all(color: effectiveBorderColor),
              boxShadow: sidebarTheme.floatingShadows,
            ),
            child: content,
          ),
        );
      case ShadSidebarVariant.inset:
        content = ColoredBox(
          color: effectiveBackgroundColor,
          child: content,
        );
    }

    final open = scope.open;
    final double targetWidth;
    if (collapsible == ShadSidebarCollapsible.none || open) {
      targetWidth = effectiveWidth;
    } else {
      targetWidth = switch (collapsible) {
        ShadSidebarCollapsible.offcanvas => 0,
        // Floating and inset keep their outer margin around the icon rail:
        // `w-[calc(var(--sidebar-width-icon)+(--spacing(4)))]`.
        ShadSidebarCollapsible.icon =>
          effectiveCollapsedWidth +
              (floating || variant == ShadSidebarVariant.inset
                  ? floatingMargin.horizontal
                  : 0),
        ShadSidebarCollapsible.none => effectiveWidth,
      };
    }

    // Offcanvas slides the fixed-width panel out; anchoring it to the inner
    // edge clips the outer part first, like the reference's `left: -width`.
    // Icon mode instead re-lays the content out at the animated width.
    if (collapsible == ShadSidebarCollapsible.offcanvas) {
      content = OverflowBox(
        minWidth: effectiveWidth,
        maxWidth: effectiveWidth,
        alignment: side == ShadSidebarSide.start
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: content,
      );
    }

    return AnimatedContainer(
      duration: duration,
      curve: curve,
      width: targetWidth,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: content,
    );
  }
}

class _SidebarColumn extends StatelessWidget {
  const _SidebarColumn({
    required this.header,
    required this.footer,
    required this.scrollController,
    required this.children,
  });

  final Widget? header;
  final Widget? footer;
  final ScrollController? scrollController;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final sidebarTheme = ShadTheme.of(context).sidebarTheme;
    final contentGap = sidebarTheme.contentGap ?? 8;

    final spaced = <Widget>[
      for (var i = 0; i < children.length; i++) ...[
        if (i > 0) SizedBox(height: contentGap),
        children[i],
      ],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null)
          Padding(
            padding: sidebarTheme.headerPadding ?? const EdgeInsets.all(8),
            child: header,
          ),
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: spaced,
            ),
          ),
        ),
        if (footer != null)
          Padding(
            padding: sidebarTheme.footerPadding ?? const EdgeInsets.all(8),
            child: footer,
          ),
      ],
    );
  }
}

/// A ghost icon button that toggles the enclosing sidebar, shadcn/ui's
/// `SidebarTrigger`.
class ShadSidebarTrigger extends StatefulWidget {
  const ShadSidebarTrigger({super.key, this.icon, this.onPressed});

  /// The icon, defaults to `PanelLeft`.
  final Widget? icon;

  /// Called before the sidebar is toggled.
  final VoidCallback? onPressed;

  @override
  State<ShadSidebarTrigger> createState() => _ShadSidebarTriggerState();
}

class _ShadSidebarTriggerState extends State<ShadSidebarTrigger> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final scope = ShadSidebarScope.of(context);
    return Semantics(
      button: true,
      label: 'Toggle sidebar',
      child: ShadGestureDetector(
        cursor: SystemMouseCursors.click,
        onHoverChange: (value) => setState(() => hovered = value),
        onTap: () {
          widget.onPressed?.call();
          scope.toggle();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: hovered ? theme.colorScheme.accent : null,
            borderRadius: theme.radii.sm,
          ),
          child: IconTheme.merge(
            data: IconThemeData(
              size: 16,
              color: hovered
                  ? theme.colorScheme.accentForeground
                  : theme.colorScheme.foreground,
            ),
            child: Center(
              child: widget.icon ?? const Icon(LucideIcons.panelLeft),
            ),
          ),
        ),
      ),
    );
  }
}

/// The grab strip on the sidebar's inner edge, shadcn/ui's `SidebarRail`.
class _ShadSidebarRail extends StatefulWidget {
  const _ShadSidebarRail();

  @override
  State<_ShadSidebarRail> createState() => _ShadSidebarRailState();
}

class _ShadSidebarRailState extends State<_ShadSidebarRail> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final scope = ShadSidebarScope.of(context);
    final borderColor =
        theme.sidebarTheme.borderColor ?? theme.colorScheme.sidebarBorder;

    // The cursor points where clicking will move the edge, like the
    // reference: `[[data-side=left]_&]:cursor-w-resize` flipping to
    // `e-resize` when collapsed, and mirrored on the right side.
    final onLeft =
        (scope.side == ShadSidebarSide.start) ==
        (Directionality.of(context) == TextDirection.ltr);
    final cursor = onLeft == scope.open
        ? SystemMouseCursors.resizeLeft
        : SystemMouseCursors.resizeRight;

    return ShadGestureDetector(
      cursor: cursor,
      // The whole strip toggles, not just the 2px line it highlights —
      // deferring to the child left everything but the hairline untappable.
      behavior: HitTestBehavior.opaque,
      onHoverChange: (value) => setState(() => hovered = value),
      onTap: scope.toggle,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 2,
          height: double.infinity,
          color: hovered ? borderColor : const Color(0x00000000),
        ),
      ),
    );
  }
}

/// {@template ShadSidebarGroup}
/// A titled section of sidebar content, shadcn/ui's `SidebarGroup` +
/// `SidebarGroupLabel` + `SidebarGroupContent`.
/// {@endtemplate}
class ShadSidebarGroup extends StatelessWidget {
  /// {@macro ShadSidebarGroup}
  const ShadSidebarGroup({
    super.key,
    this.label,
    this.action,
    required this.children,
  });

  /// The group heading; fades out in the icon rail.
  final Widget? label;

  /// A small trailing control on the heading row, shadcn's
  /// `SidebarGroupAction`.
  final Widget? action;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final sidebarTheme = ShadTheme.of(context).sidebarTheme;
    final scope = ShadSidebarScope.of(context);
    final collapsed = scope.collapsed;

    final labelHeight = sidebarTheme.groupLabelHeight ?? 32;
    final duration = sidebarTheme.duration ?? const Duration(milliseconds: 200);
    final curve = sidebarTheme.curve ?? Curves.linear;

    return Padding(
      padding: sidebarTheme.groupPadding ?? const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (label != null)
            // `-mt-8 opacity-0`: the label slides away and the menu below
            // takes its place.
            AnimatedContainer(
              duration: duration,
              curve: curve,
              height: collapsed ? 0 : labelHeight,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: AnimatedOpacity(
                duration: duration,
                curve: curve,
                opacity: collapsed ? 0 : 1,
                child: OverflowBox(
                  minHeight: labelHeight,
                  maxHeight: labelHeight,
                  alignment: Alignment.bottomCenter,
                  child: _GroupLabelRow(label: label!, action: action),
                ),
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}

class _GroupLabelRow extends StatelessWidget {
  const _GroupLabelRow({required this.label, this.action});

  final Widget label;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final sidebarTheme = theme.sidebarTheme;
    final labelStyle =
        sidebarTheme.groupLabelTextStyle ?? theme.textTheme.muted;

    return Padding(
      padding:
          sidebarTheme.groupLabelPadding ??
          const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: DefaultTextStyle.merge(
              style: labelStyle,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.clip,
              child: label,
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}

/// A vertical list of menu rows, shadcn/ui's `SidebarMenu`.
class ShadSidebarMenu extends StatelessWidget {
  const ShadSidebarMenu({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final gap = ShadTheme.of(context).sidebarTheme.menuGap ?? 4;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    );
  }
}

/// {@template ShadSidebarMenuButton}
/// A row in a sidebar menu, shadcn/ui's `SidebarMenuButton`.
///
/// Renders an icon, a label and an optional trailing widget; highlights with
/// the sidebar accent on hover, press and when [isActive]. In the icon rail
/// it shrinks to a square and, when [tooltip] is given, shows the label as a
/// tooltip instead.
/// {@endtemplate}
class ShadSidebarMenuButton extends StatefulWidget {
  /// {@macro ShadSidebarMenuButton}
  const ShadSidebarMenuButton({
    super.key,
    this.onPressed,
    this.leading,
    required this.child,
    this.trailing,
    this.isActive = false,
    this.size = ShadSidebarMenuButtonSize.regular,
    this.variant = ShadSidebarMenuButtonVariant.standard,
    this.tooltip,
    this.focusNode,
    this.enabled = true,
  });

  final VoidCallback? onPressed;

  /// The icon at the start of the row.
  final Widget? leading;

  /// The label. Clipped, not wrapped, when space runs out.
  final Widget child;

  /// A badge or action at the end of the row; hidden in the icon rail.
  final Widget? trailing;

  /// Whether this row is the current one; keeps the accent highlight.
  final bool isActive;

  final ShadSidebarMenuButtonSize size;

  final ShadSidebarMenuButtonVariant variant;

  /// Shown next to the icon rail when collapsed.
  final String? tooltip;

  final FocusNode? focusNode;

  final bool enabled;

  /// {@template ShadSidebarMenuButton.height}
  /// Height of a menu button, shadcn's `h-8`.
  /// {@endtemplate}
  @override
  State<ShadSidebarMenuButton> createState() => _ShadSidebarMenuButtonState();
}

class _ShadSidebarMenuButtonState extends State<ShadSidebarMenuButton> {
  bool hovered = false;
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final sidebarTheme = theme.sidebarTheme;
    final scope = ShadSidebarScope.of(context);
    final collapsed = scope.collapsed;

    final duration = sidebarTheme.duration ?? const Duration(milliseconds: 200);
    final curve = sidebarTheme.curve ?? Curves.linear;

    final expandedHeight = switch (widget.size) {
      ShadSidebarMenuButtonSize.sm => sidebarTheme.menuButtonHeightSm ?? 28,
      ShadSidebarMenuButtonSize.regular => sidebarTheme.menuButtonHeight ?? 32,
      ShadSidebarMenuButtonSize.lg => sidebarTheme.menuButtonHeightLg ?? 48,
    };

    // In the icon rail every size becomes a square that fills the rail's
    // inner width: `size-8! p-2!`.
    final groupPadding = (sidebarTheme.groupPadding ?? const EdgeInsets.all(8))
        .resolve(
          Directionality.of(context),
        );
    final collapsedSize = scope.collapsedWidth - groupPadding.horizontal;
    final iconSize = sidebarTheme.iconSize ?? 16;

    final height = collapsed ? collapsedSize : expandedHeight;
    final padding = collapsed
        ? EdgeInsets.symmetric(
            horizontal: math.max(0, (collapsedSize - iconSize) / 2),
          )
        : (sidebarTheme.menuButtonPadding ??
              const EdgeInsets.symmetric(horizontal: 8));

    final textStyle = switch (widget.size) {
      ShadSidebarMenuButtonSize.sm =>
        sidebarTheme.menuButtonTextStyleSm ??
            sidebarTheme.menuButtonTextStyle ??
            theme.textTheme.small,
      _ => sidebarTheme.menuButtonTextStyle ?? theme.textTheme.small,
    };

    final accent = sidebarTheme.accentColor ?? theme.colorScheme.sidebarAccent;
    final accentForeground =
        sidebarTheme.accentForegroundColor ??
        theme.colorScheme.sidebarAccentForeground;
    final foreground =
        sidebarTheme.foregroundColor ?? theme.colorScheme.sidebarForeground;

    final highlighted =
        widget.enabled && (hovered || pressed || widget.isActive);
    final contentColor = highlighted ? accentForeground : foreground;
    final radius = sidebarTheme.menuButtonRadius ?? theme.radii.sm;
    final gap = sidebarTheme.menuButtonGap ?? 8;

    final outline = widget.variant == ShadSidebarMenuButtonVariant.outline;
    final borderColor =
        sidebarTheme.borderColor ?? theme.colorScheme.sidebarBorder;

    final ringColor = sidebarTheme.ringColor ?? theme.colorScheme.sidebarRing;
    final ringWidth = sidebarTheme.ringWidth ?? 2;

    // Every fixed-width part after the icon animates to zero on the same
    // timeline as the button's width, so at any point of the collapse the
    // row's minimum width fits the animated bounds — a plain SizedBox gap
    // (or an instantly-dropped trailing) overflows the 16px inner width of
    // the 32px square.
    Widget row = Row(
      children: [
        if (widget.leading != null) ...[
          IconTheme.merge(
            data: IconThemeData(size: iconSize, color: contentColor),
            child: widget.leading!,
          ),
          AnimatedContainer(
            duration: duration,
            curve: curve,
            width: collapsed ? 0 : gap,
          ),
        ],
        Expanded(
          child: DefaultTextStyle.merge(
            style: textStyle.copyWith(
              color: contentColor,
              fontWeight: widget.isActive ? FontWeight.w500 : null,
            ),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.clip,
            child: widget.child,
          ),
        ),
        // The reference hides badges and actions in the icon rail; here they
        // shrink away instead of vanishing, for the same fits-at-every-frame
        // reason.
        if (widget.trailing != null)
          ClipRect(
            child: AnimatedAlign(
              duration: duration,
              curve: curve,
              alignment: AlignmentDirectional.centerEnd,
              widthFactor: collapsed ? 0 : 1,
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: gap),
                child: IconTheme.merge(
                  data: IconThemeData(size: iconSize, color: contentColor),
                  child: DefaultTextStyle.merge(
                    style: textStyle.copyWith(color: contentColor),
                    child: widget.trailing!,
                  ),
                ),
              ),
            ),
          ),
      ],
    );

    if (widget.leading == null && collapsed) {
      // Nothing to shrink to: keep the label clipped instead of an empty box.
      row = Center(child: row);
    }

    Widget button = ShadFocusable(
      canRequestFocus: widget.enabled,
      focusNode: widget.focusNode,
      builder: (context, focused, child) {
        return ShadDecorator(
          focused: focused,
          decoration: ShadDecoration(
            border: ShadBorder.all(radius: radius, width: 0),
            secondaryFocusedBorder: ShadBorder.all(
              radius: radius.add(BorderRadius.circular(ringWidth)),
              width: ringWidth,
              offset: ringWidth,
              color: ringColor,
            ),
          ),
          child: child,
        );
      },
      child: ShadGestureDetector(
        cursor: widget.enabled ? SystemMouseCursors.click : MouseCursor.defer,
        onHoverChange: widget.enabled
            ? (value) => setState(() => hovered = value)
            : null,
        onTapDown: widget.enabled
            ? (_) => setState(() => pressed = true)
            : null,
        onTapUp: widget.enabled ? (_) => setState(() => pressed = false) : null,
        onTapCancel: widget.enabled
            ? () => setState(() => pressed = false)
            : null,
        onTap: widget.enabled ? widget.onPressed : null,
        // The sidebar lays its content out at the expanded width even while
        // the rail is collapsed (see ShadSidebar), so the square form needs
        // an explicit width; the LayoutBuilder below supplies the expanded
        // target so both ends of the animation are finite.
        child: LayoutBuilder(
          builder: (context, constraints) {
            final expandedWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : null;
            return AnimatedContainer(
              duration: duration,
              curve: curve,
              width: collapsed ? collapsedSize : expandedWidth,
              height: height,
              padding: padding,
              decoration: BoxDecoration(
                color: highlighted
                    ? accent
                    : outline
                    ? theme.colorScheme.background
                    : null,
                borderRadius: radius,
                boxShadow: outline
                    ? [
                        BoxShadow(
                          color: highlighted ? accent : borderColor,
                          spreadRadius: 1,
                          blurStyle: BlurStyle.outer,
                        ),
                      ]
                    : null,
              ),
              child: row,
            );
          },
        ),
      ),
    );

    if (!widget.enabled) {
      button = Opacity(opacity: theme.disabledOpacity, child: button);
    }

    button = Semantics(
      button: true,
      enabled: widget.enabled,
      selected: widget.isActive,
      child: button,
    );

    if (widget.tooltip != null && collapsed && !scope.isMobile) {
      // The tooltip hangs off the button's inner side — away from the
      // screen edge the rail sits on — with the arrow pointing back at it.
      final towardEnd = scope.side == ShadSidebarSide.start;
      final physicalRight =
          towardEnd == (Directionality.of(context) == TextDirection.ltr);
      button = ShadTooltip(
        anchor: ShadAnchor(
          childAlignment: towardEnd
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          overlayAlignment: towardEnd
              ? AlignmentDirectional.centerStart
              : AlignmentDirectional.centerEnd,
          offset: Offset(physicalRight ? 8 : -8, 0),
        ),
        arrowDirection: physicalRight
            ? AxisDirection.left
            : AxisDirection.right,
        builder: (context) => Text(widget.tooltip!),
        child: button,
      );
    }

    // Pin the (possibly square) button to the start edge: its parent stays at
    // the expanded width in the icon rail, and stretch would re-widen it.
    return Align(
      alignment: AlignmentDirectional.centerStart,
      heightFactor: 1,
      child: button,
    );
  }
}

/// A count or status marker at the end of a menu row, shadcn/ui's
/// `SidebarMenuBadge`.
class ShadSidebarMenuBadge extends StatelessWidget {
  const ShadSidebarMenuBadge({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final sidebarTheme = theme.sidebarTheme;
    return Container(
      height: 20,
      constraints: const BoxConstraints(minWidth: 20),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      child: DefaultTextStyle.merge(
        style: sidebarTheme.badgeTextStyle ?? theme.textTheme.small,
        child: child,
      ),
    );
  }
}

/// A small hover-accent icon control, shadcn/ui's `SidebarMenuAction` and
/// `SidebarGroupAction`: put it in a menu button's `trailing` or a group's
/// `action` slot.
class ShadSidebarMenuAction extends StatefulWidget {
  const ShadSidebarMenuAction({
    super.key,
    required this.icon,
    this.onPressed,
    this.semanticLabel,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  @override
  State<ShadSidebarMenuAction> createState() => _ShadSidebarMenuActionState();
}

class _ShadSidebarMenuActionState extends State<ShadSidebarMenuAction> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final sidebarTheme = theme.sidebarTheme;
    final accent = sidebarTheme.accentColor ?? theme.colorScheme.sidebarAccent;
    final accentForeground =
        sidebarTheme.accentForegroundColor ??
        theme.colorScheme.sidebarAccentForeground;
    final foreground =
        sidebarTheme.foregroundColor ?? theme.colorScheme.sidebarForeground;

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: ShadGestureDetector(
        cursor: SystemMouseCursors.click,
        onHoverChange: (value) => setState(() => hovered = value),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: hovered ? accent : null,
            borderRadius: sidebarTheme.menuButtonRadius ?? theme.radii.sm,
          ),
          child: IconTheme.merge(
            data: IconThemeData(
              size: sidebarTheme.iconSize ?? 16,
              color: hovered ? accentForeground : foreground,
            ),
            child: Center(child: widget.icon),
          ),
        ),
      ),
    );
  }
}

/// An indented, bordered list nested under a menu row, shadcn/ui's
/// `SidebarMenuSub`. Hidden entirely in the icon rail.
class ShadSidebarMenuSub extends StatelessWidget {
  const ShadSidebarMenuSub({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final sidebarTheme = theme.sidebarTheme;
    final scope = ShadSidebarScope.of(context);
    if (scope.collapsed) return const SizedBox.shrink();

    final borderColor =
        sidebarTheme.borderColor ?? theme.colorScheme.sidebarBorder;
    final gap = sidebarTheme.menuGap ?? 4;

    return Container(
      margin:
          sidebarTheme.subMenuMargin ??
          const EdgeInsets.symmetric(horizontal: 14),
      padding:
          sidebarTheme.subMenuPadding ??
          const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        border: BorderDirectional(start: BorderSide(color: borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// A row inside a [ShadSidebarMenuSub], shadcn/ui's `SidebarMenuSubButton`.
class ShadSidebarMenuSubButton extends StatefulWidget {
  const ShadSidebarMenuSubButton({
    super.key,
    this.onPressed,
    this.leading,
    required this.child,
    this.isActive = false,
    this.small = false,
    this.focusNode,
  });

  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget child;
  final bool isActive;

  /// Whether to render at the `sm` (text-xs) size.
  final bool small;

  final FocusNode? focusNode;

  @override
  State<ShadSidebarMenuSubButton> createState() =>
      _ShadSidebarMenuSubButtonState();
}

class _ShadSidebarMenuSubButtonState extends State<ShadSidebarMenuSubButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final sidebarTheme = theme.sidebarTheme;

    final accent = sidebarTheme.accentColor ?? theme.colorScheme.sidebarAccent;
    final accentForeground =
        sidebarTheme.accentForegroundColor ??
        theme.colorScheme.sidebarAccentForeground;
    final foreground =
        sidebarTheme.foregroundColor ?? theme.colorScheme.sidebarForeground;
    final highlighted = hovered || widget.isActive;
    final contentColor = highlighted ? accentForeground : foreground;

    var textStyle = sidebarTheme.subButtonTextStyle ?? theme.textTheme.small;
    if (widget.small) textStyle = textStyle.copyWith(fontSize: 12);

    final ringColor = sidebarTheme.ringColor ?? theme.colorScheme.sidebarRing;
    final ringWidth = sidebarTheme.ringWidth ?? 2;
    final radius = sidebarTheme.menuButtonRadius ?? theme.radii.sm;
    final gap = sidebarTheme.menuButtonGap ?? 8;

    return Semantics(
      button: true,
      selected: widget.isActive,
      child: ShadFocusable(
        focusNode: widget.focusNode,
        builder: (context, focused, child) {
          return ShadDecorator(
            focused: focused,
            decoration: ShadDecoration(
              border: ShadBorder.all(radius: radius, width: 0),
              secondaryFocusedBorder: ShadBorder.all(
                radius: radius.add(BorderRadius.circular(ringWidth)),
                width: ringWidth,
                offset: ringWidth,
                color: ringColor,
              ),
            ),
            child: child,
          );
        },
        child: ShadGestureDetector(
          cursor: SystemMouseCursors.click,
          onHoverChange: (value) => setState(() => hovered = value),
          onTap: widget.onPressed,
          child: Container(
            height: sidebarTheme.subButtonHeight ?? 28,
            padding:
                sidebarTheme.subButtonPadding ??
                const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: highlighted ? accent : null,
              borderRadius: radius,
            ),
            child: Row(
              children: [
                if (widget.leading != null) ...[
                  IconTheme.merge(
                    // `[&>svg]:text-sidebar-accent-foreground`: sub icons
                    // always take the accent foreground.
                    data: IconThemeData(
                      size: sidebarTheme.iconSize ?? 16,
                      color: accentForeground,
                    ),
                    child: widget.leading!,
                  ),
                  SizedBox(width: gap),
                ],
                Expanded(
                  child: DefaultTextStyle.merge(
                    style: textStyle.copyWith(color: contentColor),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.clip,
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A placeholder menu row while content loads, shadcn/ui's
/// `SidebarMenuSkeleton`.
class ShadSidebarMenuSkeleton extends StatefulWidget {
  const ShadSidebarMenuSkeleton({super.key, this.showIcon = false});

  final bool showIcon;

  @override
  State<ShadSidebarMenuSkeleton> createState() =>
      _ShadSidebarMenuSkeletonState();
}

class _ShadSidebarMenuSkeletonState extends State<ShadSidebarMenuSkeleton> {
  // Random width between 50% and 90%, stable for this row's lifetime.
  final widthFactor = 0.5 + math.Random().nextDouble() * 0.4;

  @override
  Widget build(BuildContext context) {
    final sidebarTheme = ShadTheme.of(context).sidebarTheme;
    final iconSize = sidebarTheme.iconSize ?? 16;
    final gap = sidebarTheme.menuButtonGap ?? 8;
    return Container(
      height: sidebarTheme.menuButtonHeight ?? 32,
      padding:
          sidebarTheme.menuButtonPadding ??
          const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          if (widget.showIcon) ...[
            ShadSkeleton(width: iconSize, height: iconSize),
            SizedBox(width: gap),
          ],
          Expanded(
            child: FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: widthFactor,
              child: const ShadSkeleton(height: 16),
            ),
          ),
        ],
      ),
    );
  }
}

/// A hairline between sidebar sections, shadcn/ui's `SidebarSeparator`.
class ShadSidebarSeparator extends StatelessWidget {
  const ShadSidebarSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return ShadSeparator.horizontal(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: theme.sidebarTheme.borderColor ?? theme.colorScheme.sidebarBorder,
    );
  }
}
