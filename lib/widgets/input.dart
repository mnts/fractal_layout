import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fractal/c.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:super_tooltip/super_tooltip.dart';

import 'tooltip.dart';

class FractalInput extends StatefulWidget {
  final NodeFractal fractal;
  final Widget? trailing;
  final Widget? leading;
  const FractalInput({
    required this.fractal,
    super.key,
    this.trailing,
    this.leading,
  });

  static final types = <String, TextInputType>{
    'date': TextInputType.datetime,
    'email': TextInputType.emailAddress,
    'name': TextInputType.name,
    'number': TextInputType.number,
    'none': TextInputType.none,
    'phone': TextInputType.phone,
    'input': TextInputType.text,
    'street': TextInputType.streetAddress,
    'url': TextInputType.url,
    'secret': TextInputType.visiblePassword,
  };

  @override
  State<FractalInput> createState() => _FractalInputState();
}

class _FractalInputState extends State<FractalInput> {
  NodeFractal get f => widget.fractal;
  Rewritable? get rew => context.read<Rewritable?>();

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
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return options.isEmpty ? buildInput(f) : buildOptionsInput(f, options);
  }

  late final _tipCtrl = FTipCtrl();
  Widget buildOptionsInput(NodeFractal f, Iterable<String> options) {
    return FractalTooltip(
      controller: _tipCtrl,
      width: 100,
      height: 200,
      direction: TooltipDirection.right,
      content: ListView(children: [
        ...options.map(
          (opt) => InkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              child: Text(opt, style: const TextStyle(fontSize: 18)),
            ),
            onTap: () {
              _tipCtrl.hideTooltip();
              ctrl.text = opt;
              rew!.write(f.name, opt);
            },
          ),
        ),
      ]),
      child: buildInput(f),
    );
  }

  late final ctrl = TextEditingController(text: value);

  Widget buildInput(NodeFractal f) {
    final type = FractalInput.types[f['widget']];
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: TextFormField(
        controller: ctrl,
        style: const TextStyle(
          fontSize: 20,
        ),
        keyboardType: type,
        maxLines: 1,
        obscureText: type == TextInputType.visiblePassword,
        decoration: InputDecoration(
          labelText: f.title.value?.content ?? f.name,
          prefixIcon: widget.leading,
          /* ??
              SizedBox.square(
                dimension: 62,
                child: FIcon(f),
              )*/

          contentPadding: const EdgeInsets.all(2),
          isDense: true,
          suffixIcon: widget.trailing,
        ),
        onTap: () {
          _tipCtrl.showTooltip();
        },
        inputFormatters: switch (type) {
          TextInputType.number => <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
          _ => null,
        },
        onTapOutside: (ev) {
          if (rew != null &&
              value != ctrl.text.trim() &&
              !(value == ' ' && ctrl.text == '')) {
            rew!.write(f.name, ctrl.text);
          }
        },
      ),
    );
  }
}
