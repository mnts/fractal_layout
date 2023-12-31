import 'dart:async';
import 'dart:ui';

import 'package:dartlin/dartlin.dart';
import 'package:flutter/material.dart';
import 'package:frac/index.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/models/event.dart';
import 'package:signed_fractal/services/sorted.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'icon.dart';

class FSortable<T extends EventFractal> extends StatelessWidget {
  final SortedFrac<T> sorted;
  final Widget Function(T) builder;
  final Function()? cb;

  final bool reverse;
  final bool horizontal;

  FSortable({
    this.cb,
    this.reverse = true,
    this.horizontal = false,
    required this.sorted,
    required this.builder,
    super.key,
  });

  final state = Frac<int>(0);

  Timer? timer;
  order(T f, int i) {
    timer?.cancel();
    timer = Timer(
      const Duration(milliseconds: 400),
      () {
        sorted.order(f, i);
        cb?.call();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //context.read<SortedFrac>();

    return Listen(
      sorted,
      (context, child) => DragTarget<T>(
        onWillAccept: (f) {
          if (f == null) return false;
          if (sorted.length > 0) return true;
          order(f, 0);
          return true;
        },
        onLeave: (f) {
          return;
          if (f == null) return;
          sorted.remove(f);
          cb?.call();
        },
        onAccept: (ev) {
          //cb?.call();
        },
        builder: (context, d, rejectedData) {
          if (sorted.value.isEmpty) {
            return Container(
              height: 30,
            );
          }

          int i = 0;
          return LayoutBuilder(builder: (context, constraints) {
            maxWidth = constraints.maxWidth;
            return constraints.maxWidth > FractalView.gridWidth
                ? grid()
                : ListView(
                    //itemCount: sorted.value.length,
                    reverse: reverse,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    //shrinkWrap: false,
                    scrollDirection:
                        horizontal ? Axis.horizontal : Axis.vertical,
                    padding: const EdgeInsets.only(
                      //top: 56,
                      left: 1,
                    ),
                    children: [
                      ...sorted.value.mapIndexed(tile),
                      removal(),
                    ],
                  );
          });
        },
      ),
    );
  }

  double maxWidth = 0;

  SliverGridDelegate get gridDelegate =>
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: maxWidth ~/ FractalView.gridWidth ~/ 0.7,
        childAspectRatio: 1,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
      );

  Widget grid() {
    return SingleChildScrollView(
      child: GridView(
        reverse: reverse,
        gridDelegate: gridDelegate,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        //shrinkWrap: false,
        scrollDirection: horizontal ? Axis.horizontal : Axis.vertical,
        padding: const EdgeInsets.only(
          //top: 56,
          left: 1,
        ),
        children: [
          ...sorted.value.map(
            (f) => card(f),
          ),
          removal(),
        ],
      ),
    );
  }

  Widget card(T f) {
    return Container(
      //onPressed: () {},
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
      constraints: const BoxConstraints(maxHeight: 200),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: FIcon(f),
          ),
          /*
          if (widget.trailing != null)
            Positioned(
              top: 2,
              right: 2,
              child: widget.trailing!,
            ),
            */
          if (f is NodeFractal && f['price'] != null)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 4,
                  right: 4,
                  top: 2,
                  bottom: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${f['price']}€',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(
                      180,
                      120,
                      20,
                      1,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 6,
                  sigmaY: 6,
                ),
                child: Container(
                  color: Colors.white.withAlpha(100),
                  padding: const EdgeInsets.all(2),
                  alignment: Alignment.center,
                  child: builder(f),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget removal() {
    return Listen(
      key: const Key('Removal'),
      state,
      (ctx, child) => Visibility(
        visible: state.value > 0,
        child: DragTarget<T>(
          onWillAccept: (f) {
            if (f == null) return false;
            state.value = 2;
            return true;
          },
          onAccept: (f) {
            sorted.remove(f);

            cb?.call();
            timer?.cancel();
          },
          onLeave: (ev) {
            state.value = 1;
          },
          builder: (
            context,
            d,
            List<dynamic> rejectedData,
          ) =>
              Container(
            color: state.value == 2
                ? Color.fromARGB(255, 211, 129, 21).withAlpha(200)
                : Colors.red.withAlpha(200),
            height: 56,
            child: const Icon(Icons.delete_forever),
          ),
        ),
      ),
    );
  }

  Widget tile(int i, T f) {
    final index = i++;
    //final f = sorted.value[i];

    return DragTarget<T>(
      onWillAccept: (into) {
        if (into == null || into == f) return false;
        order(into, index);
        return true;
      },
      onAccept: (ev) {},
      onLeave: (ev) {
        timer?.cancel();
      },
      builder: (
        context,
        d,
        List<dynamic> rejectedData,
      ) =>
          FractalMovable(
        event: f,
        onDragStart: () {
          state.value = 1;
        },
        onDragEnd: () {
          state.value = 0;
        },
        child: builder(f),
      ),
    );
  }
}
