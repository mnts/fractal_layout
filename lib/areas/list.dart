import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/extensions/app.dart';

import '../widget.dart';
import '../widgets/tile.dart';
import '../widgets/title.dart';

class FractalList extends FNodeWidget {
  FractalList(
    super.node, {
    this.exclude = const [],
    this.filter,
    this.builder,
    super.key,
  });

  final Widget Function(EventFractal f)? builder;
  final List<EventFractal> exclude;
  final bool Function(Fractal)? filter;

  Widget subTile(EventFractal f) => builder?.call(f) ?? FractalTile(f);

  @override
  Widget area() {
    return Listen(
      f.sub,
      (ctx, child) => ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          FractalView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              ...f.sub.list
                  .where(
                    (f) => ((filter?.call(f) ?? true) &&
                        !exclude.contains(f) &&
                        f is! InteractionFractal),
                  )
                  .map(
                    (node) => FractalMovable(
                      event: node,
                      child: subTile(node),
                    ),
                  ),
            ],
          ),
          if (f.extend != null)
            Container(
              height: 28,
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 2),
              child: FTitle(
                f.extend!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppFractal.active.bw.withAlpha(150),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (f.extend != null)
            FractalList(
              f.extend!,
              exclude: exclude,
              filter: filter,
            ),
        ],
      ),
    );
  }
}
