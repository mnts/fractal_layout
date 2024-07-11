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
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(FractalPad oldWidget) => pad != oldWidget.pad;
}

class FractalLayer extends StatelessWidget {
  const FractalLayer({
    super.key,
    required this.pad,
    required this.child,
  });
  final EdgeInsets pad;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final pad = FractalPad.of(context).pad;
    return FractalPad(
      pad: EdgeInsets.only(
        top: this.pad.top + pad.top,
      ),
      child: child,
    );
  }
}
