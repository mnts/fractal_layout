import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../inputs/index.dart';
import '../inputs/input.dart';

class FractalAttr extends StatefulWidget {
  final Attr attr;
  const FractalAttr(this.attr, {super.key});

  @override
  State<FractalAttr> createState() => _FractalAttrState();
}

class _FractalAttrState extends State<FractalAttr> {
  @override
  Widget build(BuildContext context) {
    return switch (widget.attr) {
      Attr a when a.name.contains('_at') => FInputDate(
          a,
          mode: DateRangePickerSelectionMode.range,
        ),
      Attr a when 'INTEGER' == a.format => FractalInput(
          fractal: a,
          type: 'number',
          options: a.options,
        ),
      Attr a when 'REAL' == a.format => FractalRange(
          a,
        ),
      _ => FractalInput(
          fractal: widget.attr,
        ),
    };
  }
}
