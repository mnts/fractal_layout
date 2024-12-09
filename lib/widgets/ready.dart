import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signed_fractal/signed_fractal.dart';

class FractalReady<T extends NodeFractal> extends StatelessWidget {
  final T node;
  final Widget Function() builder;
  const FractalReady(
    this.node,
    this.builder, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: node.whenLoaded,
      builder: (ctx, snap) => snap.hasData
          ? builder()
          : const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
    );
  }
}
