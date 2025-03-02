import 'dart:async';
import 'dart:ui';
import 'package:dartlin/collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:fractal_layout/index.dart';
import '../../widget.dart';
import '../thing.dart';

class SlidesFScaffold extends FNodeWidget {
  SlidesFScaffold(
    super.node, {
    super.key,
  });

  Future<List<EventFractal>> getTabs(BuildContext context) async {
    final rew = context.read<Rewritable?>();
    if (rew case NodeFractal rewNode) {
      return f.inNode(rewNode);
    }
    return f.sorted.value;
  }

  @override
  Widget scaffold() {
    return Builder(builder: (context) {
      final rew = context.read<Rewritable?>();
      final theme = Theme.of(context);

      return Listen(
        f.sorted,
        (ctx, child) => FutureBuilder(
            future: getTabs(context),
            builder: (ctx, snap) {
              //final w = MediaQuery.of(context).size.width;
              if (snap.data case List<EventFractal> tabs) {
                return DefaultTabController(
                  length: tabs.length,
                  child: Watch<NodeFractal>(
                    f,
                    (ctx, child) => FractalScaffold(
                      key: Key('@${f.hash}'),
                      node: rew as NodeFractal? ?? f,
                      title: Theme(
                        data: theme.copyWith(
                          listTileTheme: theme.listTileTheme.copyWith(
                            textColor: Colors.white,
                            iconColor: Colors.white,
                          ),
                        ),
                        child: TabBar(
                          padding: const EdgeInsets.only(top: 7),
                          indicatorPadding: const EdgeInsets.all(0),
                          tabs: <Widget>[
                            ...tabs.mapIndexed(tab),
                          ],
                          isScrollable: true,
                        ),
                      ),
                      body: area(),
                    ),
                  ),
                );
              }
              return const CupertinoActivityIndicator();
            }),
      );
    });
  }

  @override
  dialog() {
    return Builder(builder: (context) {
      final tabs = getTabs(context);

      return FutureBuilder(
          future: getTabs(context),
          builder: (ctx, snap) {
            if (snap.data case List<EventFractal> tabs) {
              DefaultTabController(
                length: tabs.length,
                child: super.dialog(),
              );
            }
            return const CupertinoActivityIndicator();
          });
    });
  }

  @override
  bar() => Row(children: [
        icon(),
        const SizedBox(
          width: 4,
        ),
        title(),
        Container(
          width: 200,
          child: Theme(
              data: ThemeData(
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
                  ...f.sorted.value.mapIndexed(tab),
                ],
                isScrollable: true,
              )),
        ),
        buttonMaximize(),
      ]);

  @override
  onlyArea() {
    return Listen(f.sorted, (ctx, ch) {
      return FutureBuilder(
          future: getTabs(ctx),
          builder: (ctx, snap) {
            if (snap.data case List<EventFractal> tabs) {
              return DefaultTabController(
                length: f.sorted.value.length,
                child: Stack(
                  children: [
                    Watch<NodeFractal>(
                      f,
                      (ctx, ch) => area(),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Theme(
                        data: ThemeData(
                          textTheme: Theme.of(ctx).textTheme.apply(
                                bodyColor: Colors.white,
                                displayColor: Colors.white,
                              ),
                        ),
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        AppFractal.active.wb.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: TabBar(
                                    padding: const EdgeInsets.only(top: 7),
                                    indicatorPadding: const EdgeInsets.all(0),
                                    tabs: <Widget>[
                                      ...tabs.mapIndexed(tab),
                                    ],
                                    isScrollable: true,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const CupertinoActivityIndicator();
          });
    });
  }

  @override
  area() {
    return Listen(f.sorted, (ctx, child) {
      return FutureBuilder(
          future: getTabs(ctx),
          builder: (ctx, snap) {
            if (snap.data case List<EventFractal> tabs) {
              return tabs.isEmpty
                  ? Container()
                  : TabBarView(
                      children: [
                        ...tabs.map(
                          (f) => FractalThing(f),
                        ),
                      ],
                    );
            }

            return const CupertinoActivityIndicator();
          });
    });
  }

  static Timer? timer;
  order(EventFractal fr, int i) {
    timer?.cancel();
    timer = Timer(
      const Duration(milliseconds: 400),
      () {
        f.sorted.order(fr, i);
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
              if (f case NodeFractal node) ConfigFArea.openDialog(node);
            },
            child: SizedBox.square(
              dimension: 48,
              child: FIcon(
                f,
                shadows: const <Shadow>[
                  Shadow(
                    color: Colors.white,
                    blurRadius: 32.0,
                  ),
                ],
                noImage: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
