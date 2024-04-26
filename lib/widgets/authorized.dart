import 'package:flutter/material.dart';
import 'package:signed_fractal/signed_fractal.dart';

class AuthorizedUser extends StatefulWidget {
  final UserFractal user;
  const AuthorizedUser({
    super.key,
    required this.user,
  });

  @override
  State<AuthorizedUser> createState() => _AuthorizedState();
}

class _AuthorizedState extends State<AuthorizedUser> {
  UserFractal get user => widget.user;
  late final ctrl = TextEditingController(
    text: user.title.value?.content ?? '',
  );

  @override
  void initState() {
    user.title.listen((val) {
      ctrl.text = val?.content ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (MediaQuery.of(context).size.width > 200)
          Container(
            width: 180,
            padding: const EdgeInsets.fromLTRB(
              18,
              0,
              8,
              0,
            ),
            child: TextField(
              maxLines: 1,
              textAlign: TextAlign.end,
              onSubmitted: (v) {
                user.write('title', v);
              },
              controller: ctrl,
              decoration: InputDecoration(
                isDense: true,
                fillColor: Colors.transparent,
                hintText: user.name, //?? user.eth ?? '#${user.id}',
              ),
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.person,
          ),
        )
      ],
    );
  }
}
