import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

class ResizableBasicExample extends StatelessWidget {
  const ResizableBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return SizedBox(
      width: 300,
      height: 200,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: theme.radius,
          border: Border.all(color: theme.colorScheme.border),
        ),
        child: ClipRRect(
          borderRadius: theme.radius,
          child: ShadResizablePanelGroup(
            showHandle: true,
            children: [
              ShadResizablePanel(
                id: 0,
                defaultSize: .5,
                minSize: .2,
                child: const Center(child: Text('One')),
              ),
              ShadResizablePanel(
                id: 1,
                defaultSize: .5,
                child: ShadResizablePanelGroup(
                  axis: Axis.vertical,
                  showHandle: true,
                  children: [
                    ShadResizablePanel(
                      id: 0,
                      defaultSize: .5,
                      child: const Center(child: Text('Two')),
                    ),
                    ShadResizablePanel(
                      id: 1,
                      defaultSize: .5,
                      child: const Center(child: Text('Three')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
