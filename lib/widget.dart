import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/widgets/tile.dart';

import 'areas/node.dart';
import 'controllers/scaffold.dart';
import 'scaffold.dart';

class FractalAreaWidget<T extends NodeFractal> extends FractalWidget<T> {
  final Widget Function(BuildContext context) builder;
  FractalAreaWidget(super.node, this.builder, {super.key});
  @override
  area(context) => builder(context);
}

class FractalWidget<T extends NodeFractal> extends StatelessWidget
    with FractalWidgetMix<T> {
  FractalWidget(T node, {super.key}) {
    this.node = node;
  }
}

mixin FractalWidgetMix<T extends NodeFractal> on StatelessWidget {
  late final T node;

  @override
  Widget build(BuildContext context) {
    final scaffoldCtrl = context.read<FScaffoldCtrl?>();
    return scaffoldCtrl == null ? scaffold(context) : area(context);
  }

  Widget scaffold(BuildContext context) {
    return FractalScaffold(
      node: node,
      body: area(context),
    );
  }

  Widget area(BuildContext context) {
    return FNodeArea(node);
  }

  Widget tile(BuildContext context) {
    return FractalTile(node);
  }
}
