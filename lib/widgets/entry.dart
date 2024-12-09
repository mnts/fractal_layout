import 'package:flutter/material.dart';
import 'package:signed_fractal/models/index.dart';

class FractalEntry extends StatelessWidget {
  final MapEntry<String, WriterFractal> entry;
  //final Function(String val) submit;
  FractalEntry({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('set-${entry.key}'),
      height: 30,
      child: Row(
        children: [
          Container(
            width: 100,
            alignment: Alignment.centerRight,
            child: Tooltip(
              message: entry.key,
              child: Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: TextFormField(
              maxLines: 1,
              scrollPadding: EdgeInsets.zero,
              decoration: const InputDecoration(
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              initialValue: entry.value.content,
              onFieldSubmitted: submit,
            ),
          ),
        ],
      ),
    );
  }

  void submit(String v) {
    final f = entry.value.to;
    if (f case NodeFractal node) {
      node.write(entry.key, v);
    }
  }
}
