import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';

import '../controllers/tiles.dart';

class FractalButton extends StatefulWidget {
  final NodeFractal node;
  final Function()? onTap;
  final double? size;

  const FractalButton({
    super.key,
    this.onTap,
    this.size,
    required this.node,
  });

  @override
  State<FractalButton> createState() => _FractalButtonState();
}

class _FractalButtonState extends State<FractalButton> {
  NodeFractal get f => widget.node;

  static final style = ButtonStyle(
    visualDensity: VisualDensity.compact,
    padding: MaterialStateProperty.all(EdgeInsets.zero),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<TilesCtrl?>();
    final size = (widget.size ?? 40) + (widget.size ?? 4) / 4;
    final icon = Container(
      width: size,
      height: size + 4,
      child: Builder(
        builder: (ctx) => InkWell(
          onTap: () {
            ConfigFArea.dialog(f);
          },
          child: FIcon(f, size: widget.size),
        ),
      ),
    );

    return FilledButton(
      //icon: widget.node.icon,

      style: style,
      onLongPress: () {
        ConfigFArea.dialog(f);
      },
      onPressed: widget.onTap ??
          () {
            ConfigFArea.dialog(f);
          },
      child: Row(children: [
        icon,
        Expanded(
          child: FTitle(
            f,
            style: TextStyle(
              color: Colors.white,
              fontSize: widget.size ?? 18,
            ),
          ),
        ),
        if (ctrl?.noPrice != true && f['price'] != null) Text('${f['price']}€'),
        const SizedBox(width: 4),
      ]),
    );
  }
}
