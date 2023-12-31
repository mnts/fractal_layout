import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_flutter/widgets/movable.dart';
import 'package:go_router/go_router.dart';
import 'package:signed_fractal/models/index.dart';
import 'package:signed_fractal/signed_fractal.dart';
import '../index.dart';
import '../widgets/sortable.dart';
import '../widgets/tile.dart';
import 'config.dart';

typedef FExpand = int Function(NodeFractal, NodeFractal)?;

class ScreensArea extends StatefulWidget {
  final NodeFractal node;
  final FExpand expand;
  final Function(EventFractal)? onTap;
  final EdgeInsets? padding;

  final ScrollPhysics? physics;

  const ScreensArea({
    super.key,
    this.expand,
    this.onTap,
    this.physics,
    this.padding,
    required this.node,
  });

  @override
  State<ScreensArea> createState() => _ScreensAreaState();
}

class _ScreensAreaState extends State<ScreensArea> {
  NodeFractal get node => widget.node;

  late final sub = node['sub'];

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('sortableList'),
      physics: widget.physics,
      shrinkWrap: widget.physics != null,
      padding: widget.padding,
      children: [
        FSortable(
          key: const Key('sortable'),
          reverse: false,
          sorted: node.sorted,
          cb: node.sort,
          builder: (f) => tile(f),
        ),
        if (node.sub.list.isNotEmpty)
          const Icon(
            Icons.more_horiz,
          ),
        Listen(
          node.sorted,
          (context, child) => Listen(
            node.sub,
            (ctx, child) => FractalView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ...node.sub.list
                    .where((f) => !node.sorted.value.contains(f))
                    .map(
                      (node) => FractalMovable(
                        event: node,
                        child: tile(node),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ],
    );
    /*
        ListView(
          padding: const EdgeInsets.only(
            bottom: 50,
            left: 1,
          ),
          children: node.sub.list
              .whereType<NodeFractal>()
              .map(
                (f) => FractalMovable(
                  event: f,
                  child: ListTile(
                    leading: f.ctrl.icon.widget,
                    title: FTitle(f),
                    onTap: () {
                      app?.go(f);
                    },
                    trailing: widget.expand != null
                        ? IconButton(
                            icon: const Icon(
                              Icons.arrow_right,
                            ),
                            onPressed: () {
                              widget.expand!(node, f);
                            },
                          )
                        : null,
                  ),
                ),
              )
              .toList(),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            color: Colors.grey.shade400.withAlpha(230),
            child: NewNodeF(
              onCreate: (f) {
                node.sorted.order(f);
                setState(() {
                  node.sort();
                });
              },
              to: node,
            ),
          ),
        ),
      ],
    );
        */
  }

  Widget tile(EventFractal f) => HoverOver(
        builder: (h) => FractalTile(
          f,
          onTap: () {
            if (widget.onTap != null) return widget.onTap!(f);
            if (f is NodeFractal &&
                ['none'].contains(f.extend?['screen'] ?? node['screen'])) {
              return ConfigFArea.dialog(f);
            }
            if (f case NodeFractal node) {
              widget.expand?.call(AppFractal.active, f);
              FractalLayoutState.active.go(node);
            }
          },
          trailing: f is NodeFractal &&
                  widget.expand != null &&
                  (f.extend?['sub'] ?? node['sub']) != 'none'
              ? /*DragTarget(
                builder: (ctx, l, r) => */
              AnimatedOpacity(
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                  opacity: h ? 1 : 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_right,
                    ),
                    onPressed: () {
                      widget.expand!(node, f);
                    },
                  ),
                ) /*,
                onWillAccept: (d) {
                  widget.expand!(node, f);
                  return node != f;
                },
              )*/
              : null,
        ),
      );
}
