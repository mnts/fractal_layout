import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/models/ui.dart';
import 'package:signed_fractal/signed_fractal.dart';

class ColumnsFScreen extends StatelessWidget {
  final NodeFractal node;
  const ColumnsFScreen({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return Listen(
      node.sorted,
      (context, child) => ListView(
        padding: EdgeInsets.fromLTRB(
          4, FractalScaffoldState.pad, 4, 6,
          //vertical: 56,
        ),
        children: [
          ...node.sorted.value.map((f) {
            f.preload();

            if (f case NodeFractal node) {
              var screenName = f.type;
              final uif = UIF.map[screenName];
              if (uif == null || screenName == 'node') {
                return Listen(node, (context, child) {
                  if (node['screen'] case String screenName) {
                    final uif = UIF.map[screenName];

                    return uif?.area?.call(f, context) ??
                        const SizedBox(height: 1);
                  }
                  return FractalTile(node);
                });
              }
              return uif.area?.call(f, context) ?? const SizedBox(height: 1);
            }
            return const SizedBox(height: 1);
          }),
        ],
      ),
    );
  }
}
