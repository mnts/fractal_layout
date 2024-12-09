import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:go_router/go_router.dart';

import '../index.dart';
import '../route.dart';

final home = GoRoute(
  path: '/',
  builder: (context, state) {
    final app = AppFractal.active;

    return Listen(
      app,
      (ctx, child) {
        final homeHash = app.resolve('home');
        return homeHash != null
            ? FractalPick(
                homeHash,
                builder: (f) {
                  //return UserRoute(key: Key(path), hash: hash);
                  return Watch(
                    app as Rewritable?,
                    (ctx, child) => FractalRoute(
                      homeHash,
                    ),
                  );
                },
                loader: () => FractalScaffold(
                  node: app,
                  body: Container(),
                ),
              )
            : FractalScaffold(
                node: app,
                body: Container(),
              );
      },
      preload: 'rewriter',
    );
  },
);
