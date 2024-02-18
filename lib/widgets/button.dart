import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';

import '../controllers/tiles.dart';

class FractalButton extends StatefulWidget {
  final NodeFractal node;
  final Function()? onTap;

  const FractalButton({
    super.key,
    this.onTap,
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
    final icon = SizedBox.square(
      dimension: 40,
      child: f.icon,
    );

    return FilledButton(
      //icon: widget.node.icon,

      style: style,
      child: Row(children: [
        icon,
        Expanded(
          child: FTitle(
            f,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        if (ctrl?.noPrice != true && f['price'] != null) Text('${f['price']}€'),
        const SizedBox(width: 4),
      ]),
      onLongPress: () {
        ConfigFArea.dialog(f);
      },
      onPressed: widget.onTap ??
          () {
            ConfigFArea.dialog(f);
          },
    );
  }
}
