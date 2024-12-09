import 'dart:convert';

import 'package:fractal_layout/widget.dart';

import '../index.dart';
import '../tools/export.dart';

class FTableCatalog extends StatefulWidget {
  final CatalogFractal fractal;
  const FTableCatalog(this.fractal, {super.key});

  @override
  State<FTableCatalog> createState() => _FTableCatalogState();
}

class _FTableCatalogState extends State<FTableCatalog> {
  String sortBy = 'createdAt';
  bool desc = true;

  /*
  Map<int, TableColumnWidth> get widths {
    final Map<int, TableColumnWidth> ws = {};
    if (widget.fractal.source case NodeCtrl ctrl) {
      for (int i = 0; i < ctrl.attributes.length; i++) {
        final attr = ctrl.attributes[i];
        ws[i] = switch (attr.format) {
          'INTEGER' => const FixedColumnWidth(90),
          _ => const FlexColumnWidth(),
        };
      }
    }
    return ws;
  }
  */

  Map<int, TableColumnWidth> get widths {
    final Map<int, TableColumnWidth> ws = {};
    for (int i = 0; i < heads.length; i++) {
      final head = heads[i];
      ws[i] = head.width > 0
          ? FixedColumnWidth(head.width * 1)
          : const FlexColumnWidth();
    }
    return ws;
  }

  late final ctrl = widget.fractal.source as NodeCtrl;

  Iterable<String> get attrs {
    if (widget.fractal['attrs'] case String pAttrs) {
      return pAttrs.split(',');
    }

    return ctrl.allAttributes.values.map((a) => a.name);
  }

  late var heads = <HeadF>[
    if (widget.fractal['attrs'] case String pAttrs)
      ...pAttrs.split(',').map((a) {
        final attr = ctrl.allAttributes[a];
        return HeadF(
          name: a,
          width: switch (attr?.format) {
            'INTEGER' => 90,
            _ => 0,
          },
        );
      })
    else
      for (var attr in ctrl.allAttributes.values)
        HeadF(
          name: attr.name,
          width: switch (attr.format) {
            'INTEGER' => 90,
            _ => 0,
          },
        ),
    //HeadF(name: 'updated', width: 190),
  ];

  int trySort(Fractal fa, Fractal fb) {
    final a = fa[sortBy], b = fb[sortBy];

    return switch (a) {
          num i => i.compareTo(b as num),
          String str => str.compareTo(b as String),
          _ => 0,
        } *
        (desc ? -1 : 1);
  }

  List<Fractal> get sorted => widget.fractal.list
    ..sort(
      trySort,
    );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: FractalPad.of(context).pad,
          scrollDirection: Axis.vertical,
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 999,
                ),
                child: Table(
                  border: TableBorder.all(
                    color: Colors.grey.shade200,
                  ),
                  columnWidths: widths,
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    header,
                    ...sorted.map((t) {
                      t.preload();
                      /*
          final dateStatus = DateTime.fromMillisecondsSinceEpoch(
            (status?.createdAt ?? 0) * 1000,
          ).toLocal();

          final dateCreated = DateTime.fromMillisecondsSinceEpoch(
            t.createdAt * 1000,
          ).toLocal();
          */

                      return TableRow(
                        children: <Widget>[
                          ...heads.map(
                            (head) => TCell(
                              Text(t.represent(head.name)),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 4,
          left: 4,
          height: 48,
          child: Row(
            children: [
              const Spacer(),
              IconButton.filled(
                icon: const Icon(Icons.exit_to_app_rounded),
                tooltip: 'save',
                onPressed: () {
                  final doc = """
${heads.map((head) => head.title).join(',')}
${sorted.map((t) => heads.map(
                            (head) => t.represent(head.name),
                          ).join(',')).join('\n')}
                  """;

                  print(doc);
                  export(
                    utf8.encode(doc),
                    '${widget.fractal.name}.csv',
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  TableRow get header => TableRow(
        decoration: const BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        )),
        children: <Widget>[
          ...heads.map(
            (head) => InkWell(
              onTap: () {
                if (head
                    .name.isNotEmpty /* && sorters.containsKey(head.name)*/) {
                  setState(() {
                    desc = sortBy == head.name ? !desc : true;
                    sortBy = head.name;
                  });
                }
              },
              child: Container(
                width: head.width > 0 ? head.width * 1 : null,
                padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
                child: Row(
                  children: [
                    Text(
                      head.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    if (sortBy == head.name)
                      Icon(desc ? Icons.arrow_drop_down : Icons.arrow_drop_up),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}

class HeadF {
  String? _title;
  String get title =>
      _title ?? "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";

  String name;

  int width;
  HeadF({
    String? title,
    required this.name,
    this.width = 0,
  }) {
    if (title != null) {
      _title = title;
    }
  }
}
