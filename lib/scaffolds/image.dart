import '../section/images.dart';
import '../widget.dart';
import '../widgets/layer.dart';

class FractalImg extends FNodeWidget {
  FractalImg(super.node, {super.key});

  @override
  area() {
    return Builder(
      key: f.widgetKey('img'),
      builder: (ctx) => InteractiveViewer(
        trackpadScrollCausesScale: true,
        boundaryMargin: FractalPad.maybeOf(ctx)?.pad ?? EdgeInsets.zero,
        child: FractalImage(
          f.file!,
        ),
      ),
    );
  }
}
