import 'dart:ui';

import 'package:fractal_layout/widget.dart';

import 'layer.dart';

class FractalBar extends StatelessWidget {
  final List<Widget> children;
  const FractalBar(this.children, {super.key});

  @override
  Widget build(BuildContext context) {
    final pad = FractalPad.maybeOf(context)?.pad ?? EdgeInsets.zero;

    return Positioned(
      bottom: 0,
      left: pad.left,
      right: pad.right,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 0,
            sigmaY: 2,
          ),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: Colors.grey.shade100.withAlpha(180),
            child: Flex(
              direction: Axis.horizontal,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
