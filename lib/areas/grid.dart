import 'dart:ui';

import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';

import '../index.dart';

class FGridArea extends StatefulWidget {
  final EdgeInsets? padding;
  const FGridArea(this.catalog, {super.key, this.onTap, this.padding});
  final Function(Fractal)? onTap;

  final CatalogFractal catalog;

  @override
  State<FGridArea> createState() => _FGridAreaState();
}

class _FGridAreaState extends State<FGridArea> {
  double maxWidth = 0;
  static double gridWidth = 640;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      maxWidth = constraints.maxWidth;
      return Listen(
          widget.catalog,
          (ctx, child) =>
              grid() /*constraints.maxWidth > gridWidth
            ? grid()
            : Wrap(
                spacing: 4,
                runSpacing: 4,
                direction: Axis.horizontal,
                children: [
                  ...widget.filter.list.map(
                    (f) => card(f),
                  ),
                  //removal(),
                ],
              ),*/
          );
    });
  }

  Widget grid() {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(6),
          child: GridView(
            reverse: false,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: maxWidth ~/ 192,
              childAspectRatio: 14 / 10,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            //shrinkWrap: false,
            scrollDirection: Axis.vertical,
            padding: widget.padding,
            children: [
              ...widget.catalog.list.map(
                (f) => card(f),
              ),
              //removal(),
            ],
          ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: IconButton.filled(
            onPressed: modalCreate,
            icon: const Icon(Icons.add),
          ),
        )
      ],
    );
  }

  void modalCreate({
    NodeFractal? to,
    NodeFractal? extend,
    Function(NodeFractal)? cb,
    NodeCtrl? ctrl,
  }) {
    FractalSubState.modal(to: widget.catalog);
  }

  Widget card(Fractal f) {
    final hasVideo = (f is NodeFractal && f.video != null);
    f.preload();
    return Listen(
      f,
      (ctx, ch) => InkWell(
        child: Hero(
          tag: f.widgetKey('f'),
          child: Container(
            //onPressed: () {},
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5),
            ),
            constraints: const BoxConstraints(
              maxHeight: 200,
              //maxWidth: 250,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    child: FIcon(f),
                    onTap: () {
                      if (f case NodeFractal node) {
                        FractalLayoutState.active.go(node);
                      }
                    },
                  ),
                ),
                if (hasVideo)
                  Center(
                    child: IconButton.filled(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey.shade700.withAlpha(180),
                        ),
                      ),
                      onPressed: () {
                        FractalLayoutState.active.go(f);
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                      ),
                    ),
                  ),
                /*
          if (widget.trailing != null)
            Positioned(
              top: 2,
              right: 2,
              child: widget.trailing!,
            ),
            */
                if (f is NodeFractal && f['price'] != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 2,
                        bottom: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${f['price']}€',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(
                            180,
                            120,
                            20,
                            1,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (f case NodeFractal node)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 4,
                          sigmaY: 4,
                        ),
                        child: Container(
                          color: Colors.white.withAlpha(100),
                          padding: const EdgeInsets.all(2),
                          alignment: Alignment.center,
                          child: Column(children: [
                            if (node.description != null)
                              Text(
                                node.description ?? '',
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 12,
                                  height: 1,
                                ),
                              ),
                            tile(f),
                          ]),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        onLongPress: () {
          if (f is NodeFractal) {
            ConfigFArea.dialog(f);
          }
        },
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!(f);
          } else if (f.runtimeType == NodeFractal) {
            ConfigFArea.dialog(f as NodeFractal);
          } else if (f case NodeFractal node) {
            FractalLayoutState.active.go(node);
          }
        },
      ),
    );
  }

  Widget tile(Fractal f) {
    return HoverOver(
      builder: (h) => FractalMovable(
        event: f,
        child: FTitle(
          f,
          style: TextStyle(
            color: h ? Colors.black : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}
