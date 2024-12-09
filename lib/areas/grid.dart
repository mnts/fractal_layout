import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app_fractal/app_fractal.dart';
import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:super_tooltip/super_tooltip.dart';
import '../index.dart';
import 'attrs.dart';
import 'camera.dart';

class FGridArea extends StatefulWidget {
  final EdgeInsets? padding;
  const FGridArea(
    this.catalogs, {
    super.key,
    this.onTap,
    this.padding,
  });
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
    super.initState();

    //build on first frame load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var c in widget.catalogs) {
        c
          ..synch()
          ..listen(reload);
      }
      reload();
    });
  }

  @override
  dispose() {
    for (var c in widget.catalogs) {
      c.unListen(reload);
    }
    super.dispose();
  }

  var list = <Fractal>[];

  reload([Fractal? f]) {
    final l = <Fractal>[];
    for (final c in widget.catalogs) {
      for (f in c.list) {
        if (!l.contains(f)) l.add(f);
      }
    }
    setState(() {
      list = l;
      //reOrder();
    });
  }

  reOrder() {
    final by = widget.catalogs.first.order.entries.first;
    list.sort(
      (Fractal a, Fractal b) => switch ((a[by.key], b[by.key])) {
        (num an, num bn) => an.compareTo(bn) * (by.value ? -1 : 1),
        (String an, String bn) => an.compareTo(bn) * (by.value ? -1 : 1),
        _ => 0,
      },
      //((a[by.key]?.compareTo(b[by.key]) ?? 0) * by.value ? -1 : 1),
    );
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

  final tipFilters = SuperTooltipController();

  Widget grid() {
    CatalogFractal? postC = (widget.catalogs
        .where(
          (c) => c.source == null || c.source is EventsCtrl,
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
          right: 4,
          left: 4,
          height: 48,
          child: Row(
            children: [
              /*
              if (widget.catalogs[0].source case EventsCtrl c)
                FractalTooltip(
                  controller: tipFilters,
                  direction: TooltipDirection.up,
                  content: FractalAttrs(
                    widget.catalogs[0],
                  ),
                  child: IconButton.filled(
                    icon: const Icon(
                      Icons.filter_alt_outlined,
                    ),
                    onPressed: () async {
                      tipFilters.showTooltip();
                      //camera();
                    },
                  ),
                ),
                */
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
                          (c) => c.source is EventsCtrl,
                        )
                        .firstOrNull;

                    final ev = await EventFractal.controller.put({
                      'content': f.name,
                      'kind': 2,
                      'to': c?.filter['to'] ?? postC.hash,
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
        EventFractal post when post.kind == 2 => cardPost(post),
        NodeFractal node => widget.catalogs.isNotEmpty
            ? node.widget(
                '${widget.catalogs.first['cards'] ?? ''}',
              )
            : tile(f),
        _ => tile(f),
      };

  tile(Fractal f) {
    return FractalTile(f);
  }

  Widget cardPost(EventFractal ev) => InkWell(
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

  dialog(Fractal f) {
    showDialog(
      context: context,
      builder: (context) {
        pop() {
          Navigator.pop(context);
        }

        return Dialog(
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
            child: DefaultTabController(
              length: list.length,
              initialIndex: list.indexOf(f),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: AlignmentDirectional.center,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: TabBarView(
                      children: [
                        ...list.map(
                          (f) => Stack(
                            clipBehavior: Clip.none,
                            alignment: AlignmentDirectional.center,
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: InkWell(
                                  onTap: pop,
                                ),
                              ),
                              Center(
                                child: Container(
                                    padding: const EdgeInsets.all(56),
                                    child: switch (f) {
                                      EventFractal pf when pf.file != null =>
                                        FractalImage(pf.file!),
                                      _ => FTitle(f),
                                    }),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton.filled(
                                  icon: const Icon(Icons.delete_forever),
                                  tooltip: 'Delete',
                                  onPressed: () {
                                    if (f case EventFractal evf) evf.remove();

                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: IconButton.filled(
                                  icon: const Icon(Icons.rotate_90_degrees_ccw),
                                  tooltip: 'Rotate',
                                  onPressed: () {
                                    rotate(f, -90);
                                    if (f case EventFractal evf) evf.remove();
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 64,
                                left: 0,
                                child: IconButton.filled(
                                  icon: const Icon(
                                      Icons.rotate_90_degrees_cw_outlined),
                                  tooltip: 'Rotate',
                                  onPressed: () {
                                    rotate(f, 90);

                                    if (f case EventFractal evf) evf.remove();
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    left: 56,
                    right: 56,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.withAlpha(128),
                      ),
                      height: 56,
                      child: TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.center,
                        indicatorWeight: 4,
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.only(right: 1),
                        tabs: [
                          ...list.map(
                            (f) => Tab(
                                child: switch (f) {
                              EventFractal pf when pf.file != null =>
                                FractalImage(pf.file!),
                              _ => FTitle(f),
                            }),
                          ),
                        ],
                      ),
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
      },
    );
  }

  rotate(Fractal fractal, num deg) async {
    final file = (fractal as EventFractal).file;

    if (file == null) return;

    final f = await FractalImage.rotate(file);
    await f.publish();

    final c = widget.catalogs
        .where(
          (c) => c.source is EventsCtrl,
        )
        .firstOrNull;
    final ev = await EventFractal.controller.put({
      'file': f.name,
      'to': c?.filter['to'] ?? c!.hash,
      'owner': UserFractal.active.value?.hash,
    });
    ev.synch();
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
                      (c) => c.source is EventsCtrl,
                    )
                    .firstOrNull;

                await f.publish();
                final ev = await EventFractal.controller.put({
                  'content': f.name,
                  'kind': 2,
                  'to': c?.filter['to'] ?? c!.hash,
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
