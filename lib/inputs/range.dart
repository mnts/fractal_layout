import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal/c.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/widgets/index.dart';
import 'package:signed_fractal/signed_fractal.dart';

class FractalRange extends StatefulWidget {
  final NodeFractal fractal;
  final Widget? trailing;
  final Widget? leading;
  final double? size;
  const FractalRange(
    this.fractal, {
    super.key,
    this.size,
    this.trailing,
    this.leading,
  });

  @override
  State<FractalRange> createState() => _FractalRangeState();
}

class _FractalRangeState extends State<FractalRange> {
  NodeFractal get f => widget.fractal;
  late final rew = context.read<Rewritable?>();
  CatalogFractal? get catalog => context.read<CatalogFractal?>();

  String get value {
    return (rew?.m[widget.fractal.name]?.content ?? '').trim();
  }

  Iterable<String> options = [];

  @override
  void initState() {
    if (f['options'] case String opt) {
      if (EventFractal.isHash(opt)) {
        NetworkFractal.request(opt).then(
          (f) {
            if (f is! NodeFractal) return;
            setState(() {
              options = f.sorted.value.whereType<NodeFractal>().map(
                    (f) => f.name,
                  );
            });
          },
        );
      } else {
        options = Fractal.maps[opt]?.keys ?? FractalC.options[opt] ?? [];
      }
    }

    startCtrl.addListener(refresh);
    endCtrl.addListener(refresh);

    if (rew != null) {
      rew!.m.listen(updateValue);
    }

    super.initState();
  }

  submit([ev]) {
    /*
    if (rew != null &&
        value != ctrl.text.trim() &&
        !(value == ' ' && ctrl.text == '')) {
      rew!.write(f.name, ctrl.text);
    }
    */
  }

  @override
  dispose() {
    rew?.m.unListen(updateValue);
    super.dispose();
  }

  updateValue(WriterFractal f) {
    if (f.attr == widget.fractal.name) {
      //ctrl.text = post.content;
    }
  }

  RangeValues _cur = const RangeValues(100, 400);

  late final startCtrl = TextEditingController();
  late final endCtrl = TextEditingController();

  static final inpDec = InputDecoration(
    isDense: true,
    filled: true,
    fillColor: AppFractal.active.wb.withOpacity(0.8),
    contentPadding: const EdgeInsets.symmetric(
      vertical: 2,
      horizontal: 2,
    ),
  );

  final timer = TimedF();

  final focusStart = FocusNode();
  final focusEnd = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: Row(children: [
        FTitle(f),
        const SizedBox(width: 4),
        SizedBox(
          width: 48,
          child: TextFormField(
            focusNode: focusStart,
            controller: startCtrl,
            scrollPadding: const EdgeInsets.all(1),
            maxLines: 1,
            decoration: inpDec,
            //initialValue: '${_cur.start}',
          ),
        ),
        Expanded(
          child: RangeSlider(
            values: _cur,
            min: double.tryParse('${f['min']}') ?? 0,
            max: double.tryParse('${f['max']}') ?? 3000,
            divisions: int.tryParse('${f['div']}'),
            labels: RangeLabels(
              _cur.start.round().toString(),
              _cur.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _cur = values;
                startCtrl.text = '${_cur.start}';
                endCtrl.text = '${_cur.end}';
              });

              refresh();
            },
          ),
        ),
        SizedBox(
          width: 48,
          child: TextFormField(
            focusNode: focusEnd,
            scrollPadding: const EdgeInsets.all(1),
            controller: endCtrl,
            decoration: inpDec,
            maxLines: 1,
            //initialValue: '${_cur.end}',
          ),
        ),
      ]),
    );
  }

  refresh() {
    timer.hold(() {
      if (catalog case CatalogFractal c) {
        final start = double.tryParse(startCtrl.text);
        final end = double.tryParse(endCtrl.text);
        final flt = c.filter[f.name] = {
          if (start != null) 'gte': start,
          if (end != null) 'lte': end,
        };
        _cur = RangeValues(start ?? 0, end ?? 999);
        if (flt.isEmpty) c.filter!.remove(f.name);
        c.refresh();
      }
    }, 90);
  }
}
