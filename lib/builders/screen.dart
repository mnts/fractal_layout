import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/widgets/document.dart';
import '../models/index.dart';

extension ScreenFractalBuilder on ScreenFractal {
  Widget build(BuildContext context) {
    return Container(
      key: widgetKey('doc'),
      child: DocumentArea(
        this,
      ),
    );
  }

  Widget tile(BuildContext context) {
    final app = context.read<AppFractal?>();
    return ListTile(
      leading: ctrl.icon.widget,
      /*
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
  W              vertical: 2,
              ),
              */
      title: Watch(
        title,
        (ctx, child) => Text(
          title.value?.content ?? name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () {
        FractalLayoutState.active.go(this);
      },
    );
  }
}
