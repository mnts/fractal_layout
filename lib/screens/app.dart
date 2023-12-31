import 'package:app_fractal/app.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';

class AppFHome extends StatefulWidget {
  const AppFHome({super.key});

  @override
  State<AppFHome> createState() => _AppFHomeState();
}

class _AppFHomeState extends State<AppFHome> {
  @override
  Widget build(BuildContext context) {
    final app = context.read<AppFractal>();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
                SliverAppBar(
                  expandedHeight: 800.0,
                  floating: true,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      width: 120,
                      height: 230,
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: app.icon,
                    ),
                  ),
                ),
              ],
              body: ListTileTheme(
                iconColor: Theme.of(context).colorScheme.onBackground,
                child: ListView(
                  children: <Widget>[],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
