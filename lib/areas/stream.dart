import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/widgets/message.dart';
import 'package:fractal_layout/widgets/post.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:velocity_x/velocity_x.dart';

import '../widgets/index.dart';

class StreamArea extends StatefulWidget {
  final NodeFractal fractal;
  const StreamArea({
    required this.fractal,
    super.key,
  });

  @override
  State<StreamArea> createState() => _StreamAreaState();
}

class _StreamAreaState extends State<StreamArea> {
  late final catalog = CatalogFractal<EventFractal>(
    filter: {
      'event': {
        'to': widget.fractal.hash,
      },
    },
    source: EventFractal.controller,
  );
  /*
  List<EventFractal> events = [];

  @override
  void initState() {
    super.initState();
  }

  initCtrl(EventsCtrl ctrl) {
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
    return Listen(catalog, (ctx, child) {
      return Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: catalog.list.length, //catalog.list.length,
            reverse: false,
            padding: const EdgeInsets.only(
              bottom: 50,
              left: 4,
            ),
            itemBuilder: (context, i) {
              return switch (catalog.list[i]) {
                PostFractal f => MessageField(
                    message: f,
                  ),
                EventFractal ev => FractalTile(ev),
              };
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

          if (widget.fractal.to != null)
            Align(
              alignment: Alignment.bottomLeft,
              child: Listen(
                UserFractal.active,
                (ctx, child) => UserFractal.active.isNull
                    ? Container() /*Container(
                    height: 28,
                    color: Colors.orange.shade200,
                    alignment: Alignment.center,
                    child: Text('Login to post'),
                  )*/
                    : PostArea(to: widget.fractal),
              ),
            ),
        ],
      );
    });
  }
}
