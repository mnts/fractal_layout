import 'package:fractal_layout/index.dart';

import '../widget.dart';

class ConfigFArea<T extends EventFractal> extends FractalWidget<T> {
  ConfigFArea(super.f, {super.key});

  static openDialog(ExtendableF fractal) {
    showDialog(
      context: FractalScaffoldState.active.context,
      builder: (ctx) => FDialog(
        width: 480,
        height: 640,
        child: ConfigFArea(fractal),
      ),
    );
  }

  static NodeFractal? designNode;

  ExtendableF get fractal => f as ExtendableF;

  /*
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (designNode == null) {
        NetworkFractal.request(
          '${AppFractal.active['designer']}',
        ).then((node) async {
          switch (node) {
            case NodeFractal node:
              await node.preload('node');
              setState(() {
                designNode = node;
              });
          }
        });
      }
    });
    super.initState();
  }
  */

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: DefaultTabController(
        initialIndex: 0,
        length: 5,
        child: Watch<Fractal?>(
          fractal,
          (ctx, child) => Stack(
            children: [
              Positioned(
                top: 56,
                left: 0,
                right: 0,
                bottom: 56,
                child: TabBarView(
                  children: <Widget>[
                    SetupArea(fractal),
                    /*
                      if (currentScreen case NodeFractal node)
                        FSortable<EventFractal>(
                          sorted: node.sorted,
                          cb: node.sort,
                          builder: (event) => MessageField(
                            message: event,
                          ),
                        )
                      else
                        Container(),
                        */

                    //FractalPick(),

                    if (fractal case NodeFractal node)
                      Stack(
                        children: [
                          Positioned.fill(
                            child: ScreensArea(
                              node: node,
                              onTap: (f) {
                                Navigator.of(context).pop();
                                ConfigFArea.openDialog(fractal);
                              },
                            ),
                          ),
                          if (fractal.to case Rewritable rew)
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: IconButton.filled(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ConfigFArea.openDialog(fractal);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                ),
                              ),
                            ),
                          if (fractal case NodeFractal node)
                            Positioned(
                              bottom: 4,
                              left: 4,
                              child: IconButton.filled(
                                onPressed: () {
                                  FractalSubState.modal(
                                    to: node,
                                  );
                                },
                                icon: const Icon(
                                  Icons.add,
                                ),
                              ),
                            )
                        ],
                      ),
                    /*
                    ListView(
                      children: [
                        const ListTile(
                          title: Text('Who can see it'),
                          subtitle: SelectableText('Everyone'),
                        ),
                        const ListTile(
                          title: Text('Who can interact'),
                          subtitle: SelectableText('Authenticated'),
                        ),
                        const ListTile(
                          title: Text('Who can post into'),
                          subtitle: SelectableText('Approved'),
                        ),
                        ListTile(
                          title: const Text(
                            'Who can assign privileges',
                          ),
                          subtitle: RichText(
                            text: TextSpan(children: [
                              const WidgetSpan(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                              ),
                              TextSpan(
                                text: 'Joe',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                              const TextSpan(text: '  '),
                              const WidgetSpan(
                                child: Icon(
                                  Icons.group,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                              ),
                              TextSpan(
                                text: 'Receptionists',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ]),
                          ),
                        ),
                        ListTile(
                          title: Text('Who can update'),
                          subtitle: SelectableText('Owner'),
                        ),
                        ListTile(
                          title: Text('Managers'),
                          subtitle: RichText(
                            text: TextSpan(children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                              ),
                              TextSpan(
                                text: 'Mantas',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(text: '  '),
                              WidgetSpan(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 18,
                                ),Theme.of(context)
                              ),
                              TextSpan(
                                text: 'Elon',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ]),
                          ),
                        ),
                        ListTile(
                          title: Text('What items can go inside'),
                          subtitle: SelectableText('Screen, Node, Post'),
                        ),
                      ],
                    ),
                    */
                    if (fractal case NodeFractal node)
                      StreamArea(
                        key: fractal.widgetKey(
                          'stream',
                        ),
                        fractal: node,
                      ),
                    //if (fractal case Rewritable node)

                    if (fractal case Rewritable rewF)
                      SettingsArea(
                        node: rewF,
                      )
                  ],
                ),
              ),
              if (fractal case NodeFractal node)
                Positioned(
                  height: 56,
                  top: 0,
                  left: 0,
                  right: 0,
                  child: FRenamable(node),
                ),
              Positioned(
                height: 56,
                bottom: 0,
                left: 0,
                right: 0,
                child: Theme(
                  data: theme.copyWith(
                    tabBarTheme: theme.tabBarTheme.copyWith(
                      tabAlignment: TabAlignment.fill,
                      dividerHeight: 0,
                    ),
                  ),
                  child: TabBar(
                    tabs: <Widget>[
                      if (fractal is Rewritable)
                        Tab(
                          icon: Icon(Icons.settings),
                        ),
                      if (fractal is NodeFractal)
                        Tab(
                          icon: Icon(Icons.design_services_outlined),
                        ),
                      if (fractal is NodeFractal)
                        Tab(
                          icon: Icon(Icons.menu),
                        ),
                      //Tab(icon: Icon(Icons.lock_person_outlined)),
                      //Tab(icon: Icon(Icons.bookmarks)),
                      if (fractal is NodeFractal)
                        Tab(
                          icon: Icon(Icons.chat_outlined),
                        ),
                      Tab(
                        icon: Icon(Icons.list_alt_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
