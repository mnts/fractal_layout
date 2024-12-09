import 'dart:ui';
import 'package:app_fractal/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_base/fractals/device.dart';

class PostArea extends StatefulWidget {
  final EventFractal? to;
  const PostArea({super.key, this.to});

  @override
  State<PostArea> createState() => _PostAreaState();
}

class _PostAreaState extends State<PostArea> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();

  final images = <ImageF>[];
  ImageF? image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return /*Container(
      height: 90,
      color: Colors.grey.shade200.withOpacity(0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          */
        ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 3),
        child: Container(
          height: 38,
          width: double.infinity,
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () async {
                  if (image != null) {
                    return setState(() {
                      image = null;
                    });
                  }
                  final img = await FractalImage.pick();
                  if (img != null) {
                    setState(() {
                      image = (img);
                    });
                  }
                },
                visualDensity: VisualDensity.compact,
                icon: image != null
                    ? FractalImage(image!)
                    : Icon(
                        Icons.add,
                        color: theme.colorScheme.primary,
                      ),
              ),
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  onSubmitted: post,
                  autofocus: true,
                  focusNode: _focus,
                  style: TextStyle(
                    color: AppFractal.active.bw,
                    shadows: [
                      Shadow(
                        color: AppFractal.active.wb,
                        blurRadius: 2,
                      )
                    ],
                  ),
                  scrollPadding: const EdgeInsets.all(2),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(
                      left: 2,
                      right: 1,
                      top: 0,
                      bottom: 4,
                    ),
                    fillColor: Colors.transparent,
                    hintText: "Write message...",
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  post(_ctrl.text);
                },
                icon: Icon(
                  color: theme.colorScheme.primary,
                  Icons.send,
                ),
              ),
            ],
          ),
        ),
      ),
    ); /*,
        ],
      ),
    )*/
  }

  post(String msg) {
    final post = EventFractal(
      content: msg,
      to: widget.to,
      //file: image,
    )..synch();
    if (kDebugMode) {
      print(post);
    }
    setState(() {
      image = null;
    });
    _ctrl.clear();
    _focus.requestFocus();
  }
}
