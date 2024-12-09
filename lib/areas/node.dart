import 'dart:ui';

import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:video_player/video_player.dart';

class FNodeArea extends StatefulWidget {
  final NodeFractal node;
  const FNodeArea(this.node, {super.key});

  @override
  State<FNodeArea> createState() => _FNodeAreaState();
}

class _FNodeAreaState extends State<FNodeArea> {
  @override
  void initState() {
    init();
    widget.node.addListener(init);

    /*
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        const Duration(milliseconds: 300),
      ).then((d) {
        setState(() {});
      });
    });
    */

    super.initState();
  }

  @override
  dispose() {
    widget.node.removeListener(init);
    videoCtrl?.dispose();
    super.dispose();
  }

  VideoPlayerController? videoCtrl;
  void init() {
    if (widget.node.video != null && videoCtrl == null) {
      videoCtrl = VideoPlayerController.networkUrl(
        Uri.parse(widget.node.video!.url),
      )..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.node.image != null)
          Positioned.fill(
            child: Hero(
              tag: widget.node.widgetKey('f'),
              child: FractalImage(
                widget.node.image!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        if (videoCtrl != null && videoCtrl!.value.isInitialized)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Center(
                child: AspectRatio(
                  aspectRatio: videoCtrl!.value.aspectRatio,
                  child: VideoPlayer(videoCtrl!),
                ),
              ),
            ),
          ),
        if (videoCtrl != null)
          Center(
            child: IconButton.filled(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.grey.shade700.withAlpha(180),
                ),
              ),
              onPressed: () {
                setState(() {
                  videoCtrl!.value.isPlaying
                      ? videoCtrl!.pause()
                      : videoCtrl!.play();
                });
              },
              icon: Icon(
                videoCtrl!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          ),
      ],
    );
  }
}
