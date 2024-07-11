import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:go_router/go_router.dart';
import 'package:signed_fractal/models/user.dart';

import '../index.dart';

class FractalUsers extends StatefulWidget {
  final EdgeInsets? padding;
  final NodeFractal? node;
  final Frac<String> search;

  const FractalUsers({
    super.key,
    this.node,
    required this.search,
    this.padding,
  });

  @override
  State<FractalUsers> createState() => FractalUsersState();
}

class FractalUsersState extends State<FractalUsers> {
  @override
  void initState() {
    defaultFilter.listen(newUser);
    checkFilter();
    widget.search.addListener(() {
      checkFilter();
    });

    super.initState();
  }

  @override
  dispose() {
    defaultFilter.unListen(newUser);
    super.dispose();
  }

  checkFilter() {
    final s = widget.search.value;
    if (s.isNotEmpty) {
      setState(() {
        if (users != null) {
          users!
            ..unListen(newUser)
            ..dispose();
        }
        users = makeFilter(s);
        users!.listen(newUser);
      });
    } else if (users != null) {
      setState(() {
        users = null;
      });
    }
  }

  CatalogFractal<UserFractal>? users;
  static var defaultFilter = makeFilter('');
  static CatalogFractal<UserFractal> makeFilter(String name) =>
      CatalogFractal<UserFractal>(
        filter: (name.isNotEmpty) ? {'name': '%$name%'} : {},
        source: UserFractal.controller,
      )
        ..createdAt = 2
        ..synch();

  newUser([UserFractal? u]) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final interacts = <UserFractal>[];

    /*
    widget.node?.interactions.list.forEach((inter) {
      if (inter.owner != null && notMe(inter.owner!)) {
        interacts.add(inter.owner!);
      }
    });
    */

    final sorted = (users ?? defaultFilter)
        .list
        //.where((f) => !interacts.contains(f) && notMe(f))
        .toList();
    sorted.sort((a, b) => a.name.compareTo(b.name));

    return ListView(
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
        ...sorted.map(
          (f) => FractalMovable(
            event: f,
            child: FractalUser(
              f,
              onTap: () {
                FractalLayoutState.active.go(f);
              },
            ),
          ),
        ),
      ],
    );
  }

  bool notMe(UserFractal user) {
    return UserFractal.active.value != user;
  }
}
