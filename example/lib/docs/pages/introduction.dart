import 'package:example/docs/docs.dart';

final introductionDoc = ComponentDoc(
  slug: 'introduction',
  title: 'Introduction',
  description:
      'shadcn/ui, built for Flutter. The components, the eight styles, and '
      'the theme system match the reference down to the pixel.',
  body: (context) => const DocProse(
    children: [
      DocParagraph(
        'shad is a Flutter implementation of shadcn/ui. It is a port in the '
        'strict sense. Every color, radius, padding, shadow, and type size '
        'comes from the reference CSS instead of an approximation, so a '
        'screen built with shad sits next to its web counterpart without a '
        'seam.',
      ),
      DocParagraph(
        'The library is self-contained. Components use the Flutter widgets '
        'layer directly, with no Material or Cupertino dependency, and '
        'every visual decision flows from the theme. Restyling an app is '
        'configuration, not surgery: swap the color scheme, the corner '
        'radius, or the entire style preset, and every component follows.',
      ),
      DocSection(
        title: "What's in the box",
        children: [
          DocBullets(
            items: [
              'The shadcn/ui component set: buttons, forms, and menus, '
                  'plus the command palette, data table, calendar, and '
                  'sidebar.',
              'The eight shadcn styles (vega, nova, maia, lyra, mira, '
                  'luma, sera, and rhea) as complete presets: geometry, '
                  'typography, and shadows, switchable with one setting.',
              'Sixteen color schemes, each in light and dark, plus the '
                  'menu finishes from the shadcn theme editor: inverted, '
                  'translucent, and bold accent.',
              'Lucide icons through `LucideIcons` and `flutter_animate` '
                  'effects, both re-exported so a single import covers '
                  'them.',
            ],
          ),
        ],
      ),
      DocSection(
        title: 'About these docs',
        children: [
          DocParagraph(
            'Every example on these pages is a real widget. The code under '
            'the Code tab is the exact file the preview runs, bundled into '
            'the app as an asset, so the two can never drift apart.',
          ),
          DocParagraph(
            'This documentation app is itself built with shad. Open the '
            'theme editor with the paintbrush button in the top bar and '
            'change the style, palette, or radius. The whole app '
            'restyles, including these pages.',
          ),
        ],
      ),
    ],
  ),
);
