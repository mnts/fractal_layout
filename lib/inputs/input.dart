import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fractal/c.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/extensions/form.dart';
import 'package:fractal_layout/index.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:file_picker/file_picker.dart';

import '../widgets/tooltip.dart';

class FractalInput extends StatefulWidget {
  final NodeFractal fractal;
  final Widget? trailing;
  final Widget? leading;
  final double? size;
  final String? type;
  final Iterable<String> options;

  const FractalInput({
    required this.fractal,
    this.options = const [],
    super.key,
    this.type,
    this.size,
    this.trailing,
    this.leading,
  });

  static final types = <String, TextInputType?>{
    'date': TextInputType.datetime,
    'email': TextInputType.emailAddress,
    'name': TextInputType.name,
    'number': TextInputType.number,
    'none': TextInputType.none,
    'phone': TextInputType.phone,
    'input': TextInputType.text,
    'directory': TextInputType.text,
    'street': TextInputType.streetAddress,
    'url': TextInputType.url,
    'secret': TextInputType.visiblePassword,
    'description': TextInputType.multiline,
  };

  @override
  State<FractalInput> createState() => _FractalInputState();
}

class _FractalInputState extends State<FractalInput> {
  NodeFractal get f => widget.fractal;
  late final rew = form ?? context.read<Rewritable?>();

  Future<String> get value async {
    return ((await form?.getVal(f.name)) ?? rew?.m[f.name]?.content ?? '')
        .trim();
  }

  CatalogFractal? get catalog => context.read<CatalogFractal?>();

  Iterable<String> options = [];

  late NodeFractal? form = FractalNodeIn.of(context)?.find({'form': true});

  @override
  void initState() {
    options = widget.options;

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

    //cb on first frame to get the value
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (rew != null) {
        rew!.m.listen(updateValue);
      }

      ctrl.text = await value;
    });

    focusNode.addListener(() {
      submit();
    });

    super.initState();
  }

  submit([ev]) async {
    if (await value != ctrl.text.trim() &&
        !(await value == ' ' && ctrl.text == '')) {
      form != null
          ? form!.setVal(f.name, ctrl.text)
          : rew?.write(f.name, ctrl.text);
    }
  }

  @override
  dispose() {
    rew?.m.unListen(updateValue);

    super.dispose();
  }

  updateValue(WriterFractal f) {
    if (f.attr == widget.fractal.name) {
      ctrl.text = f.content;
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
      width: 160,
      height: 240,
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
              if (widget.fractal case Attr attr) {
                if (catalog != null) {
                  if (opt.isNotEmpty) {
                    catalog!.filter[f.name] = switch (attr.format) {
                      'INTEGER' => [...options].indexOf(opt),
                      _ => opt,
                    };
                  } else {
                    catalog!.filter.remove(f.name);
                  }
                  catalog!.refresh();
                }
              } else {
                ctrl.text = opt;
                rew!.write(f.name, opt);
              }
              _tipCtrl.hideTooltip();
            },
          ),
        ),
      ]),
      child: buildInput(f),
    );
  }

  final ctrl = TextEditingController(text: '');

  FocusNode focusNode = FocusNode();

  Widget buildInput(NodeFractal f) {
    final typeS = f.resolve('ui') ?? widget.type;
    final type = FractalInput.types[typeS];

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: TextFormField(
        controller: ctrl,
        focusNode: focusNode,
        style: TextStyle(
          fontSize: widget.size ?? 20,
        ),
        keyboardType: type,
        maxLines: /*typeS == 'description' ? 1 : */
            int.tryParse('${f['lines']}') ?? 1,
        expands: typeS == 'description',
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
        onTap: () async {
          if (typeS == 'directory') {
            String? dir = await FilePicker.platform.getDirectoryPath();
            if (dir != null) ctrl.text = dir;
          } else
            _tipCtrl.showTooltip();
        },
        //onFieldSubmitted: submit,
        //onEditingComplete: submit,
        inputFormatters: switch (type) {
          TextInputType.number => <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
          _ => null,
        },
        //onTapOutside: submit,
      ),
    );
  }
}
