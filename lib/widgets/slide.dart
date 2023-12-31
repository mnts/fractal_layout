import 'dart:convert';
import 'package:app_fractal/screen.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/signed_fractal.dart';

class FractalSlide extends StatefulWidget {
  final ScreenFractal fractal;
  const FractalSlide({required this.fractal, super.key});

  @override
  State<FractalSlide> createState() => _FractalSlideState();
}

class _FractalSlideState extends State<FractalSlide> {
  ScreenFractal get f => widget.fractal;

  late final controller = FleatherController(
    f.document,
  );

  final FocusNode focusNode = FocusNode();
  bool _focused = false;
  @override
  void initState() {
    focusNode.addListener(_editorFocusChanged);
    super.initState();
  }

  void _editorFocusChanged() {
    setState(() {
      _focused = focusNode.hasFocus;
    });
  }

  save() {
    final doc = jsonEncode(
      controller.document.toJson(),
    );
    f.write('doc', doc);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: f.widgetKey('doc'),
      children: [
        if (f.image != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: FractalImage(
              f.image!,
              fit: BoxFit.cover,
            ),
          ),
        Center(
          child: Theme(
            data: ThemeData(
              textTheme: const TextTheme(
                bodySmall: TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0, // shadow blur
                      color: Colors.orange, // shadow color
                      offset: Offset(2.0, 2.0), // how much shadow will be shown
                    ),
                  ],
                ),
              ),
            ),
            child: FleatherEditor(
              focusNode: focusNode,
              padding: const EdgeInsets.all(8),
              controller: controller,
              expands: false,
              scrollable: true,
              scrollPhysics: const ClampingScrollPhysics(),
            ),
          ),
        ),
        Positioned(
          top: 56,
          left: 0,
          right: 0,
          height: 42,
          child: Visibility(
            visible: _focused,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                onPressed: save,
                icon: Icon(Icons.save),
                tooltip: 'save',
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: FleatherToolbar.basic(
                  controller: controller,
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
