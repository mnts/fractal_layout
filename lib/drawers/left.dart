import '../index.dart';
import '../widget.dart';

class FLeftDrawer extends StatefulWidget {
  const FLeftDrawer({super.key});

  @override
  State<FLeftDrawer> createState() => _FLeftDrawerState();
}

class _FLeftDrawerState extends State<FLeftDrawer> {
  bool get isWide => FractalScaffoldState.active.isWide;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    final layout = FractalLayoutState.active;

    return Stack(alignment: Alignment.topCenter, children: [
      if (FractalScaffoldState.isMobile) const StatusPad(),
      FractalSub(
        key: const Key('subDrawerList'),
        sequence: FractalLayoutState.active.sequence,
        //[app],
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
                  node.onTap(context);
                }
              },
            ),
          _ => Container(),
        },
        ctrls: [
          if (isWide)
            IconButton(
              onPressed: () {
                //scaffoldKey.currentState?.closeDrawer();
                FractalScaffoldState.active.setState(() {
                  layout.leftLocked = !layout.leftLocked;
                });
              },
              icon: Icon(
                layout.leftLocked ? Icons.menu : Icons.menu_open_sharp,
              ),
            )
        ],
      ),
    ]);
  }
}
