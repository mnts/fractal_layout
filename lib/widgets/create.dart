import 'package:app_fractal/index.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/signed_fractal.dart';

import '../index.dart';
import 'tile.dart';

class CreateNodeF extends StatefulWidget {
  final Function(NodeFractal)? onCreate;
  final NodeFractal Function(NodeCtrl)? beforeCreate;
  final NodeFractal? to;
  final NodeFractal? extend;
  final NodeCtrl? ctrl;

  const CreateNodeF({
    super.key,
    this.ctrl,
    this.to,
    this.extend,
    this.onCreate,
    this.beforeCreate,
  });

  @override
  State<CreateNodeF> createState() => _NewNodeFState();
}

class _NewNodeFState extends State<CreateNodeF> {
  final ctrls = FractalCtrl.where<NodeCtrl>();
  ImageF? image;

  late NodeCtrl ctrl = widget.ctrl ?? NodeFractal.controller;

  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _labelCtrl = TextEditingController();
  final _labelFocus = FocusNode();

  NodeFractal rew = makeRew();
  static NodeFractal makeRew() {
    final rew = NodeFractal();

    rew.hash = Hashed.makeHash(rew.hashData);
    return rew;
  }

  @override
  void initState() {
    _nameCtrl.addListener(() {});
    _labelFocus.addListener(() {
      formatLabel();
    });
    _labelFocus.requestFocus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Watch<Rewritable?>(
      rew,
      (ctx, child) => ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(
            top: 16,
            left: 8,
            bottom: 16,
            right: 4,
          ),
          children: [
            if (widget.extend != null) FractalTile(widget.extend!),
            if (image != null)
              FractalImage(
                image!,
                key: Key(
                  'img@${image.hashCode}',
                ),
              ),
            /*
          TextFormField(
            controller: _labelCtrl,
            focusNode: _labelFocus,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              label: Text('Label'),
              hintText: '',
              contentPadding: EdgeInsets.all(2),
            ),
            onTapOutside: formatLabel,
            onEditingComplete: formatLabel,
            onSaved: formatLabel,
            onFieldSubmitted: (v) {
              formatLabel();
            },
          ),
          */
            TextFormField(
              controller: _nameCtrl,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                prefixIcon: (widget.extend == null)
                    ? DropdownButton2(
                        customButton: SizedBox(
                          width: 48,
                          height: 48,
                          child: ctrl.icon.widget,
                        ),
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
                        buttonStyleData: const ButtonStyleData(),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.all(0),
                        ),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            rew = makeRew();
                            ctrl = value;
                          });
                        },
                      )
                    : null,
                hintText: 'Short name',
                contentPadding: EdgeInsets.all(2),
              ),
              onTapOutside: format,
              onFieldSubmitted: (v) {
                submit();
              },
            ),
            if (widget.to != null)
              Row(children: [
                Text('into'),
                Expanded(
                  child: FractalTile(widget.to!),
                ),
              ]),
            ...[
              ctrl,
              ...ctrl.controllers
                  .where((ctrl) => ctrl.runtimeType != EventsCtrl)
            ].map(
              (c) => Column(children: [
                const SizedBox(height: 16),
                if (c != ctrl)
                  Row(
                    children: [
                      SizedBox.square(
                        dimension: 32,
                        child: c.icon.widget,
                      ),
                      Text(
                        c.name,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ...c.attributes
                    .where(
                      (a) => !(const ['name']).contains(a.name),
                    )
                    .map(
                      (a) => FractalInput(
                        fractal: a,
                      ),
                    ),
              ]),
            ),
            if (ctrl is UserCtrl)
              TextFormField(
                controller: _passCtrl,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.lock),
                  hintText: 'Password',
                  contentPadding: EdgeInsets.all(2),
                ),
                onTapOutside: format,
                onFieldSubmitted: (v) {
                  submit();
                },
              ),
            Row(
              children: [
                const Spacer(),
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
          ]),
    ));
  }

  formatLabel([_]) {
    if (_nameCtrl.text.isEmpty) {
      _nameCtrl.text = _labelCtrl.text;
      format();
    }
  }

  format([_]) {
    _nameCtrl.text = _nameCtrl.text
        .replaceAll(RegExp(r"\s+\b|\b\s"), "_")
        .replaceAll(
          RegExp('[^A-Za-z0-9_-]'),
          '',
        )
        .toLowerCase();
  }

  submit() async {
    format();
    final m = {'name': _nameCtrl.text, 'created_at': unixSeconds};

    rew.m.list.whereType<WriterFractal>().forEach((post) {
      m[post.attr] = post.content;
    });

    if (widget.extend?.hash case String h) {
      m['extend'] = h;
    }

    if (widget.to?.hash case String h) {
      m['to'] = h;
    }

    if (ctrl is UserCtrl) {
      m['password'] = _passCtrl.text;
    }

    final node = widget.beforeCreate?.call(ctrl) ?? await ctrl.put(m);
    if (node == null) return;

    node.synch();
    //screen.write('title', _labelCtrl.text);
    widget.onCreate?.call(node);
    ConfigFArea.dialog(node);
  }
}
