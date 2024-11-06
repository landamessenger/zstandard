import 'dart:typed_data';

import 'package:zstandard_linux/zstandard_linux.dart';

extension ZstandardExt on Uint8List? {
  Future<Uint8List?> compress({int compressionLevel = 3}) async {
    var data = this;
    if (data == null) return null;
    return ZstandardLinux().compress(data, compressionLevel);
  }

  Future<Uint8List?> decompress() async {
    var data = this;
    if (data == null) return null;
    return ZstandardLinux().decompress(data);
  }
}
