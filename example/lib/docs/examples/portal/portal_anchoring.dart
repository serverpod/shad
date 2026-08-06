import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';

/// Cycles `ShadAnchorAuto` follower anchors on a hover-triggered portal.
class PortalAnchoringExample extends StatefulWidget {
  const PortalAnchoringExample({super.key});

  @override
  State<PortalAnchoringExample> createState() => _PortalAnchoringExampleState();
}

class _PortalAnchoringExampleState extends State<PortalAnchoringExample> {
  var visible = false;
  late final Timer timer;
  var alignmentIndex = 0;

  static const _alignments = [
    AlignmentGeometry.topStart,
    AlignmentGeometry.topCenter,
    AlignmentGeometry.topEnd,
    AlignmentGeometry.centerStart,
    AlignmentGeometry.center,
    AlignmentGeometry.centerEnd,
    AlignmentGeometry.bottomStart,
    AlignmentGeometry.bottomCenter,
    AlignmentGeometry.bottomEnd,
  ];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        alignmentIndex = (alignmentIndex + 1) % _alignments.length;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final alignment = _alignments[alignmentIndex];

    return SizedBox(
      height: 320,
      width: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                alignment.toString(),
                style: theme.textTheme.muted,
              ),
            ),
          ),
          Align(
            child: ShadPortal(
              anchor: ShadAnchorAuto(followerAnchor: alignment),
              visible: visible,
              portalBuilder: (context) {
                return ShadMouseArea(
                  groupId: 'portal-demo',
                  child: ColoredBox(
                    color: theme.colorScheme.primary,
                    child: const SizedBox(
                      width: 200,
                      height: 200,
                      child: Center(
                        child: Text('200x200'),
                      ),
                    ),
                  ),
                );
              },
              child: ShadMouseArea(
                groupId: 'portal-demo',
                onEnter: (_) => setState(() => visible = true),
                onExit: (_) => setState(() => visible = false),
                child: ColoredBox(
                  color: theme.colorScheme.destructive,
                  child: const SizedBox(
                    width: 100,
                    height: 100,
                    child: Center(
                      child: Text('100x100'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
