import 'dart:typed_data';

import 'package:zstandard_windows/zstandard_windows.dart';

extension ZstandardExt on Uint8List? {
  Future<Uint8List?> compress({int compressionLevel = 3}) async {
    var data = this;
    if (data == null) return null;
    return ZstandardWindows().compress(data, compressionLevel);
  }

  Future<Uint8List?> decompress() async {
    var data = this;
    if (data == null) return null;
    return ZstandardWindows().decompress(data);
  }
}
