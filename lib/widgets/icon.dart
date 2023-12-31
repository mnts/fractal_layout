import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_app_flutter/index.dart';
import 'package:fractal_flutter/data/icons.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/models/index.dart';
import 'package:dartlin/control_flow.dart';

import '../areas/config.dart';
import 'tip.dart';

extension IconNodeExt on NodeFractal {
  Widget get icon {
    return Builder(
      builder: (ctx) => InkWell(
        onTap: () {
          ConfigFArea.dialog(this);
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
  final EventFractal f;
  final bool noImage;
  const FIcon(
    this.f, {
    super.key,
    this.noImage = false,
  });

  @override
  Widget build(BuildContext context) {
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
                    color: AppFractal.active.wb,
                  ),
                  child: FractalImage(
                    key: Key(
                      '${node.image!.name}@icon',
                    ),
                    node.image!,
                    fit: BoxFit.cover,
                  ),
                )
              : switch (node.m['icon']?.content) {
                  //'check' => check(context),
                  String icnS => icnS.let((it) {
                      final color = node.m['color']?.content;
                      return Icon(
                        parse(icnS, f.ctrl.icon.codePoint),
                        color: color != null
                            ? Color(
                                int.tryParse(
                                      color,
                                    ) ??
                                    0,
                              )
                            : null,
                      );
                    }),
                  _ => f.ctrl.icon.widget,
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
