import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// The placeholder used to be driven by a ValueListenableBuilder wrapped
/// around the whole field, so every keystroke — and every cursor move, since
/// TextEditingController notifies on selection changes too — rebuilt
/// EditableText, the decorator, the scrollbar and the leading/trailing row.
/// It is now driven by a derived notifier scoped to the placeholder alone.
/// These tests pin the visible behaviour that refactor had to preserve.
void main() {
  Widget wrap(Widget child) => ShadApp(home: child);

  testWidgets('placeholder shows when empty and hides once text is typed', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const ShadInput(placeholder: Text('Email'))),
    );

    expect(find.text('Email'), findsOneWidget);

    await tester.enterText(find.byType(ShadInput), 'a');
    await tester.pump();
    expect(find.text('Email'), findsNothing);

    await tester.enterText(find.byType(ShadInput), '');
    await tester.pump();
    expect(find.text('Email'), findsOneWidget);
  });

  testWidgets('placeholder is hidden when an initialValue is provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const ShadInput(initialValue: 'hello', placeholder: Text('Email')),
      ),
    );

    expect(find.text('Email'), findsNothing);
  });

  testWidgets('placeholder follows an external controller', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      wrap(
        ShadInput(controller: controller, placeholder: const Text('Email')),
      ),
    );
    expect(find.text('Email'), findsOneWidget);

    controller.text = 'typed externally';
    await tester.pump();
    expect(find.text('Email'), findsNothing);

    controller.clear();
    await tester.pump();
    expect(find.text('Email'), findsOneWidget);
  });

  testWidgets('placeholder follows a swapped controller', (tester) async {
    final first = TextEditingController(text: 'filled');
    final second = TextEditingController();
    addTearDown(first.dispose);
    addTearDown(second.dispose);

    await tester.pumpWidget(
      wrap(ShadInput(controller: first, placeholder: const Text('Email'))),
    );
    expect(find.text('Email'), findsNothing);

    await tester.pumpWidget(
      wrap(ShadInput(controller: second, placeholder: const Text('Email'))),
    );
    expect(find.text('Email'), findsOneWidget);

    // The old controller must no longer drive the placeholder.
    first.text = 'still filled';
    await tester.pump();
    expect(find.text('Email'), findsOneWidget);
  });

  testWidgets('moving the cursor does not toggle the placeholder', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'abc');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      wrap(
        ShadInput(controller: controller, placeholder: const Text('Email')),
      ),
    );
    expect(find.text('Email'), findsNothing);

    controller.selection = const TextSelection.collapsed(offset: 1);
    await tester.pump();
    expect(find.text('Email'), findsNothing);
  });
}
