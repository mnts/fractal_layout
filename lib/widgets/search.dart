import 'package:app_fractal/app.dart';
import 'package:app_fractal/screen.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_flutter/widgets/movable.dart';
import 'package:go_router/go_router.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:axi/index.dart';

import '../layout.dart';
import 'index.dart';
import 'tile.dart';

class SearchFBox<F extends NodeFractal> extends StatefulWidget {
  final TextEditingController ctrl;
  final Function(F)? onTap;
  //final bool Function(NodeFractal)? filter;
  final FlowF<F> flow;
  const SearchFBox({
    required this.ctrl,
    this.onTap,
    required this.flow,
    super.key,
    //this.filter,
  });

  @override
  State<SearchFBox> createState() => _SearchFBoxState();
}

class _SearchFBoxState extends State<SearchFBox> {
  TextEditingController get _searchCtrl => widget.ctrl;

  @override
  void initState() {
    _searchCtrl.addListener(search);
    super.initState();
  }

  String filter = '';
  search() {
    setState(() {
      filter = _searchCtrl.text;
    });
  }

  @override
  dispose() {
    _searchCtrl.removeListener(search);
    super.dispose();
  }

  Iterable<NodeFractal> get list => widget.flow.list.where(
        (f) => filter.isNotEmpty ? f.name.contains(filter) : true,
      );

  @override
  Widget build(BuildContext context) {
    return FractalBlur(
      level: 0,
      child: ListView(
        children: [
          for (final f in list)
            FractalMovable(
              event: f,
              child: FractalTile(
                f,
                onTap: () {
                  if (widget.onTap != null) return widget.onTap!(f);
                  FractalLayoutState.active.go(f);
                },
              ),
            ),
        ],
      ),
    );
  }
}
