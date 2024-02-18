import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_app_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/widgets/title.dart';
import 'package:signed_fractal/models/user.dart';

import '../screens/fscreen.dart';

class ProfileArea extends StatefulWidget {
  final UserFractal user;
  const ProfileArea({required this.user, super.key});

  @override
  State<ProfileArea> createState() => _ProfileAreaState();
}

class _ProfileAreaState extends State<ProfileArea>
    with TickerProviderStateMixin {
  late final _tabCtrl = TabController(
    length: 9,
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    return FScreen(
      Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Container(
            color: Colors.grey.shade200.withAlpha(150),
            height: 96,
            child: Row(
              children: [
                Container(
                  height: 90,
                  width: 98,
                  padding: const EdgeInsets.only(left: 6, right: 3),
                  child: widget.user.icon,
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(children: [
                          Expanded(
                            child: FTitle(widget.user, size: 28),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.currency_bitcoin,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.block,
                            ),
                          ),
                        ]),
                        TabBar(
                          controller: _tabCtrl,
                          tabs: const <Widget>[
                            Tab(
                              icon: Icon(Icons.info),
                            ),
                            Tab(
                              icon: Icon(Icons.question_mark),
                            ),
                            Tab(
                              icon: Icon(Icons.face_6),
                            ),
                            Tab(
                              icon: Icon(Icons.money_rounded),
                            ),
                            Tab(
                              icon: Icon(Icons.bakery_dining),
                            ),
                            Tab(
                              icon: Icon(Icons.comments_disabled),
                            ),
                            Tab(
                              icon: Icon(Icons.person),
                            ),
                            Tab(
                              icon: Icon(Icons.chat_outlined),
                            ),
                            Tab(
                              icon: Icon(Icons.person),
                            ),
                          ],
                        ),
                      ]),
                )
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                AppsFAreas(widget.user),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
