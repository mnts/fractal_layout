import 'dart:convert';

import 'package:app_fractal/index.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signature/signature.dart';
import 'package:signed_fractal/models/node.dart';

import '../index.dart';
import '../widgets/create.dart';
import 'screens.dart';

class FractalConsent extends StatefulWidget {
  final ScreenFractal screen;
  final UserFractal user;
  final Function()? onSigned;
  const FractalConsent({
    required this.screen,
    required this.user,
    this.onSigned,
    super.key,
  });

  @override
  State<FractalConsent> createState() => _FractalFormState();
}

class _FractalFormState extends State<FractalConsent> {
  FleatherController? controller;

  ScreenFractal get screen => widget.screen;

  ParchmentDocument get document {
    final d = doc;

    return d.isEmpty
        ? ParchmentDocument()
        : ParchmentDocument.fromJson(
            jsonDecode(
              doc,
            ),
          );
  }

  String get doc {
    String str = '';
    if (screen['doc'] case String str1) {
      str = str1;
    }

    if (node != null) {
      str = str.replaceAllMapped(
        RegExp(r'\{\w+\}'),
        (match) {
          final s = str.substring(match.start, match.end);
          final name = s.substring(1, s.length - 1);
          final d = node![name];
          if (d case String str) return str;

          return s;
        },
      );
    }
    return str;
  }

  @override
  void initState() {
    controller = FleatherController(
      document: screen.document,
    );

    super.initState();
  }

  late final node = widget.screen.myInteraction;

  final _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: const Color.fromARGB(255, 82, 90, 97),
  );

  @override
  Widget build(BuildContext context) {
    return (isSubmitted || widget.user != UserFractal.active.value)
        ? ListView(
            padding: const EdgeInsets.all(8),
            children: buildList(),
          )
        : ListView(
            padding: const EdgeInsets.all(8),
            children: [
              FSortable(
                sorted: screen.sorted,
                builder: (f) => FractalTile(f),
              ),
              FilledButton.icon(
                onPressed: () {
                  setState(() {
                    isSubmitted = true;
                  });
                },
                icon: const Icon(Icons.check),
                label: const Text('Submit'),
              ),
            ],
          );
  } // current system is infusing slavery upon the cnsciousness of humanity

  bool isSubmitted = false;

  void sign() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        clipBehavior: Clip.hardEdge,
        backgroundColor: Colors.white.withAlpha(200),
        child: SizedBox(
          width: 480,
          height: 320,
          child: Stack(
            children: [
              Signature(
                controller: _controller,
                width: 480,
                height: 320,
                backgroundColor: Colors.white,
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: IconButton.filled(
                  onPressed: () async {
                    final bytes = await _controller.toPngBytes();
                    if (bytes == null) return;
                    final img = ImageF.bytes(bytes);
                    img.publish();
                    setState(() {
                      node.image = img;
                      node.write(
                        'image',
                        img.name,
                      );
                      widget.onSigned?.call();
                    });
                  },
                  icon: const Icon(
                    Icons.check,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildList() {
    return [
      Listen(
        node.m,
        (context, child) => FleatherEditor(
          controller: FleatherController(
            document: document,
          ),
          readOnly: true,
        ),
      ),
      if (node.image != null)
        SizedBox(
          height: 180,
          child: FractalImage(node!.image!),
        )
      else if (widget.user == UserFractal.active.value)
        Signature(
          controller: _controller,
          width: 320,
          height: 240,
          backgroundColor: Colors.grey,
        ),
      if (node.image == null && widget.user == UserFractal.active.value)
        IconButton.filled(
          onPressed: () async {
            final bytes = await _controller.toPngBytes();
            if (bytes == null) return;
            final img = ImageF.bytes(bytes);
            img.publish();
            setState(() {
              node.image = img;
              node.write(
                'image',
                img.name,
              );
            });
          },
          icon: const Icon(
            Icons.check,
          ),
        ),
      if (node['price'] != null)
        FilledButton(
          onPressed: () {
            sign();
          },
          child: Text('Pay ${node['price']}€'),
        )
    ];
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
                  to: screen,
                  //extend:
                  onCreate: (f) {
                    setState(() {
                      screen
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
