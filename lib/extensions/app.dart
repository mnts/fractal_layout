import 'package:app_fractal/app.dart';
import 'package:flutter/material.dart';

extension AppFractalExt on AppFractal {
  Color get wb => dark ? Colors.black : Colors.white;
  Color get bw => !dark ? Colors.black : Colors.white;
}
