import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';

import 'index.dart';

class FractalGate extends StatefulWidget {
  const FractalGate({super.key});

  @override
  State<FractalGate> createState() => _FractalGateState();
}

class _FractalGateState extends State<FractalGate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (ctx, box) => Flex(
          direction: box.maxWidth > 600 ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          //direction: box.maxWidth > 800 ? Axis.horizontal : Axis.vertical,
          children: [
            Expanded(
              child: Container(
                color: FractalLayoutState.active.color,
                height: double.infinity,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(48),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(800),
                      color: Colors.white,
                    ),
                    child: Image.asset(
                      'assets/logo.png',
                    ),
                  ),
                ),
              ),
            ),
            const Expanded(
              child: AuthArea(),
            ),
          ],
        ),
      ),
    );
  }
}
