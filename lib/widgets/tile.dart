import 'dart:ui';
import 'package:app_fractal/app.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/views/printable.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:fractal_flutter/data/icons.dart';
import '../controllers/tiles.dart';
import '../index.dart';
import '../inputs/index.dart';
import '../inputs/range.dart';
import '../tiles/ref.dart';

enum FractalTileStyle {
  tile,
  row,
}

class FractalTile extends StatefulWidget {
  final Fractal fractal;
  final Function()? onTap;
  final Widget? trailing;
  final Widget? leading;
  final double? size;
  final double maxWidth;
  final FractalTileStyle style;
  const FractalTile(
    this.fractal, {
    super.key,
    this.onTap,
    this.size,
    this.style = FractalTileStyle.tile,
    this.maxWidth = 384,
    this.trailing,
    this.leading,
  });

  static final options = [
    'tile',
    'card',
    'input',
    'select',
    'search',
    'color',
    'button',
    'signature',
    'icon',
    ...builders.keys,
    ...FractalInput.types.keys,
  ];

  static final builders = <String, Widget Function(NodeFractal)>{
    'date': (f) => FInputDate(f),
    //'time': (f) => FInputDate(f),
    'date_time': (f) => FInputDate(f),
    'date_range': (f) => FInputDate(f),
    'time': (f) => FInputTime(f),
    'range': (f) => FractalRange(f),
    'nav': (f) => FInputNav(f),
    'ref': (f) => FTileRef(f),
  };

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

  /*
  reload([PostFractal? f]) {
    setState(() {});
  }
  */

  @override
  void dispose() {
    //rew?.m.removeListener(reload);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blur = FractalBlur.maybeOf(context)?.level ?? 0;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth:
            double.tryParse('${widget.fractal['width']}') ?? widget.maxWidth,
      ),
      child: blur > 0
          ? ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppFractal.active.wb.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: thing(),
                  ),
                ),
              ),
            )
          : thing(),
    );
  }

  Widget thing() => switch (widget.fractal) {
        (NodeFractal f) => Listen(
            f,
            (ctx, child) {
              return Listen(
                f.m,
                (ctx, child) => GestureDetector(
                  onLongPress: () {
                    ConfigFArea.openDialog(f);
                  },
                  onSecondaryTap: () {
                    ConfigFArea.openDialog(f);
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
        (EventFractal f) => ListTile(
            minLeadingWidth: 20,
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.zero,
            leading: SizedBox.square(
              dimension: widget.size ?? 48,
              child: f.icon,
            ),
            title: Text(
              f.display,
            ),
          ),
        _ => const SizedBox(),
      };

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
    return switch (f.m['ui']?.content) {
      'select' => FractalPick(
          '${f['options']}',
          builder: (fOptions) => switch (f) {
            NodeFractal node => FractalSelect(
                fractal: node,
                trailing: widget.trailing,
              ),
          },
        ),
      'search' => FractalSelector(
          node: f,
          flow: UserFractal.flow,
        ),
      'button' => FractalButton(
          node: f,
          size: widget.size,
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
    final app = context.read<AppFractal?>();

    final ic = f.m['icon']?.content;
    final isCheck = ic == 'check';

    final icon = ic == '0'
        ? null
        : SizedBox.square(
            dimension: widget.size ?? 38,
            child: isCheck
                ? check()
                : Builder(
                    builder: (ctx) => InkWell(
                      onTap: () {
                        ConfigFArea.openDialog(f);
                      },
                      child: FIcon(
                        f,
                        size: widget.size,
                        color: FractalLayoutState.active.color,
                      ),
                    ),
                  ),
          );
    tap() {
      isCheck
          ? toggleCheck
          : widget.onTap?.call() ??
              () {
                ConfigFArea.openDialog(f);
              };
    }

    var style = widget.style;
    if (FPrintableLayer.maybeOf(context) case FPrintableLayer layer) {
      style = FractalTileStyle.row;
    }

    return switch (style) {
      (FractalTileStyle.row) => GestureDetector(
          onTap: tap,
          child: Row(children: [
            if (icon != null) icon,
            Expanded(
              child: define(f),
            ),
            if (ctrl?.noPrice != true && f['price'] != null)
              Text('${f['price']}€'),
            const SizedBox(width: 4),
            if (widget.trailing != null) widget.trailing!,
          ]),
        ),
      (FractalTileStyle.tile) => ListTile(
          leading: icon,
          //.minLeadingWidth: 20,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          title: Row(children: [
            Expanded(
              child: define(f),
            ),
            if (ctrl?.noPrice != true && f['price'] != null)
              Text('${f['price']}€'),
            const SizedBox(width: 4),
          ]),
          onTap: tap,
          trailing: widget.trailing,
        ),
    };
  }

  define(NodeFractal f) {
    final type = f.resolve('ui');
    if (FractalInput.types.containsKey(type)) {
      return FractalInput(
        fractal: f,
        size: widget.size,
      );
    }

    final builder = FractalTile.builders[type];
    if (builder != null) {
      return builder(f);
    }
    return FTitle(
      f,
      align: switch (f['align']) {
        'center' => TextAlign.center,
        'right' => TextAlign.right,
        'left' => TextAlign.left,
        _ => TextAlign.left,
      },
      style: TextStyle(
        fontSize: widget.size ?? 18,
        color: AppFractal.active.bw,
        fontWeight: FontWeight.bold,
      ),
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
