import 'dart:ui';

import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';

class FractalBackground extends StatelessWidget {
  final Widget child;
  final FileF media;
  const FractalBackground({
    super.key,
    required this.child,
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: FractalImage(
            media,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 90),
          child: child,
        ),
      ],
    );
  }

  /*
   ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(80),
                borderRadius: BorderRadius.circular(8),
              ),
              child: 
          ),
        ),
      ],
    */
}
