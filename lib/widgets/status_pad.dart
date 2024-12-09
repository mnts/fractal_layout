import 'dart:ui';

import 'package:flutter/material.dart';

class StatusPad extends StatelessWidget {
  const StatusPad({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    final pad = MediaQuery.of(context).viewPadding.top;

    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 0,
              sigmaY: 2,
            ),
            child: Container(
              height: pad + 2,
              color: color.withAlpha(220),
            ),
          ),
        ));
  }
}
