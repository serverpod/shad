import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shad/shad.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

/// One documented component: what the sidebar lists and a doc page renders.
class ComponentDoc {
  const ComponentDoc({
    required this.slug,
    required this.title,
    required this.description,
    this.playgroundRoute,
    this.examples = const [],
    this.body,
  });

  /// Stable identifier, also the examples' directory name.
  final String slug;

  final String title;

  /// One or two sentences under the title.
  final String description;

  /// Route of the interactive knob playground for this component, if any.
  final String? playgroundRoute;

  final List<ComponentExample> examples;

  /// Extra content below the examples (or instead of them).
  final WidgetBuilder? body;
}

/// One example on a doc page: a live preview plus its source file.
///
/// The source shown is the *actual file* the preview widget lives in —
/// `lib/docs/examples/<slug>/<id>.dart`, bundled as an asset — so the code on
/// screen can never drift from the code that runs.
class ComponentExample {
  const ComponentExample({
    required this.id,
    required this.title,
    this.description,
    required this.builder,
    this.minPreviewHeight = 220,
    this.padding = const EdgeInsets.all(32),
  });

  /// The example's file name without extension.
  final String id;

  final String title;
  final String? description;
  final WidgetBuilder builder;
  final double minPreviewHeight;
  final EdgeInsetsGeometry padding;

  String assetPath(String slug) => 'lib/docs/examples/$slug/$id.dart';
}

/// A titled section of the docs sidebar.
class DocGroup {
  const DocGroup({required this.title, required this.items});

  final String title;
  final List<ComponentDoc> items;
}

/// Loads the Dart grammar and highlighter theme once, before the app runs.
class CodeHighlighter {
  CodeHighlighter._();

  static Highlighter? _dart;

  static Future<void> ensureInitialized() async {
    if (_dart != null) return;
    await Highlighter.initialize(['dart']);
    // Code blocks are always dark, like shadcn's docs, so only the dark
    // highlighter theme is needed.
    final theme = await HighlighterTheme.loadDarkTheme();
    _dart = Highlighter(language: 'dart', theme: theme);
  }

  static TextSpan highlight(String code) {
    final highlighter = _dart;
    if (highlighter == null) {
      return TextSpan(text: code);
    }
    return highlighter.highlight(code);
  }
}

/// A dark, syntax-highlighted code block with a copy button.
///
/// Dark in both themes, like shadcn's docs: a code block is a terminal-like
/// artefact, not part of the themed page.
class CodeBlock extends StatelessWidget {
  const CodeBlock({super.key, required this.code, this.maxHeight = 480});

  /// Renders the bundled source file at [assetPath].
  static Widget asset(String assetPath, {double maxHeight = 480}) =>
      _AssetCodeBlock(assetPath: assetPath, maxHeight: maxHeight);

  final String code;
  final double? maxHeight;

  static const _background = Color(0xFF09090B);
  static const _border = Color(0x1AFFFFFF);

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    Widget content = SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text.rich(
          CodeHighlighter.highlight(code.trimRight()),
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 13,
            height: 1.6,
            color: Color(0xFFD4D4D8),
          ),
        ),
      ),
    );

    if (maxHeight != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight!),
        child: content,
      );
    }

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _background,
        borderRadius: theme.radii.lg,
        border: Border.all(color: _border),
      ),
      child: Stack(
        children: [
          content,
          PositionedDirectional(
            top: 8,
            end: 8,
            child: _CopyButton(code: code),
          ),
        ],
      ),
    );
  }
}

class _AssetCodeBlock extends StatefulWidget {
  const _AssetCodeBlock({required this.assetPath, required this.maxHeight});

  final String assetPath;
  final double maxHeight;

  @override
  State<_AssetCodeBlock> createState() => _AssetCodeBlockState();
}

class _AssetCodeBlockState extends State<_AssetCodeBlock> {
  late Future<String> _code;

  @override
  void initState() {
    super.initState();
    _code = rootBundle.loadString(widget.assetPath);
  }

  @override
  void didUpdateWidget(_AssetCodeBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.assetPath != oldWidget.assetPath) {
      _code = rootBundle.loadString(widget.assetPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _code,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CodeBlock(
            code:
                '// Missing source asset: ${widget.assetPath}\n'
                '// Add its directory to the example pubspec assets.',
            maxHeight: widget.maxHeight,
          );
        }
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 120,
            child: Center(child: ShadSpinner()),
          );
        }
        return CodeBlock(code: snapshot.data!, maxHeight: widget.maxHeight);
      },
    );
  }
}

class _CopyButton extends StatefulWidget {
  const _CopyButton({required this.code});

  final String code;

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool copied = false;

