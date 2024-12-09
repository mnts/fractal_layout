import 'dart:convert';
import 'package:fractal_layout/widget.dart';
import '../index.dart';

class FractalCatalog<T extends CatalogFractal> extends FNodeWidget<T> {
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
  Widget scaffold() => Watch<CatalogFractal>(
        f,
        (ctx, ch) => FractalScaffold(
          node: f,
          title: Row(
            children: [
              const SizedBox(width: 4),
              _viewButton,
              const Spacer(),
            ],
          ),
          body: area(),
        ),
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
    if (rewritable == null) return _area(f);

    final fu = CatalogFractal.controller.put({
      'filter': {
        ...f.filter,
        'to': rewritable!.hash,
        if (rewritable!['ext_filter'] case String flt) ...jsonDecode(flt),
      },
      'mode': f.mode,
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

  _area(CatalogFractal c) => Listen(
        view,
        (ctx, ch) => switch (view.value) {
          'csv' => FTableCatalog(c),
          _ => FGridArea(
              key: ObjectKey(c.hash),
              [c],
            ),
        },
      );
}
