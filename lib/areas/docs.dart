import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal/utils/random.dart';
import 'package:fractal_flutter/index.dart';
import '../index.dart';
import 'area.dart';

class DocsArea extends StatefulWidget {
  final NodeFractal node;
  const DocsArea({required this.node, super.key});

  @override
  State<DocsArea> createState() => _DocsAreaState();
}

class _DocsAreaState extends State<DocsArea>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    sorted.listen(refresh);
    widget.node.preload();
  }

  SortedFrac<EventFractal> get sorted => widget.node.sorted;

  refresh([_]) {
    setState(() {});
  }

  final newCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final scaffold = FractalScaffoldState.active;
    return DefaultTabController(
      length: 1 + sorted.value.length,
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
        child: Column(children: [
          Container(
            height: 32,
            color: const Color.fromARGB(255, 31, 16, 16).withAlpha(32),
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
                      ...sorted.value.map(
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
          Expanded(
            child: TabBarView(
              children: [
                ListView(
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
                          '${AppFractal.active['templates']}',
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
                ...widget.node.sorted.value.map(
                  (f) => FractalArea(f),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  createDoc(String str, [EventFractal? extend]) {
    var name = formatFName(str);
    final docF = widget.node.sub[name];
    if (docF != null) {
      final rand = getRandomString(3);
      name = name + '_' + rand;
    }

    final m = {
      'name': name,
      'to': widget.node.hash,
      'owner': widget.node.owner!.hash,
    };

    if (extend != null) m['extend'] = extend.hash;

    final doc = ScreenFractal.fromMap(m)..synch();

    widget.node.sorted.order(doc, 0);
    widget.node.sort();
    newCtrl.clear();
    refresh();
  }
}
