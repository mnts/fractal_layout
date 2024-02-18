import 'dart:ui';
import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_app_flutter/extensions/skin.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/models/index.dart';
import 'package:go_router/go_router.dart';
import 'package:fractal_app_flutter/index.dart';
import 'screens/video.dart';
import 'section/index.dart';

class FractalLayout<T extends AppFractal> extends StatefulWidget {
  final T fractal;
  final Widget Function()? authArea;
  //final Widget? avatar;
  final Widget? footer;
  final Widget? topRight;
  final Function()? onAuth;
  final List<Widget> actions;
  final Widget? logo;
  final Widget? home;
  final bool noDrawer;
  final List<SectionF> sections;
  final Widget? Function(EventFractal f)? display;
  final Function(GlobalKey<ScaffoldState> key)? endDrawer;
  final Function(RawKeyEvent event, BuildContext context)? onKey;
  final Widget? title;
  final List<RouteBase> routes;

  static final FocusNode focus = FocusNode();

  const FractalLayout(
    this.fractal, {
    super.key,
    this.sections = const [],
    this.routes = const [],
    this.logo,
    this.home,
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
    widget.fractal.preload();
    //widget.fractal.myInteraction;
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

    super.initState();
  }

  ThemeData get theme => app.skin.theme(app.dark);

  go([NodeFractal? screen, String extra = '']) {
    final _screen = screen ?? AppFractal.active;
    final path = screen != null && screen != AppFractal.active
        ? _screen.path + extra
        : '/';
    _router.push(path);
    //setState(() {});
    //VRouter.of(ctx).to('/${screen.name}');
  }

  late final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => widget.home != null
            ? FractalScaffold(
                body: widget.home!,
                title: top,
              )
            : DocumentScaffold(screen: app),
      ),
      ...widget.routes,
    ],
  );
  String get title =>
      widget.fractal.title.value?.content ?? widget.fractal.name;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: title,
      home: Material(
        child: Listen(
          widget.fractal,
          (ctx, child) => MaterialApp.router(
            // showPerformanceOverlay: !kIsWeb,
            showPerformanceOverlay: false,
            debugShowCheckedModeBanner: false,
            theme: theme,
            title: title,
            routerConfig: _router,
          ),
        ),
      ),
    );
  }

  bool leftLocked = false;
  bool rightLocked = false;
  late final sequence = SortedFrac<NodeFractal>([app]);

  Widget get top {
    return const SearchBox();
  }

  Color get color => theme.primaryColor.withAlpha(190);

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
