import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/models/index.dart';
import 'package:signed_fractal/models/node.dart';

class FRenamable extends StatefulWidget {
  final NodeFractal node;
  final double size;

  const FRenamable(
    this.node, {
    this.size = 32,
    super.key,
  });

  TextStyle get textStyle => TextStyle(
        fontSize: size,
        //color: Colors.orange,
        fontWeight: FontWeight.bold,
      );

  @override
  State<FRenamable> createState() => _FRenamableState();
}

class _FRenamableState extends State<FRenamable> {
  NodeFractal get node => widget.node;
  late final ctrl = TextEditingController(text: node.display);

  bool rename = false;
  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final cl = Theme.of(context).canvasColor;

    return TextFormField(
      controller: ctrl,
      focusNode: focus,
      onFieldSubmitted: save,
      style: widget.textStyle,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        isDense: true,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
      ),
    );
    /*
    return Row(
      children: [
        Expanded(
          child: (!rename)
              ? InkWell(
                  onTap: () {
                    AppFractal.active.go(node);
                  },
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: widget.textStyle,
                    textAlign: TextAlign.center,
                  ),
                )
              : TextFormField(
                  controller: ctrl,
                  focusNode: focus,
                  onFieldSubmitted: save,
                  style: widget.textStyle,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    isDense: true,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
        ),
        if (/*node.own && */ !rename)
          IconButton(
            onPressed: () {
              setState(() {
                rename = true;
                focus.requestFocus();
              });

              //tipCtrl.showTooltip();
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                const EdgeInsets.all(2),
              ),
            ),
            //color: cl,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.edit,
            ),
          ),
      ],
    );
    */
  }

  save(String? val) {
    setState(() {
      rename = false;
    });
    if (val == null || val == node.display) return;
    node.write('title', val);
  }
}
