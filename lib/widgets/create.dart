import 'dart:ui';

import 'package:app_fractal/index.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:signed_fractal/sys.dart';

import '../index.dart';
import '../inputs/input.dart';
import 'tile.dart';

class CreateNodeF extends StatefulWidget {
  final Function(NodeFractal)? onCreate;
  final NodeFractal Function(NodeCtrl)? beforeCreate;
  final NodeFractal? to;
  final NodeFractal? extend;
  final NodeCtrl? ctrl;

  const CreateNodeF({
    super.key,
    this.ctrl,
    this.to,
    this.extend,
    this.onCreate,
    this.beforeCreate,
  });

  @override
  State<CreateNodeF> createState() => _NewNodeFState();
}

class _NewNodeFState extends State<CreateNodeF> {
  ImageF? image;

  late NodeCtrl ctrl = widget.ctrl ?? NodeFractal.controller;

  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _labelCtrl = TextEditingController();
  final _labelFocus = FocusNode();

  late final _orderTip = SuperTooltipController();

  var rew = makeRew();
  static NodeFractal makeRew() {
    final re = NodeFractal(name: 'create')..doHash();
    return re;
  }

  Rewritable? filterRew;

  @override
  void initState() {
    _nameCtrl.addListener(() {});
    _labelFocus.addListener(() {
      formatLabel();
    });
    _labelFocus.requestFocus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Watch<Fractal?>(
        widget.to,
        (ctx, child) => Form(
              child: Watch<Rewritable?>(
                rew,
                (ctx, child) => Listen(
                  rew,
                  (ctx, child) => ListView(
                      //shrinkWrap: true,
                      //physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(8, 16, 4, 16),
                      children: [
                        if (widget.extend != null) FractalTile(widget.extend!),
                        if (image != null)
                          FractalImage(
                            image!,
                            key: Key(
                              'img@${image.hashCode}',
                            ),
                          ),
                        /*
                      TextFormField(
                        controller: _labelCtrl,
                        focusNode: _labelFocus,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          label: Text('Label'),
                          hintText: '',
                          contentPadding: EdgeInsets.all(2),
                        ),
                        onTapOutside: formatLabel,
                        onEditingComplete: formatLabel,
                        onSaved: formatLabel,
                        onFieldSubmitted: (v) {
                          formatLabel();
                        },
                      ),
                      */
                        TextFormField(
                          controller: _nameCtrl,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: (widget.extend == null)
                                ? SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: ctrl.icon.widget,
                                  )
                                : null,
                            hintText: 'Short name',
                            contentPadding: EdgeInsets.all(2),
                          ),
                          onTapOutside: format,
                          onFieldSubmitted: (v) {
                            submit();
                          },
                        ),
                        if (widget.to != null)
                          Row(children: [
                            const Text('into'),
                            Expanded(
                              child: FractalTile(widget.to!),
                            ),
                          ]),
                        ScreensArea(
                          physics: const ClampingScrollPhysics(),
                          node: FSys.ctrlMap[ctrl.name]!,
                          builder: builder,
                          filter: (f) => switch (f) {
                            Attr a => filter(a),
                            _ => false,
                          },
                          //expand: exp,
                        ),
                        if (ctrl is UserCtrl)
                          TextFormField(
                            controller: _passCtrl,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.lock),
                              hintText: 'Password',
                              contentPadding: EdgeInsets.all(2),
                            ),
                            onTapOutside: format,
                            onFieldSubmitted: (v) {
                              submit();
                            },
                          ),
                        Row(
                          children: [
                            const Spacer(),
                            IconButton(
                              onPressed: () async {
                                final img = await FractalImage.pick();
                                if (img != null) {
                                  setState(() {
                                    image = (img);
                                  });
                                }
                              },
                              icon: const Icon(Icons.image),
                            ),
                            IconButton.filled(
                              onPressed: submit,
                              icon: const Icon(Icons.task_alt),
                            )
                          ],
                        ),
                      ]),
                ),
              ),
            ));
  }

  Widget builder(EventFractal f) => switch (f) {
        Attr a when a.name == 'filter' => rew['source'] is String
            ? Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey.shade200.withAlpha(100),
                child: Watch(
                  filterRew,
                  (ctx, ch) => ScreensArea(
                    physics: const ClampingScrollPhysics(),
                    node: FSys.ctrlMap[rew['source']]!,
                    builder: builder,
                    filter: (f) => switch (f) {
                      Attr a => a.isIndex &&
                          ![
                            'order',
                            'source',
                            'filter',
                          ].contains(a.name),
                      _ => true,
                    },
                    //expand: exp,
                  ),
                ),
              )
            : const SizedBox(),
        Attr a when a.name == 'source' => FractalSelect(
            fractal: FSys.ctrls,
            onSelected: (f) {
              if (f is NodeFractal) rew.write('source', f.name);
              setState(() {
                filterRew = makeRew();
              });
            }),
        Attr a when a.name == 'order' => _orderButton,
        _ => FractalTile(f),
      };

  bool filter(Attr attr) => !attr.name.contains(RegExp(
        r'^(id|name|hash|owner|.*_at|extend|sig|pubkey)$',
      ));

  bool desc = true;
  String by = '';

  Widget orderBuilder(EventFractal f) => switch (f) {
        Attr a => InkWell(
            onTap: () {
              setState(() {
                by = a.name;
              });
              _orderTip.hideTooltip();
            },
            child: FTitle(f),
          ),
        _ => const SizedBox(),
      };

  Widget get _orderButton {
    if (rew['source'] case String s) {
      return FractalTooltip(
        controller: _orderTip,
        content: Container(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 500,
            minHeight: 100,
          ),
          child: ScreensArea(
            physics: const ClampingScrollPhysics(),
            node: FSys.ctrlMap[rew['source']]!,
            builder: orderBuilder,
            filter: (f) => switch (f) {
              Attr a => a.isIndex,
              _ => false,
            },
            //expand: exp,
          ),
        ),
        child: ListTile(
          leading: InkWell(
            onTap: () {
              setState(() {
                desc = !desc;
              });
            },
            child: Icon(
              desc ? Icons.arrow_downward : Icons.arrow_upward_rounded,
            ),
          ),
          title: InkWell(
            onTap: () {
              _orderTip.showTooltip();
            },
            child: Text(by.isEmpty ? 'Order' : by),
          ),
        ),

        /*
         Row(
          children: [
            IconButton(
              onPressed: () {
                final order = {
                  'order': {
                    //catalog!.order.keys.first: !desc,
                  }
                };
              },
              icon: Icon(
                desc ? Icons.arrow_downward : Icons.arrow_upward,
              ),
            ),
            //FSys.ctrlMap[rew['source']]!
            FractalPick(
              s,
              builder: (f) => f is NodeFractal
                  ? DropdownButton<String>(
                      //value: catalog!.order.keys.first,
                      underline: Container(),
                      borderRadius: BorderRadius.circular(4),
                      icon: const Icon(Icons.sort_by_alpha_rounded),
                      elevation: 16,
                      onChanged: (String? value) {
                        /*
                _make({
                  'order': {value: desc}
                });
                */
                      },
                      items: [
                        const DropdownMenuItem<String>(
                          value: '',
                          child: Text('insertion'),
                        ),
                        ...f.sub.values.map<DropdownMenuItem<String>>((a) {
                          return DropdownMenuItem<String>(
                            value: a.name,
                            child: Text(a.display),
                          );
                        })
                      ],
                    )
                  : const SizedBox(),
            ),
          ],
        ),
        */
      );
    }
    return const SizedBox();
  }

  formatLabel([_]) {
    if (_nameCtrl.text.isEmpty) {
      _nameCtrl.text = _labelCtrl.text;
      format();
    }
  }

  format([_]) {
    _nameCtrl.text = formatFName(_nameCtrl.text);
  }

  submit() async {
    format();
    final m = {
      'name': _nameCtrl.text,
      'created_at': unixSeconds,
    };

    final attrs = <String, Attr>{};
    for (var c in [
      ctrl,
      ...ctrl.controllers.where(
        (ctrl) => ctrl.runtimeType != EventsCtrl,
      ),
    ]) {
      for (var attr in c.attributes) {
        attrs[attr.name] = attr;
      }
    }

    rew.m.list.whereType<WriterFractal>().forEach((post) {
      final attr = attrs[post.attr];
      m[post.attr] = attr?.fromString(post.content) ?? post.content;
    });

    if (rew['source'] case String s) {
      m['source'] = s;
      final ctrl = FractalCtrl.map[s]!;
      if (by.isNotEmpty) {
        m['order'] = {by: desc};
      }
      if (filterRew != null) {
        final filter = m['filter'] = <String, dynamic>{};
        filterRew!.m.list.whereType<WriterFractal>().forEach((post) {
          final attr = ctrl.allAttributes[post.attr]!;
          if (post.content.contains('-')) {
            final [from, to] = post.content.split('-');
            if (attr.format == 'INTEGER') {
              filter[post.attr] = (attr.name.contains('_at'))
                  ? {
                      'gt': DateTime.parse(
                            from.trim(),
                          ).millisecondsSinceEpoch ~/
                          1000,
                      'lt': DateTime.parse(
                            to.trim(),
                          ).millisecondsSinceEpoch ~/
                          1000,
                    }
                  : {
                      'gt': int.parse(from),
                      'lt': int.parse(to),
                    };
            } else if (attr.format == 'REAL') {
              filter[post.attr] = {
                'gt': double.parse(from),
                'lt': double.parse(to),
              };
            }
          } else {
            filter[post.attr] = attr.fromString(post.content);
          }
        });
      }
    }

    if (widget.extend?.hash case String h) {
      m['extend'] = h;
    }

    if (widget.to?.hash case String h) {
      m['to'] = h;
    }

    if (ctrl is UserCtrl) {
      m['password'] = _passCtrl.text;
    }

    if (UserFractal.active.value?.id case int id) m['owner'] = id;

    final node = widget.beforeCreate?.call(ctrl) ?? await ctrl.put(m);

    await node.synch();
    //screen.write('title', _labelCtrl.text);
    widget.onCreate?.call(node) ?? Navigator.pop(context);
    if (node is CatalogFractal || node is UserFractal) {
      FractalLayoutState.active.go(node);
    } else {
      ConfigFArea.dialog(node);
    }
  }
}
