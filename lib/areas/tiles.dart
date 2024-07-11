import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';

import '../cards/tile.dart';
import '../index.dart';

class FractalTiles extends StatefulWidget {
  final NodeFractal node;
  const FractalTiles(this.node, {super.key});

  @override
  State<FractalTiles> createState() => _FractalTilesState();
}

class _FractalTilesState extends State<FractalTiles> {
  NodeFractal get node => widget.node;

  @override
  void initState() {
    node.preload('node');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Listen(
        node.sorted,
        (ctx, child) => Wrap(
          alignment: WrapAlignment.center,
          spacing: 2,
          //clipBehavior: Clip.antiAlias,
          /*
              primary: false,
              crossAxisCount: countRow,
              childAspectRatio: 5 / 4,
              shrinkWrap: true,
              mainAxisSpacing: 4,
              crossAxisSpacing: 6,
              */
          //children: [...links.map((g) => DImage(url: g)).toList()],

          children: [
            ...node.sorted.value.whereType<NodeFractal>().map(
                  (f) =>
                      UIF.cards[node['cards']]?.call(f) ??
                      TileItem(
                        f,
                      ),
                ),
          ],
        ),
      ),
    );
  }
}
