import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:fractal_flutter/data/icons.dart';
import 'package:fractal_layout/widget.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';

import '../inputs/icon.dart';
import '../widgets/insertion.dart';

class FractalControls extends StatefulWidget {
  final Rewritable f;
  const FractalControls(this.f, {super.key});

  @override
  State<FractalControls> createState() => _FractalControlsState();
}

class _FractalControlsState extends State<FractalControls> {
  Rewritable get f => widget.f;
  Color get color => switch (int.tryParse(
        '${widget.f.m['color']?.content}',
      )) {
        int c => Color(c),
        _ => Theme.of(context).colorScheme.primary,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            //if (f.own)
            /*
            IconButton(
              onPressed: () {
                ClientFractal.main?.sink(f);
              },
              icon: const Icon(
                Icons.cloud_sync_sharp,
              ),
              tooltip: 'Synch',
            ),
            */
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
            if (f case NodeFractal node)
              IconButton(
                onPressed: _uploadFile,
                icon: const Icon(Icons.upload_file),
                tooltip: 'Upload file',
              ),
            if (f case NodeFractal node)
              IconButton(
                onPressed: _uploadImage,
                icon: const Icon(Icons.add_a_photo_outlined),
                tooltip: 'Upload image',
              ),
            if (f case NodeFractal node)
              IconButton(
                onPressed: _uploadVideo,
                icon: const Icon(Icons.video_file_outlined),
                tooltip: 'Upload video',
              ),

            Container(
              width: 36,
              padding: const EdgeInsets.fromLTRB(2, 8, 2, 0),
              child: IconFPicker(
                icon: const Icon(Icons.apps),
                enableSearch: true,
                initialValue: '${f['icon'] ?? ''}',
                iconCollection: MaterialFIcons.mIcons,
                onChanged: (val) {
                  f.write('icon', val);
                },
                onSaved: (val) => print(val),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(2, 6, 0, 2),
              child: ColorIndicator(
                width: 24,
                height: 24,
                borderRadius: 6,
                color: color,
                hasBorder: true,
                onSelectFocus: false,
                onSelect: () {
                  colorPickerDialog();
                },
              ),
            ),
            if (f case NodeFractal node)
              IconButton(
                onPressed: _choseFolder,
                icon: const Icon(Icons.folder_special_outlined),
                tooltip: 'Choose local folder',
              ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                FInsertion.dialog(f);
              },
              icon: const Icon(Icons.playlist_add_rounded),
              tooltip: 'Into text',
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
      ),
    );
  }

  _choseFolder() async {
    if (f case NodeFractal node) {
      print(f);
      final path = await FilePicker.platform.getDirectoryPath();

      if (path != null) f.write('folder', path);
    }
  }

  _uploadImage() async {
    //if (!f.own) return;
    if (f case NodeFractal node) {
      final file = await FractalImage.pick();
      if (file == null) return;
      await file.publish();
      node.image = file;
      node.write('image', file.name);
      node.notifyListeners();
    }
  }

  _uploadFile() async {
    //if (!f.own) return;
    final file = await FractalImage.pick();
    if (file == null) return;
    await file.publish();
    f.write('file', file.name);
    f.notifyListeners();
  }

  _uploadVideo() async {
    if (!f.own) return;
    if (f case NodeFractal node) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        withData: true,
      );

      final bytes = result?.files.first.bytes;
      if (bytes == null) return null;
      //result?.files.first.

      final file = FileF.bytes(bytes);
      await file.publish();
      node.video = file;
      node.write('video', file.name);
      node.notifyListeners();
    }
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      //color: dialogPickerColor,
      onColorChanged: (Color color) {
        f.write('color', color.value.toString());
      },
      width: 32,
      height: 32,
      borderRadius: 8,
      spacing: 2,
      runSpacing: 3,
      wheelDiameter: 155,
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      /*
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      */
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.wheel: true,
      },
      //customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      actionsPadding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(
        minHeight: 280,
        minWidth: 300,
        maxWidth: 320,
      ),
    );
  }
}
