import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/signed_fractal.dart';

import '../index.dart';
import '../views/thing.dart';

class FractalPick extends StatefulWidget {
  final String hash;
  final Widget Function(EventFractal)? builder;
  final Widget Function()? loader;
  const FractalPick(
    this.hash, {
    super.key,
    this.builder,
    this.loader,
  });

  @override
  State<FractalPick> createState() => _FractalPickState();
}

class _FractalPickState extends State<FractalPick> {
  @override
  void initState() {
    super.initState();
    pick();
  }

  @override
  void didUpdateWidget(oldWidget) {
    pick();
    super.didUpdateWidget(oldWidget);
  }

  EventFractal? fractal;

  pick() {
    NetworkFractal.request(widget.hash).then((f) {
      setState(() {
        f.preload('node');
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
            : FractalThing(fractal!)
        : widget.loader?.call() ?? const CupertinoActivityIndicator();
  }
}
