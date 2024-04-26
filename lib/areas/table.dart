import 'package:app_fractal/app_fractal.dart';
import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';

class FTableArea extends StatefulWidget {
  final EventsCtrl ctrl;
  const FTableArea({super.key, required this.ctrl});

  @override
  State<FTableArea> createState() => _FTableAreaState();
}

class _FTableAreaState extends State<FTableArea> {
  static final fields = ['icon', 'name', 'price', 'hash'];

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: Colors.white,
      ),
      columnWidths: widths,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        header,
        TableRow(
          children: <Widget>[
            Container(
              height: 32,
              color: Colors.green,
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Container(
                height: 32,
                width: 32,
                color: Colors.red,
              ),
            ),
            Container(
              height: 64,
              color: Colors.blue,
            ),
          ],
        ),
        TableRow(
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
          children: <Widget>[
            Container(
              height: 64,
              width: 164,
              color: Color.fromARGB(255, 23, 39, 185),
            ),
            Container(
              height: 32,
              color: Colors.yellow,
            ),
            Center(
              child: Container(
                height: 32,
                width: 32,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Map<int, TableColumnWidth> get widths => Map.fromEntries([
        for (int i = 0; i < widget.ctrl.attributes.length; i++)
          MapEntry(i + 1, IntrinsicColumnWidth())
      ]);

  TableRow get header => TableRow(
        decoration: const BoxDecoration(
          color: Colors.grey,
        ),
        children: <Widget>[
          ...widget.ctrl.attributes.map(
            (attr) => Container(
              width: 128,
              padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
              child: Text(
                attr.display,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      );
}
