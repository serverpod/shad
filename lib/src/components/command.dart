import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shad/src/components/dialog.dart';
import 'package:shad/src/components/input.dart';
import 'package:shad/src/i18n/localizations_delegate.dart';
import 'package:shad/src/raw_components/roving_focus.dart';
import 'package:shad/src/theme/components/decorator.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/theme/themes/shadows.dart';
import 'package:shad/src/utils/border.dart';
import 'package:shad/src/utils/debug_check.dart';
import 'package:shad/src/utils/gesture_detector.dart';

/// A single selectable row in a [ShadCommand].
///
/// This is a description rather than a widget: the command renders it, so that
/// filtering, highlighting and keyboard navigation stay in one place.
@immutable
class ShadCommandItem {
  const ShadCommandItem({
    required this.label,
    this.onSelected,
    this.leading,
    this.trailing,
    this.keywords = const [],
    this.enabled = true,
    this.value,
  });

  /// The text shown for the item, and what the filter matches against.
  final String label;

  /// Called when the item is chosen, by click or by Enter.
  final VoidCallback? onSelected;

  /// An icon shown before the label.
  final Widget? leading;

  /// Shown at the end of the row, typically a `ShadKbd` shortcut hint.
  final Widget? trailing;

  /// Extra terms the filter should match, for synonyms the label omits.
  ///
  /// "Sign out" might carry `['logout', 'exit']`.
  final List<String> keywords;

  /// Whether the item can be chosen.
  final bool enabled;

  /// An arbitrary payload, surfaced through [ShadCommand.onItemSelected].
  final Object? value;

  /// The haystack the default filter searches.
  String get searchText => [label, ...keywords].join(' ').toLowerCase();
}

/// A titled run of [ShadCommandItem]s.
@immutable
class ShadCommandGroup {
  const ShadCommandGroup({
    required this.items,
    this.heading,
  });

  /// The heading shown above the group. Groups whose items are all filtered
  /// out are hidden along with their heading.
  final String? heading;

  final List<ShadCommandItem> items;
}

/// Filters items against the current query.
///
/// Return the items to show, in the order to show them.
typedef ShadCommandFilter =
    List<ShadCommandItem> Function(
      List<ShadCommandItem> items,
      String query,
    );

/// {@template ShadCommand}
/// A searchable command palette.
///
/// Mirrors shadcn/ui's `Command`: a filter field over a grouped, keyboard
/// navigable list. Use [showShadCommandDialog] for the ⌘K overlay, or embed
/// [ShadCommand] directly inside a popover or a page.
///
/// ```dart
/// ShadCommand(
///   groups: [
///     ShadCommandGroup(
///       heading: 'Suggestions',
///       items: [
///         ShadCommandItem(label: 'Calendar', onSelected: openCalendar),
///         ShadCommandItem(label: 'Search Emoji', keywords: ['emoji']),
///       ],
///     ),
///   ],
/// )
/// ```
///
/// Up/Down move the highlight, Home/End jump to the ends, Enter chooses and
/// Escape closes. The highlight is a roving one — the search field keeps
/// keyboard focus throughout, so the user can keep typing.
/// {@endtemplate}
class ShadCommand extends StatefulWidget {
  /// {@macro ShadCommand}
  const ShadCommand({
    super.key,
    required this.groups,
    this.placeholder,
    this.emptyBuilder,
    this.onItemSelected,
    this.onQueryChanged,
    this.filter,
    this.controller,
    this.autofocus = true,
    this.onEscape,
    this.backgroundColor,
    this.decoration,
    this.padding,
    this.height,
    this.width,
    this.showSearch = true,
    this.leadingSearchIcon,
    this.itemRadius,
  });

  /// The grouped items.
  ///
  /// Pass a single group with no heading for an ungrouped list.
  final List<ShadCommandGroup> groups;

  /// The placeholder of the search field.
  final Widget? placeholder;

  /// Builds the empty state shown when the filter matches nothing.
  ///
  /// Defaults to a centred line with the localized "No results found." —
  /// shadcn's `CommandEmpty`.
  final Widget Function(BuildContext context, String query)? emptyBuilder;

