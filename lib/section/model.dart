import 'package:flutter/material.dart';

import '../section.dart';

class SectionF {
  var type = SectionType.area;
  double width = 200;
  IconData icon;
  String title;

  SectionF({
    this.title = '',
    this.icon = Icons.abc,
  });
}
