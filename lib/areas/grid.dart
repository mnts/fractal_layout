import 'dart:ui';

import 'package:app_fractal/app_fractal.dart';
import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/signed_fractal.dart';
import '../index.dart';
import 'camera.dart';

class FGridArea extends StatefulWidget {
  final EdgeInsets? padding;
  const FGridArea(this.catalogs, {super.key, this.onTap, this.padding});
  final Function(Fractal)? onTap;

  final List<CatalogFractal> catalogs;

  @override
  State<FGridArea> createState() => _FGridAreaState();
}

class _FGridAreaState extends State<FGridArea> {
  double maxWidth = 0;
  static double gridWidth = 640;

  @override
  void initState() {
    for (var c in widget.catalogs) {
      c
        ..synch()
        ..preload('node')
        ..listen(reload)
        ..sub.listen(reload);
    }
    reload();
    super.initState();
  }

  @override
  dispose() {
    for (var c in widget.catalogs) {
      c
        ..unListen(reload)
        ..sub.unListen(reload);
    }
    super.dispose();
  }

  var list = <Fractal>[];

  reload([Fractal? f]) {
    final l = <Fractal>[];
    for (final c in widget.catalogs) {
      for (f in c.sub.list) {
        if (!l.contains(f)) l.add(f);
      }
      for (f in c.list) {
        if (!l.contains(f)) l.add(f);
      }
    }
    setState(() {
      list = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      maxWidth = constraints.maxWidth;
      return grid();

      /*constraints.maxWidth > gridWidth
            ? grid()
            : Wrap(
                spacing: 4,
                runSpacing: 4,
                direction: Axis.horizontal,
                children: [
                  ...widget.filter.list.map(
                    (f) => card(f),
                  ),
                  //removal(),
                ],
              ),*/
    });
  }

