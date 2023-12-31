import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fractal_socket/index.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:velocity_x/velocity_x.dart';

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

  @override
  void initState() {
    _ctrlName.addListener(() {
      if (_ctrlName.text.length > 3) search();
    });
    super.initState();
  }

  CatalogFractal? filter;
  search() async {
    filter?.dispose();
    filter = CatalogFractal({'name': _ctrlName.text})..synch();

    if (filter?.list.first case UserFractal? u) {
      setState(() {
        user = u;
        _errPass = null;
      });
    }
  }

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
    final u = await UserFractal.byName(name);
    if (u != null) {
      return setState(() {
        _errName = 'User already exists';
      });
    }
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
    } else {
      setState(() {
        _errPass = 'Wrong password';
      });
    }
  }

  bool agree = false;

  @override
  Widget build(BuildContext context) {
    close() {
      if (!UserFractal.active.isNull) {
        Navigator.pop(context);
      }
    }

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
          Row(children: [
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
          ]),
          user == null
              ? ElevatedButton.icon(
                  icon: const Icon(Icons.person_add),
                  onPressed: () {
                    register();
                    close();
                  },
                  label: const Text('Create account'),
                )
              : ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  onPressed: () {
                    login();
                    close();
                  },
                  label: const Text('Log in'),
                ),
        ],
      ),
    );
  }

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
