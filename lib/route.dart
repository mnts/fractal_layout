import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';

import 'index.dart';
import 'models/ui.dart';

class FractalRoute extends StatefulWidget {
  final String path;
  const FractalRoute(this.path, {super.key});

  @override
  State<FractalRoute> createState() => _FractalRouteState();
}

class _FractalRouteState extends State<FractalRoute> {
  @override
  Widget build(BuildContext context) {
    final h = widget.path.split('|');
    final hash = h[0];
    final rew = context.read<Rewritable?>() as NodeFractal?;

    return FractalPick(hash, builder: (evf) {
      NodeFractal node = evf as NodeFractal? ?? AppFractal.active;

      return Listen(node, (ctx, child) {
        var screenName = h.length > 1 ? h[1] : node.type;
        var uib = UIF.map[screenName] ?? UIF.map['nav']!;

        if (node['screen'] case String screenName) {
          final uiba = UIF.map[screenName];
          if (uiba != null) uib = uiba;
        }

        return uib(node);
      });
    });
  }
}
