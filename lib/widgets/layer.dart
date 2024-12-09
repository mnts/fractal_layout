import 'package:flutter/material.dart';

class FractalPad extends InheritedWidget {
  const FractalPad({
    super.key,
    required this.pad,
    required super.child,
  });

  final EdgeInsets pad;

  static FractalPad? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FractalPad>();
  }

  static FractalPad of(BuildContext context) {
    final FractalPad? result = maybeOf(context);
    return result!;
  }

  @override
  bool updateShouldNotify(FractalPad oldWidget) => pad != oldWidget.pad;
}

class FractalLayer extends StatelessWidget {
  const FractalLayer({
    super.key,
    this.pad,
    required this.child,
  });
  final EdgeInsets? pad;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (this.pad == null) {
      return FractalPad(
        pad: EdgeInsets.zero,
        child: child,
      );
    }

    final pad = FractalPad.maybeOf(context)?.pad ?? EdgeInsets.zero;
    return FractalPad(
      pad: EdgeInsets.only(
        top: this.pad!.top + pad.top,
        bottom: this.pad!.bottom + pad.bottom,
        left: this.pad!.left + pad.left,
        right: this.pad!.right + pad.right,
      ),
      child: child,
    );
  }
}
