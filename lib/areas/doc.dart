import 'package:app_fractal/index.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

class DocArea extends StatefulWidget {
  final ScreenFractal fractal;

  const DocArea(this.fractal, {super.key});

  @override
  State<DocArea> createState() => _DocAreaState();
}

class _DocAreaState extends State<DocArea> {
  ScreenFractal get f => widget.fractal;

  late final controller = FleatherController(
    f.document,
  );

  @override
  Widget build(BuildContext context) {
    return FleatherEditor(
      //focusNode: focusNode,

      scrollable: true,
      controller: controller,
      expands: false,
      readOnly: true,
      maxHeight: 200,
      scrollPhysics: const ClampingScrollPhysics(),
    );
  }
}
