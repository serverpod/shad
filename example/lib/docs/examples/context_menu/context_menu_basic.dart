import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ContextMenuBasicExample extends StatelessWidget {
  const ContextMenuBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    const divider = ShadSeparator.horizontal(
      margin: EdgeInsets.symmetric(vertical: 4),
    );
    return ShadContextMenuRegion(
      constraints: const BoxConstraints(minWidth: 300),
      items: const [
        ShadContextMenuItem.inset(child: Text('Back')),
        ShadContextMenuItem.inset(enabled: false, child: Text('Forward')),
        ShadContextMenuItem.inset(child: Text('Reload')),
        ShadContextMenuItem.inset(
          trailing: Icon(LucideIcons.chevronRight),
          items: [
            ShadContextMenuItem(child: Text('Save Page As...')),
            ShadContextMenuItem(child: Text('Create Shortcut...')),
            divider,
            ShadContextMenuItem(child: Text('Developer Tools')),
          ],
          child: Text('More Tools'),
        ),
        divider,
        ShadContextMenuItem(
          leading: Icon(LucideIcons.check),
          child: Text('Show Bookmarks Bar'),
        ),
        ShadContextMenuItem.inset(child: Text('Show Full URLs')),
      ],
      child: Container(
        width: 300,
        height: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.border),
          borderRadius: theme.radii.md,
        ),
        child: const Text('Right click here'),
      ),
    );
  }
}
