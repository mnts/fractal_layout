import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import '../index.dart';

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
  void initState() {
    widget.fractal.preload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: SizedBox(
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
                  opacity: h ? 1 : 1,
                  child: IconButton(
                    icon: const Icon(
                      Icons.message,
                    ),
                    onPressed: () {
                      final hashes = [
                        UserFractal.active.value!.hash,
                        widget.fractal.hash,
                      ];

                      hashes.sort();

                      final chatFu = NodeFractal.controller.put({
                        'name': 'chat:${hashes.join(',')}',
                        'created_at': 0,
                      });

                      chatFu.then(
                        (node) => FractalLayoutState.active.go(
                          node,
                          '|stream',
                        ),
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
