import 'package:app_fractal/index.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:go_router/go_router.dart';

import '../route.dart';

final profileRoute = GoRoute(
  path: '/@:h',
  builder: (context, state) {
    final hash =
        state.pathParameters['h'] ?? UserFractal.active.value?.hash ?? '';

    return FractalPick(hash, builder: (f) {
      //return UserRoute(key: Key(path), hash: hash);
      return Watch(
        f as Rewritable?,
        (ctx, child) => FractalRoute(
          '${AppFractal.active['profile']}',
        ),
      );
    });
  },
);
