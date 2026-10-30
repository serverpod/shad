import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ContextMenuSubmenusExample extends StatelessWidget {
  const ContextMenuSubmenusExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    const divider = ShadSeparator.horizontal(
      margin: EdgeInsets.symmetric(vertical: 4),
    );
    const more = Icon(LucideIcons.chevronRight);
    return ShadContextMenuRegion(
      constraints: const BoxConstraints(minWidth: 220),
      items: const [
        ShadContextMenuItem(
          leading: Icon(LucideIcons.folderOpen),
          child: Text('Open'),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.appWindow),
          trailing: more,
          items: [
            ShadContextMenuItem(child: Text('Preview')),
            ShadContextMenuItem(child: Text('Text Editor')),
            ShadContextMenuItem(child: Text('Code')),
            divider,
            ShadContextMenuItem(child: Text('Other...')),
          ],
          child: Text('Open With'),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.share2),
          trailing: more,
          items: [
            ShadContextMenuItem(child: Text('Email')),
            ShadContextMenuItem(child: Text('Messages')),
            ShadContextMenuItem(child: Text('AirDrop')),
            ShadContextMenuItem(
              trailing: more,
              items: [
                ShadContextMenuItem(child: Text('Copy Link')),
                ShadContextMenuItem(child: Text('Copy Embed Code')),
                ShadContextMenuItem(child: Text('Copy as Markdown')),
              ],
              child: Text('Copy'),
            ),
          ],
          child: Text('Share'),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.folderInput),
          trailing: more,
          items: [
            ShadContextMenuItem(child: Text('Desktop')),
            ShadContextMenuItem(child: Text('Documents')),
            ShadContextMenuItem(child: Text('Downloads')),
            ShadContextMenuItem(
              trailing: more,
              items: [
                ShadContextMenuItem(child: Text('Design')),
                ShadContextMenuItem(child: Text('Engineering')),
                ShadContextMenuItem(child: Text('Marketing')),
              ],
              child: Text('Projects'),
            ),
          ],
          child: Text('Move To'),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.tag),
          trailing: more,
          items: [
            ShadContextMenuItem(child: Text('Red')),
            ShadContextMenuItem(child: Text('Orange')),
            ShadContextMenuItem(child: Text('Green')),
            ShadContextMenuItem(child: Text('Blue')),
            divider,
            ShadContextMenuItem(child: Text('Edit Tags...')),
          ],
          child: Text('Tags'),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.arrowUpDown),
          trailing: more,
          items: [
            ShadContextMenuItem(child: Text('Name')),
            ShadContextMenuItem(child: Text('Date Modified')),
            ShadContextMenuItem(child: Text('Size')),
            ShadContextMenuItem(child: Text('Kind')),
          ],
          child: Text('Sort By'),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.layoutGrid),
          trailing: more,
          items: [
            ShadContextMenuItem(child: Text('Icons')),
            ShadContextMenuItem(child: Text('List')),
            ShadContextMenuItem(child: Text('Columns')),
            ShadContextMenuItem(child: Text('Gallery')),
          ],
          child: Text('View As'),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.copy),
          trailing: more,
          items: [
            ShadContextMenuItem(child: Text('Duplicate')),
            ShadContextMenuItem(child: Text('Copy Path')),
            ShadContextMenuItem(child: Text('Copy Name')),
          ],
          child: Text('Copy'),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.zap),
          trailing: more,
          items: [
            ShadContextMenuItem(child: Text('Compress')),
            ShadContextMenuItem(child: Text('Convert Image')),
            ShadContextMenuItem(child: Text('Remove Background')),
            ShadContextMenuItem(child: Text('Create PDF')),
          ],
          child: Text('Quick Actions'),
        ),
        divider,
        ShadContextMenuItem(
          leading: Icon(LucideIcons.trash2),
          destructive: true,
          child: Text('Move to Trash'),
        ),
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
