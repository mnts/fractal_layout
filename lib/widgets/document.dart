import 'dart:convert';

import 'package:app_fractal/index.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:signed_fractal/models/rewriter.dart';

class DocumentArea extends StatefulWidget {
  final ScreenFractal screen;
  const DocumentArea(this.screen, {super.key});

  @override
  State<DocumentArea> createState() => _DocumentAreaState();
}

class _DocumentAreaState extends State<DocumentArea> {
  late final controller = FleatherController(
    widget.screen.document,
  );

  @override
  void initState() {
    _focused = focusNode.hasFocus;
    focusNode.addListener(_editorFocusChanged);
    controller.document.changes.listen((d) {
      print(d);
    });

    super.initState();
  }

  save() {
    final doc = jsonEncode(
      controller.document.toJson(),
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.screen.own)
          Container(
            height: 36,
            child: Visibility(
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
                      controller: controller,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        FleatherEditor(
          padding: EdgeInsets.all(8),
          focusNode: focusNode,
          controller: controller,
          expands: true,
        ),
      ],
    );
  }
}
