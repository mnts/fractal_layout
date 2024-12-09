import 'package:flutter/material.dart';
import 'package:fractal_layout/index.dart';

class FPrintableLayer extends InheritedWidget {
  const FPrintableLayer({
    super.key,
    required super.child,
  });

  static FPrintableLayer? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FPrintableLayer>();
  }

  @override
  bool updateShouldNotify(FractalPad oldWidget) => child != oldWidget.child;
}

class FPrintable extends StatelessWidget {
  final Widget child;
  const FPrintable(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(),
      child: FPrintableLayer(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            key: GlobalKey(),
            body: Material(
              color: Colors.white,
              child: InheritedTheme.captureAll(
                context,
                FractalBlur(
                  level: 0,
                  child: FractalPad(
                    pad: EdgeInsets.zero,
                    child: Theme(
                      data: ThemeData(
                        scaffoldBackgroundColor: Colors.white,
                        listTileTheme: const ListTileThemeData(
                          enableFeedback: false,
                          tileColor: Colors.transparent,
                        ),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
