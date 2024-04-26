import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/builders/pick.dart';
import 'package:intl/intl.dart';
import 'package:signed_fractal/signed_fractal.dart';
import '../areas/nav.dart';
import '../index.dart';
import '../widgets/dialog.dart';

class FInputNav extends StatefulWidget {
  final NodeFractal fractal;
  final Widget? trailing;
  final Widget? leading;
  const FInputNav(
    this.fractal, {
    super.key,
    this.trailing,
    this.leading,
  });

  @override
  State<FInputNav> createState() => _FInputDateState();
}

class _FInputDateState extends State<FInputNav> {
  NodeFractal get fractal => widget.fractal;
  Rewritable? get rew => context.read<Rewritable?>();

  void selectorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => FDialog(
        width: 480,
        height: 640,
        child: NavFModal(
          onSelect: (path) {
            rew!.write(fractal.name, path);
            Navigator.of(ctx).pop();
            setState(() {});
          },
        ),
      ),
    );
  }

  String get value {
    return (rew?.m[widget.fractal.name]?.content ?? '').trim();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: rew != null
              ? Listen(
                  rew!.m,
                  (ctx, child) {
                    return FractalPick(
                      switch (value) {
                        'site' => FractalLayoutState.active.app.hash,
                        'account' => UserFractal.active.value?.hash ?? '',
                        'user' => (context.read<UserFractal?>() ??
                                UserFractal.active.value)!
                            .hash,
                        _ => value,
                      },
                      key: rew!.widgetKey(value),
                    );
                  },
                )
              : Container(),
        ),
        IconButton(
          icon: const Icon(Icons.cloud_upload_outlined),
          onPressed: selectorDialog,
        ),
      ],
    );
  }
}
