import 'package:flutter/material.dart';

class ResponsiveStack extends StatelessWidget {
  final List<Widget> children;
  const ResponsiveStack(this.children, {Key? key});

  @override
  Widget build(BuildContext context) {
    return (MediaQuery.of(context).size.width > 700)
        ? Row(children: children)
        : Column(children: children);
  }
}
