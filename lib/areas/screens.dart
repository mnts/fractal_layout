import 'dart:async';
import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/models/index.dart';
import 'package:signed_fractal/signed_fractal.dart';
import '../index.dart';
import '../widgets/sortable.dart';
import '../widgets/tile.dart';

typedef FExpand = void Function(NodeFractal);

class ScreensArea extends StatefulWidget {
  final NodeFractal node;
  final FExpand? expand;
  final Widget? trailing;
  final Function(EventFractal)? onTap;
  final List<EventFractal> exclude;
  final ScrollPhysics? physics;
  final bool Function(Fractal)? filter;
  final Widget Function(EventFractal f)? builder;

  const ScreensArea({
    super.key,
    this.expand,
    this.filter,
    this.trailing,
    this.exclude = const [],
    this.onTap,
    this.physics,
    this.builder,
    required this.node,
  });

  @override
  State<ScreensArea> createState() => _ScreensAreaState();
}

class _ScreensAreaState extends State<ScreensArea> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Listen(
      widget.node,
      (ctx, ch) => ListView(
        physics: widget.physics,
        shrinkWrap: widget.physics != null,
        padding: FractalPad.maybeOf(context)?.pad,
        children: [
          if (widget.filter != null)
            ...widget.node.sorted.value
                .where(
                  widget.filter!,
                )
                .map(
                  (f) => tile(f),
                )
          else
            FSortable(
              reverse: false,
              sorted: widget.node.sorted,
              cb: widget.node.sort,
              builder: (f) => tile(f),
            ),
          //if (node.sub.list.isNotEmpty)
          if ((widget.filter != null &&
                  widget.node.sorted.value.where(widget.filter!).isNotEmpty) ||
              widget.node.sorted.value.isNotEmpty)
            const Icon(
              Icons.more_horiz,
              color: Colors.grey,
            ),
          Listen(
            widget.node.sorted,
            (context, child) => FractalView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ...widget.node.sub.list
                    .where(
                      (f) => ((widget.filter?.call(f) ?? true) &&
                          ![
                            ...widget.node.sorted.value,
                            ...widget.exclude,
                          ].contains(f) &&
                          f is! InteractionFractal),
                    )
                    .map(
                      (node) => FractalMovable(
                        event: node,
                        child: tile(node),
                      ),
                    ),
              ],
            ),
          ),
          if (widget.node.extend != null)
            InkWell(
              onTap: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 2),
                child: Row(
                  children: [
                    Expanded(
                      child: FTitle(
                        widget.node.extend!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppFractal.active.bw.withAlpha(150),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      expanded
                          ? Icons.arrow_drop_down
                          : Icons.fiber_manual_record_outlined,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          if (expanded && widget.node.extend != null)
            FractalLayer(
              child: ScreensArea(
                physics: const ClampingScrollPhysics(),
                node: widget.node.extend!,
                builder: tile,
                filter: widget.filter,
                exclude: widget.node.sorted.value,
              ),
            ),
        ],
      ),
      preload: 'node',
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

  static Timer? timer;
  dragOpen(NodeFractal f) {
    timer?.cancel();
    timer = Timer(
      const Duration(milliseconds: 600),
      () {
        widget.expand!(f);
      },
    );
  }

  Widget tile(EventFractal f) =>
      widget.builder?.call(f) ??
      HoverOver(
        builder: (h) => FractalTile(
          f,
          onTap: () {
            //if (widget.onTap != null) return widget.onTap!(f);
            /*
            if (f is NodeFractal &&
                ['none'].contains(
                  f.extend?['screen'] ?? node['screen'],
                )) {
              return ConfigFArea.dialog(f);
            }
            */
            widget.onTap?.call(f);
          },
          trailing: f is NodeFractal &&
                  widget.expand != null &&
                  (f.extend?['sub'] ?? widget.node['sub']) != 'none'
              ? /*DragTarget(
                builder: (ctx, l, r) => */
              DragTarget(
                  builder: (ctx, l, r) => AnimatedOpacity(
                    duration: const Duration(
                      milliseconds: 200,
                    ),
                    opacity: h
                        ? 1
                        : FractalScaffoldState.isMobile
                            ? 0.8
                            : 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_right,
                      ),
                      onPressed: () {
                        widget.expand!(f);
                      },
                    ),
                  ),
                  onWillAcceptWithDetails: (d) {
                    dragOpen(f);
                    return true;
                  },
                  onLeave: (d) {
                    timer?.cancel();
                  },
                )
              : widget.trailing,
        ),
      );
}
