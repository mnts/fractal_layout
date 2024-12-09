import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';

import '../index.dart';

class FListCard extends StatelessWidget {
  final NodeFractal node;

  const FListCard(this.node, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      elevation: 4,
      child: SizedBox(
        width: 320,
        child: Stack(
          children: [
            Listen(node.sorted, (context, child) {
              return Container(
                padding: const EdgeInsets.only(
                  top: 56,
                  left: 4,
                  right: 4,
                  bottom: 4,
                ),
                child: FSortable(
                  key: const Key('sortable'),
                  reverse: false,
                  sorted: node.sorted,
                  cb: node.sort,
                  builder: (f) => switch (f) {
                    UserFractal u => FractalUser(
                        u,
                        onTap: () {
                          FractalLayoutState.active.go(f);
                        },
                      ),
                    _ => FractalTile(f),
                  },
                ),
              );
            }),
            Positioned(
              top: 4,
              left: 4,
              right: 4,
              height: 48,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300.withAlpha(200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FractalTile(
                  node,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
