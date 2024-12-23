import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/signed_fractal.dart';
import '../areas/nav.dart';
import '../index.dart';
import '../widgets/dialog.dart';

class FTileRef extends StatefulWidget {
  final NodeFractal fractal;
  final Widget? trailing;
  final Widget? leading;
  const FTileRef(
    this.fractal, {
    super.key,
    this.trailing,
    this.leading,
  });

  @override
  State<FTileRef> createState() => _FTileRefState();
}

class _FTileRefState extends State<FTileRef> {
  NodeFractal get fractal => widget.fractal;
  Rewritable? get rew => context.read<Rewritable?>();

  String get value {
    return ('${widget.fractal['value'] ?? ''}').trim();
  }

  String get attr {
    return ('${widget.fractal['attribute'] ?? ''}').trim();
  }

  UserFractal? get user => context.read<UserFractal?>();
  String get userHash => '${(user ?? UserFractal.active.value)?.hash}';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      width: 100,
      child: FractalPick(
          switch (value) {
            'site' => FractalLayoutState.active.app.hash,
            'account' => UserFractal.active.value?.hash ?? '',
            'user' => userHash,
            _ => value,
          }, builder: (ev) {
        final at = '${ev[attr] ?? '-$attr-'}';
        return (attr.isNotEmpty)
            ? EventFractal.isHash(at)
                ? FractalPick(
                    at,
                    builder: (evt) => FractalTile(
                      evt,
                      style: FractalTileStyle.row,
                    ),
                  )
                : Text(
                    at,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  )
            : FractalTile(
                ev,
                style: FractalTileStyle.row,
              );
      }),
    );
  }
}
