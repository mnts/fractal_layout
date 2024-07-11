import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:go_router/go_router.dart';

import '../areas/config.dart';
import '../areas/settings.dart';
import 'renamable.dart';
import 'tile.dart';

class FTip extends StatefulWidget {
  final NodeFractal node;
  const FTip(this.node, {super.key});

  @override
  State<FTip> createState() => _FTipState();
}

class _FTipState extends State<FTip> {
  NodeFractal get f => widget.node;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppFractal>();

    return Listen<NodeFractal>(
      f,
      (context, child) => Stack(
        children: [
          ListView(
            children: [
              if (f.image != null)
                FractalImage(
                  f.image!,
                  fit: BoxFit.cover,
                )
              else
                const SizedBox(height: 32),
              Row(
                children: [
                  FilledButton(
                    onPressed: () {
                      FractalLayoutState.active.go(f);
                    },
                    child: Row(
                      children: [
                        f.ctrl.icon.widget,
                        Text(f.ctrl.name),
                        const Icon(Icons.navigate_next),
                      ],
                    ),
                  ),
                  Spacer(),
                  IconButton.filled(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => Dialog(
                          child: SizedBox(
                            width: 400,
                            height: 700,
                            child: ConfigFArea(f),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings),
                    tooltip: 'Config',
                  ),
                ],
              ),
              if (f.owner != null)
                SizedBox(
                  height: 64,
                  child: FRL(
                    f.owner!,
                    (owner) => Row(
                      children: [
                        const Text('Created by: '),
                        Flexible(
                          child: FractalTile(
                            owner,
                            onTap: () {
                              context.go(owner.path);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Positioned(
            top: -4,
            left: -4,
            child: IconButton(
              onPressed: _uploadIcon,
              icon: const Icon(Icons.upload_file),
              tooltip: 'Upload image',
            ),
          ),
        ],
      ),
    );
  }

  _uploadIcon() async {
    if (!f.own) return;
    final file = await FractalImage.pick();
    if (file == null) return;
    await file.publish();
    f.image = file;
    f.write('image', file.name);
    f.notifyListeners();
  }
}
