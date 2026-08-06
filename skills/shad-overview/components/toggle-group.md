# Toggle Group

A set of two-state buttons that can be toggled on or off.

## Single

Selecting one value clears the others.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ToggleGroupBasicExample extends StatefulWidget {
  const ToggleGroupBasicExample({super.key});

  @override
  State<ToggleGroupBasicExample> createState() =>
      _ToggleGroupBasicExampleState();
}

class _ToggleGroupBasicExampleState extends State<ToggleGroupBasicExample> {
  Set<String> alignment = {'left'};

  @override
  Widget build(BuildContext context) {
    return ShadToggleGroup<String>(
      values: alignment,
      onChanged: (values) => setState(() => alignment = values),
      children: const [
        ShadToggleGroupItem(
          value: 'left',
          semanticLabel: 'Align left',
          child: Icon(LucideIcons.alignLeft),
        ),
        ShadToggleGroupItem(
          value: 'center',
          semanticLabel: 'Align center',
          child: Icon(LucideIcons.alignCenter),
        ),
        ShadToggleGroupItem(
          value: 'right',
          semanticLabel: 'Align right',
          child: Icon(LucideIcons.alignRight),
        ),
      ],
    );
  }
}
```

## Multiple

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ToggleGroupMultipleExample extends StatefulWidget {
  const ToggleGroupMultipleExample({super.key});

  @override
  State<ToggleGroupMultipleExample> createState() =>
      _ToggleGroupMultipleExampleState();
}

class _ToggleGroupMultipleExampleState
    extends State<ToggleGroupMultipleExample> {
  Set<String> formatting = {'bold'};

  @override
  Widget build(BuildContext context) {
    return ShadToggleGroup<String>.multiple(
      values: formatting,
      onChanged: (values) => setState(() => formatting = values),
      children: const [
        ShadToggleGroupItem(
          value: 'bold',
          semanticLabel: 'Bold',
          child: Icon(LucideIcons.bold),
        ),
        ShadToggleGroupItem(
          value: 'italic',
          semanticLabel: 'Italic',
          child: Icon(LucideIcons.italic),
        ),
        ShadToggleGroupItem(
          value: 'underline',
          semanticLabel: 'Underline',
          child: Icon(LucideIcons.underline),
        ),
      ],
    );
  }
}
```

## Outline

Every item uses the outline toggle style.

```dart
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ToggleGroupOutlineExample extends StatefulWidget {
  const ToggleGroupOutlineExample({super.key});

  @override
  State<ToggleGroupOutlineExample> createState() =>
      _ToggleGroupOutlineExampleState();
}

class _ToggleGroupOutlineExampleState extends State<ToggleGroupOutlineExample> {
  Set<String> values = const {'bold'};

  @override
  Widget build(BuildContext context) {
    return ShadToggleGroup<String>(
      values: values,
      toggleVariant: ShadToggleVariant.outline,
      onChanged: (next) => setState(() => values = next),
      children: const [
        ShadToggleGroupItem(
          value: 'bold',
          semanticLabel: 'Bold',
          child: Icon(LucideIcons.bold),
        ),
        ShadToggleGroupItem(
          value: 'italic',
          semanticLabel: 'Italic',
          child: Icon(LucideIcons.italic),
        ),
        ShadToggleGroupItem(
          value: 'underline',
          semanticLabel: 'Underline',
          child: Icon(LucideIcons.underline),
        ),
      ],
    );
  }
}
```

