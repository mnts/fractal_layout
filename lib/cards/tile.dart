import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';

class TileItem extends StatefulWidget {
  final NodeFractal node;
  const TileItem(
    this.node, {
    super.key,
  });

  @override
  State<TileItem> createState() => _TileEdItemState();
}

class _TileEdItemState extends State<TileItem>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.node.preload();
  }

  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  hover(bool o) {
    o ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Listen(
        widget.node,
        (ctx, child) {
          final desc = widget.node.description;
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              widget.node.onTap(ctx);
            },
            onLongPress: () {
              ConfigFArea.openDialog(widget.node);
            },
            onSecondaryTap: () {
              ConfigFArea.openDialog(widget.node);
            },
            onHover: hover,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (ctx, child) => Container(
                width: desc == null ? 128 : 320,
                height: 96,
                padding: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      scheme.primary,
                      scheme.primary.withOpacity(0.75),
                    ],
                  ),
                ),
                child: Flex(
                  direction: desc == null ? Axis.vertical : Axis.horizontal,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(desc == null ? 2 : 6),
                      child: Icon(
                        FIcon.parse(
                            widget.node.resolve('icon') as String? ?? 'dot',
                            widget.node.ctrl.icon.codePoint),
                        weight: 8,
                        size: 48,
                        color: scheme.primary,
                        shadows: [
                          Shadow(
                            color: Colors.white,
                            offset: const Offset(3, 3),
                            blurRadius: 30 - _controller.value * 15,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    desc == null
                        ? FTitle(
                            widget.node,
                            style: const TextStyle(
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.white,
                                  //offset: Offset(1, 1),
                                  blurRadius: 6,
                                )
                              ],
                            ),
                          )
                        : Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FTitle(
                                    widget.node,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.white,
                                          //offset: Offset(1, 1),
                                          blurRadius: 6,
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    desc,
                                    maxLines: 3,
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 12,
                                    ),
                                  )),
                                ]),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
        preload: 'rewriter',
      ),
    );
  }
}
