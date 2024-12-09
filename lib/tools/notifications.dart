import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:app_fractal/index.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/layout.dart';
import 'package:fractal_socket/index.dart';
import '../widgets/index.dart';

class NotificationsTool extends StatefulWidget {
  const NotificationsTool({super.key});

  @override
  State<NotificationsTool> createState() => _NotificationsToolState();
}

class _NotificationsToolState extends State<NotificationsTool> {
  final _tip = FTipCtrl();
  List<EventFractal> events = [];

  static bool nRequested = false;

  @override
  void initState() {
    initCtrl(EventFractal.controller);
    if (!nRequested) {
      FSocketAPI.maps['notification']!.listen(preload);
      NetworkFractal.out?.sink({'cmd': 'notifications'});
      nRequested = true;
    }

    super.initState();
  }

  initCtrl(EventsCtrl ctrl) {
    events.addAll(
      EventFractal.map.values.where(filter),
    );
    sort();

    EventFractal.map.listen(receive);
  }

  static preload(Map<String, Map<String, dynamic>> list) async {
    final r = list.values;
    final map = <String, Map<String, dynamic>>{};
    for (var m in r) {
      final f = m['node'] = await NetworkFractal.request(m['hash']);
      if (f case NodeFractal node) {
        final hashes = node.name.split(':')[1].split(',');
        hashes.remove(UserFractal.active.value!.hash);
        if (hashes.isNotEmpty) {
          m['user'] = await NetworkFractal.request(hashes[0]);
        }
      }
      map[m['hash']] = m;
    }
    notifications.value = map;
  }

  static final notifications = Frac<Map<String, Map<String, dynamic>>>({});

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
    return event.to?.hash == UserFractal.active.value?.hash;
  }

  @override
  Widget build(BuildContext context) {
    final user = UserFractal.active.value!;

    //final notifications = FSocketMix.maps['notification'];
    return Listen(
      notifications,
      (ctx, child) => FractalTooltip(
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
                    listView(notifications.value),

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
            icon: Stack(
              children: [
                const Icon(
                  Icons.notification_important,
                  color: Colors.white,
                ),
                if (notifications.value.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${notifications.value.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          )),
    );
  }

  Widget listView(Map<String, Map<String, dynamic>> map) {
    final list = [...map.values];
    list.sort((a, b) => a['time'].compareTo(b['time']));
    return ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      reverse: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(
        bottom: 56,
      ),
      itemBuilder: (context, i) => notificationW(list[i]),
    );
  }

  Widget notificationW(MP m) {
    final node = m['node'];
    final user = m['user'];
    return InkWell(
      onTap: () {
        FractalLayoutState.active.go(
          node,
          '|stream',
        );
      },
      child: SizedBox(
        height: 56,
        child: ListTile(
          leading: SizedBox.square(
            dimension: 42,
            child: FIcon(user ?? node),
          ),
          title: Text(user.display),
          subtitle: Text(m['content']),
        ),
      ),
    );
  }
}
