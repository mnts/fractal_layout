import 'dart:convert';
import 'package:fractal_layout/widget.dart';
import '../index.dart';

class FractalCatalog extends FNodeWidget {
  FractalCatalog(super.f, {super.key});

  final view = Frac(views[0]);
  //String get view => f.myInteraction.m['view']?.content ?? views[0];
  static const views = ['grid', 'csv'];

  List<Attr> get sorts {
    if (f.source case NodeCtrl ctrl) {
      return [
        ...ctrl.allAttributes.values.where((a) => a.isIndex),
      ];
    }
    return [];
  }

  //CatalogFractal? catalog;
  //bool get desc => catalog?.order.values.every((v) => v) ?? true;

  /*
  @override
  wscaffold() {
    return FutureBuilder(
      future: f.myInteraction.events.whenLoaded,
      builder: (ctx, snap) {
        if (snap.data == null) {
          return const CircularProgressIndicator();
        }

        return Listen(
          f.myInteraction,
          (ctx, ch) {
            if (f.myInteraction['re'] case String cHash) {
              return FractalPick(cHash, builder: (f) {
                catalog = f as CatalogFractal..reMake = _make;
                return scaffold;
              });
            }

            _make({});

            return FractalScaffold(
              node: f,
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          preload: 're',
        );
      },
    );
  }
  */
  @override
  Widget bar() => Row(
        children: [
          const SizedBox(width: 4),
          _viewButton,
          const Spacer(),
        ],
      );

  @override
  Widget scaffold() => FractalScaffold(
        node: f,
        title: bar(),
        body: area(),
      );

  /*
  _make(Map m) {
    final ctrl = CatalogFractal.controller;
    final c = catalog ?? f;
    final map = <String, dynamic>{
      'source': m['source'] ?? c['source'],
      'mode': c['mode'],
      'filter': {
        ...c.filter,
        ...m['filter'] ?? {},
      },
      'order': m['order'] ?? c.order,
      'name': 'catalog',
      'limit': 300,
      //'to': f.myInteraction.hash,
      'type': 'catalog',
    };
    print(map);
    ctrl.put(map).then((c) {
      f.myInteraction.write('re', c.hash);
    });
  }
  */

  Widget get _viewButton => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Listen(
          view,
          (ctx, ch) => DropdownButton<String>(
            value: view.value,
            underline: Container(),
            borderRadius: BorderRadius.circular(4),
            icon: const Icon(Icons.remove_red_eye_outlined),
            elevation: 16,
            onChanged: (String? value) {
              if (value == null) return;
              view.value = value;
              //f.myInteraction.write('view', value);
            },
            items: views.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      );

  @override
  area() {
    //if (rewritable == null)
    return _area(f);

    final fu = CatalogFractal.controller.put({
      'filter': {
        ...f.filter,
        'to': rewritable!.hash,
        if (rewritable!['ext_filter'] case String flt) ...jsonDecode(flt),
      },
      //'mode': f.mode,
      'source': f['source'],
      'owner': rewritable!.owner?.hash ?? '',
      'created_at': 0,
      'extend': f.hash,
    });

    return FractalFuture(
      fu,
      (c) => _area(c),
    );
  }

  List<EventFractal> get list => f.list;

  _area(FilterF c) => Listen(
        view,
        (ctx, ch) => switch (view.value) {
          //'csv' => FTableCatalog(c),
          _ => grid(),
        },
      );

  Widget grid() {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(6),
            child: GridView(
              reverse: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: maxWidth ~/ 192,
                childAspectRatio: 14 / 10,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              //shrinkWrap: false,
              scrollDirection: Axis.vertical,
              padding: FractalPad.of(context).pad,
              children: [
                ...list.map(
                  (f) => tile(f),
                ),
                //removal(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 4,
            left: 4,
            height: 48,
            child: Row(
              children: [
                /*
              if (widget.catalogs[0].source case EventsCtrl c)
                FractalTooltip(
                  controller: tipFilters,
                  direction: TooltipDirection.up,
                  content: FractalAttrs(
                    widget.catalogs[0],
                  ),
                  child: IconButton.filled(
                    icon: const Icon(
                      Icons.filter_alt_outlined,
                    ),
                    onPressed: () async {
                      tipFilters.showTooltip();
                      //camera();
                    },
                  ),
                ),
                */
                const Spacer(),
                if (f.source case NodeCtrl ctrlNode)
                  IconButton.filled(
                    icon: const Icon(Icons.upload_file),
                    onPressed: () async {
                      final img = await FractalImage.pick();
                      if (img == null) return;

                      await img.publish();

                      final ev = await EventFractal.controller.put({
                        'content': img.name,
                        'kind': 2,
                        'to': f.filter['to'] ?? f.hash,
                        'owner': UserFractal.active.value?.hash,
                      });
                      ev.synch();
                    },
                  ),
                if (f.source case NodeCtrl ctrlNode)
                  IconButton.filled(
                    onPressed: modalCreate,
                    icon: const Icon(Icons.add),
                  ),
              ],
            ),
          )
        ],
      );
    });
  }

  void modalCreate({
    NodeFractal? to,
    NodeFractal? extend,
    Function(NodeFractal)? cb,
    NodeCtrl? ctrl,
  }) {
    if (f case NodeFractal node) FractalSubState.modal(to: node);
  }

  late final cardsType = '${f['cards'] ?? ''}';
  Widget tile(Fractal f) => switch (f) {
        NodeFractal f => f.widget(cardsType),
        _ => FractalTile(f),
      };
}
