import 'dart:convert';

import 'package:app_fractal/index.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/models/node.dart';

import '../index.dart';
import '../widgets/create.dart';
import 'screens.dart';

class FractalForm extends StatefulWidget {
  final NodeFractal node;
  final Rewritable rewriter;
  const FractalForm({
    required this.node,
    required this.rewriter,
    super.key,
  });

  @override
  State<FractalForm> createState() => _FractalFormState();
}

class _FractalFormState extends State<FractalForm> {
  @override
  void initState() {
    super.initState();
  }

  NodeFractal? node;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Stack(children: [
      Center(
        /*
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        */
        child: Watch<Rewritable>(
          widget.rewriter,
          (ctx, child) => Container(
            width: 400,
            alignment: Alignment.center,
            child: ScreensArea(
              node: widget.node,
            ),
          ),
        ),
      ),
      buildPlus()
    ]);
  }

  Widget buildPlus() {
    return Positioned(
      bottom: 2,
      right: 2,
      child: IconButton.filled(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => Dialog(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                  maxHeight: 900,
                ),
                child: CreateNodeF(
                  to: widget.node,
                  //extend:
                  onCreate: (f) {
                    setState(() {
                      widget.node
                        ..sorted.order(f)
                        ..sort();

                      Navigator.of(ctx).pop();
                    });
                  },
                ),
              ),
            ),
          );
        },

        //shape: const CircleBorder(),
        //foregroundColor: theme.primaryColor,
        //backgroundColor: theme.colorScheme.primary,
        icon: const Icon(Icons.add),
      ),
    );
  }
}
