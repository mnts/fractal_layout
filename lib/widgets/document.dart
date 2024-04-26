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
import '../models/ui.dart';
import 'insertion.dart';

class DocumentArea extends StatefulWidget {
  final ScreenFractal screen;
  final EdgeInsets? padding;
  static FleatherController? ctrl;
  final bool editable;
  final bool onlyContent;

  const DocumentArea(
    this.screen, {
    super.key,
    this.onlyContent = false,
    this.padding,
    this.editable = true,
  });

  static insert(EventFractal f) {
    final controller = ctrl;
    if (controller == null) return;
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;
    // Move the cursor to the beginning of the line right after the embed.
    // 2 = 1 for the embed itself and 1 for the newline after it
    final newSelection = controller.selection.copyWith(
      baseOffset: index + 2,
      extentOffset: index + 2,
    );

    final block = SpanEmbed(
      'tile',
      data: {'hash': f.hash},
    );

    controller.replaceText(
      index,
      length,
      block,
      selection: newSelection,
    );
  }

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
      'content' => FractalPick(
          node.value.data['hash'],
          builder: (f) => switch (f) {
            NodeFractal node => Container(
                  color: Colors.grey.shade100.withAlpha(200),
                  height: 300,
                  child: f.ui.area?.call(node, context),
                ) ??
                FractalTile(f),
            _ => FractalTile(f),
          },
        ),
      _ => Container(),
    };
  }

  @override
  State<DocumentArea> createState() => _DocumentAreaState();
}

class _DocumentAreaState extends State<DocumentArea> {
  var _ctrl = FleatherController();

  ScreenFractal get screen => widget.screen;

  late final myInteraction = screen.myInteraction;

  @override
  void initState() {
    _focused = focusNode.hasFocus;
    focusNode.addListener(_editorFocusChanged);

    _ctrl.document.changes.listen((d) {
      print(d);
    });
    init();
    screen.addListener(() {
      init();
    });
    screen.preload();

    Future.delayed(
      const Duration(milliseconds: 300),
    ).then((d) {
      setState(() {
        ready = true;
      });
    });

    super.initState();
  }

  bool ready = false;

  VideoPlayerController? videoCtrl;
  void init() {
    var doc = widget.screen.document;
    if (doc == null) {
      if (widget.screen.extend case ScreenFractal screen) {
        doc = screen.document;
      }
    }

    _ctrl.dispose();
    _ctrl = FleatherController(document: doc);
    DocumentArea.ctrl = _ctrl;
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
                      controller: _ctrl,
                    ),
                  )
                : Container(),
          ),
          /*
          if (_focused)
            IconButton.filled(
              onPressed: insertModal,
              icon: const Icon(Icons.menu),
              tooltip: 'menu',
            ),
            */
          if (_focused)
            IconButton.filled(
              onPressed: () {
                FInsertion.selectorDialog(screen.extend ?? screen);
              },
              icon: const Icon(Icons.post_add_sharp),
              tooltip: 'add',
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
      _ctrl.document.toJson(),
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
    return rew == null
        ? Watch<Rewritable?>(
            widget.screen,
            (context, child) => view,
          )
        : view;
  }

  Rewritable? get rew => context.read<Rewritable?>();

  Widget get view => widget.onlyContent
      ? editor()
      : Stack(
          children: [
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
            Positioned.fill(
              child: Theme(
                data: ThemeData(
                  textTheme: const TextTheme(
                    bodyMedium: TextStyle(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0, // shadow blur
                          offset:
                              Offset(2.0, 2.0), // how much shadow will be shown
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
                child: (screen.image != null) ? animated() : editor(),
              ),
            ),
            if (widget.editable) buildCtrl(),
          ],
        );

  Widget animated() {
    return AnimatedOpacity(
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
    );
  }

  final scrollCtrl = ScrollController();
  Widget editor() {
    return FleatherField(
      key: screen.widgetKey('document${_focused ? 1 : 0}'),
      padding: widget.padding ?? const EdgeInsets.all(8),
      //focusNode: focusNode,
      //enableInteractiveSelection: false,
      controller: _ctrl,
      expands: false,
      embedBuilder: DocumentArea.embedBuilder,
      showCursor: _focused,
      readOnly: !_focused,
      //scrollable: false,
      //scrollController: scrollCtrl,
    );
  }

  @override
  dispose() {
    focusNode.unfocus();
    focusNode.dispose();
    //DocumentScaffold.ctrl = null;
    _ctrl.dispose();
    super.dispose();
  }
}
