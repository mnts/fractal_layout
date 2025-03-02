import 'package:fractal_socket/api.dart';

import '../areas/screens.dart';
import '../widget.dart';
import '../widgets/index.dart';

class FractalNet extends StatefulWidget {
  const FractalNet({super.key});

  @override
  State<FractalNet> createState() => _FractalNetState();
}

class _FractalNetState extends State<FractalNet> {
  static final seq = SortedFrac<NodeFractal<EventFractal>>([
    DeviceFractal.my,
  ]);

  @override
  Widget build(BuildContext context) {
    if (NetworkFractal.out case FSocketAPI soc) {
      return FractalTooltip(
        content: nav,
        width: 300,
        height: 400,
        child: Tooltip(
          message: 'Network',
          child: InkWell(
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.withAlpha(64),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Listen(
                soc.active,
                (ctx, ch) => Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: soc.active.value ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget get nav => FractalSub(
        key: const Key('subNetList'),
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
