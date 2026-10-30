import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class DropdownMenuBasicExample extends StatelessWidget {
  const DropdownMenuBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadDropdownMenu(
      constraints: const BoxConstraints(minWidth: 224),
      items: const [
        ShadContextMenuItem(
          leading: Icon(LucideIcons.user),
          trailing: Text('⇧⌘P'),
          child: Text('Profile'),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.settings),
          trailing: Text('⌘S'),
          child: Text('Settings'),
        ),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.users),
          trailing: Icon(LucideIcons.chevronRight),
          items: [
            ShadContextMenuItem(child: Text('Email')),
            ShadContextMenuItem(child: Text('Message')),
          ],
          child: Text('Invite users'),
        ),
        ShadSeparator.horizontal(margin: EdgeInsets.symmetric(vertical: 4)),
        ShadContextMenuItem(
          leading: Icon(LucideIcons.logOut),
          destructive: true,
          child: Text('Log out'),
        ),
      ],
      builder: (context, controller, _) => ShadButton.outline(
        onPressed: controller.toggle,
        child: const Text('Open'),
      ),
    );
  }
}
