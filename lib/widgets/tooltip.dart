import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../scaffold.dart';
import '../widget.dart';
export 'package:super_tooltip/super_tooltip.dart';

typedef FTipCtrl = SuperTooltipController;

class FractalTooltip extends StatelessWidget {
  final Widget child;
  final Widget content;
  final double width;
  final double height;
  final TooltipDirection direction;

  FractalTooltip({
    super.key,
    required this.child,
    required this.content,
    this.width = 360,
    this.height = 480,
    this.direction = TooltipDirection.down,
    FTipCtrl? controller,
  }) {
    tipCtrl = controller ?? FTipCtrl();
  }

  late final FTipCtrl tipCtrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final wb = dark ? Colors.black : Colors.white;

    return SuperTooltip(
      controller: tipCtrl,
      showBarrier: false,
      verticalOffset: 20,
      arrowTipDistance: 20,
      arrowLength: 10,
      shadowBlurRadius: 24,
      shadowSpreadRadius: 8,
      borderColor: Colors.transparent,
      borderWidth: 0,

      //constraints: const BoxConstraints.tightFor(height: 400),
      popupDirection: direction,
      content: TapRegion(
        onTapInside: (tap) {},
        onTapOutside: (tap) {
          tipCtrl.hideTooltip();
        },
        child: Watch(
          FractalScaffoldState.active.ctrl,
          (ctx, child) => Container(
            constraints: BoxConstraints(
              maxWidth: width,
              minWidth: 100,
              maxHeight: height,
              minHeight: 100,
            ),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 6,
                  sigmaY: 6,
                ),
                child: content,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: wb.withAlpha(180),
      child: child,
    );
  }

  hide() {
    final t = Timer(
      const Duration(milliseconds: 10),
      () {
        tipCtrl.hideTooltip();
      },
    );
  }
}
