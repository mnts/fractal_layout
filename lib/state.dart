import 'package:flutter/material.dart';
import 'package:fractal/lib.dart';

import 'controllers/index.dart';

class FractalWidgetState extends StatelessWidget {
  final Fractal fractal;
  const FractalWidget(this.fractal, {super.key});

  get scaffold => context.read<FScaffoldCtrl?>();

  @override
  Widget build(BuildContext context) {
    return scaffold != null
        ? FractalScaffold(
            node: widget.screen,
            body: body,
          )
        : body;
  }

  Widget scaffold() => FractalScaffold(
        node: widget.screen,
        body: body,
      );
}
