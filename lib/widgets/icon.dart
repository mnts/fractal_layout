import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/data/icons.dart';
import 'package:fractal_flutter/index.dart';
import 'package:dartlin/control_flow.dart';
import 'package:fractal_layout/index.dart';
import '../areas/config.dart';

extension IconNodeExt on NodeFractal {
  Widget get icon {
    return Builder(
      builder: (ctx) => InkWell(
        onTap: () {
          ConfigFArea.openDialog(this);
        },
        child: FIcon(this),
      ),
    );
  }
}

extension IconFractalExt on EventFractal {
  Widget get icon => FIcon(this);
}

class FIcon extends StatelessWidget {
  final Fractal f;
  final bool noImage;
  final Color? color;
  final double? size;
  final List<Shadow>? shadows;

  const FIcon(
    this.f, {
    super.key,
    this.color,
    this.size,
    this.shadows,
    this.noImage = false,
  });

  @override
  Widget build(BuildContext context) {
    //'check' => check(context),
    Color? c;
    if (f['color'] case String cNum) {
      c = Color(int.tryParse(cNum) ?? 0);
    }
    return switch (f) {
      NodeFractal node => Container(
          clipBehavior: Clip.hardEdge,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              this is UserFractal ? 80 : 8,
            ),
          ),
          child: node.image != null && noImage == false
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: c ?? AppFractal.active.wb,
                  ),
                  child: FractalImage(
                    key: Key(
                      '${node.image!.name}@icon',
                    ),
                    node.image!,
                    fit: BoxFit.cover,
                  ),
                )
              : switch (node['icon']) {
                  String icnS => icnS.let((it) {
                      return Icon(
                        parse(icnS, f.ctrl.icon.codePoint),
                        color: c,
                        shadows: shadows,
                        size: size,
                      );
                    }),
                  _ => Icon(
                      IconData(
                        f.ctrl.icon.codePoint,
                        fontFamily: f.ctrl.icon.fontFamily,
                      ),
                      shadows: shadows,
                      size: size,
                      color: c ?? color,
                    ),
                },
        ),
      _ => f.ctrl.icon.widget,
    };
  }

  static IconData parse(String icnS, int def) {
    final icn = int.tryParse(icnS);
    return icn != null
        ? IconData(
            icn,
            fontFamily: 'MaterialIcons',
          )
        : MaterialFIcons.mIcons[icnS] ??
            IconData(
              def,
              fontFamily: 'MaterialIcons',
            );
  }
}

extension IconExt on IconF {
  Widget get widget => Icon(
        IconData(codePoint, fontFamily: fontFamily),
      );
}
