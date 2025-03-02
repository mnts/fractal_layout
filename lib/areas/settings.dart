import 'package:flutter/material.dart';
import 'package:fractal_layout/index.dart';
import 'package:signed_fractal/models/index.dart';
import 'package:signed_fractal/services/map.dart';

import '../widgets/entry.dart';

class SettingsArea extends StatefulWidget {
  final Rewritable node;
  const SettingsArea({required this.node, super.key});

  @override
  State<SettingsArea> createState() => _SettingsAreaState();
}

class _SettingsAreaState extends State<SettingsArea> {
  MapEvF<WriterFractal> get m => widget.node.m;
  @override
  void initState() {
    m.listen(refresh);
    super.initState();
  }

  @override
  dispose() {
    m.unListen(refresh);
    super.dispose();
  }

  refresh([_]) {
    setState(() {});
  }

  final _nameCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();

  Future<void> submit(String v) async {
    widget.node.write(_nameCtrl.text, _valueCtrl.text);
    _nameCtrl.clear();
    _valueCtrl.clear();
    return;
  }

  static const _decoration = InputDecoration(
    isDense: true,
    fillColor: Colors.transparent,
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 30,
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: TextFormField(
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  controller: _nameCtrl,
                  scrollPadding: EdgeInsets.zero,
                  decoration: const InputDecoration(
                    hintText: 'key',
                    isDense: true,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onFieldSubmitted: submit,
                ),
              ),
              const Text(': '),
              Expanded(
                child: TextFormField(
                  maxLines: 1,
                  scrollPadding: EdgeInsets.zero,
                  decoration: const InputDecoration(
                    hintText: 'value',
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  controller: _valueCtrl,
                  onFieldSubmitted: submit,
                ),
              ),
            ],
          ),
        ),
        for (final entry in m.map.entries)
          FractalEntry(
            entry: entry,
          ),
      ],
    );
  }
}
