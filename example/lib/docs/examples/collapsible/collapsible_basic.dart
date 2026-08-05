import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CollapsibleBasicExample extends StatelessWidget {
  const CollapsibleBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return SizedBox(
      width: 350,
      child: ShadCollapsible(
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
                open ? LucideIcons.chevronsDownUp : LucideIcons.chevronsUpDown,
              ),
              semanticLabel: open ? 'Collapse' : 'Expand',
              onPressed: toggle,
            ),
          ],
        ),
        child: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ShadCard(child: Text('@radix-ui/primitives')),
              SizedBox(height: 8),
              ShadCard(child: Text('@radix-ui/colors')),
              SizedBox(height: 8),
              ShadCard(child: Text('@stitches/react')),
            ],
          ),
        ),
      ),
    );
  }
}