  /// Called with the chosen item, in addition to its own `onSelected`.
  final ValueChanged<ShadCommandItem>? onItemSelected;

  /// Called whenever the query changes.
  final ValueChanged<String>? onQueryChanged;

  /// Overrides the matching strategy.
  ///
  /// Defaults to a case-insensitive substring match over the label and
  /// keywords, preserving the declared order. Supply your own for fuzzy or
  /// server-side matching.
  final ShadCommandFilter? filter;

  /// A controller for the search field.
  final TextEditingController? controller;

  /// Whether the search field takes focus on mount, defaults to `true`.
  final bool autofocus;

  /// Called when Escape is pressed.
  final VoidCallback? onEscape;

  /// {@template ShadCommand.backgroundColor}
  /// The background color of the palette.
  /// {@endtemplate}
  final Color? backgroundColor;

  /// {@template ShadCommand.decoration}
  /// The decoration of the palette.
  /// {@endtemplate}
  final ShadDecoration? decoration;

  /// {@template ShadCommand.padding}
  /// The padding around the palette's contents.
  /// {@endtemplate}
  final EdgeInsetsGeometry? padding;

  /// {@template ShadCommand.height}
  /// The height of the palette.
  /// {@endtemplate}
  final double? height;

  /// {@template ShadCommand.width}
  /// The width of the palette.
  /// {@endtemplate}
  final double? width;

  /// Whether the search field is shown. Set to `false` to filter externally.
  final bool showSearch;

  /// The icon shown before the search field.
  final Widget? leadingSearchIcon;

  /// The corner radius of an item, overriding the theme's.
  ///
  /// [showShadCommandDialog] passes the theme's `dialogItemRadius` here —
  /// shadcn rounds items a step further inside a dialog than inline.
  final BorderRadiusGeometry? itemRadius;

  /// The default filter: a case-insensitive substring match over the label and
  /// keywords, preserving the declared order.
  ///
  /// Exposed so a custom [filter] can fall back to it, and so the matching
  /// rule can be tested directly.
  static List<ShadCommandItem> defaultFilter(
    List<ShadCommandItem> items,
    String query,
  ) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return items;
    return items.where((item) => item.searchText.contains(normalized)).toList();
  }

  @override
  State<ShadCommand> createState() => ShadCommandState();
}

class ShadCommandState extends State<ShadCommand> {
  TextEditingController? _internalController;

  TextEditingController get searchController =>
      widget.controller ?? _internalController!;

  final _rovingController = ShadRovingFocusController();
  final _scrollController = ScrollController();
  final _searchFocusNode = FocusNode(debugLabel: 'ShadCommand search');

  /// The keys of the currently visible item rows, used to scroll the
  /// highlighted one into view.
  final _itemKeys = <int, GlobalKey>{};

  /// Pointer hover moves the highlight but must not scroll — only keyboard
  /// navigation should bring items into view.
  var _scrollHighlightedIntoView = true;

  int? _previousHighlightedIndex;

  String _query = '';

