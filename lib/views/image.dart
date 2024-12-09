import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';

import '../widget.dart';
import '../widgets/dialog.dart';

class FractalImageView extends FNodeWidget {
  FractalImageView(super.node, {super.key});

  static show(NodeFractal node) {
    FDialog.show(
      child: FractalImageView(node),
    );
  }

  view() {
    return Builder(
      builder: (context) => Theme(
        data: ThemeData(
          iconTheme: const IconThemeData(
            size: 32,
            color: Colors.white,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: InkWell(onTap: () {
                Navigator.pop(context);
              }),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Hero(
                  tag: f.widgetKey('img'),
                  child: FractalImage(f.file!),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.delete_forever),
                tooltip: 'Delete',
                onPressed: () {
                  f.remove();

                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Close',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
