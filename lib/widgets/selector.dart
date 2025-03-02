import 'dart:async';

import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/widgets/icon.dart';

import '../index.dart';
import 'search.dart';
import 'tooltip.dart';

class FractalSelector<T extends NodeFractal> extends StatefulWidget {
  final String hint;
  final Function(T)? onSelected;
  final NodeFractal? node;
  final FlowF<T> flow;
  final T? preSelected;
  const FractalSelector({
    super.key,
    this.node,
    this.onSelected,
    required this.flow,
    this.hint = '',
    this.preSelected,
  });

  select(T node) {
    onSelected?.call(node);
  }

  @override
  State<FractalSelector> createState() => _FractalSelectorState();
}

class _FractalSelectorState extends State<FractalSelector> {
  final tipCtrl = FTipCtrl();
  final txtCtrl = TextEditingController();
  //final flow = TypeFilter<UserFractal>(EventFractal.map);
  NodeFractal? selected;
  Rewritable? get rew => context.read<Rewritable?>();
  CatalogFractal? get catalog => context.read<CatalogFractal?>();

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
          select(f);
        },
      ),
      child: TextFormField(
        maxLines: 1,
        controller: txtCtrl,
        decoration: InputDecoration(
          hintText: selected?.name ?? widget.node?.display ?? widget.hint,
          //hintStyle: TextStyle(color: Colors.grey.withAlpha(200)),
          //fillColor: wb.withAlpha(200),
          contentPadding: const EdgeInsets.all(2),
          prefixIcon: GestureDetector(
            onLongPress: () {
              if (widget.node != null) ConfigFArea.openDialog(widget.node!);
            },
            child: SizedBox(
              width: 24,
              height: 24,
              child: selected?.icon ?? const Icon(Icons.person),
            ),
          ),
          suffixIcon: selected != null
              ? IconButton(
                  icon: const Icon(Icons.disabled_by_default),
                  onPressed: unSelect,
                )
              : null,
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

  unSelect() {
    setState(() {
      if (widget.node case NodeFractal wNode) {
        if (catalog != null) {
          catalog!.filter!.remove(wNode.name);
          catalog!.refresh();
        } else {
          rew?.write(wNode.name, '');
        }
      }
      selected = null;
    });
  }

  select(NodeFractal node) {
    widget.select(node);

    if (widget.node case NodeFractal wNode) {
      if (catalog != null) {
        catalog!.filter![wNode.name] = node.hash;
        catalog!.refresh();
      } else {
        rew?.write(wNode.name, node.hash);
      }
    }
  }
}
