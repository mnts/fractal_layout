import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal/lib.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_flutter/screens/fscreen.dart';
import 'package:fractal_layout/builders/index.dart';
import 'package:fractal_layout/widgets/slides.dart';
import 'package:signed_fractal/signed_fractal.dart';

import '../areas/consent.dart';
import '../areas/form.dart';
import '../areas/stream.dart';
import '../index.dart';
import '../widgets/document.dart';
import '../widgets/tile.dart';

class UIF<T extends ScreenFractal> {
  static final map = <String, UIF>{
    'screen': UIF(
      // tile: (screen, context) => screen.tile(context),
      scaffold: (screen, context) {
        return DocumentScaffold(
          screen: screen as ScreenFractal,
        );
      },
      screen: (screen, context) {
        return FScreen(
          DocumentArea(
            screen as ScreenFractal,
            key: screen.widgetKey('doc'),
          ),
        );
      },
    ),
    'node': UIF(
      //tile: (screen, context) => screen.tile(context),
      screen: (screen, context) => FractalSlides(
        screen as NodeFractal,
      ),
    ),
    'stream': UIF(
      //tile: (screen, context) => screen.tile(context),
      screen: (screen, context) => StreamArea(
        fractal: screen,
      ),
    ),
    'form': UIF(
      //tile: (screen, context) => screen.tile(context),
      screen: (screen, context) => switch (screen) {
        (NodeFractal node) => FScreen(
            FractalForm(node: node),
          ),
        _ => Container(),
      },
    ),
    'consent': UIF(
      //tile: (screen, context) => screen.tile(context),
      screen: (screen, context) => switch (screen) {
        (ScreenFractal node) => FScreen(
            FractalConsent(
              screen: node,
              user: UserFractal.active.value!,
            ),
          ),
        _ => Container(),
      },
    ),
  };
  static final def = map['screen']!;

  final Widget Function(EventFractal, BuildContext) screen;
  //final Widget Function(ScreenFractal, BuildContext) tile;
  final Widget? Function(EventFractal, BuildContext)? scaffold;
  const UIF({
    //required this.tile,
    this.scaffold,
    required this.screen,
  });
}

extension ScreenExtWidget on FractalCtrl {
  UIF get ui {
    return UIF.map.containsKey(name) ? UIF.map[name]! : UIF.def;
  }
}

extension NodeExtWidget on NodeFractal {
  UIF get ui {
    final sName = this['screen'] ?? ctrl.name;
    return UIF.map.containsKey(sName) ? UIF.map[sName]! : UIF.def;
  }
}
