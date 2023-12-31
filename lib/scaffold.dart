import 'dart:async';
import 'dart:ui';

import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_app_flutter/index.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_flutter/widgets/movable.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/tools/cart.dart';
import 'package:fractal_layout/tools/notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:velocity_x/velocity_x.dart';

class FractalScaffold extends StatefulWidget {
  final Widget body;
  final Widget? title;
  final NodeFractal? node;
  const FractalScaffold({
    super.key,
    required this.body,
    this.node,
    this.title,
  });

  static void modal(Widget child) {
    showDialog(
      context: FractalScaffoldState.active.context,
      builder: (ctx) => Dialog(
        clipBehavior: Clip.hardEdge,
        child: child,
      ),
    );
  }

  @override
  State<FractalScaffold> createState() => FractalScaffoldState();
}

class FractalScaffoldState extends State<FractalScaffold>
    with TickerProviderStateMixin {
  static late FractalScaffoldState active;

  AppFractal get app => context.read<AppFractal>();
  NodeFractal? get node => widget.node;

  @override
  void initState() {
    //AppFractal.active = widget.fractal;

    _leftCurve.addStatusListener((status) {
      setState(() {
        leftStatus = status;
      });
    });

    _rightCurve.addStatusListener((status) {
      setState(() {
        rightStatus = status;
      });
    });

    active = this;
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final _userTypesCtrl = FTipCtrl();

  static const Duration _duration = Duration(milliseconds: 300);
  late final leftCtrl = AnimationController(
    vsync: this,
    duration: _duration,
  );
  var leftStatus = AnimationStatus.dismissed;
  late final _leftCurve = CurvedAnimation(
    parent: leftCtrl,
    curve: Curves.ease,
  );

  late final rightCtrl = AnimationController(
    vsync: this,
    duration: _duration,
  );
  var rightStatus = AnimationStatus.dismissed;
  late final _rightCurve = CurvedAnimation(
    parent: rightCtrl,
    curve: Curves.ease,
  );

  FractalLayoutState get layout => FractalLayoutState.active;

  static const double drawerWidth = 360;

  Color get color => FractalLayoutState.active.color;

  final padding = const EdgeInsets.symmetric(
    horizontal: 4,
    vertical: 56,
  );

  double get w => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppFractal>();
    final isWide = w > maxWide;

    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        backgroundColor: AppFractal.active.wb.withAlpha(190),
        child: layout.leftLocked ? null : leftDrawer,
      ),
      endDrawer: Drawer(
        backgroundColor: AppFractal.active.wb.withAlpha(190),
        child: layout.rightLocked ? null : rightDrawer,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: layout.leftLocked && isWide ? drawerWidth : 0,
            right: layout.rightLocked && w > maxWide - 300 ? drawerWidth : 0,
            child: Watch<AppFractal>(
              key: AppFractal.main.widgetKey('app'),
              AppFractal.main,
              (ctx, child) => Listen(
                AppFractal.main,
                (ctx, child) => Listen(
                  UserFractal.active,
                  (ctx, child) => Watch(
                    UserFractal.active,
                    (ctx, child) => Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: widget.body,
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: _bar(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (layout.leftLocked && isWide)
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: drawerWidth,
              child: Container(
                decoration: BoxDecoration(
                  color: AppFractal.active.dark
                      ? Colors.grey.shade900
                      : Colors.grey.shade100,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 6,
                      blurRadius: 6,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: leftDrawer,
              ),
            ),
          if (layout.rightLocked && w > maxWide - 300)
            Positioned(
              top: 0,
              bottom: 0,
              width: drawerWidth,
              //left: -drawerWidth + leftPush,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppFractal.active.dark
                      ? Colors.grey.shade900
                      : Colors.grey.shade100,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 6,
                      blurRadius: 6,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: rightDrawer,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    leftCtrl.dispose();
    rightCtrl.dispose();
    super.dispose();
  }

  static const maxWide = 980;
  Widget get leftDrawer {
    final isWide = w > maxWide - 300;
    return FractalSub(
      key: const Key('subDrawerList'),
      sequence: FractalLayoutState.active.sequence,
      //[app],
      buildView: (ev, exp) => switch (ev) {
        NodeFractal node => ScreensArea(
            node: node,
            expand: exp,
            padding: padding,
            key: ev.widgetKey(
              'nav',
            ),
          ),
        _ => Container(),
      },
      ctrls: [
        if (isWide)
          IconButton(
            onPressed: () {
              scaffoldKey.currentState?.closeDrawer();
              setState(() {
                layout.leftLocked = !layout.leftLocked;
              });
              if (!layout.leftLocked) scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(
              layout.leftLocked ? Icons.menu : Icons.menu_open_sharp,
            ),
          )
      ],
    );
  }

  Widget get rightDrawer {
    final scheme = Theme.of(context).colorScheme;
    final isWide = w > maxWide;

    const padding = EdgeInsets.only(
      bottom: 50,
      top: 56,
      left: 4,
    );
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        (UserFractal.active.value == null)
            ? Container(
                padding: padding,
                child: const AuthArea(),
              )
            : FractalUsers(
                padding: padding,
                node: FractalLayoutState.active.sequence.value.last,
              ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 56,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 0,
                  sigmaY: 2,
                ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  color: color,
                  child: UserFractal.active.value != null
                      ? Theme(
                          data: ThemeData(
                            listTileTheme: const ListTileThemeData(
                              textColor: Colors.white,
                              iconColor: Colors.white,
                            ),
                          ),
                          child: FractalUser(UserFractal.active.value!),
                        )
                      : const Expanded(
                          child: Text(
                            'Authorization',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 40,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 0,
                  sigmaY: 2,
                ),
                child: Container(
                  color: AppFractal.active.wb.withAlpha(128),
                  child: Row(
                    children: [
                      if (isWide)
                        IconButton(
                          onPressed: () {
                            scaffoldKey.currentState?.closeEndDrawer();
                            setState(() {
                              layout.rightLocked = !layout.rightLocked;
                            });
                            if (!layout.rightLocked)
                              scaffoldKey.currentState?.openEndDrawer();
                          },
                          icon: Icon(
                            layout.rightLocked
                                ? Icons.menu
                                : Icons.menu_open_sharp,
                          ),
                        ),
                      const Spacer(),
                      if (UserFractal.active.value != null) buildPlus(),
                      lightMode,
                      if (UserFractal.active.value != null)
                        IconButton(
                          onPressed: () {
                            UserFractal.logOut();
                          },
                          icon: const Icon(
                            Icons.exit_to_app,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    //final nodes = ObjectDBFilter<NodeModel>({});
  }

  Widget buildPlus() {
    return FractalTooltip(
      controller: _userTypesCtrl,
      direction: TooltipDirection.up,
      width: 200,
      height: 160,
      content: ListView(children: [
        ...?FractalLayoutState.userTypes?.sorted.value.map(
          (f) => FractalTile(
            f,
            onTap: () {
              if (f is! NodeFractal) return;

              _userTypesCtrl.hideTooltip();
              FractalSubState.modal(
                extend: f,
                to: UserFractal.active.value,
                ctrl: UserFractal.controller,
                cb: (f) {
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ]),
      child: IconButton(
        onPressed: () {
          _userTypesCtrl.showTooltip();
        },
        icon: const Icon(
          Icons.person_add,
        ),
      ),
    );
  }

  Widget get lightMode {
    return IconButton(
      onPressed: () {
        setState(() {
          app.dark = !app.dark;
        });
      },
      icon: Icon(app.dark ? Icons.dark_mode : Icons.light_mode),
    );
  }

  Widget _bar(BuildContext context) {
    final active = UserFractal.active;

    final layout = FractalLayoutState.active;
    /*return SlidingBar(
      controller: _animCtrl,
      visible: !widget.fractal.hideAppBar,
      child: */
    return Container(
      color: color,
      height: 56,
      //backgroundColor: widget.fractal.skin.color.toMaterial,

      //mainAxisAlignment: MainAxisAlignment.spaceBetween,

      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 2),
          child: Hero(
            tag: 'title',
            child: Row(children: bar),
          ),
        ),
      ),
    );
    //);
  }

  List<Widget> get bar {
    final layout = FractalLayoutState.active;
    final w = MediaQuery.of(context).size.width;

    final showName = node != null &&
        (!layout.leftLocked) &&
        node != AppFractal.active &&
        w > 800;
    return [
      //if (!layout.leftLocked)if (w > 600 && !layout.leftLocked)
      if (!layout.leftLocked || w < maxWide)
        IconButton(
          onPressed: () {
            final scaffold = scaffoldKey.currentState;
            if (scaffold == null) return;
            (scaffold.isDrawerOpen == true)
                ? scaffold.closeDrawer()
                : scaffold.openDrawer();
            /*
                  final ctrl = FractalLayoutState.active.animCtrl;
                  (ctrl.isCompleted) ? ctrl.reverse() : ctrl.forward();
                  */
          },
          icon: AppFractal.active.image != null
              ? Container(
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppFractal.active.wb,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AbsorbPointer(
                      child: FractalImage(
                    AppFractal.active.image!,
                  )),
                )
              : const Icon(Icons.menu),
        ),
      if (!layout.leftLocked && w >= maxWide)
        TextButton(
          onPressed: () {
            FractalLayoutState.active.go(AppFractal.active);
          },
          onLongPress: () {
            if (node case NodeFractal node) {
              ConfigFArea.dialog(node);
            }
          },
          style: const ButtonStyle(
            padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
          child: FTitle(
            app,
            style: FractalSubState.textStyle,
          ),
        ),

      if (showName)
        const Icon(
          Icons.arrow_right_sharp,
          color: Colors.white,
        ),
      if (showName)
        TextButton.icon(
          onPressed: () {
            if (node case NodeFractal node) {
              ConfigFArea.dialog(node);
            }
          },
          style: const ButtonStyle(
            padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
          icon: SizedBox.square(
            dimension: 32,
            child: FIcon(node!),
          ),
          label: FTitle(
            node!,
            style: FractalSubState.textStyle,
          ),
        ),
      Expanded(
        child: Center(child: widget.title),
      ),
      if (w > 650 && UserFractal.active.value != null)
        const NotificationsTool(),
      if (w > 600 && UserFractal.active.value != null) const CartTool(),
      if (UserFractal.active.value == null && !app.isGated)
        ElevatedButton(
          onPressed: () {
            final layout = scaffoldKey.currentState;
            layout?.openEndDrawer();
          },
          child: Row(
            children: [
              if (w > 600)
                const Text(
                  'Authenticate',
                ),
              const Icon(
                Icons.lock_person_outlined,
              )
            ],
          ),
        )
      else if (!layout.rightLocked)
        IconButton(
          onPressed: () {
            final scaffold = scaffoldKey.currentState;
            if (scaffold == null) return;
            (scaffold.isEndDrawerOpen == true)
                ? scaffold.closeEndDrawer()
                : scaffold.openEndDrawer();
            /*
                  final ctrl = FractalLayoutState.active.animCtrl;
                  (ctrl.isCompleted) ? ctrl.reverse() : ctrl.forward();
                  */
          },
          icon: UserFractal.active.value?.image != null
              ? Container(
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppFractal.active.wb,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AbsorbPointer(
                      child: FractalImage(
                    UserFractal.active.value!.image!,
                  )),
                )
              : Icon(
                  Icons.person,
                  color: AppFractal.active.wb,
                ),
        ),
    ];
  }

  Widget get top {
    final w = MediaQuery.of(context).size.width;

    return Row(
      //crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      //direction: Axis.horizontal,
      children: [
        const Spacer(),

        /*if (widget.fractal.currentScreen?.ctrl != null)
                      Expanded(
                        child: widget.fractal.currentScreen!.ctrl!(),
                      ),*/
        //if(widget.fractal.ctrl != null) getActions(context),
      ],
    );
  }
}
