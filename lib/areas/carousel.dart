import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/widgets/index.dart';

import '../cards/tile.dart';
import '../index.dart';
import '../models/ui.dart';
import '../views/index.dart';
import '../widget.dart';

class FractalCarousel extends FNodeWidget {
  FractalCarousel(super.node, {super.key});
  final ctrl = ScrollController();

  @override
  area() {
    return Listen(
      f.sorted,
      (ctx, child) => FScrollView(
        //padding: const EdgeInsets.all(4),
        children: [
          ...f.sorted.value.whereType<NodeFractal>().map(
                (fs) => Container(
                  padding: const EdgeInsets.all(1),
                  child: f['cards'] != null
                      ? fs.widget('${f['cards']}')
                      : FractalSized(fs),
                ),
              ),
          Center(
            child: IconButton(
              onPressed: () async {
                final fNew = NodeFractal();
                await fNew.synch();
                f.sorted.add(fNew);
                f.sort();
              },
              icon: const Icon(
                Icons.add,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
