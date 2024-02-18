import 'package:flutter/material.dart';
import 'package:fractal/c.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/widgets/index.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:super_tooltip/super_tooltip.dart';

class FractalSelect extends StatefulWidget {
  final NodeFractal fractal;
  final Widget? trailing;
  const FractalSelect({required this.fractal, super.key, this.trailing});

  @override
  State<FractalSelect> createState() => _FractalSelectState();
}

class _FractalSelectState extends State<FractalSelect> {
  NodeFractal get fractal => widget.fractal;
  Rewritable? get rew => context.read<Rewritable?>();

  Iterable<String> options = [];

  initOptionsNode(String hash) {
    if (EventFractal.isHash(value)) {
      NetworkFractal.request(value).then((node) {
        if (node is NodeFractal) {
          setState(() {
            selected = node;
          });
        }
      });
    }
    NetworkFractal.request(hash).then((node) {
      if (node is NodeFractal) {
        setState(() {
          _optionsNode = node;
        });
      }
    });
  }

  String get value {
    return rew?.m[fractal.name]?.content ?? '';
  }

  NodeFractal? _optionsNode;

  @override
  void initState() {
    if (fractal['options'] case String opt) {
      if (EventFractal.isHash(opt)) {
        initOptionsNode(opt);
      }
      super.initState();
    }
  }

  late final _tipCtrl = FTipCtrl();

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<NodeFractal>(
      //initialSelection: _optionsNode,
      onSelected: (f) {
        // This is called when the user selects an item.
        setState(() {
          selected = f;
          if (f != null) select(f);
        });
      },
      expandedInsets: EdgeInsets.all(2),
      leadingIcon: SizedBox.square(
        dimension: 48,
        child: selected?.icon ?? fractal.icon,
      ),
      trailingIcon: widget.trailing,
      initialSelection: selected,

      dropdownMenuEntries: [
        ..._optionsNode?.sorted.value.whereType<NodeFractal>().map((f) {
              return DropdownMenuEntry<NodeFractal>(
                value: f,
                leadingIcon: SizedBox.square(
                  dimension: 48,
                  child: f.icon,
                ),
                label: f.display,
              );
            }) ??
            [],
      ],
    );
  }

  select(NodeFractal node) {
    rew?.write(fractal.name, node.hash);
  }

  NodeFractal? selected;
}
