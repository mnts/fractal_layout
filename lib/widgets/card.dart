import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/signed_fractal.dart';

import '../areas/config.dart';
import '../controllers/tiles.dart';
import 'icon.dart';
import 'title.dart';

class FractalCard extends StatefulWidget {
  final NodeFractal fractal;
  final Function()? onTap;
  final Widget? trailing;
  final Widget? child;
  const FractalCard(
    this.fractal, {
    super.key,
    this.onTap,
    this.child,
    this.trailing,
  });

  @override
  State<FractalCard> createState() => _FractalCardState();
}

class _FractalCardState extends State<FractalCard> {
  NodeFractal get f => widget.fractal;

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<TilesCtrl?>();

    return Container(
      //onPressed: () {},
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
      constraints: const BoxConstraints(maxHeight: 200),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: InkWell(
              onTap: widget.onTap ??
                  () {
                    ConfigFArea.openDialog(f);
                  },
              child: FIcon(f),
            ),
          ),
          if (widget.trailing != null)
            Positioned(
              top: 2,
              right: 2,
              child: widget.trailing!,
            ),
          if (ctrl?.noPrice != true && f['price'] != null)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 4,
                  right: 4,
                  top: 2,
                  bottom: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${f['price']}€',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(
                      180,
                      120,
                      20,
                      1,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 6,
                  sigmaY: 6,
                ),
                child: Container(
                  color: Colors.white.withAlpha(100),
                  padding: const EdgeInsets.all(2),
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: widget.onTap ??
                        () {
                          ConfigFArea.openDialog(f);
                        },
                    child: widget.child ?? FTitle(f),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
