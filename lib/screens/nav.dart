import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/section/search.dart';
import 'package:velocity_x/velocity_x.dart';

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
            ...path.mapIndexed(
              (e, i) {
                return i + 1 < path.length
                    ? SizedBox(
                        width: 320,
                        child: buildScreen(i),
                      )
                    : Expanded(
                        child: buildScreen(i),
                      );
              },
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
      expand: (curNode, next) {
        if (next is! NodeFractal) return 0;
        setState(() {
          path
            ..removeRange(i + 1, path.length)
            ..add(next);
        });
        return path.length;
      },
      key: node.widgetKey(
        'nav',
      ),
    );
  }
}
