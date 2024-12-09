import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';

import '../index.dart';
import '../widget.dart';

class StreamFWidget extends FNodeWidget {
  StreamFWidget(super.node, {super.key});

  @override
  area() => Builder(builder: (ctx) {
        final rew = ctx.read<Rewritable?>();
        return StreamArea(
          fractal: rew is NodeFractal ? rew : f,
        );
      });

  @override
  scaffold() {
    return FractalScaffold(
      //node: screen as NodeFractal,
      title: Builder(
        builder: (ctx) {
          final hashes = f.name.split(':')[1].split(',');
          hashes.remove(UserFractal.active.value!.hash);
          return SizedBox(
            width: 220,
            child: FractalPick(hashes.first),
          );
        },
      ),
      body: StreamArea(
        padding: const EdgeInsets.only(
          top: 80,
          bottom: 50,
          left: 4,
        ),
        fractal: f,
      ),
    );
  }
}
