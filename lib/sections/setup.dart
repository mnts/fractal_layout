import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fractal_flutter/data/icons.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/widgets/tile.dart';
import 'package:fractal_layout/widgets/tooltip.dart';
import 'package:fractal_socket/client.dart';
import 'package:go_router/go_router.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:file_picker/file_picker.dart';
import 'package:timeago/timeago.dart';
import '../inputs/icon.dart';
import '../views/thing.dart';
import 'dates.dart';

class SetupArea extends StatelessWidget {
  final ExtendableF f;
  SetupArea(this.f, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      if (f case NodeFractal node)
        (node.image != null || node.video != null)
            ? SizedBox(
                height: 200,
                child: MediaArea(
                  node: node,
                ),
              )
            : Container(),

      /*
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
        */

      if (f case NodeFractal node) FractalControls(node),
      if (f case NodeFractal node when node.folder?.isNotEmpty == true)
        SelectableText(
          textAlign: TextAlign.center,
          onTap: () {
            Clipboard.setData(
              ClipboardData(text: node.folder!),
            );
          },
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
          node.folder!,
        ),
      Center(
        child: Tooltip(
          message: 'Hash id',
          child: SelectableText(
            textAlign: TextAlign.center,
            onTap: () {
              Clipboard.setData(
                ClipboardData(text: f.hash),
              );
            },
            style: const TextStyle(fontSize: 14),
            f.hash,
          ),
        ),
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
            child: Text(
              f['ui'] as String? ??
                  f.extend?.title.value?.content ??
                  f.extend?.name ??
                  f.ctrl.name,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const Icon(Icons.arrow_right_alt_sharp),
          if (f case NodeFractal node)
            Tooltip(
              message: 'initial name',
              child: SelectableText(
                textAlign: TextAlign.center,
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(text: node.name),
                  );
                },
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                node.name,
              ),
            ),
          const Spacer(),
          Text(
            '#${f.id}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 8),
        ],
      ),

      if (f.extend != null)
        Row(
          children: [
            const SizedBox(width: 8),
            const RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.subdirectory_arrow_left_sharp,
              ),
            ),
            SizedBox(
              height: 32,
              width: 32,
              child: f.extend!.icon,
            ),
            FTitle(f.extend!),
            const Spacer(),
            Tooltip(
              message: 'Extends',
              child: SelectableText(
                textAlign: TextAlign.center,
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(text: f.extend!.hash),
                  );
                },
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
                f.extend!.hash,
              ),
            ),
          ],
        ),
      SetupFDates(f),
      switch (f.owner) {
        UserFractal user => FractalUser(user),
        EventFractal ev => FractalTile(ev),
        _ => const SizedBox(),
      },
      if (f case Rewritable rewF when f.uis.isNotEmpty)
        Center(
          child: DropdownMenu<String>(
            initialSelection: '${f['ui'] ?? ''}',
            hintText: 'UI Design',
            onSelected: (String? value) {
              if (value == null) return;
              rewF.write('ui', value);
            },
            dropdownMenuEntries: [
              ...f.uis.map(
                (u) => DropdownMenuEntry<String>(
                  value: u,
                  label: u.toTitleCase,
                ),
              ),
            ],
          ),
        ),

      /*
        //description text field
        TextField(
          maxLines: 3,
          onTapOutside: (ev) {
            final value = descriptionCtrl.text.trim();
            if ('${f['description'] ?? ''}' != value) {
              f.write('description', value);
            }
          },
          decoration: const InputDecoration(
            labelText: 'Description',
          ),
          controller: descriptionCtrl,
        ),
        */
      if (f case NodeFractal node)
        FractalTags(
          list: node.tags,
          onChanged: (list) {
            node.write('tags', list.join(' '));
          },
        ),
      if (f.extend != null)
        ...f.extend!.sorted.value.map(
          (subF) => FractalTile(subF),
        ),
      ...FractalThing.areas,
      //if (f.extend != null) row('extends', f.extend!),
    ]);
  }

  /*
  late final descriptionCtrl = TextEditingController(
    text: f['description'] as String?,
  );

  //late final cart = UserFractal.active.value!.require('cart');

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
      */
}
