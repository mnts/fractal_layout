import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/section/search.dart';
import '../index.dart';
import 'fscreen.dart';

class NavScreen extends StatefulWidget {
  final NodeFractal node;
  const NavScreen({super.key, required this.node});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  late final path = <NodeFractal>[widget.node];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return FractalScaffold(
      title: const SearchBox(),
      body: FScreen(
        Row(
          key: const Key('subDrawerList'),
          //[app],
          //itemCount: path.length,
          //scrollDirection: Axis.horizontal,
          //itemBuilder: (ctx, i) {
          children: [
            ...Iterable<int>.generate(path.length).toList().map(
                  (i) => ((i + 1 < path.length)
                      ? SizedBox(
                          width: 320,
                          child: buildScreen(i),
                        )
                      : Expanded(
                          child: buildScreen(i),
                        )),
                ),
          ],
        ),
      ),
    );
  }

  Widget buildScreen(int i) {
    final node = path[i];
    return ScreensArea(
      node: node,
      expand: (next) {
        setState(() {
          path
            ..removeRange(i + 1, path.length)
            ..add(next);
        });
      },
      key: node.widgetKey(
        'nav',
      ),
    );
  }
}
