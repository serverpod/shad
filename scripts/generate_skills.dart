// ignore_for_file: avoid_print
//
// Regenerates skills/shad-overview/components/*.md from the example app's
// documentation pages, which are the single source of truth for component
// descriptions and sample code (see CLAUDE.md: "the code shown is the code
// that runs").
//
// Run from the repository root:
//   dart run scripts/generate_skills.dart
//
// This only touches the per-component pages under components/. The overview
// (SKILL.md) and the guides/ directory are maintained by hand, because they
// carry explanatory prose that the example app does not have a source for.

import 'dart:io';

/// Component slugs, in the order `example/lib/docs/registry.dart` lists
/// them. Kept as an explicit list (rather than scanning the directory) so a
/// component only appears here once it has a real docs page.
const _slugs = [
  'accordion',
  'alert',
  'avatar',
  'badge',
  'breadcrumb',
  'button',
  'calendar',
  'card',
  'checkbox',
  'collapsible',
  'command',
  'context_menu',
  'data_table',
  'date_picker',
  'dialog',
  'empty',
  'icon_button',
  'input',
  'input_otp',
  'kbd',
  'keyboard_toolbar',
  'menubar',
  'pagination',
  'popover',
  'progress',
  'radio_group',
  'resizable',
  'select',
  'separator',
  'sheet',
  'sidebar',
  'skeleton',
  'slider',
  'sonner',
  'spinner',
  'switch',
  'table',
  'tabs',
  'textarea',
  'time_picker',
  'toast',
  'toggle',
  'toggle_group',
  'tooltip',
];

void main() {
  final pagesDir = Directory('example/lib/docs/pages');
  final outDir = Directory('skills/shad-overview/components')
    ..createSync(recursive: true);

  // Start clean so a renamed or removed component cannot leave a stale file
  // behind.
  for (final entity in outDir.listSync()) {
    if (entity is File && entity.path.endsWith('.md')) entity.deleteSync();
  }

  final rows = <String>[];

  for (final slug in _slugs) {
    final pageFile = File('${pagesDir.path}/$slug.dart');
    if (!pageFile.existsSync()) {
      stderr.writeln('Skipping $slug: no docs page at ${pageFile.path}');
      continue;
    }
    final source = pageFile.readAsStringSync();
    final page = _parsePage(source);
    final fileName = slug.replaceAll('_', '-');
    File('${outDir.path}/$fileName.md').writeAsStringSync(_render(slug, page));
    rows.add(
      '| ${page.title} | ${page.description} | [$fileName.md](components/$fileName.md) |',
    );
    print('Wrote components/$fileName.md');
  }

  print('');
  print('Component table rows (paste into SKILL.md if the set changed):');
  print(rows.join('\n'));
}

class _Page {
  _Page({
    required this.title,
    required this.description,
    required this.examples,
  });

  final String title;
  final String description;
  final List<_Example> examples;
}

class _Example {
  _Example({required this.id, required this.title, this.description});

  final String id;
  final String title;
  final String? description;
}

_Page _parsePage(String source) {
  final title = _firstMatch(source, RegExp(r"title:\s*'([^']*)'"));

  final examplesIndex = source.indexOf('examples:');
  final descriptionSpan = source.substring(
    source.indexOf('description:'),
    examplesIndex == -1 ? source.indexOf(');') : examplesIndex,
  );
  final description = _concatStrings(descriptionSpan);

  final examples = <_Example>[];
  if (examplesIndex != -1) {
    final block = _bracketedBlock(source, source.indexOf('[', examplesIndex));
    for (final chunk in _splitTopLevel(block, 'ComponentExample(')) {
      final id = _firstMatch(chunk, RegExp(r"id:\s*'([^']*)'"));
      final exTitle = _firstMatch(chunk, RegExp(r"title:\s*'([^']*)'"));
      String? exDescription;
      if (chunk.contains('description:')) {
        final descStart = chunk.indexOf('description:');
        final builderStart = chunk.indexOf('builder:');
        final span = chunk.substring(
          descStart,
          builderStart == -1 ? chunk.length : builderStart,
        );
        exDescription = _concatStrings(span);
      }
      if (id != null && exTitle != null) {
        examples.add(
          _Example(id: id, title: exTitle, description: exDescription),
        );
      }
    }
  }

  return _Page(
    title: title ?? '',
    description: description,
    examples: examples,
  );
}

/// Concatenates every single-quoted string literal in [span], which is how
/// Dart's formatter wraps a long string constant across multiple lines
/// (adjacent string literals).
String _concatStrings(String span) {
  final matches = RegExp(r"'((?:[^'\\]|\\.)*)'").allMatches(span);
  return matches
      .map((m) => m.group(1)!.replaceAll(r"\'", "'").replaceAll(r'\\', r'\'))
      .join();
}

String? _firstMatch(String source, RegExp pattern) =>
    pattern.firstMatch(source)?.group(1);

/// Returns the contents of the bracketed block starting at [openIndex]
/// (which must point at `[` or `(`), matching brackets by depth so nested
/// parens (e.g. `builder: (_) => Foo()`) do not confuse the split below.
String _bracketedBlock(String source, int openIndex) {
  final open = source[openIndex];
  final close = open == '[' ? ']' : ')';
  var depth = 0;
  for (var i = openIndex; i < source.length; i++) {
    if (source[i] == open) depth++;
    if (source[i] == close) {
      depth--;
      if (depth == 0) return source.substring(openIndex + 1, i);
    }
  }
  throw StateError('Unbalanced brackets from index $openIndex');
}

/// Splits [block] into the top-level occurrences of `$marker ... )`,
/// tracking paren depth so nested calls stay inside their own chunk.
List<String> _splitTopLevel(String block, String marker) {
  final chunks = <String>[];
  var searchFrom = 0;
  while (true) {
    final start = block.indexOf(marker, searchFrom);
    if (start == -1) break;
    final openIndex = start + marker.length - 1;
    var depth = 0;
    var end = openIndex;
    for (var i = openIndex; i < block.length; i++) {
      if (block[i] == '(') depth++;
      if (block[i] == ')') {
        depth--;
        if (depth == 0) {
          end = i;
          break;
        }
      }
    }
    chunks.add(block.substring(start, end + 1));
    searchFrom = end + 1;
  }
  return chunks;
}

String _render(String slug, _Page page) {
  final buffer = StringBuffer()
    ..writeln('# ${page.title}')
    ..writeln()
    ..writeln(page.description)
    ..writeln();

  for (final example in page.examples) {
    buffer.writeln('## ${example.title}');
    buffer.writeln();
    if (example.description != null) {
      buffer.writeln(example.description);
      buffer.writeln();
    }
    final exampleFile = File(
      'example/lib/docs/examples/$slug/${example.id}.dart',
    );
    if (exampleFile.existsSync()) {
      buffer
        ..writeln('```dart')
        ..writeln(exampleFile.readAsStringSync().trimRight())
        ..writeln('```')
        ..writeln();
    } else {
      stderr.writeln(
        'Missing example source: ${exampleFile.path} (referenced by $slug)',
      );
    }
  }

  return buffer.toString();
}
