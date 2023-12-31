import 'dart:async';

import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_layout/widgets/icon.dart';

import 'search.dart';
import 'tooltip.dart';

class FractalSelector<T extends NodeFractal> extends StatefulWidget {
  final String hint;
  final void Function(T) onSelected;
  final FlowF<T> flow;
  final T? preSelected;
  const FractalSelector({
    super.key,
    required this.onSelected,
    required this.flow,
    this.hint = '',
    this.preSelected,
  });

  select(T f) {
    onSelected(f);
  }

  @override
  State<FractalSelector> createState() => _FractalSelectorState();
}

class _FractalSelectorState extends State<FractalSelector> {
  final tipCtrl = FTipCtrl();
  final txtCtrl = TextEditingController();
  //final flow = TypeFilter<UserFractal>(EventFractal.map);
  NodeFractal? selected;

  @override
  void initState() {
    selected = widget.preSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FractalTooltip(
      controller: tipCtrl,
      content: SearchFBox(
        ctrl: txtCtrl,
        flow: widget.flow,
        /*
        filter: (f) {
          return f is UserFractal;
        },
        */
        onTap: (f) {
          setState(() {
            selected = f;
            tipCtrl.hideTooltip();
            txtCtrl.text = '';
          });
          widget.select(f);
        },
      ),
      child: TextFormField(
        maxLines: 1,
        controller: txtCtrl,
        decoration: InputDecoration(
          hintText: selected?.name ?? widget.hint,
          //hintStyle: TextStyle(color: Colors.grey.withAlpha(200)),
          //fillColor: wb.withAlpha(200),
          contentPadding: const EdgeInsets.all(2),
          prefixIcon: SizedBox(
            width: 24,
            height: 24,
            child: selected?.icon ?? const Icon(Icons.person),
          ),
          //isDense: true,
        ),
        onTap: () {
          tipCtrl.showTooltip();
        },
        /*
        onTapOutside: (c) {
          final t = Timer(
            const Duration(milliseconds: 10),
            () {
              tipCtrl.hideTooltip();
            },
          );
        },
        */
      ),
    );
  }
}
