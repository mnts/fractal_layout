import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';

import '../index.dart';
import '../views/thing.dart';

class FRows extends StatefulWidget {
  final NodeFractal node;
  const FRows(this.node, {super.key});

  @override
  State<FRows> createState() => _FRowsState();
}

class _FRowsState extends State<FRows> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Listen(
        widget.node.sorted,
        (context, child) {
          return ListView(
            //itemCount: sorted.value.length,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            //shrinkWrap: false,
            scrollDirection: Axis.vertical,
            padding: FractalPad.of(context).pad,
            children: [
              ...widget.node.sorted.value.map(row),
            ],
          );
        },
        preload: 'node',
      ),
    );
  }

  Widget row(EventFractal f) {
    final size = double.tryParse('${f['size']}');
    final height = double.tryParse('${f['height']}');

    return Listen(
      f,
      (ctx, child) => Container(
        constraints: BoxConstraints(
          maxHeight: height ?? 300,
        ),
        child: switch (f) {
          NodeFractal node when f.image != null => FractalImage(
              f.image!,
              fit: BoxFit.contain,
            ),
          NodeFractal node when node['screen'] == null => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FractalTile(
                  f,
                  size: size,
                  maxWidth: 486,
                ),
              ],
            ),
          _ => FractalThing(f),
        },
      ),
      preload: 'writer',
    );
  }
}
