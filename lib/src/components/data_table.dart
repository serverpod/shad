import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shad/src/components/checkbox.dart';
import 'package:shad/src/components/empty.dart';
import 'package:shad/src/components/pagination.dart';
import 'package:shad/src/components/table.dart';
import 'package:shad/src/theme/theme.dart';
import 'package:shad/src/utils/debug_check.dart';
import 'package:shad/src/utils/gesture_detector.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

/// Width of the leading checkbox column in a selectable [ShadDataTable].
///
/// Wide enough for the default 16px cell inset plus a 16px checkbox.
const _kSelectionColumnExtent = FixedTableSpanExtent(56);

/// Matches the table's default horizontal inset on the leading edge.
const _kSelectionCellPadding = EdgeInsetsDirectional.only(start: 16, end: 8);

/// Matches the table's default horizontal inset on the trailing edge.
const _kTrailingCellPadding = EdgeInsetsDirectional.only(start: 8, end: 16);

/// Fills the viewport after [precedingExtent], leaving [trailingFixed] pixels
/// for trailing fixed-width columns.
class _RemainingMinusTrailingFixedExtent extends TableSpanExtent {
  const _RemainingMinusTrailingFixedExtent(this.trailingFixed);

  final double trailingFixed;

  @override
  double calculateExtent(SpanExtentDelegate delegate) {
    return math.max(
      0,
      delegate.viewportExtent - delegate.precedingExtent - trailingFixed,
    );
  }
}

/// The direction a [ShadDataTable] is sorted in.
enum ShadSortDirection {
  ascending,
  descending;

  ShadSortDirection get flipped => this == ascending ? descending : ascending;
}

/// A column definition for a [ShadDataTable].
@immutable
class ShadDataTableColumn<T> {
  const ShadDataTableColumn({
    required this.id,
    required this.header,
    required this.cellBuilder,
    this.compare,
    this.extent,
    this.alignment,
    this.headerAlignment,
    this.visible = true,
  });

  /// A stable identifier, used for sorting and column visibility.
  final String id;

  /// The header label.
  final String header;

  /// Builds the cell content for a row.
  final Widget Function(BuildContext context, T row) cellBuilder;

  /// Compares two rows by this column.
  ///
  /// A column is sortable exactly when this is non-null — there is no separate
  /// `sortable` flag to keep in sync with it.
  final Comparator<T>? compare;

  /// The width of the column.
  ///
  /// When null, this column flexes to fill the viewport minus any trailing
  /// [FixedTableSpanExtent] columns after it. If there is no trailing fixed
  /// column, [ShadTable]'s default of 100 logical pixels applies.
  final TableSpanExtent? extent;

  /// The alignment of cell content.
  final Alignment? alignment;

  /// The alignment of the header, defaults to [alignment].
  final Alignment? headerAlignment;

  /// Whether the column is shown.
  final bool visible;

  bool get sortable => compare != null;
}

/// Holds the sort, filter, paging and selection state of a [ShadDataTable].
///
/// The controller owns the source rows and derives [visibleRows] from them, so
/// sorting or filtering never mutates what the caller passed in.
class ShadDataTableController<T> extends ChangeNotifier {
  ShadDataTableController({
    List<T> rows = const [],
    this.pageSize,
    String? sortColumnId,
    ShadSortDirection sortDirection = ShadSortDirection.ascending,
    bool Function(T row)? filter,
  }) : _rows = List.of(rows),
       _sortColumnId = sortColumnId,
       _sortDirection = sortDirection,
       _filter = filter;

  /// How many rows to show per page. Null disables paging.
  final int? pageSize;

  List<T> _rows;
  String? _sortColumnId;
  ShadSortDirection _sortDirection;
  bool Function(T row)? _filter;
  int _page = 1;
  final Set<Object> _selectedKeys = {};

  /// Set by [ShadDataTable] so the controller can resolve a column id to its
  /// comparator without the caller having to hand it the columns twice.
  List<ShadDataTableColumn<T>> _columns = const [];

  /// The unfiltered, unsorted source rows.
  List<T> get rows => List.unmodifiable(_rows);

  set rows(List<T> value) {
    _rows = List.of(value);
    _clampPage();
    notifyListeners();
  }

  String? get sortColumnId => _sortColumnId;

  ShadSortDirection get sortDirection => _sortDirection;

