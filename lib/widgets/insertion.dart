import 'dart:ui';
import 'package:fleather/fleather.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import '../index.dart';
import '../widget.dart';

class FInsertion extends StatefulWidget {
  final EventFractal f;
  const FInsertion(this.f, {super.key});

  static dialog(EventFractal f) {
    showDialog(
      context: FractalScaffoldState.active.context,
      builder: (ctx) => FDialog(
        width: 240,
        height: 320,
        child: FInsertion(f),
      ),
    );
  }

  static void selectorDialog(NodeFractal node) {
    showDialog(
      context: FractalScaffoldState.active.context,
      builder: (ctx) => FDialog(
        width: 480,
        height: 640,
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Watch<Fractal>(
                  node,
                  (ctx, ch) => ScreensArea(
                    node: node,
                    expand: (next) {
                      Navigator.of(ctx).pop();
                      FInsertion.selectorDialog(next);
                    },
                    onTap: (f) {
                      Navigator.of(ctx).pop();
                      FInsertion.dialog(f);

                      /*

                switch (f) {
                  case ScreenFractal screen:
                    final node = ScreenFractal(
                      name: screen.name,
                      to: widget.node,
                      extend: screen,
                    );
                    node.doHash();
                    consentDialog(node);
                }
                */
                    },
                  ),
                ),
              ),
            ),
            if (node.to case Rewritable rew)
              Positioned(
                bottom: 4,
                left: 4,
                child: IconButton.filled(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    if (rew case NodeFractal node) {
                      FInsertion.selectorDialog(node);
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                  ),
                ),
              ),
            Positioned(
              bottom: 4,
              left: 44,
              child: IconButton.filled(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  FInsertion.selectorDialog(AppFractal.active);
                },
                icon: const Icon(
                  Icons.home,
                ),
              ),
            ),
            if (node case NodeFractal node)
              Positioned(
                bottom: 4,
                right: 4,
                child: IconButton.filled(
                  onPressed: () {
                    FractalSubState.modal(
                      to: node,
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  State<FInsertion> createState() => _FInsertionState();
}

class _FInsertionState extends State<FInsertion> {
  static final options = ['tile', 'content', 'text'];

  bool isBlock = false;
  String type = 'tile';

  @override
  Widget build(BuildContext context) {
    final layout = FractalLayoutState.active;

    return Stack(
      children: [
        Positioned.fill(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(4, 50, 4, 2),
            children: [
              Row(
                children: [
                  Checkbox(
                      value: isBlock,
                      onChanged: (b) {
                        setState(() {
                          isBlock = b!;
                        });
                      }),
                  const Expanded(
                    child: Text('Entire block'),
                  ),
                ],
              ),
              DropdownMenu<String>(
                initialSelection: type,
                dropdownMenuEntries: [
                  ...options.map(
                    (m) => DropdownMenuEntry<String>(
                      label: m.capitalize,
                      value: m,
                    ),
                  ),
                ],
                onSelected: (o) {
                  setState(() {
                    type = o!;
                  });
                },
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 48, color: layout.color,
            //backgroundColor: widget.fractal.skin.color.toMaterial,

            //mainAxisAlignment: MainAxisAlignment.spaceBetween,

            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 2),
                child: TextButton.icon(
                  onPressed: () {
                    if (widget.f case NodeFractal node) {
                      ConfigFArea.openDialog(node);
                    }
                  },
                  style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 4),
                    ),
                  ),
                  icon: SizedBox.square(
                    dimension: 32,
                    child: FIcon(
                      widget.f,
                      noImage: true,
                      color: Colors.white,
                    ),
                  ),
                  label: FTitle(
                    widget.f,
                    style: FractalSubState.textStyle,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton.filled(
            onPressed: insert,
            icon: const Icon(Icons.check),
          ),
        ),
      ],
    );
  }

  insert() {
    final controller = DocumentArea.ctrl;
    if (controller == null) return;
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;
    // Move the cursor to the beginning of the line right after the embed.
    // 2 = 1 for the embed itself and 1 for the newline after it
    final newSelection = controller.selection.copyWith(
      baseOffset: index + 2,
      extentOffset: index + 2,
    );

    final data = {'hash': widget.f.hash};

    Object block = isBlock
        ? BlockEmbed(
            type,
            data: data,
          )
        : SpanEmbed(
            type,
            data: data,
          );

    if (type == 'text') {
      if (widget.f case NodeFractal node) {
        final doc = node.document;
        if (doc != null) {
          block = doc.toPlainText();
        }
      }
    }

    controller.replaceText(
      index,
      length,
      block,
      selection: newSelection,
    );
  }
}
