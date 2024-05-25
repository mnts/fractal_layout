import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signed_fractal/fr.dart';
import 'package:signed_fractal/signed_fractal.dart';

class FRL<V extends EventFractal> extends StatelessWidget {
  final FR<V>? fr;
  final Widget Function(V) cb;
  final Widget? def;
  const FRL(this.fr, this.cb, {super.key, this.def});

  @override
  Widget build(BuildContext context) {
    return fr?.future != null
        ? FutureBuilder(
            future: fr!.future,
            builder: ((context, snap) => snap.data != null
                ? cb(snap.data!)
                : def ?? const CupertinoActivityIndicator()),
          )
        : def ?? const SizedBox();
  }
}
