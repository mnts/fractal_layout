import 'package:app_fractal/index.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:signed_fractal/signed_fractal.dart';

class CreateNodeFC extends StatefulWidget {
  final Function(NodeFractal)? onCreate;
  final NodeFractal? to;
  const CreateNodeFC({super.key, this.to, this.onCreate});

  @override
  State<CreateNodeFC> createState() => _NewNodeFState();
}

class _NewNodeFState extends State<CreateNodeFC> {
  late var ctrl = ctrls.first;
  final ctrls = FractalCtrl.where<NodeCtrl>();
  ImageF? image;

  final _nameCtrl = TextEditingController();

  @override
  void initState() {
    _nameCtrl.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: ListView(shrinkWrap: true, children: [
      if (image != null)
        FractalImage(
          image!,
          key: Key(
            'img@${image.hashCode}',
          ),
        ),
      ListTile(
        leading: DropdownButton2(
          customButton: ctrl.icon.widget,
          isDense: true,
          items: ctrls
              .map(
                (c) => DropdownMenuItem<NodeCtrl>(
                  value: c,
                  child: ListTile(
                    leading: c.icon.widget,
                    title: Text(c.label),
                  ),
                ),
              )
              .toList(),
          dropdownStyleData: DropdownStyleData(
            width: 240,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.all(0),
          ),
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              ctrl = value;
            });
          },
        ),
        title: TextFormField(
          controller: _nameCtrl,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          decoration: const InputDecoration(
            fillColor: Colors.transparent,
            hintText: 'name',
            contentPadding: EdgeInsets.all(2),
            isDense: true,
          ),
          onTapOutside: format,
          onFieldSubmitted: (v) {
            submit();
          },
        ),
      ),
      Row(
        children: [
          Expanded(
            child: Container(),
          ),
          IconButton(
            onPressed: () async {
              final img = await FractalImage.pick();
              if (img != null) {
                setState(() {
                  image = (img);
                });
              }
            },
            icon: const Icon(Icons.image),
          ),
          IconButton.filled(
            onPressed: submit,
            icon: const Icon(Icons.task_alt),
          )
        ],
      ),
    ]));
  }

  format([_]) {
    _nameCtrl.text = _nameCtrl.text
        .replaceAll(RegExp(r"\s+\b|\b\s"), "_")
        .replaceAll(
          RegExp('[^A-Za-z0-9_]'),
          '',
        )
        .toLowerCase();
  }

  submit() {
    final v = _nameCtrl.text;
    final screen = switch (ctrl) {
      (CanvasCtrl _) => CanvasFractal(
          name: v,
          //file: image,
          to: widget.to,
        ),
      (ScreenCtrl _) => ScreenFractal(
          name: v,
          //file: image,
          to: widget.to,
        ),
      (NodeCtrl _) => NodeFractal(
          name: v,
          //file: image,
          to: widget.to,
        ),
    };
    print(screen);
    screen.synch();
    widget.onCreate?.call(screen);
  }
}
