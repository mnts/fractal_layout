import 'package:app_fractal/index.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/areas/config.dart';
import 'package:velocity_x/velocity_x.dart';

class FTitle extends StatelessWidget {
  final EventFractal fractal;
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
      EventFractal() => Text(
          fractal.hash,
          style: textStyle,
        ),
    };
  }

  TextStyle get textStyle =>
      style ??
      TextStyle(
        fontSize: size,
        //color: Colors.orange,
        fontWeight: FontWeight.bold,
      );
}
