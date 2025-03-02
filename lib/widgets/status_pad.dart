import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class StatusPad extends StatelessWidget {
  final double left;
  final double right;
  const StatusPad({
    super.key,
    this.left = 0,
    this.right = 0,
  });

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).viewPadding.top;

    return Positioned(
        top: 0,
        left: left,
        right: right,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 2,
              sigmaY: 2,
            ),
            child: Container(
              height: max(0, pad - 0.2),
              color: Colors.grey.shade200.withAlpha(100),
            ),
          ),
        ));
  }
}
