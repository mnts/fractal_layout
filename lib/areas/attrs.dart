import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';

import '../inputs/input.dart';

class FractalAttrs extends StatefulWidget {
  final CatalogFractal catalog;
  const FractalAttrs(
    this.catalog, {
    super.key,
  });

  @override
  State<FractalAttrs> createState() => _FractalAttrsState();
}

class _FractalAttrsState extends State<FractalAttrs> {
  EventsCtrl get ctrl => switch (widget.catalog.source) {
        EventsCtrl ev => ev,
        _ => throw UnimplementedError(),
      };

  @override
  Widget build(BuildContext context) {
    return Watch<CatalogFractal>(
      widget.catalog,
      (context, child) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          top: 16,
          left: 8,
          bottom: 16,
          right: 4,
        ),
        children: [
          ...[ctrl, ...ctrl.controllers].map(
            (c) => Column(children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox.square(
                    dimension: 32,
                    child: c.icon.widget,
                  ),
                  Text(
                    c.name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ...c.attributes
                  .where(
                    (a) => !(const ['name']).contains(a.name) && a.isIndex,
                  )
                  .map(
                    (a) => FractalAttr(
                      a,
                    ),
                  ),
            ]),
          ),
        ],
      ),
    );
  }
}
