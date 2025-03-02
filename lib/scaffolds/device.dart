import '../widget.dart';
import '../widgets/layer.dart';

class FractalDevice extends FractalWidget {
  FractalDevice(super.node, {super.key});

  @override
  area() {
    return Builder(
      builder: (ctx) => ListView(
        padding: FractalPad.of(ctx).pad,
        children: [
          Row(children: [
            Text(
              FileF.path,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const Spacer(),
            IconButton.filled(
              onPressed: () {},
              icon: const Icon(
                Icons.folder_zip_outlined,
                size: 22,
              ),
            )
          ]),
        ],
      ),
    );
  }
}
