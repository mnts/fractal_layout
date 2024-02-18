import 'dart:async';

import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_socket/index.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:velocity_x/velocity_x.dart';

import '../layout.dart';

class AuthArea extends StatefulWidget {
  const AuthArea({super.key});

  @override
  State<AuthArea> createState() => _AuthAreaState();
}

class _AuthAreaState extends State<AuthArea> {
  final _ctrlName = TextEditingController();
  final _ctrlPassword = TextEditingController();

  String? _errName;
  String? _errPass;

  UserFractal? user;

  Timer? _timer;

  @override
  void initState() {
    _ctrlName.addListener(() {
      setState(() {
        filter = null;
        user = null;
      });
      if (_ctrlName.text.length > 3) {
        _timer?.cancel();
        _timer = Timer(
          const Duration(milliseconds: 500),
          search,
        );
      }
    });
    super.initState();
  }

  CatalogFractal<UserFractal>? filter;
  void search() async {
    filter?.dispose();
    setState(() {
      filter = makeCatalog();
    });
    refresh();
  }

  refresh([UserFractal? u]) {
    setState(() {
      user = (filter?.list != null && filter!.list.isNotEmpty)
          ? filter!.list[0]
          : null;
    });
  }

  CatalogFractal<UserFractal> makeCatalog() => CatalogFractal<UserFractal>(
        filter: {
          'node': {'name': _ctrlName.text},
        },
        source: UserFractal.controller,
      )
        ..createdAt = 2
        ..synch()
        ..listen(refresh);

  validate() {
    final name = _ctrlName.text;
    _errName = null;
    _errPass = null;

    if (name.length < 4) {
      _errName = 'too short (min. 4 symbols)';
    }

    final password = _ctrlPassword.text;
    if (password.length < 6) {
      _errPass = 'too short (min. 6 symbols)';
    }

    setState(() {});
    return (_errName == null && _errPass == null);
  }

  register() async {
    if (!validate()) return;

    final name = _ctrlName.text;
    /*
    final u = await UserFractal.byName(name);
    if (u != null) {
      return setState(() {
        _errName = 'User already exists';
      });
    }
    */
    final user = UserFractal(
      //eth: address,
      name: name,
      password: _ctrlPassword.text,
    );
    user.synch();
    UserFractal.activate(user);
  }

  login() {
    if (!validate()) return;
    if (user == null) {
      return setState(() {
        _errName = 'User not found';
      });
    }

    final password = _ctrlPassword.text;
    if (user!.auth(password)) {
      UserFractal.activate(user!);
      FractalLayoutState.active.go();
    } else {
      setState(() {
        _errPass = 'Wrong password';
      });
    }
  }

  bool agree = false;
  close() {
    /*
    if (!UserFractal.active.isNull) {
      Navigator.pop(context);
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        runSpacing: 12,
        children: [
          TextFormField(
            controller: _ctrlName,
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.person),
              label: const Text('Username'),
              error: buildError(_errName),
            ),
          ),
          TextFormField(
            controller: _ctrlPassword,
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.lock),
              label: const Text('Password'),
              error: buildError(_errPass),
            ),
            obscureText: true,
          ),
          (user == null)
              ? Row(children: [
                  Checkbox(
                    //checkColor: Colors.white,
                    //fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: agree,
                    onChanged: (bool? value) {
                      setState(() {
                        agree = value!;
                      });
                    },
                  ),
                  const Text('I agree to'),
                  TextButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(
                      EdgeInsets.all(4),
                    )),
                    isSemanticButton: false,
                    child: const Text(
                      'the terms of service',
                    ),
                  )
                ])
              : FractalUser(user!),
          if (filter != null)
            Listen(
              filter!,
              (context, child) =>
                  filter!.list.isEmpty ? registerButton : loginButton,
            ),
        ],
      ),
    );
  }

  Widget get registerButton => ElevatedButton.icon(
        icon: const Icon(Icons.person_add),
        onPressed: () {
          register();
          if (!AppFractal.active.isGated) close();
        },
        label: const Text('Create account'),
      );
  Widget get loginButton => ElevatedButton.icon(
        icon: const Icon(Icons.login),
        onPressed: () {
          login();
          if (!AppFractal.active.isGated) close();
        },
        label: const Text('Log in'),
      );

  Widget? buildError(String? msg) => msg != null
      ? Text(
          msg,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        )
      : null;
}