  bool Function(T row)? get filter => _filter;

  set filter(bool Function(T row)? value) {
    _filter = value;
    // A new filter changes the row count, so a deep page may no longer exist.
    _page = 1;
    notifyListeners();
  }

  /// The current page, 1-based.
  int get page => _page;

  set page(int value) {
    final clamped = value.clamp(1, pageCount);
    if (_page == clamped) return;
    _page = clamped;
    notifyListeners();
  }

  /// The rows left after filtering and sorting, before paging.
  List<T> get filteredRows {
    final filtered = _filter == null
        ? List<T>.of(_rows)
        : _rows.where(_filter!).toList();

    final column = _columnById(_sortColumnId);
    if (column?.compare != null) {
      filtered.sort(
        _sortDirection == ShadSortDirection.ascending
            ? column!.compare!
            : (a, b) => column!.compare!(b, a),
      );
    }
    return filtered;
  }

  /// The rows actually rendered: [filteredRows] narrowed to the current page.
  List<T> get visibleRows {
    final filtered = filteredRows;
    if (pageSize == null) return filtered;
    final start = (_page - 1) * pageSize!;
    if (start >= filtered.length) return const [];
    return filtered.sublist(
      start,
      (start + pageSize!).clamp(0, filtered.length),
    );
  }

  int get pageCount {
    if (pageSize == null) return 1;
    final total = _filter == null ? _rows.length : _rows.where(_filter!).length;
    if (total == 0) return 1;
    return (total / pageSize!).ceil();
  }

  ShadDataTableColumn<T>? _columnById(String? id) {
    if (id == null) return null;
    for (final column in _columns) {
      if (column.id == id) return column;
    }
    return null;
  }

  void _clampPage() {
    final clamped = _page.clamp(1, pageCount);
    if (clamped != _page) _page = clamped;
  }

  /// Sorts by [columnId], flipping the direction if it is already the sort
  /// column, and clearing the sort when it flips back past descending.
  void sortBy(String columnId) {
    if (_sortColumnId == columnId) {
      if (_sortDirection == ShadSortDirection.ascending) {
        _sortDirection = ShadSortDirection.descending;
      } else {
        // Third click clears the sort, matching the shadcn data-table demo.
        _sortColumnId = null;
        _sortDirection = ShadSortDirection.ascending;
      }
    } else {
      _sortColumnId = columnId;
      _sortDirection = ShadSortDirection.ascending;
    }
    notifyListeners();
  }

  // --- selection -----------------------------------------------------------

  /// The keys of the selected rows.
  ///
  /// Keys rather than rows so that selection survives a re-sort or a new page
  /// of data without depending on `==` over the row objects.
  Set<Object> get selectedKeys => Set.unmodifiable(_selectedKeys);

  bool isSelected(Object key) => _selectedKeys.contains(key);

  void setSelected(Object key, {required bool selected}) {
    final changed = selected
        ? _selectedKeys.add(key)
        : _selectedKeys.remove(key);
    if (changed) notifyListeners();
  }

  void toggleSelected(Object key) =>
      setSelected(key, selected: !_selectedKeys.contains(key));

  void selectAll(Iterable<Object> keys) {
    final before = _selectedKeys.length;
    _selectedKeys.addAll(keys);
    if (_selectedKeys.length != before) notifyListeners();
  }

  void clearSelection() {
    if (_selectedKeys.isEmpty) return;
    _selectedKeys.clear();
    notifyListeners();
  }
}

/// {@template ShadDataTable}
/// A sortable, selectable, paginated table.
///
/// Mirrors shadcn/ui's Data Table, which is a composition rather than a single
/// primitive: this wraps [ShadTable] for presentation and adds a
/// [ShadDataTableController] for sort, filter, page and selection state.
///
/// ```dart
/// ShadDataTable<User>(
///   controller: controller,
///   keyOf: (user) => user.id,
///   columns: [
///     ShadDataTableColumn(
///       id: 'name',
///       header: 'Name',
///       cellBuilder: (context, user) => Text(user.name),
///       compare: (a, b) => a.name.compareTo(b.name),
///     ),
///   ],
/// )
/// ```
///
/// [ShadTable] is built on `TableView`, a two-dimensional scroll view with no
/// shrink-wrap, so this needs a bounded height — give it one via [height], an
/// [Expanded], or a [SizedBox].
/// {@endtemplate}
class ShadDataTable<T> extends StatefulWidget {
  /// {@macro ShadDataTable}
  const ShadDataTable({
    super.key,
    required this.columns,
    required this.controller,
    this.keyOf,
    this.selectable = false,
    this.onRowTap,
    this.height,
    this.rowHeight,
    this.headerHeight,
    this.emptyBuilder,
    this.showPagination,
    this.paginationBuilder,
    this.showSelectionCount = true,
  }) : assert(
         !selectable || keyOf != null,
         'A selectable ShadDataTable needs keyOf to identify its rows',
       );

