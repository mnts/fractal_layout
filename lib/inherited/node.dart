import 'package:fractal_layout/widget.dart';
import 'package:fractal/index.dart';

class FractalNodeIn extends InheritedWidget {
  final NodeFractal node;
  final BuildContext context;
  const FractalNodeIn({
    super.key,
    required this.context,
    required this.node,
    required super.child,
  });

  static NodeFractal makeRew() {
    final re = NodeFractal(name: 'create')..doHash();
    return re;
  }

  static FractalNodeIn? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FractalNodeIn>();
  }

  FractalNodeIn? up() => of(context);

  NodeFractal? find(MP filter) {
    FractalNodeIn? nodeIn = this;
    do {
      if (nodeIn!.node.match(filter)) return nodeIn.node;
      nodeIn = nodeIn.up();
    } while (nodeIn != null);
    return null;
  }

  @override
  bool updateShouldNotify(FractalNodeIn oldWidget) => node != oldWidget.node;
}
