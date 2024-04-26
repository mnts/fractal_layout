import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import '../models/ui.dart';

class FractalArea extends StatefulWidget {
  final EventFractal fractal;
  const FractalArea(
    this.fractal, {
    super.key,
  });

  @override
  State<FractalArea> createState() => _FractalAreaState();
}

class _FractalAreaState extends State<FractalArea> {
  late final uif = UIF.map[widget.fractal.type] ?? UIF.map['nav']!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return uif.area?.call(widget.fractal, context) ?? Text('no widget');
  }
}