  @override
  Widget build(BuildContext context) {
    return ShadIconButton.ghost(
      width: 28,
      height: 28,
      iconSize: 14,
      foregroundColor: const Color(0xFFA1A1AA),
      hoverBackgroundColor: const Color(0x1AFFFFFF),
      hoverForegroundColor: const Color(0xFFFAFAFA),
      icon: Icon(copied ? LucideIcons.check : LucideIcons.copy),
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: widget.code));
        if (!mounted) return;
        setState(() => copied = true);
        Future<void>.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) setState(() => copied = false);
        });
      },
    );
  }
}

/// A titled prose section on a documentation page.
///
/// The written pages — installation, theming and so on — are assembled from
/// these: a heading followed by paragraphs, code blocks and lists, with the
/// page supplying the spacing between sections.
class DocSection extends StatelessWidget {
  const DocSection({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: theme.textTheme.h4),
        for (final child in children) ...[
          const SizedBox(height: 12),
          child,
        ],
      ],
    );
  }
}

/// A documentation paragraph.
///
/// Renders `backtick` spans as inline code — a mono face on the muted
/// surface — so identifiers read as identifiers without a full code block.
class DocParagraph extends StatelessWidget {
  const DocParagraph(this.text, {super.key});

  final String text;

  /// [text] split into plain and `code` spans.
  static List<InlineSpan> spans(BuildContext context, String text) {
    final theme = ShadTheme.of(context);
    final code = TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: 13,
      color: theme.colorScheme.foreground,
      backgroundColor: theme.colorScheme.muted,
    );
    final parts = text.split('`');
    return [
      for (var i = 0; i < parts.length; i++)
        if (parts[i].isNotEmpty)
          TextSpan(text: parts[i], style: i.isOdd ? code : null),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Text.rich(
      TextSpan(children: spans(context, text)),
      style: theme.textTheme.p,
    );
  }
}

/// A bulleted list, with the same inline-code treatment as [DocParagraph].
class DocBullets extends StatelessWidget {
  const DocBullets({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('•', style: theme.textTheme.p),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    TextSpan(children: DocParagraph.spans(context, item)),
                    style: theme.textTheme.p,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// The body of a written documentation page: sections separated by a
/// consistent gap.
class DocProse extends StatelessWidget {
  const DocProse({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(height: 32),
          children[i],
        ],
      ],
    );
  }
}

/// The bordered live-preview area of an example.
class ExamplePreview extends StatelessWidget {
  const ExamplePreview({
    super.key,
    required this.child,
    this.minHeight = 220,
    this.padding = const EdgeInsets.all(32),
  });

  final Widget child;
  final double minHeight;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.border),
        borderRadius: theme.radii.lg,
      ),
      padding: padding,
      // The preview must not inherit the page's text selection: interactive
      // examples handle their own gestures.
      child: SelectionContainer.disabled(
        child: Center(child: child),
      ),
    );
  }
}

/// A titled example section: heading, optional description, and a
/// Preview / Code tab pair.
class DocExample extends StatelessWidget {
  const DocExample({
    super.key,
    required this.slug,
    required this.example,
  });

  final String slug;
  final ComponentExample example;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(example.title, style: theme.textTheme.h4),
        if (example.description != null) ...[
          const SizedBox(height: 4),
          Text(example.description!, style: theme.textTheme.muted),
        ],
        const SizedBox(height: 12),
        ShadTabs<String>(
          value: 'preview',
          tabBarAlignment: Alignment.centerLeft,
          tabs: [
            ShadTab(
              value: 'preview',
              content: ExamplePreview(
                minHeight: example.minPreviewHeight,
                padding: example.padding,
                child: Builder(builder: example.builder),
              ),
              child: const Text('Preview'),
            ),
            ShadTab(
              value: 'code',
              content: CodeBlock.asset(example.assetPath(slug)),
              child: const Text('Code'),
            ),
          ],
        ),
      ],
    );
  }
}

/// The standard documentation page: title, description, examples.
class ComponentDocPage extends StatelessWidget {
  const ComponentDocPage({super.key, required this.doc});

  final ComponentDoc doc;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SelectionArea(
      child: SingleChildScrollView(
        // A stable key per component so switching pages resets the scroll.
        key: PageStorageKey('docs-${doc.slug}'),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(doc.title, style: theme.textTheme.h2),
                const SizedBox(height: 8),
                Text(doc.description, style: theme.textTheme.lead),
                if (doc.playgroundRoute != null) ...[
                  const SizedBox(height: 16),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: ShadButton.outline(
                      size: ShadButtonSize.sm,
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamed(doc.playgroundRoute!),
                      trailing: const Icon(LucideIcons.arrowUpRight),
                      child: const Text('Open playground'),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                for (final example in doc.examples) ...[
                  DocExample(slug: doc.slug, example: example),
                  const SizedBox(height: 40),
                ],
                if (doc.body != null) Builder(builder: doc.body!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
