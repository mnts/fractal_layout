import 'package:fractal_socket/api.dart';
import 'package:timeago/timeago.dart';

import '../widget.dart';

class SetupFDates extends StatelessWidget {
  final EventFractal f;
  const SetupFDates(this.f, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            f.syncAt = 1;
            if (NetworkFractal.out case FSocketAPI c) {
              f.syncAt = 1;
              c.distribute(f);
              f.notifyListeners();
            }
          },
          child: const Icon(
            Icons.public,
          ),
        ),
        switch (f.syncAt) {
          > 1000 => Text(
              '${format(
                DateTime.fromMillisecondsSinceEpoch(
                  f.syncAt * 1000,
                ),
                locale: 'en_short',
              )} ago',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          2 => const Text('Private'),
          1 => const Text('Gonna be shared'),
          0 => const Text('Naver shared'),
          _ => const Text('Synch issue'),
        },
        const Spacer(),
        const Text('Created: '),
        Text(
          '${format(
            DateTime.fromMillisecondsSinceEpoch(
              f.createdAt * 1000,
            ),
            locale: 'en_short',
          )} ago',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
