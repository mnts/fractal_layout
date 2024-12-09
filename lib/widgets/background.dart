import 'dart:ui';

import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';

class FractalBlur extends InheritedWidget {
  const FractalBlur({
    required this.level,
    super.key,
    required super.child,
  });

  final int level;

  static FractalBlur? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FractalBlur>();
  }

  static FractalBlur of(BuildContext context) {
    final FractalBlur? result = maybeOf(context);
    return result!;
  }

  @override
  bool updateShouldNotify(FractalBlur oldWidget) => level != oldWidget.level;
}

class FractalBackground extends StatelessWidget {
  final Widget child;
  final ImageF media;
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
        Center(
          child: FractalBlur(
            level: 4,
            child: child,
          ),
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
