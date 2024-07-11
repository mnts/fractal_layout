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
    return Container(
      margin: const EdgeInsets.all(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          UIF.onTap(widget.node);
        },
        onLongPress: () {
          ConfigFArea.dialog(widget.node);
        },
        onSecondaryTap: () {
          ConfigFArea.dialog(widget.node);
        },
        onHover: hover,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (ctx, child) => Container(
            padding: const EdgeInsets.only(top: 8),
            width: 128,
            height: 96,
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
            child: Listen(
              widget.node.m,
              (ctx, child) => Column(
                children: [
                  Icon(
                    FIcon.parse(widget.node['icon'] as String? ?? 'dot',
                        widget.node.ctrl.icon.codePoint),
                    weight: 8,
                    size: 48,
                    color: scheme.primary,
                    shadows: [
                      Shadow(
                        color: Colors.white,
                        offset: Offset(2, 2),
                        blurRadius: 30 - _controller.value * 15,
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  FTitle(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
