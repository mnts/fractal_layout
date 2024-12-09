import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/scaffold.dart';

import 'background.dart';
import 'layer.dart';

import 'package:frac/fnotifier.dart';

class FDialogCtrl extends FChangeNotifier {}

class FDialog extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;

  static show({
    required Widget child,
    double? width,
    double? height,
  }) {
    showDialog(
      context: FractalScaffoldState.active.context,
      builder: (ctx) => FDialog(
        width: width ?? 480,
        height: height ?? 640,
        child: child,
      ),
    );
  }

  static void close() {
    Navigator.of(FractalScaffoldState.active.context).pop();
  }

  FDialog({
    super.key,
    required this.child,
    this.width = 640,
    this.height = 480,
  });

  final ctrl = FDialogCtrl();

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
          child: FractalLayer(
            child: FractalBlur(
              level: 0,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: width,
                  maxHeight: height,
                ),
                child: Watch<FDialogCtrl>(
                  ctrl,
                  (ctx, child) => this.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
