import 'dart:async';
import 'dart:ui';
import 'package:fractal_layout/index.dart';
import '../widget.dart';

class FractalSized extends StatefulWidget {
  final NodeFractal f;
  const FractalSized(this.f, {super.key});

  @override
  State<FractalSized> createState() => _FractalSizedState();
}

class _FractalSizedState extends State<FractalSized> {
  MemoryImage? image;
  ImageInfo? _img;

  Future<ImageInfo> get img async {
    final bytes = await widget.f.image!.load();
    final comp = Completer<ImageInfo>();
    image ??= MemoryImage(
      bytes,
    );

    image!
        .resolve(
      const ImageConfiguration(),
    )
        .addListener(
      ImageStreamListener((inf, b) {
        _img = inf;
        comp.complete(inf);
      }),
    );
    return comp.future;
  }

  late final descCtrl = TextEditingController(
    text: widget.f.description ?? '',
  );

  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
      } else {
        if (descCtrl.text != widget.f.description) {
          widget.f.write('description', descCtrl.text);
        }
      }
      setState(() {});
    });

    widget.f.addListener(() {
      descCtrl.text = widget.f.description ?? '';
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constrains) {
        double w = 200,
            h = constrains.maxHeight == double.infinity
                ? 200
                : constrains.maxHeight;

        return Listen(
          widget.f,
          (ctx, child) {
            /*
            if (widget.f.image == null) {
              return SizedBox(
                width: w,
                height: h,
                child: Center(
                  child: InkWell(
                    onTap: () async {
                      final file = await FractalImage.pick();
                      if (file == null) return;
                      await file.publish();
                      widget.f.write('image', file.name);
                    },
                    child: FIcon(
                      widget.f,
                      size: 128, //constrains.maxHeight,
                    ),
                  ),
                ),
              );
            }
            */

            return FutureBuilder(
              future: img,
              builder: (ctx, snap) {
                final inf = snap.data;

                w = (inf != null) ? inf.image.width * h / inf.image.height : h;

                return SizedBox(
                  width: w,
                  height: h,
                  child: /*HoverOver(
                    builder: (over) => */
                      Stack(
                    children: [
                      if (inf?.image != null)
                        Positioned.fill(
                          child: Image(
                            image: image!,
                            width: w,
                            height: h,
                          ),
                        ),
                      Positioned.fill(
                        child: HoverOver(
                          builder: (hover) => BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: focusNode.hasFocus ? 3 : 0,
                                sigmaY: focusNode.hasFocus ? 3 : 0,
                              ),
                              child: TextFormField(
                                focusNode: focusNode,
                                minLines: null,
                                textAlignVertical: TextAlignVertical.bottom,
                                maxLines: null,
                                expands: true,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                decoration: InputDecoration(
                                  filled: focusNode.hasFocus,
                                  fillColor:
                                      AppFractal.active.wb.withAlpha(100),
                                ),
                                controller: descCtrl,
                              )),
                        ),
                      ),
                      if (inf?.image == null)
                        Positioned(
                          top: 0,
                          left: 0,
                          child: IconButton(
                            onPressed: () async {
                              final file = await FractalImage.pick();
                              if (file == null) return;
                              await file.publish();
                              widget.f.write('image', file.name);
                            },
                            icon: Icon(Icons.add_a_photo),
                          ),
                        ),
                      /*
                          : AnimatedPositioned(
                              left: 4,
                              right: 4,
                              bottom: over ? 4 : -40,
                              duration: Durations.medium2,
                              child: AnimatedOpacity(
                                opacity: over ? 1 : 0,
                                duration: Durations.short2,
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 3,
                                      sigmaY: 3,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color:
                                            AppFractal.active.wb.withAlpha(100),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              ConfigFArea.dialog(widget.f);
                                            },
                                            child: FTitle(
                                              widget.f,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppFractal.active.bw
                                                    .withAlpha(200),
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          if (widget.f.description != null)
                                            Text(
                                              widget.f.description!,
                                              maxLines: 4,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            */
                    ],
                  ),
                  //),
                );
                //child: ,
              },
            );
          },
          preload: 'rewriter',
        );
      },
    );
  }
}
