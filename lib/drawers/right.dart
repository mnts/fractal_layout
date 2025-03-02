import 'dart:ui';

import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/scaffold.dart';
import 'package:fractal_layout/widget.dart';
import 'package:go_router/go_router.dart';

import '../views/thing.dart';

class FRightDrawer extends StatefulWidget {
  const FRightDrawer({super.key});

  @override
  State<FRightDrawer> createState() => _FRightDrawerState();
}

class _FRightDrawerState extends State<FRightDrawer> {
  final userSearchCtrl = TextEditingController();
  final userSearch = Frac<String>('');

  @override
  void initState() {
    userSearchCtrl.addListener(() {
      userSearch.value = userSearchCtrl.text;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hash = '${AppFractal.active['layout_right'] ?? ''}';
    final scaffold = FractalScaffoldState.active;
    final app = context.read<AppFractal>();
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        if (FractalScaffoldState.isMobile) const StatusPad(),
        (UserFractal.active.value == null)
            ? Container(
                padding: scaffold.padding,
                child: const AuthArea(),
              )
            : hash.isNotEmpty
                ? Container(
                    padding: scaffold.padding,
                    child: FractalPick(
                      hash,
                      builder: (f) => FractalThing(f),
                    ),
                  )
                : FractalUsers(
                    padding: scaffold.padding,
                    search: userSearch,
                    node: FractalLayoutState.active.sequence.value.last,
                  ),
        Positioned(
          top: scaffold.statusPad,
          left: 0,
          right: 0,
          child: SizedBox(
            height: FractalScaffoldState.barHeight,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 0,
                  sigmaY: 2,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: FractalScaffoldState.active.decoration,
                  child: UserFractal.active.value != null
                      ? FractalUser(
                          UserFractal.active.value!,
                          onTap: () {
                            FractalLayoutState.active.go(
                              UserFractal.active.value,
                            );
                            //scaffold.closeDrawers();
                          },
                        )
                      : Expanded(
                          child: Center(
                            child: Text(
                              'Authorization',
                              style: TextStyle(
                                color: app.bw,
                                fontSize: 26,
                              ),
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
            height: 48,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 0,
                  sigmaY: 2,
                ),
                child: Container(
                  color: AppFractal.active.wb.withAlpha(128),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*
                      if (isWide)
                        IconButton(
                          onPressed: () {
                            FractalScaffoldState.active.setState(() {
                              layout.rightLocked = !layout.rightLocked;
                            });
                          },
                          icon: Icon(
                            layout.rightLocked
                                ? Icons.menu
                                : Icons.menu_open_sharp,
                          ),
                        ),
                        */
                      Expanded(
                        child: TextFormField(
                          controller: userSearchCtrl,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(4),
                            hintText: 'Search',
                            border: InputBorder.none,
                            //prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      /*
                      if (UserFractal.active.value != null) buildPlus(),
                      lightMode,
                      */
                      if (UserFractal.active.value != null)
                        IconButton(
                          onPressed: () {
                            UserFractal.logOut();
                            context.go('/');
                            scaffold.closeDrawers();
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
  }

  Widget buildPlus() {
    return /*FractalTooltip(
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
      child: */
        IconButton(
      onPressed: () {
        FractalSubState.modal(
          to: UserFractal.active.value,
          ctrl: UserFractal.controller,
        );
      },
      icon: const Icon(
        Icons.person_add,
      ),
    );
  }

  Widget get lightMode {
    final app = FractalLayoutState.active.app;
    return IconButton(
      onPressed: () {
        FractalLayoutState.active.setState(() {
          app.dark = !app.dark;
          FractalLayoutState.active.theme;
        });
      },
      icon: Icon(app.dark ? Icons.dark_mode : Icons.light_mode),
    );
  }
}
