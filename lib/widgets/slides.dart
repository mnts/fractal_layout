import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/signed_fractal.dart';

import '../index.dart';
import 'index.dart';
import 'slide.dart';

class FractalSlides extends StatefulWidget {
  final NodeFractal node;
  const FractalSlides(this.node, {super.key});

  @override
  State<FractalSlides> createState() => _FractalSlidesState();
}

class _FractalSlidesState extends State<FractalSlides>
    with TickerProviderStateMixin {
  SortedFrac<EventFractal> get sorted => widget.node.sorted;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);
    return DefaultTabController(
      length: sorted.length,
      child: Stack(
        children: [
          if (sorted.value.isEmpty)
            Center(
              key: widget.node.widgetKey('doc'),
              child: Text(widget.node.hash),
            ),
          Hero(
            tag: widget.node.widgetKey('f'),
            child: Positioned.fill(
              child: MediaArea(
                node: widget.node,
              ),
            ),
          ),
          TabBarView(
            children: <Widget>[
              ...sorted.value.map(
                (f) => switch (f) {
                  (NodeFractal sF) => FractalSlide(
                      fractal: sF,
                    ),
                  EventFractal() => Container(),
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                //color: theme.canvasColor.withAlpha(100),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: TabBar(
                tabAlignment: TabAlignment.center,
                tabs: [
                  ...sorted.value.map(
                    (f) => Tab(
                      icon: SizedBox(
                        width: 32,
                        height: 32,
                        child: FIcon(
                          f,
                          noImage: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
