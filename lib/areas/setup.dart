import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fractal/utils/random.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/widgets/tile.dart';
import 'package:fractal_layout/widgets/tooltip.dart';
import 'package:go_router/go_router.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:file_picker/file_picker.dart';
import 'package:super_tooltip/super_tooltip.dart';

import 'screens.dart';

class SetupArea extends StatefulWidget {
  final NodeFractal fractal;
  const SetupArea(this.fractal, {super.key});

  @override
  State<SetupArea> createState() => _SetupAreaState();
}

class _SetupAreaState extends State<SetupArea> {
  NodeFractal get f => widget.fractal;

  String dir = '';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (f.image != null)
          FractalImage(
            f.image!,
            fit: BoxFit.cover,
          ),
        if (dir.isNotEmpty)
          ListTile(
            onTap: () async {
              final dir = await FilePicker.platform.getDirectoryPath();
              if (dir == null) return;
              setState(() {
                this.dir = dir;
              });
            },
            leading: const Icon(
              Icons.folder,
            ),
            title: Text(dir),
            subtitle: const Text('item directory'),
          ),
        Row(
          children: [
            SizedBox(
              height: 32,
              width: 32,
              child: f.extend?.icon ?? f.ctrl.icon.widget,
            ),
            FractalTooltip(
              content: ListView(
                children: [
                  ...Fractal.maps['screens']?.entries.map(
                        (en) => ListTile(
                          title: Text(en.key),
                          onTap: () {
                            Navigator.pop(context);
                            context.go('/-${f.hash}|${en.key}');
                          },
                        ),
                      ) ??
                      [],
                ],
              ),
              width: 200,
              height: 180,
              child: Text(f['screen'] as String? ??
                  f.extend?.title.value?.content ??
                  f.extend?.name ??
                  f.ctrl.name),
            ),
            const Icon(Icons.navigate_next),
            Expanded(
              child: Tooltip(
                message: 'initial name',
                child: SelectableText(
                  textAlign: TextAlign.center,
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: f.name),
                    );
                  },
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  f.name,
                ),
              ),
            ),
            //if (f.own)
            IconButton(
              onPressed: () {
                f.remove();
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              tooltip: 'Remove',
            ),
            IconButton(
              onPressed: _uploadIcon,
              icon: const Icon(Icons.upload_file),
              tooltip: 'Upload image',
            ),
            FractalTooltip(
              direction: TooltipDirection.right,
              content: ListView(children: [
                ...f.extensions.values.map(
                  (f) => FractalTile(f),
                ),
              ]),
              child: Icon(Icons.share),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/-${f.hash}');
              },
              icon: const Icon(Icons.arrow_right),
              tooltip: 'Open',
            ),
          ],
        ),
        Tooltip(
          message: 'Hash id',
          child: SelectableText(
            textAlign: TextAlign.center,
            onTap: () {
              Clipboard.setData(
                ClipboardData(text: f.hash),
              );
            },
            style: const TextStyle(fontSize: 12),
            f.hash,
          ),
        ),
        FractalTags(
          list: f.tags,
          onChanged: (list) {
            f.write('tags', list.join(' '));
          },
        ),
        if (f.owner != null) row('by', f.owner!),
        if (f['price'] != null)
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                FilledButton.icon(
                  onPressed: () {
                    final treatment = NodeFractal(
                      name: '${f.name}_${getRandomString(3)}',
                      extend: f,
                      to: cart,
                    );
                    treatment.synch();
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: Text('${f['price']}'),
                ),
              ],
            ),
          ),
        if (f.extend != null)
          ...f.extend!.sorted.value.map(
            (subF) => FractalTile(subF),
          ),
        //if (f.extend != null) row('extends', f.extend!),
      ],
    );
  }

  late final cart = UserFractal.active.value!.require('cart');

  _uploadIcon() async {
    if (!f.own) return;
    final file = await FractalImage.pick();
    if (file == null) return;
    await file.publish();
    setState(() {
      f.image = file;
      f.write('image', file.name);
      f.notifyListeners();
    });
  }

  Widget row(String txt, NodeFractal node) => SizedBox(
        height: 64,
        child: Row(
          children: [
            Text('$txt: '),
            Flexible(
              child: FractalTile(
                node,
                onTap: () {
                  context.go(node.path);
                },
              ),
            ),
          ],
        ),
      );
}
