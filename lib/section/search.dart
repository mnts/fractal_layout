import 'dart:ui';

import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_app_flutter/index.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../index.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final _searchTip = SuperTooltipController();
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final app = context.read<AppFractal>();

    return Container(
      constraints: BoxConstraints(
        maxWidth: ((w > 700) ? 360 : 240),
      ),
      height: 36,
      child: FractalTooltip(
        controller: _searchTip,
        content: Container(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 500,
            minHeight: 100,
          ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 6,
                sigmaY: 6,
              ),
              child: SearchFBox(
                ctrl: _searchCtrl,
                flow: NodeFractal.flow,
                onTap: (f) {
                  FractalLayoutState.active.go(f);
                },
              ),
            ),
          ),
        ),
        child: TextFormField(
          controller: _searchCtrl,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: 'Search for clinics, dentists, documents...',
            hintStyle: TextStyle(color: Colors.grey.withAlpha(200)),
            fillColor: app.wb.withAlpha(180),
            filled: true,
            contentPadding: const EdgeInsets.all(2),
            prefixIcon: const Icon(Icons.search),
            isDense: true,
          ),
          onTap: () {
            _searchTip.showTooltip();
          },
          onTapOutside: (c) {
            Future.delayed(
              const Duration(milliseconds: 10),
              () {
                //_searchTip.hideTooltip();
              },
            );
          },
        ),
      ),
    );
  }
}
