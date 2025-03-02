import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/signed_fractal.dart';

import '../widgets/index.dart';

class StreamArea extends StatefulWidget {
  final NodeFractal fractal;
  final MP? filter;
  final EdgeInsets? padding;
  const StreamArea({
    required this.fractal,
    this.filter,
    this.padding,
    super.key,
  });

  @override
  State<StreamArea> createState() => _StreamAreaState();
}

class _StreamAreaState extends State<StreamArea> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.fractal.myInteraction.then((f) {
        f.write('seen', '');
      });
    });
  }

  /*

  List<EventFractal> events = [];
  initCtrl(EveEdgeInsetsntsCtrl ctrl) {
    events.addAll(
      EventFractal.map.values.filter(filter),
    );
    sort();

    EventFractal.map.listen(receive);
  }

  @override
  dispose() {
    EventFractal.map.unListen(receive);
    super.dispose();
  }

  receive(EventFractal? msg) {
    if (msg == null) {
      return setState(() {
        sort();
      });
    }
    if (!filter(msg)) return;
    setState(() {
      events.insert(0, msg);
      sort();
    });
  }

  sort() => events.sort((a, b) => (a.createdAt < b.createdAt) ? 1 : -1);

  bool filter(EventFractal event) {
    return event.toHash == widget.fractal.hash;
  }
  */

  @override
  Widget build(BuildContext context) {
    /*
    var title = widget.fractal.content;
    if (title.isEmpty) title = '#${widget.fractal.hash}';
    var f = widget.fractal;
    */
    final pad = FractalPad.maybeOf(context)?.pad;

    return Listen(widget.fractal, (ctx, ch) {
      final list = [
        ...widget.fractal.list.where((f) => f is! InteractionFractal),
      ];
      return Container(
          padding: pad,
          child: Stack(
            children: <Widget>[
              ListView.builder(
                itemCount: list.length, //catalog.list.length,
                reverse: true,
                padding: widget.padding ??
                    const EdgeInsets.only(
                      bottom: 50,
                      left: 4,
                    ),
                itemBuilder: (context, i) => switch (list[i]) {
                  EventFractal f => MessageField(
                      f,
                    ),
                  _ => const SizedBox(),
                },
              ),
              /*
        Align(
          alignment: Alignment.topCenter,
          child: FractalMovable(
            event: f,
            child: Container(
              height: 32,
              width: double.infinity,
              color: Theme.of(context).canvasColor.withOpacity(0.6),
              child: Text(title, style: const TextStyle(fontSize: 10)),
            ),
          ),
        ),
        */

              //if (widget.fractal?.to != null)
              Align(
                alignment: Alignment.bottomLeft,
                child: Listen(
                  UserFractal.active,
                  (ctx, child) => /*UserFractal.active.isNull
                  ? Container() /*Container(
                    height: 28,
                    color: Colors.orange.shade200,
                    alignment: Alignment.center,
                    child: Text('Login to post'),
                  )*/
                  : */
                      PostArea(
                    to: widget.fractal,
                    key: widget.fractal.widgetKey('post'),
                  ),
                ),
              ),
            ],
          ));
    });
  }
}
