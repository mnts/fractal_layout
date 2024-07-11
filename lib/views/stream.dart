import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';

import '../index.dart';
import '../widget.dart';

class StreamFWidget extends FractalWidget {
  StreamFWidget(super.node, {super.key});

  @override
  area(context) => StreamArea(
        fractal: node,
      );

  @override
  scaffold(context) {
    return FractalScaffold(
      //node: screen as NodeFractal,
      title: Builder(
        builder: (ctx) {
          final hashes = node.name.split(':')[1].split(',');
          hashes.remove(UserFractal.active.value!.hash);
          return FractalPick(hashes.first);
        },
      ),
      body: StreamArea(
        padding: const EdgeInsets.only(
          top: 80,
          bottom: 50,
          left: 4,
        ),
        fractal: node,
      ),
    );
  }
}
