import 'dart:ui';
import 'package:app_fractal/index.dart';
export 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
export 'package:flutter/material.dart' hide VoidCallback;
import 'package:fractal_flutter/index.dart';
export 'package:fractal_flutter/index.dart' hide ValueWidgetBuilder;
import 'controllers/scaffold.dart';
import 'index.dart';

class FractalAreaWidget<T extends NodeFractal> extends FractalWidget<T> {
  final Widget Function() builder;
  FractalAreaWidget(super.node, this.builder, {super.key});
  @override
  area() => builder();
}

class FractalWidget<T extends Fractal> extends StatelessWidget
    with FractalWidgetMix<T> {
  FractalWidget(T f, {super.key}) {
    this.f = f;
  }
}

class FEventWidget<T extends EventFractal> extends FractalWidget<T> {
  FEventWidget(super.f, {super.key});
  @override
  Widget card() {
    var hasVideo = false;

    if (f case NodeFractal node) hasVideo = node.video != null;
    return Builder(
      builder: (context) => Container(
        //onPressed: () {},
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(5),
        ),
        constraints: BoxConstraints(
          maxHeight: double.tryParse('${f['height']}') ?? 200,
          //maxWidth: 250,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: InkWell(
                child: FIcon(f),
                onLongPress: () {
                  if (f case NodeFractal node) {
                    ConfigFArea.openDialog(node);
                  }
                },
                onTap: () {
                  f.onTap(context);
                },
                /*
                    onTap: () {
                      if (f case NodeFractal node) {
                        FractalLayoutState.active.go(node);
                      }
                    },
                      */
              ),
            ),
            if (hasVideo)
              Center(
                child: IconButton.filled(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.grey.shade700.withAlpha(180),
                    ),
                  ),
                  onPressed: () {
                    if (f case NodeFractal node) {
                      FractalLayoutState.active.go(node);
                    }
                  },
                  icon: const Icon(
                    Icons.play_arrow,
                  ),
                ),
              ),
            /*
          if (widget.trailing != null)
            Positioned(
              top: 2,
              right: 2,
              child: widget.trailing!,
            ),
            */
            if (f is NodeFractal && f['price'] != null)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 4,
                    right: 4,
                    top: 2,
                    bottom: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${f['price']}€',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(
                        180,
                        120,
                        20,
                        1,
                      ),
                    ),
                  ),
                ),
              ),
            if (f case NodeFractal node)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 4,
                      sigmaY: 4,
                    ),
                    child: Container(
                      color: Colors.white.withAlpha(100),
                      padding: const EdgeInsets.all(2),
                      alignment: Alignment.center,
                      child: Column(children: [
                        if (node.description != null)
                          Text(
                            node.description ?? '',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 12,
                              height: 1,
                            ),
                          ),
                        FTitle(f),
                      ]),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FNodeWidget<T extends NodeFractal> extends FEventWidget<T> {
  FNodeWidget(super.f, {super.key});
  Rewritable? rewritable;
  @override
  build(context) {
    rewritable = context.read<Rewritable?>();
    return FractalNodeIn(
      node: super.f,
      context: context,
      child: super.build(context),
    );
  }

  @override
  area() => FCardNode(f);
}

class FDialogWidgetCtrl extends FChangeNotifier {}

mixin FractalWidgetMix<T extends Fractal> on StatelessWidget {
  late final T f;

  Color get color => FractalLayoutState.active.theme.primaryColor;

  late BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return switch (f) {
      NodeFractal node => Listen(
          node,
          (ctx, child) => _build(ctx),
          preload: 'rewriter',
        ),
      _ => _build(context)
    };
  }

  Widget _build(BuildContext context) {
    final dialogCtrl = context.read<FDialogCtrl?>();
    final scaffoldCtrl = context.read<FScaffoldCtrl?>();
    if (dialogCtrl != null) {
      final topF = context.read<Fractal?>();
      return topF == null ? dialog() : onlyArea();
    }
    return scaffoldCtrl == null ? scaffold() : onlyArea();
  }

  Widget onlyArea() => LayoutBuilder(
        builder: (ctx, con) {
          return (con.maxWidth < 320 && con.maxHeight < 320) ? thumb() : area();
        },
      );

  Widget thumb() => card();

  Widget scaffold() => FractalScaffold(
        node: f,
        body: area(),
      );

  static final headerTextStyle = TextStyle(
    fontSize: 18,
    color: AppFractal.active.wb,
    fontWeight: FontWeight.bold,
  );

  Widget dialog() {
    return Stack(children: [
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: color,
          ),
          padding: const EdgeInsets.all(4),
          //backgroundColor: widget.fractal.skin.color.toMaterial,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 2),
              child: Theme(
                data: ThemeData(
                  listTileTheme: const ListTileThemeData(
                    textColor: Colors.white,
                    iconColor: Colors.white,
                  ),
                ),
                child: bar(),
              ),
            ),
          ),
        ),
      ),
      Positioned.fill(
        child: FractalLayer(
          pad: const EdgeInsets.only(top: 60),
          child: Watch<Fractal>(
            f,
            (ctx, ch) => area(),
          ),
        ),
      ),
    ]);
  }

  Widget bar() => Row(children: [
        icon(),
        const SizedBox(
          width: 4,
        ),
        title(),
        const Spacer(),
        buttonMaximize(),
      ]);

  Widget title() => FTitle(
        f,
        style: headerTextStyle,
      );

  Widget icon() => Container(
        width: 46,
        height: 46,
        padding: const EdgeInsets.all(2),
        child: FIcon(f, color: Colors.white),
      );

  Widget buttonMaximize() {
    return Builder(
      builder: (context) => IconButton.filled(
        onPressed: () {
          switch (f) {
            case NodeFractal node:
              Navigator.pop(context);
              FractalLayoutState.active.go(node);
          }
        },
        icon: const Icon(Icons.home_max_rounded),
      ),
    );
  }

  Widget area() {
    return switch (f) { NodeFractal node => FNodeArea(node), _ => card() };
  }

  Widget card() {
    return FractalTile(f);
  }
}
