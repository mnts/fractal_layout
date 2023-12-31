import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/widgets/renamable.dart';

import '../layout.dart';
import '../scaffold.dart';
import '../widgets/tile.dart';
import 'screens.dart';
import 'settings.dart';
import 'setup.dart';
import 'stream.dart';

class ConfigFArea extends StatefulWidget {
  final NodeFractal fractal;
  const ConfigFArea(this.fractal, {super.key});

  static dialog(NodeFractal fractal) {
    showDialog(
      context: FractalScaffoldState.active.context,
      builder: (ctx) {
        return Dialog(
          clipBehavior: Clip.hardEdge,
          backgroundColor: Colors.white.withAlpha(200),
          child: SizedBox(
            width: 480,
            height: 740,
            child: ConfigFArea(fractal),
          ),
        );
      },
    );
  }

  @override
  State<ConfigFArea> createState() => _ConfigFAreaState();
}

//spin cryptography on your own blockchains with AIs
class _ConfigFAreaState extends State<ConfigFArea> {
  NodeFractal get fractal => widget.fractal;

  static NodeFractal? designNode;

  @override
  void initState() {
    if (designNode == null) {
      NodeFractal.flow
          .request(
        '2c1HxP518xkTBoqJqSQmnKqSP5kUa6an6kMDXBQud1zNoqxfy1',
      )
          .then((node) {
        setState(() {
          designNode = node;
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: DefaultTabController(
        initialIndex: 0,
        length: 4,
        child: Watch<Rewritable?>(
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
                    ListView(
                      children: [
                        ...designNode?.sorted.value.map(
                              (subF) => FractalTile(subF),
                            ) ??
                            [],
                      ],
                    ),
                    StreamArea(
                      key: fractal.widgetKey(
                        'stream',
                      ),
                      fractal: fractal,
                    ),
                    //if (fractal case Rewritable node)

                    SettingsArea(
                      node: fractal,
                    )
                  ],
                ),
              ),
              Positioned(
                height: 56,
                top: 0,
                left: 0,
                right: 0,
                child: FRenamable(fractal),
              ),
              const Positioned(
                height: 56,
                bottom: 0,
                left: 0,
                right: 0,
                child: TabBar(
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.settings),
                    ),
                    Tab(
                      icon: Icon(Icons.design_services_outlined),
                    ),
                    //Tab(icon: Icon(Icons.bookmarks)),
                    Tab(
                      icon: Icon(Icons.chat_outlined),
                    ),
                    Tab(
                      icon: Icon(Icons.list_alt_rounded),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