  /// The flat, filtered item list backing the roving highlight.
  ///
  /// Groups are flattened because the highlight moves across group boundaries
  /// — a user pressing Down at the end of one group lands on the first item of
  /// the next.
  List<ShadCommandItem> _visibleItems = const [];

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
    searchController.addListener(_onQueryChanged);
    _query = searchController.text;
    _rovingController.addListener(_onHighlightChanged);
  }

  @override
  void didUpdateWidget(ShadCommand oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      (oldWidget.controller ?? _internalController)?.removeListener(
        _onQueryChanged,
      );
      searchController.addListener(_onQueryChanged);
      _query = searchController.text;
    }
  }

  @override
  void dispose() {
    searchController.removeListener(_onQueryChanged);
    _internalController?.dispose();
    _rovingController
      ..removeListener(_onHighlightChanged)
      ..dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    if (searchController.text == _query) return;
    setState(() => _query = searchController.text);
    widget.onQueryChanged?.call(_query);
    // A new query means a new result set; start again from the top so Enter
    // always chooses the best match.
    _rovingController.highlightedIndex = 0;
  }

  void _onHighlightChanged() {
    if (mounted) setState(() {});

    if (!_scrollHighlightedIntoView) {
      _scrollHighlightedIntoView = true;
      _previousHighlightedIndex = _rovingController.highlightedIndex;
      return;
    }

    final index = _rovingController.highlightedIndex;
    final movingUp =
        index != null &&
        _previousHighlightedIndex != null &&
        index < _previousHighlightedIndex!;
    _previousHighlightedIndex = index;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _ensureVisible(preferStart: movingUp),
    );
  }

  void _highlightFromPointer(int index) {
    if (_rovingController.highlightedIndex == index) return;
    _scrollHighlightedIntoView = false;
    _rovingController.highlightedIndex = index;
  }

  void _ensureVisible({required bool preferStart}) {
    final index = _rovingController.highlightedIndex;
    if (index == null || !mounted) return;
    final key = _itemKeys[index];
    final context = key?.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 100),
      alignmentPolicy: preferStart
          ? ScrollPositionAlignmentPolicy.keepVisibleAtStart
          : ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
    );
  }

  void _select(ShadCommandItem item) {
    if (!item.enabled) return;
    item.onSelected?.call();
    widget.onItemSelected?.call(item);
  }

  void _activateAt(int index) {
    if (index < 0 || index >= _visibleItems.length) return;
    _select(_visibleItems[index]);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasShadTheme(context));
    final theme = ShadTheme.of(context);
    final commandTheme = theme.commandTheme;

    final filter = widget.filter ?? ShadCommand.defaultFilter;

    // Filter per group so an empty group can drop its heading too, while the
    // flat list keeps the highlight indices aligned with what is rendered.
    final filteredGroups = <(ShadCommandGroup, List<ShadCommandItem>)>[];
    final flat = <ShadCommandItem>[];
    for (final group in widget.groups) {
      final matches = filter(group.items, _query);
      if (matches.isEmpty) continue;
      filteredGroups.add((group, matches));
      flat.addAll(matches);
    }
    _visibleItems = flat;
    _rovingController.itemCount = flat.length;
    if (flat.isNotEmpty && _rovingController.highlightedIndex == null) {
      _rovingController.highlightedIndex = 0;
    }

    final effectiveBackgroundColor =
        widget.backgroundColor ??
        commandTheme.backgroundColor ??
        theme.colorScheme.popover;
    final effectiveDecoration =
        (commandTheme.decoration ?? const ShadDecoration()).merge(
          widget.decoration,
        );
    final effectiveHeight = widget.height ?? commandTheme.height;
    final effectiveWidth = widget.width ?? commandTheme.width;
    final effectiveOptionsPadding =
        commandTheme.optionsPadding ?? const EdgeInsets.fromLTRB(4, 0, 4, 4);
    final effectiveGroupPadding =
        commandTheme.groupPadding ?? const EdgeInsets.all(4);
    final effectiveItemRadius =
        widget.itemRadius ??
        commandTheme.itemRadius ??
        const BorderRadius.all(Radius.circular(4));
    final effectiveItemIconSize = commandTheme.itemIconSize ?? 16.0;

    var runningIndex = 0;
    final groupViews = <Widget>[];
    for (final (group, items) in filteredGroups) {
      final children = <Widget>[];
      if (group.heading != null) {
        children.add(
          Padding(
            padding:
                commandTheme.groupHeadingPadding ??
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              group.heading!,
              style: commandTheme.groupHeadingStyle ?? theme.textTheme.muted,
            ),
          ),
        );
      }
      for (final item in items) {
        final index = runningIndex++;
        final key = _itemKeys.putIfAbsent(index, GlobalKey.new);
        children.add(
          _ShadCommandItemView(
            key: key,
            item: item,
            highlighted: _rovingController.highlightedIndex == index,
            radius: effectiveItemRadius,
            iconSize: effectiveItemIconSize,
            onTap: () => _select(item),
            onHover: () => _highlightFromPointer(index),
          ),
        );
      }
      // `.cn-command-group p-1`: each group carries its own inset, so items
      // sit a step in from the list edge.
      groupViews.add(
        Padding(
          padding: effectiveGroupPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      );
    }

    // `.cn-command-empty py-6 text-center text-sm`: a single quiet line, not
    // the ShadEmpty hero.
    var body = flat.isEmpty
        ? (widget.emptyBuilder?.call(context, _query) ??
              Padding(
                padding:
                    commandTheme.emptyPadding ??
                    const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  ShadLocalizations.of(context).command.noResults,
                  textAlign: TextAlign.center,
                  style:
                      commandTheme.emptyTextStyle ??
                      theme.textTheme.small.copyWith(
                        fontWeight: FontWeight.normal,
                        color: theme.colorScheme.popoverForeground,
                      ),
                ),
              ))
        : SingleChildScrollView(
            controller: _scrollController,
            padding: effectiveOptionsPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: groupViews,
            ),
          );

    // `.cn-command-list max-h-72`: with no fixed height the palette hugs its
    // content and the list scrolls past this cap. An explicit height wins.
    final effectiveListMaxHeight = commandTheme.listMaxHeight ?? 288.0;
    if (effectiveHeight == null) {
      body = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: effectiveListMaxHeight),
        child: body,
      );
    }

    final borderRadius =
        effectiveDecoration.border?.radius?.resolve(
          Directionality.of(context),
        ) ??
        theme.commandTheme.decoration?.border?.radius?.resolve(
          Directionality.of(context),
        ) ??
        theme.radius;

    final ownsSurface = widget.decoration != ShadDecoration.none;

    // `.cn-command-input-group`: a soft box around the search field — an
    // `--input` wash and outline, no focus ring — rather than the old
    // full-width underlined row.
    final effectiveSearchHeight = commandTheme.searchHeight ?? 32.0;
    final effectiveSearchDecoration =
        commandTheme.searchDecoration ??
        ShadDecoration(
          color: theme.colorScheme.input.withValues(alpha: .3),
          border: ShadBorder.all(
            radius: const BorderRadius.all(Radius.circular(10)),
            color: theme.colorScheme.input.withValues(alpha: .3),
            width: 1,
          ),
          disableSecondaryBorder: true,
        );

    final content = SizedBox(
      height: effectiveHeight,
      width: effectiveWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.showSearch)
            Padding(
              padding:
                  commandTheme.searchPadding ??
                  const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: ShadInput(
                controller: searchController,
                focusNode: _searchFocusNode,
                autofocus: widget.autofocus,
                placeholder: widget.placeholder,
                decoration: effectiveSearchDecoration,
                constraints: BoxConstraints(minHeight: effectiveSearchHeight),
                padding:
                    commandTheme.searchInputPadding ??
                    const EdgeInsets.symmetric(horizontal: 8),
                gap: commandTheme.searchGap ?? 6,
                leading:
                    widget.leadingSearchIcon ??
                    Icon(
                      LucideIcons.search,
                      size: commandTheme.searchIconSize ?? 16,
                      color:
                          commandTheme.searchIconColor ??
                          theme.colorScheme.mutedForeground,
                    ),
              ),
            ),
          Flexible(child: body),
        ],
      ),
    );

    final child = ownsSurface
        ? ShadDecorator(
            decoration: effectiveDecoration.copyWith(
              color: effectiveBackgroundColor,
            ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: content,
            ),
          )
        : content;

    return ShadRovingFocus(
      controller: _rovingController,
      orientation: ShadRovingFocusOrientation.vertical,
      onActivate: _activateAt,
      onEscape: widget.onEscape,
      // The search field holds focus, so this Focus node must not steal it —
      // it only needs to see key events on their way up.
      child: child,
    );
  }
}

