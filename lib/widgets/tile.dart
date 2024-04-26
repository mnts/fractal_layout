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
import '../inputs/date.dart';
import '../inputs/icon.dart';
import '../inputs/nav.dart';
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
    'card',
    'input',
    'select',
    'color',
    'signature',
    'ref',
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
      constraints: BoxConstraints(
        maxWidth: double.tryParse('${widget.fractal['width']}') ?? 384,
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
                      ? make()
                      : Listen(
                          rew!.m,
                          (ctx, child) => make(),
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

  Widget card() {
    final f = widget.fractal;
    final hasVideo = (f is NodeFractal && f.video != null);
    return Listen(
      f,
      (ctx, ch) => InkWell(
        child: Hero(
          tag: f.widgetKey('f'),
          child: Container(
            //onPressed: () {},
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5),
            ),
            constraints: BoxConstraints(
              maxHeight: double.tryParse('${f['height']}') ?? 200,
              //maxWidth: 250,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    child: FIcon(f),
                    onTap: () {
                      if (f case NodeFractal node) {
                        FractalLayoutState.active.go(node);
                      }
                    },
                  ),
                ),
                if (hasVideo)
                  Center(
                    child: IconButton.filled(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey.shade700.withAlpha(180),
                        ),
                      ),
                      onPressed: () {
                        FractalLayoutState.active.go(f);
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                      ),
                    ),
                  ),
                /*
          if (widget.trailing != null)
            Positioned(
              top: 2,
              right: 2,
              child: widget.trailing!,
            ),
            */
                if (f is NodeFractal && f['price'] != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 2,
                        bottom: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${f['price']}€',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(
                            180,
                            120,
                            20,
                            1,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (f case NodeFractal node)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 4,
                          sigmaY: 4,
                        ),
                        child: Container(
                          color: Colors.white.withAlpha(100),
                          padding: const EdgeInsets.all(2),
                          alignment: Alignment.center,
                          child: Column(children: [
                            if (node.description != null)
                              Text(
                                node.description ?? '',
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 12,
                                  height: 1,
                                ),
                              ),
                            tile(f),
                          ]),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        onLongPress: () {
          if (f is NodeFractal) {
            ConfigFArea.dialog(f);
          }
        },
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          } else if (f.runtimeType == NodeFractal) {
            ConfigFArea.dialog(f as NodeFractal);
          } else if (f case NodeFractal node) {
            FractalLayoutState.active.go(node);
          }
        },
      ),
    );
  }

  /*
  Widget tile(Fractal f) {
    return HoverOver(
      builder: (h) => FractalMovable(
        event: f,
        child: FTitle(
          f,
          style: TextStyle(
            color: h ? Colors.black : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            height: 1.6,
          ),
        ),
      ),
    );
  }
  */

  Widget make() {
    final f = widget.fractal as NodeFractal;
    return switch (f.m['widget']?.content) {
      'select' => FractalPick(
          '${f['options']}',
          builder: (fOptions) => switch (f) {
            NodeFractal node => FractalSelect(
                fractal: node,
                trailing: widget.trailing,
              ),
          },
        ),
      'card' => card(),
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

    final ic = f.m['icon']?.content;
    final isCheck = ic == 'check';
    final icon = ic == '0'
        ? null
        : SizedBox.square(
            dimension: 38,
            child: isCheck ? check() : f.icon,
          );

    return ListTile(
      leading: icon,
      //.minLeadingWidth: 20,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      title: Row(children: [
        Expanded(
            child: switch (f['widget']) {
          'input' || 'name' || 'number' => FractalInput(
              fractal: f,
            ),
          'date' => FInputDate(f),
          'ref' => FInputNav(f),
          _ => FTitle(f),
        }),
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
