import 'dart:async';
import 'dart:ui';
import 'package:dartlin/collections.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/models/index.dart';
import 'package:fractal_layout/widgets/background.dart';
import 'package:go_router/go_router.dart';
import 'package:signed_fractal/signed_fractal.dart';

import '../../widget.dart';
import '../thing.dart';

class SlidesFScaffold extends FractalWidget {
  SlidesFScaffold(
    super.node, {
    super.key,
  });

  @override
  Widget scaffold(BuildContext context) {
    final rew = context.read<Rewritable?>();
    final w = MediaQuery.of(context).size.width;
    if (rew case NodeFractal node) node.preload();
    return Listen(
      node.sorted,
      (ctx, child) => DefaultTabController(
        length: node.sorted.value.length,
        child: FractalScaffold(
          key: Key('@${node.hash}'),
          node: rew as NodeFractal? ?? node,
          title: Theme(
              data: ThemeData(
                textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: Colors.white,
                      displayColor: Colors.white,
                    ),
                listTileTheme: const ListTileThemeData(
                  textColor: Colors.white,
                  iconColor: Colors.white,
                ),
                tabBarTheme: const TabBarTheme(
                  unselectedLabelColor: Colors.white60,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  tabAlignment: TabAlignment.center,
                  dividerHeight: 0,
                ),
              ),
              child: TabBar(
                padding: const EdgeInsets.only(top: 7),
                indicatorPadding: const EdgeInsets.all(0),
                tabs: <Widget>[
                  ...node.sorted.value.mapIndexed(tab),
                ],
                isScrollable: true,
              )),
          body: Watch<NodeFractal>(
            node,
            (ctx, child) => area(ctx),
          ),
        ),
      ),
    );
  }

  @override
  area(context) => Builder(builder: (context) {
        final pad = FractalPad.of(context).pad;

        return Listen(
          node.sorted,
          (ctx, child) => node.sorted.value.isEmpty
              ? Container()
              : TabBarView(
                  children: [
                    ...node.sorted.value.map(
                      (f) => FractalThing(f),
                    ),
                  ],
                ),
        );
      });

  static Timer? timer;
  order(EventFractal f, int i) {
    timer?.cancel();
    timer = Timer(
      const Duration(milliseconds: 400),
      () {
        node.sorted.order(f, i);
        //cb?.call();
      },
    );
  }

  Widget tab(int index, EventFractal f) {
    f.preload();
    return Tab(
      icon: Listen(
        f,
        (ctx, child) => Tooltip(
          message: f.display,
          child: GestureDetector(
            onLongPress: () {
              if (f case NodeFractal node) ConfigFArea.dialog(node);
            },
            child: SizedBox.square(
              dimension: 48,
              child: FIcon(
                f,
                noImage: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
