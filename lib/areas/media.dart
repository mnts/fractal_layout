import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:video_player/video_player.dart';

import '../index.dart';

class MediaArea extends StatefulWidget {
  final NodeFractal node;
  final BoxFit fit;
  const MediaArea({
    super.key,
    this.fit = BoxFit.cover,
    required this.node,
  });

  @override
  State<MediaArea> createState() => _MediaAreaState();
}

class _MediaAreaState extends State<MediaArea> {
  NodeFractal get f => widget.node;

  VideoPlayerController? videoCtrl;

  @override
  void initState() {
    super.initState();
    checkVideo();
    f.addListener(() {
      checkVideo();
    });
  }

  void checkVideo() {
    if (f.video != null && videoCtrl == null) {
      videoCtrl = VideoPlayerController.networkUrl(
        Uri.parse(f.video!.url),
      )..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (f.image != null)
          Positioned.fill(
            child: FractalImage(
              f.image!,
              fit: widget.fit,
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

  @override
  void dispose() {
    super.dispose();
    videoCtrl?.dispose();
  }
}
