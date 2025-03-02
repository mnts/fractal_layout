import 'dart:ui';
import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_socket/index.dart';
import 'package:go_router/go_router.dart';
import 'package:signed_fractal/sys.dart';
import 'package:universal_io/io.dart' show Platform;
import 'controllers/index.dart';
import 'drawers/index.dart';
import 'drawers/left.dart';
import 'tools/index.dart';
import 'tools/mem.dart';
import 'tools/notifications.dart';
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

  static Widget? logo;
  static Widget? rightBar;
  static Widget? leftBar;
  static Decoration? decoration;
  static var alignBar = MainAxisAlignment.start;

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
  late final theme = Theme.of(context);
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

  Color get color => FractalLayoutState.active.color;

  double get w => mq.size.width;
  bool get isWide => w > maxWide;

  static final isMobile = (Platform.isAndroid || Platform.isIOS);
  static const double barHeight = 56;
  double get statusPad => mq.viewPadding.top;
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

  final decoration = FractalScaffold.decoration ??
      BoxDecoration(
        color: Colors.grey.shade200.withAlpha(100),
        border: const Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0x33888888),
          ),
        ),

        /*
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.shade200.withAlpha(120),
            Colors.grey.shade200.withAlpha(80),
          ],
        ),
        */
      );

  Widget get scaffold => Scaffold(body: stack);
  /*Scaffold(
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
      */

  closeDrawers() {
    setState(() {
      onLeft = false;
      onRight = false;
    });
  }

  final droppable = Frac<bool>(false);

  static const double drawerWidth = 300;
  Widget get stack {
    double left = (isWide && onLeft) ? drawerWidth : 0;
    double right = (isWide && onRight) ? drawerWidth : 0;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: 0,
          //left: left,
          left: 0,
          right: 0,
          bottom: 0,
          child: FractalLayer(
            pad: EdgeInsets.only(
              top: barHeight,
              left: left,
              right: right,
            ),
            child: widget.body,
          ),
        ),
        Positioned(
          top: statusPad,
          left: left,
          right: right,
          child: _bar,
        ),
        if (isMobile)
          StatusPad(
            left: left,
            right: right,
          ),
        //body,
        //if (layout.leftLocked && isWide)\

        if (w < maxWide && (onLeft || onRight))
          Positioned.fill(
            child: DragTarget(
              builder: (ctx, cl, cd) => InkWell(
                onTap: closeDrawers,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.canvasColor.withAlpha(200),
                  ),
                ),
              ),
              onWillAccept: (data) {
                closeDrawers();
                return true;
              },
            ),
          ),

        DrawerBox(
          key: const Key('leftDrawer'),
          isOn: onLeft,
          width: drawerWidth,
          ((onLeft)) ? leftDrawer : null,
        ),

        DrawerBox(
          key: const Key('rightDrawer'),
          isOn: onRight,
          width: drawerWidth,
          isLeft: false,
          ((onRight)) ? rightDrawer : null,
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
  }

  /*
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
  */
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
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Theme(
              data: theme.copyWith(
                textTheme: theme.textTheme.copyWith(
                  bodyMedium: TextStyle(
                    color: Colors.black,
                  ),
                  labelMedium: TextStyle(
                    color: Colors.black,
                  ),
                  titleMedium: TextStyle(
                    color: Colors.black,
                  ),
                  displayMedium: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              child: Container(
                height: barHeight,

                //color: Colors.black87,

                decoration: FractalScaffold.decoration ?? decoration,

                //backgroundColor: widget.fractal.skin.color.toMaterial,

                //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                child: Row(
                  mainAxisAlignment: FractalScaffold.alignBar,
                  children: bar,
                ),
              ),
            ),
          ),
        );
    //);
  }

  static bool onLeft = false;
  static bool onRight = false;

  MediaQueryData get mq => MediaQuery.of(context);
  List<Widget> get bar {
    final layout = FractalLayoutState.active;

    final showName = node != null && node != AppFractal.active && isWide;
    return [
      //if (!layout.leftLocked)if (w > 600 && !layout.leftLocked)
      if (FractalScaffold.leftBar case Widget leftBar)
        leftBar
      else
        InkWell(
          onTap: () async {
            //await AppFractal.active.whenLoaded;
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
              color: AppFractal.active.wb.withAlpha(90),
            ),
            clipBehavior: Clip.antiAlias,
            child: (AppFractal.active.image != null && !onLeft)
                ? AbsorbPointer(
                    child: FractalImage(
                    AppFractal.active.image!,
                  ))
                : Icon(
                    Icons.menu,
                    color: theme.primaryColor,
                  ),
          ),
        ),

      if ((isWide && !onLeft) || FractalScaffold.logo != null)
        TextButton(
          onPressed: () {
            FractalLayoutState.active.go(AppFractal.active);
          },
          onLongPress: () {
            if (node case NodeFractal node) {
              ConfigFArea.openDialog(node);
            }
          },
          style: const ButtonStyle(
            padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
          child: FractalScaffold.logo ??
              FTitle(
                app,
              ),
        ),

      const FractalNet(),

      if (showName)
        const Icon(
          Icons.arrow_right_sharp,
          //color: Colors.white,
        ),
      if (showName)
        TextButton.icon(
          onPressed: () {
            if (node case NodeFractal node) {
              ConfigFArea.openDialog(node);
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
              //color: Colors.white,
            ),
          ),
          label: FTitle(
            node!,
            style: FractalSubState.textStyle,
          ),
        ),
      if (widget.title != null ||
          FractalScaffold.alignBar != MainAxisAlignment.center)
        Expanded(
          child: Center(
              child: widget
                  .title /* ?? ((w < maxWide) ? FractalScaffold.logo : null)*/),
        ),
      /*
      if (w > 650 && UserFractal.active.value != null)
        const NotificationsTool(),
      */
      ...widget.menu,
      if (isWide) const FMem(),
      for (var b in menu) b(),
      /*
      if (w > 600 && UserFractal.active.value != null)
        const NotificationsTool(key: Key('fNotifications')),
      */
      // User name if signed
      //if(showName)
      if (UserFractal.active.value case UserFractal user
          when (isWide && !onRight))
        TextButton(
          onPressed: () {
            FractalLayoutState.active.go(user);
          },
          onLongPress: () {
            if (node case NodeFractal node) {
              ConfigFArea.openDialog(node);
            }
          },
          style: const ButtonStyle(
            padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
          child: FractalScaffold.logo ??
              FTitle(
                user,
              ),
        ),

      if (FractalScaffold.rightBar case Widget rightBar)
        rightBar
      /*
      else if (UserFractal.active.value == null && !app.isGated)
        ElevatedButton(
          onPressed: () {
            context.go('/auth');
            /*
            setState(() {
              onRight = !onRight;
            });
            */
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
        )*/
      else if (UserFractal.active.value case UserFractal user)
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
          icon: !onRight && user.image != null
              ? FCircle(
                  size: 40,
                  FractalImage(
                    user.image!,
                    fit: BoxFit.fill,
                  ),
                )
              : Icon(
                  Icons.person,
                  color: theme.primaryColor,
                ),
        )
      else
        IconButton(
          onPressed: () {
            context.go('/auth');
          },
          icon: Icon(
            Icons.lock_person_outlined,
            color: theme.primaryColor,
          ),
        ),

      const SizedBox(width: 4),
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
