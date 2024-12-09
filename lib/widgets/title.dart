import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';

class FTitle extends StatelessWidget {
  final Fractal fractal;
  final double size;
  final TextStyle? style;
  const FTitle(this.fractal, {this.size = 18, super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return switch (fractal) {
      (NodeFractal node) => Listen(
          node.title,
          (ctx, child) => Text(
            node.display,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
        ),
      EventFractal ev => Text(
          ev.hash,
          style: textStyle,
        ),
      Fractal f => Text(
          '#${f.id}',
          style: textStyle,
        ),
    };
  }

  TextStyle get textStyle =>
      style ??
      TextStyle(
        fontSize: size,
        color: AppFractal.active.bw,
        fontWeight: FontWeight.bold,
      );
}
