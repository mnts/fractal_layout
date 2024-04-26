import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:go_router/go_router.dart';
import 'package:signed_fractal/signed_fractal.dart';

class SlidesFScaffold extends StatefulWidget {
  final NodeFractal node;
  const SlidesFScaffold(
    this.node, {
    super.key,
  });

  @override
  State<SlidesFScaffold> createState() => SlidesFScaffoldState();
}

class SlidesFScaffoldState extends State<SlidesFScaffold>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    _tabCtrl = TabController(
      length: 10,
      vsync: this,
    );

    super.initState();

    preload();
  }

  preload() async {
    final filter = CatalogFractal<UserFractal>(
      filter: {
        'node': {'name': widget.name}
      },
      source: UserFractal.controller,
    )
      ..createdAt = 2
      ..synch();

    user = filter.first;
    /*
    if (user == null) {
      UserFractal.map.request(widget.name).then((f) {
        setState(() {
          user = f;
        });
      });
    }
    */
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  UserFractal? user;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (user == null) return const CupertinoActivityIndicator();
    return FractalScaffold(
      key: Key('@${widget.node.hash}'),
      node: user!,
      title: Theme(
        data: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
          listTileTheme: const ListTileThemeData(
            textColor: Colors.white,
            iconColor: Colors.white,
          ),
          tabBarTheme: const TabBarTheme(
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabAlignment: TabAlignment.center,
            dividerHeight: 0,
          ),
        ),
        child: TabBar(
          controller: _tabCtrl,
          padding: const EdgeInsets.only(top: 7),
          indicatorPadding: EdgeInsets.all(0),
          isScrollable: true,
          tabs: const <Widget>[
            Tab(
              icon: Tooltip(
                message: 'Info',
                child: Icon(Icons.person),
              ),
            ),
            Tab(
              icon: Tooltip(
                message: 'Details',
                child: Icon(Icons.info),
              ),
            ),
            Tab(
              icon: Tooltip(
                message: 'Questionnaire',
                child: Icon(Icons.question_mark),
              ),
            ),
            Tab(
              icon: Tooltip(
                message: 'Charting',
                child: Icon(Icons.tag_faces),
              ),
            ),
            Tab(
              icon: Tooltip(
                message: 'Appointments',
                child: Icon(Icons.calendar_month),
              ),
            ),
            Tab(
              icon: Tooltip(
                message: 'Photos',
                child: Icon(Icons.photo_camera),
              ),
            ),
            Tab(
              icon: Tooltip(
                message: 'Consents',
                child: Icon(Icons.document_scanner),
              ),
            ),
            Tab(
              icon: Tooltip(
                message: 'Documents',
                child: Icon(Icons.text_snippet_rounded),
              ),
            ),
            Tab(
              icon: Tooltip(
                message: 'Comments',
                child: Icon(Icons.add_comment_rounded),
              ),
            ),
            Tab(
              icon: Tooltip(
                message: 'Events',
                child: Icon(Icons.mode_comment),
              ),
            ),
          ],
        ),
      ),
      body: Watch<NodeFractal>(
        widget.node,
        (ctx, child) => FScreen(
          Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabCtrl,
                  children: [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
