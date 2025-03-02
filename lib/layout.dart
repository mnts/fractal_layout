import 'dart:ui';
import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:go_router/go_router.dart';
import 'section/index.dart';
import 'widgets/index.dart';
import 'widgets/layer.dart';

class FractalLayout<T extends AppFractal> extends StatefulWidget {
  final T fractal;
  final Widget Function()? authArea;
  //final Widget? avatar;
  final Widget? footer;
  final Widget? topRight;
  final Function()? onAuth;
  final List<Widget> actions;
  final Widget? logo;
  final bool noDrawer;
  final List<SectionF> sections;
  final Widget? Function(EventFractal f)? display;
  final Function(GlobalKey<ScaffoldState> key)? endDrawer;
  final Function(RawKeyEvent event, BuildContext context)? onKey;
  final Widget? title;
  final GoRouter? router;

  static final FocusNode focus = FocusNode();

  const FractalLayout(
    this.fractal, {
    super.key,
    this.sections = const [],
    this.router,
    this.logo,
    this.noDrawer = false,
    this.endDrawer,
    this.display,
    this.actions = const [],
    this.topRight,
    this.footer,
    this.authArea,
    this.onKey,
    this.onAuth,
    this.title,
    //this.avatar,
  });

  @override
  State<FractalLayout> createState() => FractalLayoutState();

  static init() async {}
}

class FractalLayoutState extends State<FractalLayout> {
  AppFractal get app => widget.fractal;

  static late FractalLayoutState active;

  static NodeFractal? userTypes;

  //NodeFractal currentScreen = AppFractal.active;
  late final w = MediaQuery.of(context).size.width;

  @override
  void initState() {
    AppFractal.active = widget.fractal;
    active = this;
    widget.fractal.synch();
    widget.fractal.preload();
    //widget.fractal.myInteraction;
    /*
    NetworkFractal.request('JR5bq7UwsevCffQ78yyDzL4gZgYbi2QZVGi3UYyLvb7vFLYjC')
        .then(
      (u) {
        if (u is NodeFractal) {
          setState(() {
            userTypes = u;
          });
        }
      },
    );
    */

    super.initState();
  }

  ThemeData get theme => app.skin.theme(app.dark);

  go([NodeFractal? screen, String extra = '']) {
    final _screen = screen ?? AppFractal.active;
    final path = screen != null && screen != AppFractal.active
        ? _screen.path + extra
        : '/';
    widget.router?.go(path);
    //setState(() {});
    //VRouter.of(ctx).to('/${screen.name}');
  }

  String get title =>
      widget.fractal.title.value?.content ?? widget.fractal.name;

  @override
  Widget build(BuildContext context) {
    final viewP = MediaQuery.of(context).viewPadding;
    return MaterialApp(
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: title,
      home: Material(
        child: FractalPad(
          pad: EdgeInsets.only(
            top: viewP.top,
            //bottom: viewP.bottom,
          ),
          child: FractalBlur(
            level: 0,
            child: Listen(
              widget.fractal,
              (ctx, child) => MaterialApp.router(
                // showPerformanceOverlay: !kIsWeb,
                showPerformanceOverlay: false,
                debugShowCheckedModeBanner: false,
                theme: theme,
                title: title,
                routerConfig: widget.router,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //bool leftLocked = false;
  //bool rightLocked = false;
  late final sequence = SortedFrac<NodeFractal>([app]);

  Widget get top {
    return const SearchBox();
  }

  Color get color => theme.primaryColor;

  bool terminalOn = false;

  /*
  Widget display(EventFractal f) =>
      widget.display?.call(f) ??
      switch (f) {
        (AppFractal app) => widget.home ??
            FScreen(
              DocumentArea(
                app,
              ),
              key: const Key('home'),
            ),
        (UserFractal user) => ProfileArea(user: user),
        (NodeFractal node) => node.ui.screen(
            currentScreen,
            context,
          ),
        _ => f.ctrl.ui.screen(
            currentScreen,
            context,
          )
      };
      */
}
