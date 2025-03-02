import 'dart:ui';

import 'package:fractal_layout/widget.dart';

class DrawerBox extends StatelessWidget {
  final bool isLeft;
  final bool isOn;
  //final bool isLocked;
  final Widget? child;
  final double width;
  const DrawerBox(
    this.child, {
    super.key,
    this.isLeft = true,
    this.isOn = true,
    this.width = 300,
    //this.isLocked = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      top: 0,
      bottom: 0,
      left: isLeft ? 0 : null,
      right: isLeft ? null : 0,
      child: AnimatedSlide(
        offset: Offset(
          (isOn) ? 0 : (isLeft ? -1 : 1),
          0,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              width: width,
              decoration: BoxDecoration(
                border: const Border.symmetric(
                  vertical: BorderSide(
                    color: Color(0x11888888),
                    width: 1,
                  ),
                ),
                color: theme.brightness == Brightness.light
                    ? const Color(0x88DDDDDD)
                    : const Color(0x88333333),
                /*
            boxShadow: const [
              BoxShadow(
                color: Color(0x11888888),
                spreadRadius: 4,
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
            */
              ),
              child: (isOn) ? child : null,
            ),
          ),
        ),
      ),
    );
  }
}