class _ShadCommandItemView extends StatelessWidget {
  const _ShadCommandItemView({
    super.key,
    required this.item,
    required this.highlighted,
    required this.radius,
    required this.iconSize,
    required this.onTap,
    required this.onHover,
  });

  final ShadCommandItem item;
  final bool highlighted;
  final BorderRadiusGeometry radius;
  final double iconSize;
  final VoidCallback onTap;
  final VoidCallback onHover;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final commandTheme = theme.commandTheme;

    final foreground = !item.enabled
        ? theme.colorScheme.mutedForeground.withValues(alpha: .5)
        : highlighted
        ? commandTheme.itemSelectedForegroundColor ??
              theme.colorScheme.accentForeground
        : commandTheme.itemForegroundColor ??
              theme.colorScheme.popoverForeground;

    return Semantics(
      button: true,
      selected: highlighted,
      enabled: item.enabled,
      label: item.label,
      child: ExcludeSemantics(
        child: ShadGestureDetector(
          cursor: item.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          behavior: HitTestBehavior.opaque,
          onTap: item.enabled ? onTap : null,
          onHoverChange: (hovered) {
            if (hovered && item.enabled) onHover();
          },
          child: Container(
            padding:
                commandTheme.itemPadding ??
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: highlighted && item.enabled
                  ? commandTheme.itemSelectedBackgroundColor ??
                        theme.colorScheme.accent
                  : null,
              borderRadius: radius,
            ),
            child: IconTheme(
              data: IconThemeData(size: iconSize, color: foreground),
              child: DefaultTextStyle(
                style: (commandTheme.itemTextStyle ?? theme.textTheme.small)
                    .copyWith(color: foreground),
                child: Row(
                  children: [
                    if (item.leading != null) ...[
                      item.leading!,
                      SizedBox(width: commandTheme.itemGap ?? 8),
                    ],
                    Expanded(child: Text(item.label)),
                    if (item.trailing != null) ...[
                      SizedBox(width: commandTheme.itemGap ?? 8),
                      item.trailing!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows a [ShadCommand] as a modal palette, the ⌘K pattern.
///
/// Returns the value of the chosen item, or null if dismissed.
Future<T?> showShadCommandDialog<T>({
  required BuildContext context,
  required List<ShadCommandGroup> groups,
  Widget? placeholder,
  ShadCommandFilter? filter,
  Widget Function(BuildContext context, String query)? emptyBuilder,
  bool barrierDismissible = true,
  double? width,
  double? height,
}) {
  return showShadDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      final theme = ShadTheme.of(context);
      final commandTheme = theme.commandTheme;
      // `.cn-command-dialog top-1/3 translate-y-0`: the top edge sits at a
      // third of the screen and stays put while filtering changes the
      // height — the palette grows downward, it never recentres.
      final topOffset = MediaQuery.sizeOf(context).height / 3;
      // The dialog takes the palette's own radius
      // (`.cn-command-dialog rounded-xl!`), its theme's hairline, and no
      // shadow — `.cn-dialog-content` casts none.
      final radius = commandTheme.decoration?.border?.radius?.resolve(
        Directionality.of(context),
      );
      return Padding(
        padding: EdgeInsets.fromLTRB(16, topOffset, 16, 16),
        child: ShadDialog(
          alignment: Alignment.topCenter,
          // `sm:max-w-md`, with the padding above keeping the
          // `calc(100%-2rem)` margins on narrow screens.
          constraints: const BoxConstraints(maxWidth: 448),
          removeBorderRadiusWhenTiny: false,
          radius: radius,
          padding: EdgeInsets.zero,
          scrollable: false,
          shadows: Shadows.none,
          closeIcon: const SizedBox.shrink(),
          child: ShadCommand(
            groups: groups,
            placeholder: placeholder,
            filter: filter,
            emptyBuilder: emptyBuilder,
            width: width ?? double.infinity,
            height: height,
            decoration: ShadDecoration.none,
            backgroundColor: const Color(0x00000000),
            itemRadius: commandTheme.dialogItemRadius,
            onEscape: () => Navigator.of(context).maybePop(),
            onItemSelected: (item) {
              Navigator.of(context).pop(item.value as T?);
            },
          ),
        ),
      );
    },
  );
}
