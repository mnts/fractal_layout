import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../areas/config.dart';
import '../../trash/owner.dart';
import '../widgets/title.dart';

class AppCard extends StatelessWidget {
  final AppFractal app;
  const AppCard(this.app, {super.key});

  @override
  Widget build(BuildContext context) {
    app.preload();
    return Card(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 320,
          height: 240,
          child: Listen(
            app,
            (ctx, child) => Column(
              children: [
                Expanded(
                  child: app.icon,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        ConfigFArea.openDialog(app);
                      },
                      child: FTitle(app),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        launchUrl(
                          Uri(
                            host: app.domain,
                          ),
                          webOnlyWindowName: '_blank',
                        );
                      },
                      child: Text(app.domain),
                    ),
                  ],
                ),
                /*
            OwnerGap(
              Text(
                'Created ${timeago.format(
                  DateTime.fromMillisecondsSinceEpoch(
                    app.createdAt * 1000,
                  ),
                  locale: 'en_short',
                )} ago',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              fractal: app,
            ),
            */
              ],
            ),
          ),
        ));
  }
}
