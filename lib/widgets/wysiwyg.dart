import 'dart:convert';

import 'package:app_fractal/index.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../scaffold.dart';
import 'index.dart';

class WysiwygArea extends StatefulWidget {
  final ScreenFractal screen;
  const WysiwygArea({super.key, required this.screen});
  static FleatherController? ctrl;

  @override
  State<WysiwygArea> createState() => _WysiwygAreaState();
}

class _WysiwygAreaState extends State<WysiwygArea> {
  late final _ctrl = FleatherController(
    document: widget.screen.document,
  );

  @override
  void initState() {
    _focused = focusNode.hasFocus;
    focusNode.addListener(_editorFocusChanged);
    _ctrl.document.changes.listen((d) {
      print(d);
    });

    WysiwygArea.ctrl = _ctrl;

    super.initState();
  }

  @override
  dispose() {
    WysiwygArea.ctrl = null;
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
          icon: const Icon(Icons.save),
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
  Widget build(context) {
    return Stack(
      children: [
        FleatherEditor(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
          ),
          focusNode: focusNode,
          controller: _ctrl,
          embedBuilder: DocumentArea.embedBuilder,
          expands: true,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 48,
          child: buildCtrl(),
        ),
      ],
    );
  }
}
