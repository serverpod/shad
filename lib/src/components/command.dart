import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shadcn_ui/src/components/dialog.dart';
import 'package:shadcn_ui/src/components/empty.dart';
import 'package:shadcn_ui/src/components/input.dart';
import 'package:shadcn_ui/src/components/separator.dart';
import 'package:shadcn_ui/src/raw_components/roving_focus.dart';
import 'package:shadcn_ui/src/theme/components/decorator.dart';
import 'package:shadcn_ui/src/theme/theme.dart';
import 'package:shadcn_ui/src/utils/debug_check.dart';
import 'package:shadcn_ui/src/utils/gesture_detector.dart';

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
  });

  /// The grouped items.
  ///
  /// Pass a single group with no heading for an ungrouped list.
  final List<ShadCommandGroup> groups;

  /// The placeholder of the search field.
  final Widget? placeholder;

  /// Builds the empty state shown when the filter matches nothing.
  ///
  /// Defaults to a [ShadEmpty] with the localized "No results" title.
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureVisible());
  }

  void _ensureVisible() {
    final index = _rovingController.highlightedIndex;
    if (index == null || !mounted) return;
    final key = _itemKeys[index];
    final context = key?.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      alignment: 0.5,
      duration: const Duration(milliseconds: 100),
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
        commandTheme.optionsPadding ?? const EdgeInsets.all(4);

    var runningIndex = 0;
    final children = <Widget>[];
    for (final (group, items) in filteredGroups) {
      if (group.heading != null) {
        children.add(
          Padding(
            padding:
                commandTheme.groupHeadingPadding ??
                const EdgeInsets.fromLTRB(8, 8, 8, 4),
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
            onTap: () => _select(item),
            onHover: () => _rovingController.highlightedIndex = index,
          ),
        );
      }
    }

    final body = flat.isEmpty
        ? (widget.emptyBuilder?.call(context, _query) ??
              Padding(
                padding:
                    commandTheme.emptyPadding ??
                    const EdgeInsets.symmetric(vertical: 24),
                child: const ShadEmpty(padding: EdgeInsets.zero),
              ))
        : SingleChildScrollView(
            controller: _scrollController,
            padding: effectiveOptionsPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          );

    return ShadRovingFocus(
      controller: _rovingController,
      orientation: ShadRovingFocusOrientation.vertical,
      onActivate: _activateAt,
      onEscape: widget.onEscape,
      // The search field holds focus, so this Focus node must not steal it —
      // it only needs to see key events on their way up.
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: effectiveDecoration.border?.radius,
        ),
        child: SizedBox(
          height: effectiveHeight,
          width: effectiveWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.showSearch) ...[
                Padding(
                  padding:
                      commandTheme.searchPadding ??
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: ShadInput(
                    controller: searchController,
                    focusNode: _searchFocusNode,
                    autofocus: widget.autofocus,
                    placeholder: widget.placeholder,
                    decoration: ShadDecoration.none,
                    leading:
                        widget.leadingSearchIcon ??
                        Icon(
                          LucideIcons.search,
                          size: 16,
                          color: theme.colorScheme.mutedForeground,
                        ),
                  ),
                ),
                const ShadSeparator.horizontal(margin: EdgeInsets.zero),
              ],
              Flexible(child: body),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShadCommandItemView extends StatelessWidget {
  const _ShadCommandItemView({
    super.key,
    required this.item,
    required this.highlighted,
    required this.onTap,
    required this.onHover,
  });

  final ShadCommandItem item;
  final bool highlighted;
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
              borderRadius:
                  commandTheme.itemRadius ??
                  const BorderRadius.all(Radius.circular(4)),
            ),
            child: IconTheme(
              data: IconThemeData(size: 16, color: foreground),
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
      return ShadDialog(
        padding: EdgeInsets.zero,
        closeIcon: const SizedBox.shrink(),
        child: ShadCommand(
          groups: groups,
          placeholder: placeholder,
          filter: filter,
          emptyBuilder: emptyBuilder,
          width: width,
          height: height,
          onEscape: () => Navigator.of(context).maybePop(),
          onItemSelected: (item) {
            Navigator.of(context).pop(item.value as T?);
          },
        ),
      );
    },
  );
}
