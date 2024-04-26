import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:app_fractal/index.dart';
import 'package:fractal_flutter/index.dart';
import '../widgets/index.dart';

class NotificationsTool extends StatefulWidget {
  const NotificationsTool({super.key});

  @override
  State<NotificationsTool> createState() => _NotificationsToolState();
}

class _NotificationsToolState extends State<NotificationsTool> {
  late final cart = UserFractal.active.value!.require('cart');
  final _tip = FTipCtrl();
  List<EventFractal> events = [];

  @override
  void initState() {
    initCtrl(EventFractal.controller);
    super.initState();
  }

  initCtrl(EventsCtrl ctrl) {
    events.addAll(
      EventFractal.map.values.where(filter),
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
    return event.toHash == UserFractal.active.value?.hash;
  }

  @override
  Widget build(BuildContext context) {
    final user = UserFractal.active.value!;

    double total = 0;
    for (NodeFractal f in cart.sub.list) {
      total += double.parse('${f['price'] ?? 0}');
    }
    return FractalTooltip(
        controller: _tip,
        content: Container(
          constraints: const BoxConstraints(
            maxHeight: 360,
            minHeight: 80,
          ),
          width: 360,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 6,
                sigmaY: 6,
              ),
              child: Stack(
                children: [
                  if (cart.sub.list.isNotEmpty)
                    Listen(
                      cart.sub,
                      (ctx, child) => ListView.builder(
                        itemCount: events.length,
                        shrinkWrap: true,
                        reverse: true,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.only(
                          bottom: 56,
                        ),
                        itemBuilder: (context, i) => switch (events[i]) {
                          PostFractal f => FractalTile(
                              f,
                            ),
                          _ => Container(),
                        },
                      ),
                    )
                  else
                    Container(
                      child: const Text('empty'),
                    ),
                  /*
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 32,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 6,
                          sigmaY: 6,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              tooltip: 'Manage payment methods',
                              onPressed: () {
                                context.go('/payment_methods');
                              },
                              icon: const Icon(
                                Icons.credit_card_outlined,
                              ),
                            ),
                            const Spacer(),
                            Text('$total€',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                            const Spacer(),
                            IconButton(
                              tooltip: 'Pay all',
                              onPressed: () {},
                              icon: const Icon(
                                Icons.payments_outlined,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  */
                ],
              ),
            ),
          ),
        ),
        child: IconButton(
          onPressed: () {
            _tip.showTooltip();
            //context.go(active.value!.path);
          },
          icon: const Icon(
            Icons.notification_important,
            color: Colors.white,
          ),
        ));
  }
}
