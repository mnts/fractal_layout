import 'package:app_fractal/app_fractal.dart';
import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:signed_fractal/signed_fractal.dart';
import '../index.dart';

class FGridArea extends StatefulWidget {
  final EdgeInsets? padding;
  const FGridArea(
    this.filterable, {
    super.key,
    this.onTap,
    this.padding,
  });
  final Function(Fractal)? onTap;

  final FilterF filterable;

  @override
  State<FGridArea> createState() => _FGridAreaState();
}

class _FGridAreaState extends State<FGridArea> {
  double maxWidth = 0;
  static double gridWidth = 640;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
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

  //final tipFilters = SuperTooltipController();

  Widget grid() {
    return Listen(widget.filterable, (ctx, ch) {
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
                /*
                ...widget.filterable.list.map(
                  (f) => card(f),
                ),
                */
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
                if (widget.filterable.source case EventsCtrl ctrlEv)
                  IconButton.filled(
                    icon: const Icon(
                      Icons.camera_alt,
                    ),
                    onPressed: () async {},
                  ),
                if (widget.filterable.source case NodeCtrl ctrlNode)
                  IconButton.filled(
                    icon: const Icon(Icons.upload_file),
                    onPressed: () async {
                      final f = await FractalImage.pick();
                      if (f == null) return;

                      await f.publish();

                      final ev = await EventFractal.controller.put({
                        'content': f.name,
                        'kind': 2,
                        'to': widget.filterable.filter['to'] ??
                            widget.filterable.hash,
                        'owner': UserFractal.active.value?.hash,
                      });
                      ev.synch();
                    },
                  ),
                if (widget.filterable.source case NodeCtrl ctrlNode)
                  IconButton.filled(
                    onPressed: modalCreate,
                    icon: const Icon(Icons.add),
                  ),
              ],
            ),
          )
        ],
      );
    });
  }

  void modalCreate({
    NodeFractal? to,
    NodeFractal? extend,
    Function(NodeFractal)? cb,
    NodeCtrl? ctrl,
  }) {
    if (widget.filterable case NodeFractal node)
      FractalSubState.modal(to: node);
  }

  late String cardsType = switch (widget.filterable) {
    NodeFractal node => '${node['cards']}',
    _ => '',
  };

  Widget tile(Fractal f) {
    if (cardsType.isNotEmpty) return f.widget(cardsType);

    return FractalTile(f);
  }
}
