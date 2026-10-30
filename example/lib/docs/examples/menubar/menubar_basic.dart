import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class MenubarBasicExample extends StatelessWidget {
  const MenubarBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    const divider = ShadSeparator.horizontal(
      margin: EdgeInsets.symmetric(vertical: 4),
    );
    return ShadMenubar(
      items: const [
        ShadMenubarItem(
          items: [
            ShadContextMenuItem(child: Text('New Tab')),
            ShadContextMenuItem(child: Text('New Window')),
            ShadContextMenuItem(
              enabled: false,
              child: Text('New Incognito Window'),
            ),
            divider,
            ShadContextMenuItem(
              trailing: Icon(LucideIcons.chevronRight),
              items: [
                ShadContextMenuItem(child: Text('Email Link')),
                ShadContextMenuItem(child: Text('Messages')),
                ShadContextMenuItem(child: Text('Notes')),
              ],
              child: Text('Share'),
            ),
            ShadContextMenuItem(
              trailing: Icon(LucideIcons.chevronRight),
              items: [
                ShadContextMenuItem(child: Text('PDF')),
                ShadContextMenuItem(child: Text('HTML')),
                ShadContextMenuItem(child: Text('Plain Text')),
              ],
              child: Text('Export As'),
            ),
            divider,
            ShadContextMenuItem(child: Text('Print...')),
          ],
          child: Text('File'),
        ),
        ShadMenubarItem(
          items: [
            ShadContextMenuItem(child: Text('Undo')),
            ShadContextMenuItem(child: Text('Redo')),
            divider,
            ShadContextMenuItem(
              trailing: Icon(LucideIcons.chevronRight),
              items: [
                ShadContextMenuItem(child: Text('Search the Web')),
                divider,
                ShadContextMenuItem(child: Text('Find...')),
                ShadContextMenuItem(child: Text('Find Next')),
                ShadContextMenuItem(child: Text('Find Previous')),
              ],
              child: Text('Find'),
            ),
            divider,
            ShadContextMenuItem(child: Text('Cut')),
            ShadContextMenuItem(child: Text('Copy')),
            ShadContextMenuItem(child: Text('Paste')),
          ],
          child: Text('Edit'),
        ),
        ShadMenubarItem(
          items: [
            ShadContextMenuItem(
              leading: Icon(LucideIcons.check),
              child: Text('Always Show Full URLs'),
            ),
            ShadContextMenuItem.inset(child: Text('Reload')),
            ShadContextMenuItem.inset(child: Text('Toggle Full Screen')),
          ],
          child: Text('View'),
        ),
      ],
    );
  }
}
