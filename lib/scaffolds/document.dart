import 'dart:convert';

import 'package:app_fractal/index.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';

class DocumentScaffold extends StatefulWidget {
  final ScreenFractal screen;
  const DocumentScaffold({super.key, required this.screen});

  static FleatherController? ctrl;

  @override
  State<DocumentScaffold> createState() => _DocumentScaffoldState();
}

class _DocumentScaffoldState extends State<DocumentScaffold> {
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

  @override
  Widget build(context) {
    return FractalScaffold(
      node: widget.screen,
      body: DocumentArea(
        key: widget.screen.widgetKey('doc'),
        widget.screen,
        padding: EdgeInsets.only(
          top: FractalScaffoldState.pad,
          left: 8,
          right: 8,
          bottom: 64,
        ),
      ), /*FleatherEditor(
        padding: EdgeInsets.only(
          top: FractalScaffoldState.pad,
          left: 8,
          right: 8,
        ),
        focusNode: focusNode,
        controller: _ctrl,
        embedBuilder: DocumentArea.embedBuilder,
        expands: true,
      ),*/
    );
  }
}
