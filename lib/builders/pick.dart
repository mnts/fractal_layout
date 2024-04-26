import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/signed_fractal.dart';

import '../index.dart';

class FractalPick extends StatefulWidget {
  final String hash;
  final Widget Function(EventFractal)? builder;
  const FractalPick(this.hash, {super.key, this.builder});

  @override
  State<FractalPick> createState() => _FractalPickState();
}

class _FractalPickState extends State<FractalPick> {
  @override
  void initState() {
    super.initState();
    pick();
  }

  EventFractal? fractal;

  pick() {
    NetworkFractal.request(widget.hash).then((f) {
      setState(() {
        f.preload();
        fractal = f;
      });
    });
    /*
    final f = await FilterFractal.pick(widget.hash);
    if (f case EventFractal ef) {
      setState(() {
        fractal = ef;
      });
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return fractal != null
        ? widget.builder != null
            ? Listen(
                fractal!,
                (ctx, child) => widget.builder!.call(fractal!),
              )
            : FractalTile(fractal!)
        : const CupertinoActivityIndicator();
  }
}
