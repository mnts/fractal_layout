export 'export/io.dart'
//    if (dart.library.io) 'src/io.dart'
    if (dart.library.html) 'export/web.dart';

abstract class FExport {
  Future<void> saveDialog(List<int> bytes, String fileName);
}
