import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';

import '../index.dart';

class FMem extends StatelessWidget {
  const FMem({super.key});

  static final seq = SortedFrac<NodeFractal<EventFractal>>([
    FSys.system,
  ]);

  @override
  Widget build(BuildContext context) {
    return FractalTooltip(
      content: nav,
      width: 300,
      height: 400,
      child: Tooltip(
        message: 'Objects loaded',
        child: Listen(
          Fractal.map,
          (ctx, child) => Container(
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppFractal.active.wb.withAlpha(160),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${Fractal.map.map.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                if (Fractal.map.requests.length case int numNew when numNew > 0)
                  Text(
                    '${Fractal.map.requests.length}',
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get nav => FractalSub(
        key: const Key('subMemList'),
        sequence: seq,
        buildView: (ev, exp) => switch (ev) {
          NodeFractal node => ScreensArea(
              node: node,
              expand: exp,
              key: ev.widgetKey(
                'nav',
              ),
              onTap: (f) {
                if (f case NodeFractal node) {
                  exp(node);
                  /*
                  if (node.runtimeType != NodeFractal ||
                      node['screen'] is String) {
                    FractalLayoutState.active.go(node);
                    FractalScaffoldState.active.closeDrawers();
                  }
                  */
                  //node.onTap(context);
                }
              }),
          _ => Container(),
        },
      );
}
