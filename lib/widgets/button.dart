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
    /*
    padding: MaterialStateProperty.all(EdgeInsets.zero),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    */
  );

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<TilesCtrl?>();
    final size = (widget.size ?? 40) + (widget.size ?? 4) / 4;
    final icon = Container(
      width: size,
      height: size,
      child: Builder(
        builder: (ctx) => InkWell(
          onTap: () {
            ConfigFArea.openDialog(f);
          },
          child: FIcon(
            f,
            size: widget.size,
            color: Colors.white,
          ),
        ),
      ),
    );

    return FilledButton(
      //icon: widget.node.icon,
      //borderRadius: BorderRadius.circular(4),

      onLongPress: () {
        ConfigFArea.openDialog(f);
      },
      onPressed: widget.onTap ??
          () {
            widget.node.onTap(context);
          },
      child: SizedBox(
        //decoration: FractalScaffoldState.active.decoration,
        height: (widget.size ?? 32) + 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 4),
            Expanded(
              child: FTitle(
                f,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: (widget.size ?? 18) - 4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (ctrl?.noPrice != true && f['price'] != null)
              Text('${f['price']}€'),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
