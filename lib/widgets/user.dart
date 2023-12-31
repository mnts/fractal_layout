import 'dart:ui';

import 'package:app_fractal/index.dart';
import 'package:dartlin/control_flow.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:fractal/c.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_flutter/widgets/movable.dart';
import 'package:fractal_layout/widgets/icon.dart';
import 'package:signed_fractal/models/event.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:fractal_flutter/data/icons.dart';
import '../controllers/tiles.dart';
import '../index.dart';
import '../inputs/icon.dart';
import 'color.dart';
import 'title.dart';

class FractalUser extends StatefulWidget {
  final UserFractal fractal;
  final Function()? onTap;
  final Widget? trailing;
  const FractalUser(
    this.fractal, {
    super.key,
    this.onTap,
    this.trailing,
  });

  static const options = ['tile', 'input', 'select', 'color', 'icon'];

  @override
  State<FractalUser> createState() => _FractalUserState();
}

class _FractalUserState extends State<FractalUser> {
  Rewritable? get rew => context.read<Rewritable?>();

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppFractal>();

    return Listen(
      widget.fractal,
      (ctx, child) => Listen(
        widget.fractal.m,
        (ctx, child) => GestureDetector(
          onLongPress: () {
            ConfigFArea.dialog(widget.fractal);
          },
          onSecondaryTap: () {
            ConfigFArea.dialog(widget.fractal);
          },
          child: tile(widget.fractal),
        ),
      ),
    );
  }

  Widget tile(NodeFractal f) {
    const height = 48.0;
    return HoverOver(
      builder: (h) => InkWell(
        onTap: widget.onTap ??
            () {
              ConfigFArea.dialog(f);
            },
        child: Container(
          height: height,
          child: Stack(
            children: [
              Positioned(
                right: 2,
                bottom: 0,
                top: 0,
                left: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FTitle(f),
                    const SizedBox(width: 8),
                    SizedBox.square(
                      dimension: height,
                      child: FIcon(f),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                top: 0,
                left: 2,
                width: height,
                child: AnimatedOpacity(
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                  opacity: h ? 1 : 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.message,
                    ),
                    onPressed: () {
                      FractalLayoutState.active.go(
                        widget.fractal,
                        '|stream',
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    /*,,
      m
    );*/
  }

  write() {}
}