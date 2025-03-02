import 'package:go_router/go_router.dart';
import '../index.dart';
import '../views/slides/scaffold.dart';
import '../views/stream.dart';
import '../views/thing.dart';
import '../widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:afi/index.dart';

extension UIFExt on Fractal {
  onTap(BuildContext? context) => ui.onTap(
        this,
        context ?? FractalScaffoldState.active.context,
      );

  UIF get ui {
    return UIF(type);
  }

  Widget widget(String typeCard) {
    FractalCtrl c = ctrl;
    while (true) {
      final w = UIF.map[c.name]?.build(typeCard, this);
      if (w != null) return w;

      if (c.extend case FractalCtrl ct) {
        c = ct;
      } else {
        return FractalWidget(this);
      }
    }
  }
}

class UIF<T extends Fractal> {
  static final map = <String, UIF>{};
  final String name;
  factory UIF(String name) {
    final ui = map[name] ??= UIF<T>.fresh(
      name,
    );
    return ui as UIF<T>;
  }

  UIF.fresh(this.name);

  var actions = <String,
      Function(
    T f,
    BuildContext context,
  )>{};

  onTap(T f, BuildContext context) {
    final actionS = '${f.resolve('action') ?? ''}';

    if (actionS.isNotEmpty) {
      if (actionS.startsWith('/')) {
        (actionS[1] == '/')
            ? launchUrl(
                Uri.parse('https:$actionS'),
                mode: LaunchMode.externalApplication,
              )
            : context.go(actionS);
        return;
      }
    }
    final action = actions[actionS];
    if (action != null) return action(f, context);

    if (f is NodeFractal) {
      if (f.runtimeType == NodeFractal && f['ui'] == null) return;
      FractalLayoutState.active.go(f);
    }
  }

  Widget? build(String type, T f) {
    return builders[type]?.call(f);
  }

  var builders = <String, FractalWidget Function(T)>{
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
  };

  //static final def = map['screen']!;

  static Future init() async {
    //Fractal.maps['screens'] = UIF.map;
    //Fractal.maps['cards'] = UIF.cards;

    AppFractal.active =
        await AppFractal.byDomain(FileF.host) ?? AppFractal.main;
    await AppFractal.active.synch();

    FractalC.options['types'] = [
      ...FractalCtrl.where().map((c) => c.name),
    ];

    Attr.ui = FractalTile.options;

    final nodeUIF = UIF<NodeFractal>('node');
    nodeUIF.actions = {
      'download': (f, ctx) {
        if (f['file'] case String hash) {
          launchUrl(
            FileF.urlFile(hash),
          );
        }
      },
      'dialog': (f, ctx) {
        showDialog(
          context: FractalScaffoldState.active.context,
          builder: (ctx) => FDialog(
            width: 480,
            height: 640,
            child: FractalThing(f),
          ),
        );
      },
      'create': (node, ctx) async {},
      'submit': (node, ctx) async {
        final form = FractalNodeIn.of(ctx)?.find({'form': true});
        if (form == null) return;
        final to = await NetworkFractal.request('${form['form']}');
        var re = await to.tell(await form.myInteraction);
        if (re case NodeFractal node) {
          FractalLayoutState.active.go(node);
        }
      },
      'spread': (node, ctx) async {
        final rew = ctx.read<Rewritable?>();
        if (rew != null) {
          final m = rew.m.writtenMap;
          final pulse = PulseF(by: rew);
          final spark = SparkF(map: m, pulse: pulse);

          rew.to?.spread(spark);
        }
      },
      'go': (f, ctx) {
        FractalLayoutState.active.go(f);
      },
    };

    nodeUIF.builders = {
      '': (f) => FNodeWidget(f),
      'node': (f) => FNodeWidget(f),
      'document': (f) => FractalDocument(f),
      'text': (f) => FTextWidget(f),
      'slides': (f) => SlidesFScaffold(f),
      'media': (f) => FractalAreaWidget(
            f,
            () => Center(
              child: SizedBox(
                width: 300,
                child: ScreensArea(
                  node: f,
                ),
              ),
            ),
          ),
      'nav': (f) => FractalAreaWidget(f, () {
            if (f['rewrite'] case String rewrite) {
              return Builder(builder: (ctx) {
                late final rew =
                    ctx.read<Rewritable?>() ?? UserFractal.active.value!;

                final fu = NodeFractal.controller.put({
                  'name': f.name,
                  'to': rew.hash,
                  'owner': rew.owner?.hash,
                  'created_at': 0,
                  'extend': f.hash,
                });

                return FractalFuture(
                  fu,
                  (c) => FutureBuilder(
                    future: c.ready,
                    builder: (ctx, snap) {
                      return Center(
                        child: SizedBox(
                          width: 400,
                          child: ScreensArea(
                            node: c,
                          ),
                        ),
                      );
                    },
                  ),
                );
              });
            }
            return Center(
              child: SizedBox(
                width: 300,
                child: ScreensArea(
                  node: f,
                ),
              ),
            );
          }),
      'rows': (f) => FRows(f),
      'profile': (f) => FractalAreaWidget(
            f,
            () => FractalProfile(f),
          ),
      'stream': (f) => StreamFWidget(f),
      'device': (f) => FractalDevice(f),
      'tiles': (f) => FractalTiles(f),
      'carousel': (f) => FractalCarousel(f),
      'catalog': (f) => FractalCatalog(f),
      'image': (f) => FractalImg(f),
      'gallery': (f) => FractalGallery(f),
      /*
      'consent': (f) => FractalAreaWidget(
            f,
            () => FScreen(
              FractalConsent(
                screen: f as ScreenFractal,
                user: UserFractal.active.value!,
              ),
            ),
          ),
          */
      'tile': (f) => FractalAreaWidget(f, () => TileItem(f)),
      'list': (f) => FractalAreaWidget(f, () => FListCard(f)),
      'button': (f) => FractalAreaWidget(
            f,
            () => Container(
              padding: const EdgeInsets.all(4),
              //height: 42,
              //width: 200,
              child: FutureBuilder(
                future: f.preload(),
                builder: (ctx, snap) => Listen(
                  f,
                  (ctx, child) => ElevatedButton.icon(
                    onPressed: () {
                      UIF(f.type).onTap(f, ctx);
                    },
                    onLongPress: () {
                      ConfigFArea.openDialog(f);
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
          ),
    };
    NodeFractal.ui = [...nodeUIF.builders.keys];

    final userUIF = UIF<UserFractal>('user');
    userUIF.builders = {
      '': (f) => FractalAreaWidget(
            f,
            () => FractalProfile(
              key: f.widgetKey('profile'),
              f,
            ),
          ),
      'profile': (f) => FractalAreaWidget(
            f,
            () => FractalProfile(
              key: f.widgetKey('profile'),
              f,
            ),
          ),
    };

    final catalogUIF = UIF<CatalogFractal>('catalog');
    catalogUIF.actions = {
      'download': (f, ctx) {
        if (f['file'] case String hash) {
          launchUrl(FileF.urlFile(hash));
        }
      },
      'dialog': (f, ctx) {
        showDialog(
          context: FractalScaffoldState.active.context,
          builder: (ctx) => FDialog(
            width: 480,
            height: 640,
            child: FractalThing(f),
          ),
        );
      },
      'submit': (node, ctx) {}
    };

    catalogUIF.builders = {
      '': (f) => FractalCatalog(f),
      'grid': (f) => FractalCatalog(f),
    };

    final fileUIF = UIF<FileFractal>('file');
    fileUIF.builders = {
      'text': (f) => FTextWidget(f),
      '': (f) => FTextWidget(f),
    };
    return;
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
