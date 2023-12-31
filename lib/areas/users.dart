import 'package:app_fractal/app.dart';
import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:go_router/go_router.dart';
import 'package:signed_fractal/models/user.dart';

import '../index.dart';
import '../widgets/index.dart';

class FractalUsers extends StatefulWidget {
  final EdgeInsets? padding;
  final NodeFractal? node;
  const FractalUsers({
    super.key,
    this.node,
    this.padding,
  });

  @override
  State<FractalUsers> createState() => _FractalUsersState();
}

class _FractalUsersState extends State<FractalUsers> {
  List<UserFractal> get list => UserFractal.flow.list;

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppFractal>();
    final interacts = <UserFractal>[];

    widget.node?.interactions.list.forEach((inter) {
      if (inter.owner != null) {
        interacts.add(inter.owner!);
      }
    });

    return Listen(
      UserFractal.flow,
      (context, child) => ListView(
        padding: widget.padding,
        children: [
          if (interacts.isNotEmpty)
            const Padding(
              padding: EdgeInsets.only(
                right: 16,
                top: 8,
              ),
              child: Text(
                'Interactions',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ...interacts.map(
            (f) => FractalUser(
              f,
              onTap: () {
                FractalLayoutState.active.go(f);
              },
            ),
          ),
          if (interacts.isNotEmpty) const Divider(),
          ...list.where((f) => !interacts.contains(f)).map(
                (f) => FractalUser(
                  f,
                  onTap: () {
                    FractalLayoutState.active.go(f);
                  },
                ),
              ),
        ],
      ),
    );
  }
}
