import 'package:flutter/material.dart';
import 'package:fractal_layout/index.dart';
import 'package:go_router/go_router.dart';

final auth = GoRoute(
  path: '/auth',
  builder: (context, state) => const AuthRoute(),
);

class AuthRoute extends StatelessWidget {
  const AuthRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return FractalScaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 300,
          ),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade200.withAlpha(100),
          ),
          child: const AuthArea(),
        ),
      ),
    );
  }
}
