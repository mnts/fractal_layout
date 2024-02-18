import 'package:flutter/material.dart';
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
      title: Signature(
        controller: _controller,
        //width: 480,
        //height: 120,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
