import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import '../index.dart';
import '../views/columns/screen.dart';
import '../widgets/wysiwyg.dart';

class UIF<T extends EventFractal> {
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
      area: (f, c) => DocumentArea(
        f as ScreenFractal,
        onlyContent: false,
        key: f.widgetKey('doc'),
      ),
    ),
    'node': UIF(
      //tile: (screen, context) => screen.tile(context),
      screen: (screen, context) => FractalSlides(
        key: screen.widgetKey('slides'),
        screen as NodeFractal,
      ),
    ),
    'columns': UIF(
      //tile: (screen, context) => screen.tile(context),
      screen: (screen, context) => FractalSlides(
        key: screen.widgetKey('slides'),
        screen as NodeFractal,
      ),
      scaffold: (screen, context) {
        final _tipOptionsCtrl = FTipCtrl();

        return FractalScaffold(
          node: screen as NodeFractal,
          title: Row(children: [
            Spacer(),
            IconButton(
              icon: Icon(Icons.print),
              onPressed: () {},
            ),
            FractalTooltip(
              controller: _tipOptionsCtrl,
              width: 100,
              height: 150,
              content: ListView(children: [
                ...['whatsapp', 'email'].map(
                  (opt) => InkWell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Text(
                        opt.toCapitalized,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    onTap: () {
                      _tipOptionsCtrl.hideTooltip();
                    },
                  ),
                ),
              ]),
              child: IconButton(
                tooltip: 'Share',
                onPressed: () {
                  _tipOptionsCtrl.showTooltip();
                  /*
                        final treatment = NodeFractal(
                          name: '${f.name}_${getRandomString(3)}',
                          extend: f,
                          to: cart,
                        );
                        f.write('status', 'completed');
                        treatment.synch();
                        payed = true;*/
                },
                icon: const Icon(
                  Icons.share,
                ),
              ),
            ),
          ]),
          body: ColumnsFScreen(
            key: screen.widgetKey('columns'),
            node: screen,
          ),
        );
      },
    ),
    'catalog': UIF(
      //tile: (screen, context) => screen.tile(context),
      scaffold: (screen, context) {
        return FractalScaffold(
          node: screen as NodeFractal,
          body: screen is CatalogFractal
              ? FGridArea(
                  padding: EdgeInsets.only(
                    top: FractalScaffoldState.pad,
                  ),
                  screen,
                )
              : NavScreen(node: screen),
        );
      },
      screen: (screen, context) => screen is CatalogFractal
          ? FGridArea(
              screen,
            )
          : NavScreen(node: screen as NodeFractal),
    ),
    'stream': UIF(
      //tile: (screen, context) => screen.tile(context),
      screen: (screen, context) => switch (screen) {
        NodeFractal node => StreamArea(
            fractal: screen,
          ),
        _ => const Center(child: Text('Not supported')),
      },
    ),
    /*
    'form': UIF(
      //tile: (screen, context) => screen.tile(context),
      screen: (screen, context) => switch (screen) {
        (NodeFractal node) => FScreen(
            FractalForm(node: node),
          ),
        _ => Container(),
      },
    ),
    */
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

  final UIFb<T>? area;
  final UIFb<T> screen;
  //final Widget Function(ScreenFractal, BuildContext) tile;
  final UIFb<T>? scaffold;
  const UIF({
    //required this.tile,
    this.scaffold,
    this.area,
    required this.screen,
  });
}

typedef UIFb<T> = Widget Function(T, BuildContext);

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
