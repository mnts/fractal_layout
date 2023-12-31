import 'package:app_fractal/index.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fractal/lib.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:signed_fractal/controllers/node.dart';
import 'package:signed_fractal/signed_fractal.dart';

import '../models/index.dart';

class NewNodeF extends StatefulWidget {
  final Function(NodeFractal)? onCreate;
  final NodeFractal? to;
  const NewNodeF({super.key, this.to, this.onCreate});

  @override
  State<NewNodeF> createState() => _NewNodeFState();
}

class _NewNodeFState extends State<NewNodeF> {
  late var ctrl = ctrls.first;
  final ctrls = FractalCtrl.where<NodeCtrl>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          fillColor: Colors.transparent,
          hintText: 'New screen',
          contentPadding: EdgeInsets.all(2),
          isDense: true,
        ),
        onFieldSubmitted: (v) async {
          final screen = await ctrl.make(v);
          /*
          final screen = NodeFractal(
            name: v,
            to: widget.to,
          );
          */
          screen.synch();
          widget.onCreate?.call(screen);
        },
      ),
    );
  }
}
