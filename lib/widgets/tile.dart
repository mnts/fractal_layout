import 'dart:ui';
import 'package:signature/signature.dart';

import 'package:dartlin/control_flow.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fractal/c.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_flutter/widgets/movable.dart';
import 'package:fractal_layout/widgets/icon.dart';
import 'package:signed_fractal/models/event.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:fractal_flutter/data/icons.dart';
import '../controllers/tiles.dart';
import '../index.dart';
import '../inputs/icon.dart';
import 'color.dart';
import 'title.dart';

class FractalTile extends StatefulWidget {
  final Fractal fractal;
  final Function()? onTap;
  final Widget? trailing;
  final Widget? leading;
  const FractalTile(
    this.fractal, {
    super.key,
    this.onTap,
    this.trailing,
    this.leading,
  });

  static final options = [
    'tile',
    'input',
    'select',
    'color',
    'signature',
    'icon',
    ...FractalInput.types.keys,
  ];

  @override
  State<FractalTile> createState() => _FractalTileState();
}

class _FractalTileState extends State<FractalTile> {
  Rewritable? get rew => context.read<Rewritable?>();
  String get value {
    if (widget.fractal case NodeFractal node) {
      return rew?.m[node.name]?.content ?? '';
    }
    return '';
  }

  @override
  void initState() {
    widget.fractal.preload();
    super.initState();
    //rew?.m.addListener(reload);
  }

  reload([PostFractal? f]) {
    setState(() {});
  }

  @override
  void dispose() {
    //rew?.m.removeListener(reload);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 384,
      ),
      child: switch (widget.fractal) {
        (NodeFractal f) => Listen(
            f,
            (ctx, child) {
              return Listen(
                f.m,
                (ctx, child) => GestureDetector(
                  onLongPress: () {
                    ConfigFArea.dialog(f);
                  },
                  onSecondaryTap: () {
                    ConfigFArea.dialog(f);
                  },
                  child: rew == null
                      ? buildInput()
                      : Listen(
                          rew!.m,
                          (ctx, child) => buildInput(),
                        ),
                ),
              );
            },
          ),
        (PostFractal f) => ListTile(
            minLeadingWidth: 20,
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.zero,
            leading: SizedBox.square(
              dimension: 48,
              child: f.icon,
            ),
            title: Text(f.content),
          ),
        _ => const SizedBox(),
      },
    );
  }

  Widget buildInput() {
    final f = widget.fractal as NodeFractal;
    return switch (f.m['widget']?.content) {
      'select' => FractalSelect(
          fractal: f,
          trailing: widget.trailing,
        ),
      'button' => FractalButton(
          node: f,
        ),
      'color' => FractalColor(
          node: f,
          trailing: widget.trailing,
        ),
      'signature' => FractalSignature(
          node: f,
          trailing: widget.trailing,
        ),
      'icon' => IconFPicker(
          initialValue: value,
          icon: Icon(Icons.apps),
          title: f.name,
          labelText: f.name,
          enableSearch: true,
          searchHint: 'Search icon',
          iconCollection: MaterialFIcons.mIcons,
          onChanged: (val) {
            if (rew != null && value != val) {
              rew!.write(f.name, val);
            }
          },
          onSaved: (val) => print(val),
        ),
      _ => tile(f),
    };
  }

  Widget tile(NodeFractal f) {
    final ctrl = context.read<TilesCtrl?>();

    final isCheck = f.m['icon']?.content == 'check';
    final icon = SizedBox.square(
      dimension: 38,
      child: isCheck ? check() : f.icon,
    );

    return ListTile(
      leading: icon,
      minLeadingWidth: 20,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      title: Row(children: [
        Expanded(
          child: (FractalInput.types.keys.contains(f['widget']))
              ? FractalInput(
                  fractal: f,
                )
              : FTitle(f),
        ),
        if (ctrl?.noPrice != true && f['price'] != null) Text('${f['price']}€'),
        const SizedBox(width: 4),
      ]),
      onTap: isCheck
          ? toggleCheck
          : widget.onTap ??
              () {
                ConfigFArea.dialog(f);
              },
      trailing: widget.trailing,
    );
  }

  toggleCheck([bool? b]) {
    final node = widget.fractal as NodeFractal;
    if (b == null) {
      final cont = rew!.m[node.name]?.content ?? '';
      b = cont.isEmpty;
    }

    rew!.write(node.name, b ? ' ' : '');
  }

  Widget check() {
    if (widget.fractal is NodeFractal && rew != null) {
      final node = widget.fractal as NodeFractal;
      final cont = rew!.m[node.name]?.content ?? '';
      final si = cont.isNotEmpty;

      if (cont.trim().isEmpty) {
        return Checkbox(
          value: si,
          onChanged: (bool? v) {
            if (v == null && !si && cont.trim().isNotEmpty) return;
            toggleCheck(v);
          },
        );
      }
    }
    return const Icon(Icons.check);
  }

  write() {}
}
