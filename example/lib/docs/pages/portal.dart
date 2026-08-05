import 'package:example/docs/docs.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

final portalDoc = ComponentDoc(
  slug: 'portal',
  title: 'Portal',
  description:
      'The raw overlay primitive underneath popover, select, tooltip and '
      'menus: renders a follower widget anchored to its child, above '
      'everything else.',
  playgroundRoute: '/portal',
  body: (context) {
    final theme = ShadTheme.of(context);
    return Text(
      'ShadPortal is a building block rather than an end-user component: '
      'reach for ShadPopover, ShadTooltip or the menu components first, and '
      'drop down to the portal only when building a new floating surface. '
      'The playground shows the anchoring modes.',
      style: theme.textTheme.p,
    );
  },
);
