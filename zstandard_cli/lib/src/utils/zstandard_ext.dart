import 'dart:typed_data';

import 'package:zstandard_cli/src/zstandard_cli_base.dart';

extension ZstandardExt on Uint8List? {
  Future<Uint8List?> compress({int compressionLevel = 3}) async {
    var data = this;
    if (data == null) return null;
    return ZstandardCLI().compress(data, compressionLevel: compressionLevel);
  }

  Future<Uint8List?> decompress() async {
    var data = this;
    if (data == null) return null;
    return ZstandardCLI().decompress(data);
  }
}
