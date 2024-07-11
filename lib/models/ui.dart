import 'dart:convert';

import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal/c.dart';
import 'package:fractal_flutter/index.dart';
import '../areas/node.dart';
import '../areas/rows.dart';
import '../cards/list.dart';
import '../cards/tile.dart';
import '../index.dart';
import '../views/columns/screen.dart';
import '../views/slides/scaffold.dart';
import '../views/stream.dart';
import '../widget.dart';
import '../widgets/wysiwyg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

class UIF<T extends EventFractal> {
  //static final map = <String, Widget Function(NodeFractal)>{

  static final cards = <String, Widget Function(NodeFractal node)>{
    'tile': (f) => TileItem(f),
    'list': (f) => FListCard(f),
    'button': (f) => Container(
          padding: const EdgeInsets.all(4),
          //height: 42,
          //width: 200,
          child: FutureBuilder(
            future: f.preload(),
            builder: (ctx, snap) => Listen(
              f,
              (ctx, child) => ElevatedButton.icon(
                onPressed: () {
                  onTap(f);
                },
                onLongPress: () {
                  ConfigFArea.dialog(f);
                },
                icon: SizedBox(
                  width: 32,
                  height: 32,
                  child: FIcon(
                    f,
                    color: Colors.transparent,
                  ),
                ),
                label: FTitle(f),
                //style: appTextStyle,
              ),
            ),
          ),
        ),
  };

  static final actions = <String, Function(NodeFractal node)>{
    'download': (node) {
      if (node['file'] case String hash) {
        launchUrl(
          Uri.parse(FileF.urlFile(hash)),
        );
      }
    }
  };

  static onTap(NodeFractal node) {
    final actionS = '${node['action'] ?? ''}';

    if (actionS.isNotEmpty) {
      if (actionS.startsWith('/')) {
        (actionS[1] == '/')
            ? launchUrl(Uri.parse('https$actionS'))
            : FractalScaffoldState.active.context.push(actionS);
        return;
      }
    }
    final action = actions[actionS];
    (action != null) ? action(node) : ConfigFArea.dialog(node);
  }

  static final map = <String, FractalWidget Function(NodeFractal node)>{
    'screen': (f) => FractalDocument(f),
    'node': (f) => FractalWidget(f),
    'slides': (f) => SlidesFScaffold(f),
    'media': (f) => FractalAreaWidget(
          f,
          (ctx) => Center(
            child: SizedBox(
              width: 300,
              child: ScreensArea(
                node: f,
              ),
            ),
          ),
        ),
    'nav': (f) => FractalAreaWidget(
          f,
          (ctx) => Center(
            child: SizedBox(
              width: 300,
              child: ScreensArea(
                node: f,
              ),
            ),
          ),
        ),
    'rows': (f) => FractalAreaWidget(f, (ctx) => FRows(f)),
    /*
    'columns': UIF(
      //tile: (screen, context) => screen.tile(context),
      screen: (screen) => FractalSlides(
        key: screen.widgetKey('slides'),
        screen as NodeFractal,
      ),
      scaffold: (screen) {
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
      scaffold: (screen) {
        return FractalScaffold(
          node: screen as NodeFractal,
          body: screen is CatalogFractal
              ? FGridArea(
                  padding: EdgeInsets.only(
                    top: FractalScaffoldState.active.pad,
                  ),
                  [screen],
                )
              : NavScreen(node: screen),
        );
      },
      screen: (screen) => screen is CatalogFractal
          ? FGridArea(
              [screen],
            )
          : NavScreen(node: screen as NodeFractal),
    ),
    */
    'stream': (f) => StreamFWidget(f),
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
    'grid': (f) => FractalAreaWidget(
          f,
          (screen) => Builder(
            builder: (ctx) {
              final catalog = f as CatalogFractal;

              late final node = ctx.read<Rewritable?>();
              if (node == null) {
                return FGridArea(
                  [catalog],
                );
              }

              final fu = CatalogFractal.controller.put({
                'filter': {
                  ...?catalog.filter,
                  'to': node.hash,
                  if (node['ext_filter'] case String flt) ...jsonDecode(flt),
                },
                'mode': catalog.mode,
                'source': catalog.source?.name,
                'owner': node.owner?.ref ?? '',
                'created_at': 0,
                'extend': catalog.hash,
              });

              return FractalFuture(
                fu,
                (c) => FGridArea(
                  [c],
                ),
              );
            },
          ),
        ),
    'profile': (f) => FractalAreaWidget(
          f,
          (ctx) => FractalProfile(
            f,
          ),
        ),
    'tiles': (f) => FractalAreaWidget(
          f,
          (ctx) => FractalTiles(f),
        ),
    'consent': (f) => FractalAreaWidget(
          f,
          (ctx) => FScreen(
            FractalConsent(
              screen: f as ScreenFractal,
              user: UserFractal.active.value!,
            ),
          ),
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

  static init() {
    Fractal.maps['screens'] = UIF.map;
    Fractal.maps['cards'] = UIF.cards;
    FractalC.options['types'] = [
      ...FractalCtrl.where().map((c) => c.name),
    ];
    FractalC.options['tiles'] = FractalTile.options;
  }
}

typedef UIFb<T> = Widget Function(T);

/*

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

*/