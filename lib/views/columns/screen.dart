import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/models/ui.dart';
import 'package:signed_fractal/signed_fractal.dart';

import '../thing.dart';

class ColumnsFScreen extends StatelessWidget {
  final NodeFractal node;
  const ColumnsFScreen({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return Listen(
      node.sorted,
      (context, child) => ListView(
        padding: EdgeInsets.fromLTRB(
          4, FractalScaffoldState.active.pad, 4, 6,
          //vertical: 56,
        ),
        children: [
          ...node.sorted.value.map(
            (f) => FractalThing(f),
          ),
        ],
      ),
    );
  }
}
