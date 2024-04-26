import 'package:flutter/material.dart';
import 'package:fractal/fractal.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/models/index.dart';

import '../index.dart';

class NavFModal extends StatefulWidget {
  final Function(String) onSelect;
  const NavFModal({super.key, required this.onSelect});

  @override
  State<NavFModal> createState() => _NavFModalState();
}

class _NavFModalState extends State<NavFModal> {
  final padding = const EdgeInsets.symmetric(
    horizontal: 4,
    vertical: 48,
  );

  @override
  Widget build(BuildContext context) {
    return FractalSub(
      key: const Key('subDrawerList'),
      sequence: FractalLayoutState.active.sequence,
      //[app],
      buildView: (ev, exp) => switch (ev) {
        NodeFractal node => ScreensArea(
            node: node,
            expand: exp,
            padding: padding,
            key: ev.widgetKey(
              'nav',
            ),
            onTap: (f) => widget.onSelect(f.hash),
          ),
        _ => Container(),
      },
      ctrls: [
        ...['site', 'account', 'user'].map(
          (s) => TextButton(
            onPressed: () {
              widget.onSelect(s);
            },
            child: Text(s),
          ),
        ),
      ],
    );
  }
}
