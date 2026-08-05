import 'package:example/common/base_scaffold.dart';
import 'package:example/common/properties/bool_property.dart';
import 'package:flutter/material.dart';
import 'package:shad/shad.dart';

class CollapsiblePage extends StatefulWidget {
  const CollapsiblePage({super.key});

  @override
  State<CollapsiblePage> createState() => _CollapsiblePageState();
}

class _CollapsiblePageState extends State<CollapsiblePage> {
  final controller = ShadCollapsibleController(open: true);
  bool maintainState = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return BaseScaffold(
      appBarTitle: 'Collapsible',
      editable: [
        MyBoolProperty(
          label: 'maintainState',
          value: maintainState,
          onChanged: (value) => setState(() => maintainState = value),
        ),
      ],
      children: [
        Text('With a built-in trigger', style: theme.textTheme.h4),
        SizedBox(
          width: 350,
          child: ShadCollapsible(
            maintainState: maintainState,
            trigger: (context, open, toggle) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '@peduarte starred 3 repositories',
                    style: theme.textTheme.small,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ShadIconButton.ghost(
                  icon: Icon(
                    open
                        ? LucideIcons.chevronsDownUp
                        : LucideIcons.chevronsUpDown,
                  ),
                  semanticLabel: open ? 'Collapse' : 'Expand',
                  onPressed: toggle,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ShadCard(child: const Text('@radix-ui/primitives')),
                  const SizedBox(height: 8),
                  ShadCard(child: const Text('@radix-ui/colors')),
                  const SizedBox(height: 8),
                  ShadCard(child: const Text('@stitches/react')),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Driven by an external controller', style: theme.textTheme.h4),
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) => ShadButton.outline(
            onPressed: controller.toggle,
            child: Text(controller.open ? 'Hide details' : 'Show details'),
          ),
        ),
        SizedBox(
          width: 350,
          child: ShadCollapsible(
            controller: controller,
            maintainState: maintainState,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ShadCard(
                title: const Text('Details'),
                child: const Text(
                  'The trigger for this one lives outside the collapsible, so '
                  'the controller is what connects them.',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