  Widget grid() {
    CatalogFractal? postC = (widget.catalogs
        .where(
          (c) => c.source == null || c.source is PostCtrl,
        )
        .firstOrNull);

    CatalogFractal? catalogC = (widget.catalogs
        .where(
          (c) => c.source == null || c.source is NodeCtrl,
        )
        .firstOrNull);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(6),
          child: GridView(
            reverse: false,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: maxWidth ~/ 192,
              childAspectRatio: 14 / 10,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            //shrinkWrap: false,
            scrollDirection: Axis.vertical,
            padding: FractalPad.of(context).pad,
            children: [
              ...list.map(
                (f) => card(f),
              ),
              //removal(),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          height: 48,
          child: Row(
            children: [
              const Spacer(),
              if (postC != null)
                IconButton.filled(
                  icon: const Icon(
                    Icons.camera_alt,
                  ),
                  onPressed: () async {
                    camera();
                  },
                ),
              if (postC != null)
                IconButton.filled(
                  icon: const Icon(Icons.upload_file),
                  onPressed: () async {
                    final f = await FractalImage.pick();
                    if (f == null) return;

                    await f.publish();

                    final c = widget.catalogs
                        .where(
                          (c) => c.source is PostCtrl,
                        )
                        .firstOrNull;

                    final ev = await PostFractal.controller.put({
                      'file': f.name,
                      'to': c?.filter?['to'] ?? postC.hash,
                      'owner': UserFractal.active.value?.hash,
                    });
                    ev.synch();
                  },
                ),
              if (catalogC != null)
                IconButton.filled(
                  onPressed: modalCreate,
                  icon: const Icon(Icons.add),
                ),
            ],
          ),
        )
      ],
    );
  }

  void modalCreate({
    NodeFractal? to,
    NodeFractal? extend,
    Function(NodeFractal)? cb,
    NodeCtrl? ctrl,
  }) {
    final c = widget.catalogs.firstOrNull;

    FractalSubState.modal(to: c);
  }

  Widget card(Fractal f) => switch (f) {
        PostFractal post => cardPost(post),
        _ => cardNode(f),
      };

  Widget cardPost(PostFractal ev) => InkWell(
        child: Hero(
          tag: ev.widgetKey('img'),
          child: ev.file != null
              ? FractalImage(
                  key: ev.widgetKey('fimg'),
                  ev.file!,
                  fit: BoxFit.cover,
                )
              : Text(ev.content),
        ),
        onTap: () {
          dialog(ev);
        },
      );

  Widget cardNode(Fractal f) {
    final hasVideo = (f is NodeFractal && f.video != null);
    f.preload();
    return Listen(
      f,
      (ctx, ch) => InkWell(
        child: Hero(
          tag: f.widgetKey('f'),
          child: FractalMovable(
            event: f,
            child: Container(
              //onPressed: () {},
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5),
              ),
              constraints: const BoxConstraints(
                maxHeight: 200,
                //maxWidth: 250,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      child: FIcon(f),
                      onTap: () {
                        if (f case NodeFractal node) {
                          FractalLayoutState.active.go(node);
                        }
                      },
                    ),
                  ),
                  if (hasVideo)
                    Center(
                      child: IconButton.filled(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.grey.shade700.withAlpha(180),
                          ),
                        ),
                        onPressed: () {
                          FractalLayoutState.active.go(f);
                        },
                        icon: const Icon(
                          Icons.play_arrow,
                        ),
                      ),
                    ),
                  /*
          if (widget.trailing != null)
            Positioned(
              top: 2,
              right: 2,
              child: widget.trailing!,
            ),
            */
                  if (f is NodeFractal && f['price'] != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 4,
                          right: 4,
                          top: 2,
                          bottom: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${f['price']}€',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(
                              180,
                              120,
                              20,
                              1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (f case NodeFractal node)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 4,
                            sigmaY: 4,
                          ),
                          child: Container(
                            color: Colors.white.withAlpha(100),
                            padding: const EdgeInsets.all(2),
                            alignment: Alignment.center,
                            child: Column(children: [
                              if (node.description != null)
                                Text(
                                  node.description ?? '',
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 12,
                                    height: 1,
                                  ),
                                ),
                              tile(f),
                            ]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        onLongPress: () {
          if (f is NodeFractal) {
            ConfigFArea.dialog(f);
          }
        },
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!(f);
          } else if (f.runtimeType == NodeFractal) {
            ConfigFArea.dialog(f as NodeFractal);
          } else if (f case NodeFractal node) {
            FractalLayoutState.active.go(node);
          }
        },
      ),
    );
  }

  Widget tile(Fractal f) {
    return HoverOver(
      builder: (h) => FractalMovable(
        event: f,
        child: FTitle(
          f,
          style: TextStyle(
            color: h ? Colors.black : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            height: 1.6,
          ),
        ),
      ),
    );
  }

  dialog(PostFractal ev) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Theme(
          data: ThemeData(
            iconTheme: const IconThemeData(
              size: 32,
              color: Colors.white,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.center,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 00,
                child: InkWell(onTap: () {
                  Navigator.pop(context);
                }),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Hero(
                    tag: ev.widgetKey('img'),
                    child: FractalImage(ev.file!),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.delete_forever),
                  tooltip: 'Delete',
                  onPressed: () {
                    ev.remove();

                    Navigator.pop(context);
                  },
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Close',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void camera() async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 2,
        backgroundColor: Colors.transparent,
        child: Theme(
          data: ThemeData(
            iconTheme: const IconThemeData(
              size: 32,
              color: Colors.white,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(40),
            child: TakePictureScreen(
              onSelected: (f) async {
                final c = widget.catalogs
                    .where(
                      (c) => c.source is PostCtrl,
                    )
                    .firstOrNull;

                await f.publish();
                final ev = await PostFractal.controller.put({
                  'file': f.name,
                  'to': c?.filter?['to'] ?? c!.hash,
                  'owner': UserFractal.active.value?.hash,
                });
                ev.synch();
                //Navigator.pop(ctx);
              },
            ),
          ),
        ),
      ),
    );
  }
}