  /// The columns to render, in order. Columns with `visible: false` are
  /// skipped.
  final List<ShadDataTableColumn<T>> columns;

  /// The state of the table.
  final ShadDataTableController<T> controller;

  /// Returns a stable identity for a row, used for selection.
  final Object Function(T row)? keyOf;

  /// Whether to show a leading checkbox column.
  final bool selectable;

  /// Called when a row is tapped.
  final void Function(T row)? onRowTap;

  /// The height of the scrollable table area.
  ///
  /// Required unless an ancestor already bounds the height — see the class
  /// docs.
  final double? height;

  final double? rowHeight;
  final double? headerHeight;

  /// Builds the widget shown when there are no rows after filtering.
  final WidgetBuilder? emptyBuilder;

  /// Whether to show the pagination bar. Defaults to true when the controller
  /// has a `pageSize`.
  final bool? showPagination;

  /// Replaces the default pagination bar.
  final Widget Function(BuildContext context, ShadDataTableController<T>)?
  paginationBuilder;

  /// Whether the footer reports "n of m row(s) selected".
  final bool showSelectionCount;

  @override
  State<ShadDataTable<T>> createState() => _ShadDataTableState<T>();
}

class _ShadDataTableState<T> extends State<ShadDataTable<T>> {
  @override
  void initState() {
    super.initState();
    widget.controller
      .._columns = widget.columns
      ..addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(ShadDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
    widget.controller._columns = widget.columns;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  List<ShadDataTableColumn<T>> get _visibleColumns =>
      widget.columns.where((c) => c.visible).toList();

  TableSpanExtent? _resolveDataColumnExtent(
    List<ShadDataTableColumn<T>> columns,
    int dataColumnIndex,
  ) {
    final column = columns[dataColumnIndex];
    if (column.extent != null) return column.extent;

    final flexIndex = _flexColumnIndex(columns);
    if (flexIndex != dataColumnIndex) return null;

    final trailingFixed = _sumTrailingFixedExtents(columns, dataColumnIndex);
    if (trailingFixed <= 0) return null;

    return _RemainingMinusTrailingFixedExtent(trailingFixed);
  }

  /// The rightmost column without an [extent] that sits before the trailing
  /// fixed-width suffix.
  int? _flexColumnIndex(List<ShadDataTableColumn<T>> columns) {
    final trailingStart = _trailingFixedStartIndex(columns);
    for (var i = trailingStart - 1; i >= 0; i--) {
      if (columns[i].extent == null) return i;
    }
    return null;
  }

  int _trailingFixedStartIndex(List<ShadDataTableColumn<T>> columns) {
    var start = columns.length;
    while (start > 0 && columns[start - 1].extent is FixedTableSpanExtent) {
      start--;
    }
    return start;
  }

  double _sumTrailingFixedExtents(
    List<ShadDataTableColumn<T>> columns,
    int fromIndex,
  ) {
    var sum = 0.0;
    for (var i = fromIndex + 1; i < columns.length; i++) {
      final extent = columns[i].extent;
      if (extent is! FixedTableSpanExtent) break;
      sum += extent.pixels;
    }
    return sum;
  }

  Widget _buildHeaderCell(
    BuildContext context,
    ShadDataTableColumn<T> column,
  ) {
    final theme = ShadTheme.of(context);
    final controller = widget.controller;
    final isSorted = controller.sortColumnId == column.id;

    final label = Text(column.header, overflow: TextOverflow.ellipsis);
    if (!column.sortable) return label;

    return ShadGestureDetector(
      cursor: SystemMouseCursors.click,
      behavior: HitTestBehavior.opaque,
      onTap: () => controller.sortBy(column.id),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Flexible so a narrow column ellipsizes the label instead of
          // overflowing past the sort indicator.
          Flexible(child: label),
          if (isSorted) ...[
            const SizedBox(width: 4),
            Icon(
              controller.sortDirection == ShadSortDirection.ascending
                  ? LucideIcons.moveDown
                  : LucideIcons.moveUp,
              size: 14,
              color: theme.colorScheme.foreground,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectAllCheckbox(List<T> visibleRows) {
    final controller = widget.controller;
    final keys = visibleRows.map(widget.keyOf!).toList();
    final allSelected = keys.isNotEmpty && keys.every(controller.isSelected);

    return ShadCheckbox(
      value: allSelected,
      onChanged: (value) {
        if (value) {
          controller.selectAll(keys);
        } else {
          for (final key in keys) {
            controller.setSelected(key, selected: false);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasShadTheme(context));
    final theme = ShadTheme.of(context);
    final controller = widget.controller;
    final columns = _visibleColumns;
    final rows = controller.visibleRows;

    final selectionOffset = widget.selectable ? 1 : 0;
    final columnCount = columns.length + selectionOffset;

    final effectiveShowPagination =
        widget.showPagination ?? (controller.pageSize != null);

    Widget table;
    if (rows.isEmpty) {
      table =
          widget.emptyBuilder?.call(context) ??
          const Center(child: ShadEmpty());
    } else {
      table = ShadTable(
        columnCount: columnCount,
        rowCount: rows.length,
        pinnedRowCount: 1,
        columnSpanExtent: (index) {
          if (widget.selectable && index == 0) {
            return _kSelectionColumnExtent;
          }
          return _resolveDataColumnExtent(columns, index - selectionOffset);
        },
        header: (context, column) {
          if (widget.selectable && column == 0) {
            return ShadTableCell.header(
              height: widget.headerHeight,
              padding: _kSelectionCellPadding,
              child: _buildSelectAllCheckbox(rows),
            );
          }
          final definition = columns[column - selectionOffset];
          final dataColumnIndex = column - selectionOffset;
          final isLastColumn = dataColumnIndex == columns.length - 1;
          return ShadTableCell.header(
            alignment: definition.headerAlignment ?? definition.alignment,
            height: widget.headerHeight,
            padding: isLastColumn ? _kTrailingCellPadding : null,
            child: _buildHeaderCell(context, definition),
          );
        },
        builder: (context, vicinity) {
          final row = rows[vicinity.row];
          if (widget.selectable && vicinity.column == 0) {
            final key = widget.keyOf!(row);
            return ShadTableCell(
              height: widget.rowHeight,
              padding: _kSelectionCellPadding,
              child: ShadCheckbox(
                value: controller.isSelected(key),
                onChanged: (_) => controller.toggleSelected(key),
              ),
            );
          }
          final definition = columns[vicinity.column - selectionOffset];
          final dataColumnIndex = vicinity.column - selectionOffset;
          final isLastColumn = dataColumnIndex == columns.length - 1;
          return ShadTableCell(
            alignment: definition.alignment,
            height: widget.rowHeight,
            padding: isLastColumn ? _kTrailingCellPadding : null,
            child: definition.cellBuilder(context, row),
          );
        },
        onRowTap: widget.onRowTap == null
            ? null
            : (index) {
                // Row 0 is the pinned header, so data rows are offset by one.
                if (index == 0 || index > rows.length) return;
                widget.onRowTap!(rows[index - 1]);
              },
      );
    }

    if (widget.height != null) {
      table = SizedBox(height: widget.height, child: table);
    }

    final footerChildren = <Widget>[];
    if (widget.selectable && widget.showSelectionCount) {
      final total = controller.filteredRows.length;
      footerChildren.add(
        Text(
          '${controller.selectedKeys.length} of $total row(s) selected.',
          style: theme.textTheme.muted,
        ),
      );
    }
    if (effectiveShowPagination) {
      footerChildren
        ..add(const Spacer())
        ..add(
          widget.paginationBuilder?.call(context, controller) ??
              ShadPaginationCompact(
                page: controller.page,
                pageCount: controller.pageCount,
                onPageChanged: (page) => controller.page = page,
              ),
        );
    }

    if (footerChildren.isEmpty) return table;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.height != null) table else Expanded(child: table),
        const SizedBox(height: 12),
        Row(children: footerChildren),
      ],
    );
  }
}
