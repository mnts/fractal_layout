import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:signature/signature.dart';
import 'package:signed_fractal/signed_fractal.dart';

class FractalSignature extends StatefulWidget {
  final NodeFractal node;
  final Widget? trailing;
  const FractalSignature({
    super.key,
    required this.node,
    this.trailing,
  });

  @override
  State<FractalSignature> createState() => _FractalSignatureState();
}

class _FractalSignatureState extends State<FractalSignature> {
  NodeFractal get f => widget.node;

  final _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: const Color.fromARGB(255, 82, 90, 97),
  );

  Rewritable? get rew => context.read<Rewritable?>();

  static final timer = TimedF();
  ImageF? image;

  @override
  void initState() {
    super.initState();
    if (rew != null) {
      if (rew![f.name] case String fName) {
        setState(() {
          image = ImageF(fName);
        });
      }
    }
    _controller.onDrawEnd = () {
      timer.hold(() async {
        final bytes = await _controller.toPngBytes();
        if (bytes == null) return;
        final img = ImageF.bytes(bytes);
        img.publish();
        if (rew != null) {
          rew!.write(f.name, img.name);

          setState(() {
            image = ImageF(img.name);
          });
        }
      }, 1600);
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox.square(
        dimension: 40,
        child: f.icon,
      ),
      minLeadingWidth: 20,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      trailing: widget.trailing,
      title: image != null
          ? FractalImage(
              image!,
              fit: BoxFit.cover,
            )
          : Signature(
              controller: _controller,
              //width: 480,
              height: 86,
              backgroundColor: Colors.grey.shade100,
            ),
    );
  }
}
