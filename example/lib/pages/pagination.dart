import 'package:example/common/base_scaffold.dart';
import 'package:example/common/properties/bool_property.dart';
import 'package:example/common/properties/string_property.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PaginationPage extends StatefulWidget {
  const PaginationPage({super.key});

  @override
  State<PaginationPage> createState() => _PaginationPageState();
}

class _PaginationPageState extends State<PaginationPage> {
  int page = 5;
  int pageCount = 20;
  int siblingCount = 1;
  int boundaryCount = 1;
  bool showEdges = true;
  bool enabled = true;

  void setPage(int value) => setState(() => page = value);

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return BaseScaffold(
      appBarTitle: 'Pagination',
      editable: [
        MyStringProperty(
          label: 'pageCount',
          initialValue: '$pageCount',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            final maybe = int.tryParse(value);
            if (maybe != null && maybe > 0) {
              setState(() {
                pageCount = maybe;
                if (page > pageCount) page = pageCount;
              });
            }
          },
        ),
        MyStringProperty(
          label: 'siblingCount',
          initialValue: '$siblingCount',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            final maybe = int.tryParse(value);
            if (maybe != null) setState(() => siblingCount = maybe);
          },
        ),
        MyStringProperty(
          label: 'boundaryCount',
          initialValue: '$boundaryCount',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            final maybe = int.tryParse(value);
            if (maybe != null) setState(() => boundaryCount = maybe);
          },
        ),
        MyBoolProperty(
          label: 'showEdges',
          value: showEdges,
          onChanged: (value) => setState(() => showEdges = value),
        ),
        MyBoolProperty(
          label: 'enabled',
          value: enabled,
          onChanged: (value) => setState(() => enabled = value),
        ),
      ],
      children: [
        Text('Full', style: theme.textTheme.h4),
        ShadPagination(
          page: page,
          pageCount: pageCount,
          siblingCount: siblingCount,
          boundaryCount: boundaryCount,
          showEdges: showEdges,
          enabled: enabled,
          onPageChanged: setPage,
        ),
        Text('page $page of $pageCount', style: theme.textTheme.muted),
        const SizedBox(height: 24),
        Text('Compact', style: theme.textTheme.h4),
        ShadPaginationCompact(
          page: page,
          pageCount: pageCount,
          enabled: enabled,
          onPageChanged: setPage,
        ),
      ],
    );
  }
}
