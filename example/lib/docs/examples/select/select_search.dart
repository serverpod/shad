import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

const _dartFrameworks = {
  'serverpod': 'Serverpod',
  'relic': 'Relic',
  'flutter': 'Flutter',
  'flame': 'Flame',
  'jaspr': 'Jaspr',
  'drift': 'Drift',
  'riverpod': 'Riverpod',
  'melos': 'Melos',
  'mason': 'Mason',
  'very_good_cli': 'Very Good CLI',
};

class SelectSearchExample extends StatefulWidget {
  const SelectSearchExample({super.key});

  @override
  State<SelectSearchExample> createState() => _SelectSearchExampleState();
}

class _SelectSearchExampleState extends State<SelectSearchExample> {
  var searchValue = '';

  Map<String, String> get filtered => {
    for (final entry in _dartFrameworks.entries)
      if (entry.value.toLowerCase().contains(searchValue.toLowerCase()))
        entry.key: entry.value,
  };

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 180),
      child: ShadSelect<String>.withSearch(
        minWidth: 180,
        placeholder: const Text('Select framework...'),
        onSearchChanged: (value) => setState(() => searchValue = value),
        searchPlaceholder: const Text('Search framework'),
        options: [
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text('No framework found'),
            ),
          for (final entry in _dartFrameworks.entries)
            Offstage(
              offstage: !filtered.containsKey(entry.key),
              child: ShadOption(value: entry.key, child: Text(entry.value)),
            ),
        ],
        selectedOptionBuilder: (context, value) =>
            Text(_dartFrameworks[value]!),
        onChanged: (value) {},
      ),
    );
  }
}
