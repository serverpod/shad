import 'package:example/common/theme_editor/preview_panel.dart';
import 'package:flutter/material.dart';

/// The playground: shadcn/ui's `/create` preview, themed by whatever the
/// customizer panel is currently configured to.
///
/// It carries no theme of its own — the app is built from the editor's
/// configuration, so this is an ordinary page that happens to be a dense
/// enough dashboard to judge a theme by.
class PlaygroundScreen extends StatelessWidget {
  const PlaygroundScreen({super.key});

  @override
  Widget build(BuildContext context) => const ThemePreviewPanel();
}
