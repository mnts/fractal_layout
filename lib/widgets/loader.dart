import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signed_fractal/signed_fractal.dart';

class FractalLoader extends StatefulWidget {
  final MapF map;
  final Widget Function(EventFractal) builder;
  const FractalLoader({
    super.key,
    required this.map,
    required this.builder,
  });

  @override
  State<FractalLoader> createState() => _FractalLoaderState();
}

class _FractalLoaderState extends State<FractalLoader> {
  @override
  void initState() {
    super.initState();
  }

  EventFractal? event;

  @override
  Widget build(BuildContext context) {
    return event == null
        ? const Center(
            child: CupertinoActivityIndicator(),
          )
        : widget.builder(event!);
  }
}
