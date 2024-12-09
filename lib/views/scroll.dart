import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';

class FScrollView extends StatefulWidget {
  final List<Widget> children;
  const FScrollView({
    super.key,
    required this.children,
  });

  @override
  State<FScrollView> createState() => _ScrollViewState();
}

class _ScrollViewState extends State<FScrollView> {
  late final ctrl = ScrollController(
    onAttach: animate(),
  );

  @override
  void initState() {
    super.initState();

    //WidgetsBinding.instance.addPostFrameCallback((_) {});

    Timer(const Duration(seconds: 4), animate);
  }

  refresh([_]) {
    setState(() {});
  }

  @override
  void dispose() {
    //ctrl.removeListener(refresh);
    timer?.cancel();
    super.dispose();
  }

  Timer? timer;
  bool back = false;
  animate() {
    timer?.cancel();
    timer = Timer.periodic(
      const Duration(seconds: 6),
      scroll,
    );
  }

  scroll(Timer t) async {
    if (!ctrl.hasClients) return;
    await ctrl.animateTo(
      ctrl.offset + (256 * (back ? -1 : 1)),
      duration: const Duration(seconds: 2),
      curve: Curves.ease,
    );
    if (ctrl.offset >= ctrl.position.maxScrollExtent) {
      back = true;
    }
    if (ctrl.offset == 0) {
      back = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return HoverOver(
      builder: (over) => Stack(
        //padding: const EdgeInsets.all(4),
        children: [
          Positioned.fill(
            child: ListView(
              controller: ctrl,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              //spacing: 2,
              //clipBehavior: Clip.antiAlias,
              /*
              primary: false,
              crossAxisCount: countRow,
              childAspectRatio: 5 / 4,
              shrinkWrap: true,
              mainAxisSpacing: 4,
              crossAxisSpacing: 6,
              */
              //children: [...links.map((g) => DImage(url: g)).toList()],

              children: widget.children,
            ),
          ),
          if (over && ctrl.hasClients && ctrl.offset != 0)
            Positioned(
              top: 0,
              left: 0,
              width: 32,
              bottom: 0,
              child: InkWell(
                onTap: () async {
                  timer?.cancel();
                  await ctrl.animateTo(
                    ctrl.offset - 256,
                    duration: Durations.medium2,
                    curve: Curves.ease,
                  );
                  refresh();
                },
                child: Container(
                  color: Colors.grey.withAlpha(100),
                  child: const Icon(Icons.arrow_left_rounded),
                ),
              ),
            ),
          if (over &&
              ctrl.hasClients &&
              ctrl.offset < ctrl.position.maxScrollExtent)
            Positioned(
              top: 0,
              right: 0,
              width: 32,
              bottom: 0,
              child: InkWell(
                onTap: () async {
                  timer?.cancel();
                  await ctrl.animateTo(
                    ctrl.offset + 256,
                    duration: Durations.medium2,
                    curve: Curves.ease,
                  );
                  refresh();
                },
                child: Container(
                  color: Colors.grey.withAlpha(100),
                  child: const Icon(Icons.arrow_right_rounded),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
