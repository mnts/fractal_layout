import 'package:fractal_layout/widget.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';

import '../widgets/insertion.dart';

class FractalControls extends StatelessWidget {
  final Rewritable f;
  const FractalControls(this.f, {super.key});

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
}
