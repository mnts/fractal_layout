import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/signed_fractal.dart';

extension NodeFractalBuilder on NodeFractal {
  Widget build(BuildContext context) {
    return Container(key: widgetKey('node'), child: Container());
  }

  Widget tile(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.ac_unit,
      ),
      /*
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              */
      title: Watch(
        title,
        (ctx, child) => Text(
          title.value?.content ?? '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
