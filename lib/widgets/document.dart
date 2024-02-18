import 'dart:convert';
import 'dart:ui';

import 'package:app_fractal/index.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/models/rewriter.dart';
import 'package:video_player/video_player.dart';

import '../builders/pick.dart';
import '../index.dart';

class DocumentArea extends StatefulWidget {
  final ScreenFractal screen;
  final EdgeInsets? padding;
  const DocumentArea(this.screen, {super.key, this.padding});

  static Widget embedBuilder(context, node) {
    final theme = FleatherTheme.of(context)!;
    return switch (node.value.type) {
      'hr' => Divider(
          height:
              theme.paragraph.style.fontSize! * theme.paragraph.style.height!,
          thickness: 2,
          color: Colors.grey.shade200,
        ),
      'tile' => FractalPick(
          node.value.data['hash'],
        ),
      _ => Container(),
    };
  }

  @override
  State<DocumentArea> createState() => _DocumentAreaState();
}

class _DocumentAreaState extends State<DocumentArea> {
  late final controller = FleatherController(
    widget.screen.document,
  );

  ScreenFractal get screen => widget.screen;

  @override
  void initState() {
    _focused = focusNode.hasFocus;
    focusNode.addListener(_editorFocusChanged);
    controller.document.changes.listen((d) {
      print(d);
    });
    checkVideo();
    screen.addListener(() {
      checkVideo();
    });

    Future.delayed(const Duration(milliseconds: 300)).then((d) {
      setState(() {
        ready = true;
      });
    });

    super.initState();
  }

  bool ready = false;

  VideoPlayerController? videoCtrl;
  void checkVideo() {
    if (screen.video != null && videoCtrl == null) {
      videoCtrl = VideoPlayerController.networkUrl(
        Uri.parse(screen.video!.url),
      )..initialize().then((_) {
          setState(() {});
        });
    }
  }

  Widget buildCtrl() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 48,
        child: Row(children: [
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
          if (_focused)
            IconButton.filled(
              onPressed: save,
              icon: const Icon(Icons.save),
              tooltip: 'save',
            ),
          Expanded(
            child: (_focused)
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: FleatherToolbar.basic(
                      controller: controller,
                    ),
                  )
                : Container(),
          ),
          (_focused)
              ? IconButton.filled(
                  onPressed: close,
                  icon: const Icon(Icons.close),
                  tooltip: 'close',
                )
              : IconButton.filled(
                  onPressed: open,
                  icon: const Icon(Icons.edit),
                  tooltip: 'edit',
                ),
        ]),
      ),
    );
  }

  close() {
    //save();
    setState(() {
      _focused = false;
    });
  }

  open() {
    //save();
    setState(() {
      _focused = true;
    });
  }

  save() {
    final doc = jsonEncode(
      controller.document.toJson(),
    );
    widget.screen.write('doc', doc);
  }

  final FocusNode focusNode = FocusNode();

  late bool _focused;

  void _editorFocusChanged() {
    /*
    setState(() {
      _focused = focusNode.hasFocus;
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      if (screen.image != null)
        Positioned.fill(
          child: Hero(
            tag: screen.widgetKey('f'),
            child: FractalImage(
              screen.image!,
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
      Theme(
        data: ThemeData(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0, // shadow blur
                  offset: Offset(2.0, 2.0), // how much shadow will be shown
                ),
              ],
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            //filled: true,
          ),
        ),
        child: AnimatedOpacity(
          opacity: (!ready || (videoCtrl?.value.isPlaying ?? false)) ? 0 : 1,
          duration: const Duration(milliseconds: 600),
          child: Center(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withAlpha(180),
                  ),
                  child: editor(),
                ),
              ),
            ),
          ),
        ),
      ),
      buildCtrl(),
    ]);
  }

  Widget editor() {
    return FleatherEditor(
      key: screen.widgetKey('document'),
      padding: widget.padding ?? const EdgeInsets.all(8),
      focusNode: focusNode,
      //enableInteractiveSelection: false,
      controller: controller,
      //expands: true,
      embedBuilder: DocumentArea.embedBuilder,
      showCursor: _focused,
      readOnly: !_focused,
    );
  }

  @override
  dispose() {
    focusNode.dispose();
    //DocumentScaffold.ctrl = null;
    controller.dispose();
    super.dispose();
  }
}
