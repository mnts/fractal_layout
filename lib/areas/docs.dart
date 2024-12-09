import 'package:app_fractal/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractal/utils/random.dart';
import 'package:fractal_flutter/index.dart';
import '../index.dart';
import '../views/thing.dart';

class DocsArea extends StatefulWidget {
  final NodeFractal node;
  const DocsArea({required this.node, super.key});

  static NodeFractal? active;

  @override
  State<DocsArea> createState() => _DocsAreaState();
}

class _DocsAreaState extends State<DocsArea>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setup();
    });
  }

  NodeFractal? node;

  setup() {
    final rew = context.read<Rewritable?>();
    if (rew == null) return;
    NodeFractal.controller.put({
      'hash': '${rew.hash}-${widget.node.name}',
      'name': widget.node.name,
      'owner': rew.owner?.hash ?? '',
      'created_at': 4,
      'extend': widget.node.hash,
    }).then((n) {
      DocsArea.active = node = n;
      refresh();
    });
  }

  refresh([_]) {
    setState(() {});
  }

  final newCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final scaffold = FractalScaffoldState.active;
    if (node == null) return const CupertinoActivityIndicator();
    return Listen(
      node!,
      (ctx, child) => Listen(
        node!.sorted,
        (ctx, ch) => DefaultTabController(
          length: 1 + node!.sorted.value.length,
          child: Theme(
            data: ThemeData(
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Colors.white,
                    displayColor: Colors.white,
                  ),
              tabBarTheme: TabBarTheme(
                unselectedLabelColor: Colors.black54,
                indicatorColor: scaffold.color,
                labelColor: Colors.black,
                tabAlignment: TabAlignment.start,
                dividerHeight: 0,
              ),
            ),
            child: Stack(children: [
              Positioned.fill(
                child: FractalLayer(
                  pad: const EdgeInsets.only(top: 32),
                  child: TabBarView(
                    children: [
                      Builder(
                        builder: (ctx) => ListView(
                          padding: FractalPad.of(ctx).pad,
                          children: [
                            Center(
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 256,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextFormField(
                                  controller: newCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Enter document name',
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  onFieldSubmitted: createDoc,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            const Center(
                              child: Text(
                                'or choose from templates:',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                width: 256,
                                child: FractalPick(
                                  '${widget.node['templates']}',
                                  builder: (f) => switch (f) {
                                    NodeFractal templatesF => ScreensArea(
                                        physics: const ClampingScrollPhysics(),
                                        onTap: (f) {
                                          var title = newCtrl.text;
                                          if (title.isEmpty) title = f.display;
                                          createDoc(title, f);
                                        },
                                        node: templatesF,
                                      ),
                                    _ => FractalTile(f),
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...node!.sorted.value.map(
                        (f) => FractalThing(f),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: FractalPad.of(context).pad.top,
                left: 0,
                right: 0,
                height: 32,
                child: Container(
                  color: const Color.fromARGB(200, 200, 200, 200),
                  child: Row(
                    children: [
                      Expanded(
                        child: TabBar(
                          padding: const EdgeInsets.only(top: 7),
                          indicatorPadding: const EdgeInsets.all(0),
                          isScrollable: true,
                          tabs: <Widget>[
                            const Tab(
                              icon: Icon(Icons.add),
                            ),
                            ...node!.sorted.value.map(
                              (f) => Tab(
                                  text: switch (f) {
                                NodeFractal node => node.display,
                                _ => f.hash
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
      preload: 'node',
    );
  }

  createDoc(String str, [EventFractal? extend]) {
    var name = formatFName(str);
    final docF = node!.sub[name];
    final rand = getRandomString(3);
    name = name + '_' + rand;

    final m = {
      'name': name,
      'to': node!.hash,
      'owner': node!.owner?.hash,
    };

    if (extend != null) m['extend'] = extend.hash;

    final doc = NodeFractal.fromMap(m)..synch();

    node!.sorted.order(doc, 0);
    node!.sort();
    newCtrl.clear();
    refresh();
  }
}
