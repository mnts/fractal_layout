import 'package:app_fractal/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';

import '../index.dart';
import '../views/thing.dart';
import '../widget.dart';

class FRows extends FNodeWidget {
  final List<Widget> ctrls;
  FRows(
    super.node, {
    super.key,
    this.ctrls = const [],
  });

  @override
  Widget area() {
    return Center(
      child: Listen(f.sorted, (context, child) {
        return FutureBuilder(
          future: f.inNode(f),
          builder: (ctx, snap) {
            //final w = MediaQuery.of(context).size.width;
            if (snap.data case List<EventFractal> list) {
              return FractalLayer(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(2, 4, 2, 4),
                  decoration: BoxDecoration(
                      //color: Colors.grey.withAlpha(20),
                      ),
                  child: ListView(
                    //itemCount: sorted.value.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    //shrinkWrap: false,
                    scrollDirection: Axis.vertical,
                    padding: FractalPad.of(context).pad,

                    children: [
                      ...list.map(row),
                      if (ctrls.isNotEmpty) Row(children: ctrls),
                    ],
                  ),
                ),
              );
            }
            return const CupertinoActivityIndicator();
          },
        );
      }),
    );
  }

  Widget row(EventFractal f) {
    return Listen(
      f,
      (ctx, child) {
        final size = double.tryParse('${f['size']}');
        final height = double.tryParse('${f['height']}');

        final hasScreen = (f['screen'] != null);
        return Container(
          constraints: BoxConstraints(
            maxHeight: height ?? 300,
            maxWidth: 486,
          ),
          /*
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          decoration: BoxDecoration(
              color: hasScreen ? Colors.white : null,
              boxShadow: [
                if (hasScreen)
                  BoxShadow(
                    color: Colors.grey.withAlpha(64),
                    spreadRadius: 4,
                    blurRadius: 6, //component.borderWidth,
                    //offset: Offset(4, 4),
                  ),
              ],
              borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          */
          child: switch (f) {
            NodeFractal node when f.image != null => FractalImage(
                f.image!,
                fit: BoxFit.contain,
              ),
            NodeFractal node when node['screen'] == null => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FractalTile(
                    f,
                    size: size,
                  ),
                ],
              ),
            _ => FractalThing(f),
          },
        );
      },
      preload: 'writer',
    );
  }
}
