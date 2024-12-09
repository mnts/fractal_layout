import 'package:flutter/material.dart';

class TCell extends StatelessWidget {
  final Widget child;
  const TCell(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(maxHeight: 64),
        child: child,
      ),
    );
  }
}
