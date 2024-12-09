import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:signed_fractal/signed_fractal.dart';

class FractalProfile extends StatefulWidget {
  final NodeFractal node;
  const FractalProfile(this.node, {super.key});

  @override
  State<FractalProfile> createState() => _FractalProfileState();
}

class _FractalProfileState extends State<FractalProfile> {
  late final user =
      context.read<Rewritable?>() as UserFractal? ?? UserFractal.active.value!;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Listen(
        user,
        (ctx, child) => ListView(
          padding: const EdgeInsets.all(4),
          key: const Key('sortableList'),
          children: [
            Container(
              padding: const EdgeInsets.only(top: 96),
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double size = min(constraints.maxWidth, 480);
                    return SizedBox(
                      width: size,
                      child: Stack(
                        children: [
                          Center(
                            child: (user.image != null)
                                ? Container(
                                    clipBehavior: Clip.antiAlias,
                                    width: size,
                                    height: size,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(size),
                                    ),
                                    child: FractalImage(
                                      user.image!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(Icons.person, size: size),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 64,
                            child: IconButton(
                              onPressed: _uploadIcon,
                              icon: const Icon(Icons.photo_camera),
                              tooltip: 'Upload image',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 480,
                ),
                child: FRenamable(user, size: 48),
              ),
            ),
            if (user.email != null)
              Center(
                child: SizedBox(
                  width: 300,
                  child: ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(user.email!,
                        style: const TextStyle(
                          fontSize: 22,
                        )),
                  ),
                ),
              ),
            if (user.domain != null)
              Center(
                child: SizedBox(
                  width: 300,
                  child: ListTile(
                    leading: const Icon(Icons.home_sharp),
                    title: Text(user.domain!,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.blue)),
                  ),
                ),
              ),
            Tooltip(
              message: 'Hash id',
              child: SelectableText(
                textAlign: TextAlign.center,
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(text: user.hash),
                  );
                },
                style: const TextStyle(fontSize: 12),
                user.hash,
              ),
            ),
            FractalTags(
              list: user.tags,
              onChanged: (list) {
                user.write('tags', list.join(' '));
              },
            ),
            Center(
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_4_rounded),
                label: const Text("Manage"),
              ),
            ),
            if (user.extend != null)
              ...user.extend!.sorted.value.map(
                (subF) => FractalTile(subF),
              ),
          ],
        ),
      ),
    );
  }

  _uploadIcon() async {
    //if (!widget.user.own) return;
    final file = await FractalImage.pick();
    if (file == null) return;
    await file.publish();
    user.image = file;
    user.write('image', file.name);
    user.notifyListeners();
  }
}
