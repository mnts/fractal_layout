import 'dart:ui';

import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';

import '../index.dart';
import '../widgets/background.dart';

class FractalThing extends StatelessWidget {
  final EventFractal f;
  const FractalThing(this.f, {super.key});

  static final areas = <Builder>[];

  @override
  Widget build(BuildContext context) {
    return Listen(
      f,
      (ctx, child) {
        final screenName = '${f['ui'] ?? ''}';

        return switch (f) {
          NodeFractal node when node.image != null => FractalBackground(
              media: node.image!,
              child: screenName != ''
                  ? Center(
                      child: node.widget(screenName),
                    )
                  : const SizedBox(), /*Stack(
                children: [
                  Center(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          width: double.tryParse('${node['width']}') ?? 300.0,
                          height: double.tryParse('${node['height']}') ?? 300.0,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: 
                        uib(node),
                    
                        ),
                      ),
                    ),
                    
                  ),
                ],
              ),
                          */
            ),
          NodeFractal node => node.widget(screenName),
          _ => FractalTile(f),
        };
      },
      preload: 'rewriter',
    );
  }
}
