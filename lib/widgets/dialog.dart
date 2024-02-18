import 'dart:ui';

import 'package:flutter/material.dart';

class FDialog extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  const FDialog({
    super.key,
    required this.child,
    this.width = 640,
    this.height = 480,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white.withAlpha(160),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3,
            sigmaY: 3,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: width,
              maxHeight: height,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
