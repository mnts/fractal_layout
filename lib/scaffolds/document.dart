import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';

import '../widget.dart';

class FractalDocument extends FractalWidget {
  FractalDocument(super.node, {super.key});

  /*
  late final _ctrl = FleatherController(
    widget.screen.document,
  );

  @override
  void initState() {
    _focused = focusNode.hasFocus;
    focusNode.addListener(_editorFocusChanged);
    _ctrl.document.changes.listen((d) {
      print(d);
    });

    DocumentScaffold.ctrl = _ctrl;

    super.initState();
  }
  
  save() {
    final doc = jsonEncode(
      _ctrl.document.toJson(),
    );
    widget.screen.write('doc', doc);
  }

  final FocusNode focusNode = FocusNode();

  late bool _focused;

  void _editorFocusChanged() {
    setState(() {
      _focused = focusNode.hasFocus;
    });
  }
  */

  @override
  area(context) => switch (node) {
        ScreenFractal screen => DocumentArea(
            key: node.widgetKey('doc'),
            screen,
          ),
        _ => throw UnimplementedError(),
      };
}
