import 'dart:ui';
import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/tools/cart.dart';
import 'package:fractal_socket/index.dart';
import 'package:fractal_socket/socket.dart';
import 'package:signed_fractal/sys.dart';
import 'package:universal_io/io.dart' show Platform;
import 'controllers/index.dart';
import 'drawers/index.dart';
import 'drawers/left.dart';
import 'tools/notifications.dart';
import 'views/printable.dart';
import 'views/thing.dart';

class FractalScaffold extends StatefulWidget {
  final Widget body;
  final Widget? title;
  final Fractal? node;
  final Widget? bar;
  final List<Widget> menu;
  const FractalScaffold({
    super.key,
    this.bar,
    required this.body,
    this.node,
    this.title,
    this.menu = const [],
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

  static List<Widget Function()> menu = [];

  AppFractal get app => AppFractal.active;
  Fractal? get node => widget.node;

  final ctrl = FScaffoldCtrl();

  @override
  void initState() {
    //AppFractal.active = widget.fractal;

    /*
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
    */

    active = this;
    super.initState();
  }

  final _userTypesCtrl = FTipCtrl();

  static const Duration _duration = Duration(milliseconds: 300);

  /*
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
  */

  FractalLayoutState get layout => FractalLayoutState.active;

  static const double drawerWidth = 360;

  Color get color => FractalLayoutState.active.color;

  double get w => MediaQuery.of(context).size.width;
  bool get isWide => w > maxWide;

  static final isMobile = (Platform.isAndroid || Platform.isIOS);
  static const double barHeight = 56;
  double get statusPad => MediaQuery.of(context).viewPadding.top;
  double get pad => barHeight + statusPad;

  @override
  Widget build(BuildContext context) {
    return Watch<AppFractal>(
      key: AppFractal.main.widgetKey('app'),
      AppFractal.main,
      (ctx, child) => Watch<FScaffoldCtrl>(
        ctrl,
        (ctx, child) => Listen(
          AppFractal.main,
          (ctx, child) => Listen(
            AppFractal.active,
            (ctx, child) => FutureBuilder(
              future: app.preload('node'),
              builder: (ctx, snap) => buildLayout(
                app['layout'] as NodeFractal?,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLayout([EventFractal? f]) {
    return Listen(
      UserFractal.active,
      (ctx, child) => Watch(
        UserFractal.active,
        (ctx, child) => (UserFractal.active.value == null && f != null)
            ? scaffold ?? //FractalGate() ??
                FutureBuilder(
                  future: f.preload('node'),
                  builder: (ctx, snap) {
                    if (f['gate'] case NodeFractal gateNode) {
                      return FractalThing(gateNode);
                    }
                    return FractalGate();
                  },
                )
            : scaffold,
      ),
    );
  }

  @override
  void dispose() {
    //leftCtrl.dispose();
    //rightCtrl.dispose();
    super.dispose();
  }

  static LinearGradient get gradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          FractalLayoutState.active.color.withAlpha(210),
          FractalLayoutState.active.color,
        ],
      );

  Widget get scaffold => Scaffold(
        //key: scaffoldKey,
        /*
        drawer: Drawer(
          backgroundColor: AppFractal.active.wb.withAlpha(190),
          child: layout.leftLocked ? null : leftDrawer,
        ),
        endDrawer: Drawer(
          backgroundColor: AppFractal.active.wb.withAlpha(190),
          child: layout.rightLocked ? null : rightDrawer,
        ),
        */
        body: stack,
      );

  closeDrawers() {
    setState(() {
      onLeft = false;
      onRight = false;
    });
  }

  final droppable = Frac<bool>(false);

  Widget get stack => Stack(
        alignment: Alignment.topCenter,
        children: [
          body,
          //if (layout.leftLocked && isWide)
          if (onLeft && !layout.leftLocked || onRight && !layout.rightLocked)
            Positioned.fill(
              child: DragTarget(
                builder: (ctx, cl, cd) => InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(100),
                    ),
                  ),
                  onTap: closeDrawers,
                ),
                onWillAccept: (data) {
                  closeDrawers();
                  return true;
                },
              ),
            ),
          Positioned(
            key: const Key('leftDrawer'),
            top: 0,
            bottom: 0,
            left: 0,
            child: AnimatedSlide(
              offset: Offset((onLeft || layout.leftLocked) ? 0 : -1, 0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                width: drawerWidth,
                decoration: BoxDecoration(
                  color: (AppFractal.active.dark
                          ? Colors.grey.shade900
                          : Colors.grey.shade100)
                      .withAlpha(200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 6,
                      blurRadius: 6,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: (onLeft || layout.leftLocked) ? leftDrawer : null,
              ),
            ),
          ),
          //if (layout.rightLocked && w > maxWide - 300)
          Positioned(
            key: const Key('rightDrawer'),
            top: 0,
            bottom: 0,
            //left: -drawerWidth + leftPush,
            right: 0,
            child: AnimatedSlide(
              offset: Offset((onRight || layout.rightLocked) ? 0 : 1, 0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                width: drawerWidth,
                decoration: BoxDecoration(
                  color: (AppFractal.active.dark
                          ? Colors.grey.shade900
                          : const Color.fromRGBO(245, 245, 245, 1))
                      .withAlpha(200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 6,
                      blurRadius: 6,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: (onRight || layout.rightLocked) ? rightDrawer : null,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            width: 400,
            child: Listen(
              FSys.errors,
              (ctx, ch) => ListView(
                shrinkWrap: true,
                children: [
                  for (final err in FSys.errors.value)
                    Container(
                      margin: const EdgeInsets.all(4),
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppFractal.active.wb.withAlpha(128),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppFractal.active.bw.withAlpha(64),
                              ),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.error),
                              title: Text(
                                err,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget get body => Positioned(
        top: 0,
        bottom: 0,
        left: layout.leftLocked && isWide ? drawerWidth : 0,
        right: layout.rightLocked && w > maxWide - 300 ? drawerWidth : 0,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: FractalLayer(
                pad: const EdgeInsets.only(
                  top: barHeight,
                ),
                child: widget.body,
              ),
            ),
            Positioned(
              top: statusPad,
              left: 0,
              right: 0,
              child: _bar,
            ),
            if (isMobile) const StatusPad(),
          ],
        ),
      );

  static const maxWide = 980;
  //Widget leftLoaded = FLeftDrawer();
  static Widget leftDrawer = const FLeftDrawer();

  EdgeInsets get padding => EdgeInsets.only(
        //bottom: 50,
        top: pad,
        left: 4,
      );

  //bool rightLoaded = false;
  static Widget rightDrawer = const FRightDrawer();

  Widget get _bar {
    final active = UserFractal.active;

    final layout = FractalLayoutState.active;
    /*return SlidingBar(
      controller: _animCtrl,
      visible: !widget.fractal.hideAppBar,
      child: */
    return widget.bar ??
        Container(
          height: barHeight,

          color: Colors.black87,
          /*
          decoration: BoxDecoration(
            gradient: gradient,
          ),
          */

          //backgroundColor: widget.fractal.skin.color.toMaterial,

          //mainAxisAlignment: MainAxisAlignment.spaceBetween,

          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 2),
              child: Row(children: bar),
            ),
          ),
        );
    //);
  }

  static bool onLeft = false;
  static bool onRight = false;

  List<Widget> get bar {
    final layout = FractalLayoutState.active;
    final w = MediaQuery.of(context).size.width;

    final showName = node != null &&
        (!layout.leftLocked) &&
        node != AppFractal.active &&
        w > 800;
    return [
      //if (!layout.leftLocked)if (w > 600 && !layout.leftLocked)
      /*
      if (!layout.leftLocked || w < maxWide)
        InkWell(
          onTap: () async {
            await AppFractal.active.whenLoaded;
            setState(() {
              onLeft = !onLeft;
            });

            /*
                  final ctrl = FractalLayoutState.active.animCtrl;
                  (ctrl.isCompleted) ? ctrl.reverse() : ctrl.forward();
                  */
          },
          onDoubleTap: () {
            FractalLayoutState.active.go(AppFractal.active);
          },
          onLongPress: () {
            FractalLayoutState.active.go(AppFractal.active);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 4),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppFractal.active.wb,
            ),
            clipBehavior: Clip.antiAlias,
            child: AppFractal.active.image != null
                ? AbsorbPointer(
                    child: FractalImage(
                    AppFractal.active.image!,
                  ))
                : const Icon(Icons.menu),
          ),
        ),
      */

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

      if (NetworkFractal.out case FSocketAPI soc)
        Listen(
          soc.active,
          (ctx, ch) => Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: soc.active.value ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
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
            child: FIcon(
              node!,
              noImage: true,
              color: Colors.white,
            ),
          ),
          label: FTitle(
            node!,
            style: FractalSubState.textStyle,
          ),
        ),
      Expanded(
        child: Center(child: widget.title),
      ),
      /*
      if (w > 650 && UserFractal.active.value != null)
        const NotificationsTool(),
      */
      ...widget.menu,
      for (var b in menu) b(),
      if (w > 600 && UserFractal.active.value != null)
        const NotificationsTool(key: Key('fNotifications')),
/*
      if (UserFractal.active.value == null && !app.isGated)
        ElevatedButton(
          onPressed: () {
            setState(() {
              onRight = !onRight;
            });
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
            setState(() {
              onRight = !onRight;
            });
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
        */
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

  dialog(Widget child) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        clipBehavior: Clip.hardEdge,
        child: child,
      ),
    );
  }
}
