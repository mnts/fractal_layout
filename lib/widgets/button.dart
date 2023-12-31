import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';

class FractalButton extends StatefulWidget {
  final NodeFractal node;
  const FractalButton({
    super.key,
    required this.node,
  });

  @override
  State<FractalButton> createState() => _FractalButtonState();
}

class _FractalButtonState extends State<FractalButton> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
