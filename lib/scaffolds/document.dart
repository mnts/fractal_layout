import 'dart:convert';

import 'package:app_fractal/index.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:fractal_layout/index.dart';

class DocumentScaffold extends StatefulWidget {
  final ScreenFractal screen;
  const DocumentScaffold({super.key, required this.screen});

  @override
  State<DocumentScaffold> createState() => _DocumentScaffoldState();
}

class _DocumentScaffoldState extends State<DocumentScaffold> {
  @override
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

    super.initState();
  }

  @override
  dispose() {
    _ctrl.dispose();
    super.dispose();
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

  Widget buildCtrl() {
    return Visibility(
      visible: true, //_focused,
      child: Row(children: [
        IconButton(
          onPressed: save,
          icon: Icon(Icons.save),
          tooltip: 'save',
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FleatherToolbar.basic(
              controller: _ctrl,
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FractalScaffold(
      title: buildCtrl(),
      body: FleatherEditor(
        padding: const EdgeInsets.only(
          top: 56,
          left: 8,
          right: 8,
        ),
        focusNode: focusNode,
        controller: _ctrl,
        expands: true,
      ),
    );
  }
}
