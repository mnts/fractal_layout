import 'package:flutter/material.dart';
import 'package:fractal_flutter/image.dart';
import 'package:signed_fractal/signed_fractal.dart';

import '../widgets/title.dart';

class ImagesFArea extends StatefulWidget {
  final List<EventFractal> list;
  final EdgeInsets? padding;
  final int initial;
  const ImagesFArea({
    required this.list,
    this.initial = 0,
    this.padding,
    super.key,
  });

  @override
  State<ImagesFArea> createState() => _ImagesFAreaState();
}

class _ImagesFAreaState extends State<ImagesFArea>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(
    vsync: this,
    length: widget.list.length,
    initialIndex: widget.initial,
  );

  List<EventFractal> get list => widget.list;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.center,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: TabBarView(
            controller: _tabController,
            children: [
              ...list.map((f) => image(f)),
            ],
          ),
        ),
        if (showCtrls && list.isNotEmpty)
          Positioned(
            bottom: 4,
            left: 50,
            right: 50,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey.withAlpha(128),
              ),
              height: 40,
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                indicatorWeight: 4,
                controller: _tabController,
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.only(right: 1),
                tabs: [
                  ...list.map(
                    (f) => Tab(
                        child: switch (f) {
                      EventFractal pf when pf.file != null =>
                        FractalImage(pf.file!),
                      _ => FTitle(f),
                    }),
                  ),
                ],
              ),
            ),
          ),
        if (showCtrls && list.isNotEmpty)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              style: buttonStyle,
              tooltip: 'Close',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
      ],
    );
  }

  static const buttonStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll<Color>(
      Color(0x88888888),
    ),
  );

  pop() {
    Navigator.pop(context);
  }

  bool showCtrls = true;

  toggleCtrls() {
    setState(() {
      showCtrls = !showCtrls;
    });
  }

  bool showFull = false;
  toggleFull() {
    setState(() {
      showFull = !showFull;
    });
  }

  image(EventFractal f) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.center,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: InkWell(
            onTap: pop,
          ),
        ),
        if (showFull)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: toggleCtrls,
              onDoubleTap: toggleFull,
              child: InteractiveViewer(
                trackpadScrollCausesScale: true,
                child: FractalImage(
                  f.file!,
                ),
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(56),
            child: switch (f) {
              EventFractal pf when pf.file != null => GestureDetector(
                  onTap: toggleCtrls,
                  onDoubleTap: toggleFull,
                  child: FractalImage(
                    pf.file!,
                  ),
                ),
              _ => FTitle(f),
            },
          ),
        if (showCtrls)
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton.filled(
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Delete',
              style: buttonStyle,
              onPressed: () {
                if (f case EventFractal evf) evf.remove();

                Navigator.pop(context);
              },
            ),
          ),
        if (showCtrls)
          Positioned(
            bottom: 0,
            left: 0,
            child: IconButton.filled(
              icon: const Icon(Icons.rotate_90_degrees_ccw),
              tooltip: 'Rotate',
              style: buttonStyle,
              onPressed: () {
                rotate(f, -90);
                if (f case EventFractal evf) evf.remove();
                Navigator.pop(context);
              },
            ),
          ),
        if (showCtrls)
          Positioned(
            bottom: 46,
            left: 0,
            child: IconButton.filled(
              icon: const Icon(Icons.rotate_90_degrees_cw_outlined),
              tooltip: 'Rotate',
              style: buttonStyle,
              onPressed: () {
                rotate(f, 90);

                if (f case EventFractal evf) evf.remove();
                Navigator.pop(context);
              },
            ),
          ),
      ],
    );
  }

  rotate(Fractal fractal, num deg) async {
    final file = (fractal as EventFractal).file;

    if (file == null) return;

    final f = await FractalImage.rotate(file);
    await f.publish();

    if (f case FilterF c) {
      final ev = await EventFractal.controller.put({
        'file': f.name,
        'kind': FKind.file.index,
        'to': c.filter['to'] ?? c.hash,
        'owner': UserFractal.active.value?.hash,
      });
      ev.synch();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
