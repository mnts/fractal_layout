import 'package:flutter/material.dart';

class FractalDrawer extends StatefulWidget {
  final Widget child;
  const FractalDrawer({required this.child, super.key});

  @override
  State<FractalDrawer> createState() => _FractalDrawerState();
}

class _FractalDrawerState extends State<FractalDrawer> {
  @override
  void initState() {
    super.initState();
  }

  bool pressDrawer = false;

  @override
  Widget build(BuildContext context) {
    return /*Container(
      //width: drawerWidth,
      decoration: BoxDecoration(
        color: AppFractal.active.wb.withAlpha(200),
        /*
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 3,
            offset: const Offset(-3, 2),
          ),
        ],
        */
      ),
      child: Listener(
        onPointerDown: (_) {
          pressDrawer = true;
        },
        onPointerMove: (d) {
          if (pressDrawer == false) return;
          if (d.delta.dx.abs() < 40) return;
          FractalLayoutState.active.scaffoldKey.currentState?.closeDrawer();
          pressDrawer = false;
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3.0,
            sigmaY: 3.0,
          ),
          child: */
        Theme(
      data: ThemeData(
        listTileTheme: ListTileThemeData(
          textColor: Colors.grey.shade700,
          iconColor: Colors.grey.shade700,
        ),
      ),
      child: SafeArea(
        child: widget.child,
      ),
      //),
    );
  }
}
