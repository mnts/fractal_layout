import 'package:app_fractal/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';

import '../cards/tile.dart';
import '../index.dart';
import '../widget.dart';

class FractalTiles extends FNodeWidget {
  FractalTiles(super.node, {super.key});

  @override
  area() {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Listen(
        f.sorted,
        (ctx, child) => FutureBuilder(
          future: f.inNode(f),
          builder: (ctx, snap) {
            //final w = MediaQuery.of(context).size.width;
            if (snap.data case List<EventFractal> list) {
              return Wrap(
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
                  ...f.sorted.value.whereType<NodeFractal>().map(
                        (fs) => f['cards'] != null
                            ? fs.widget('${f['cards']}')
                            : TileItem(
                                fs,
                              ),
                      ),
                ],
              );
            }
            return const CupertinoActivityIndicator();
          },
        ),
      ),
    );
  }
}
