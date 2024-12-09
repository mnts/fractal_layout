import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<void> export(List<int> bytes, String fileName) async {
  final path = await FilePicker.platform.saveFile(
    fileName: fileName,
  );
  if (path == null) return;

  final file = File(path);
  await file.writeAsBytes(bytes);

  return;
}
