import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signed_fractal/signed_fractal.dart';

import '../index.dart';
import '../models/ui.dart';

final hashRoute = GoRoute(
  path: '/-:h',
  builder: (context, state) {
    final h = (state.pathParameters['h'] ?? '').split('|');
    final hash = h[0];

    NodeFractal node =
        EventFractal.map[hash] as NodeFractal? ?? AppFractal.active;

    var screenName = h.length > 1 ? h[1] : node.type;
    final uif = UIF.map[screenName] ?? UIF.map['nav'];

    if (screenName == 'nav') {
      return NavScreen(node: node);
    }

    return uif?.scaffold?.call(node, context) ??
        FractalScaffold(
          node: node,
          body: uif?.screen(node, context) ??
              FScreen(
                const Text('Error'),
              ),
        );
  },
);
