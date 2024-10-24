import 'dart:typed_data';

import 'package:zstandard_platform_interface/zstandard_platform_interface.dart';

class Zstandard {
  Future<String?> getPlatformVersion() {
    return ZstandardPlatformInterface.instance.getPlatformVersion();
  }

  Future<Uint8List?> compress(Uint8List data) =>
      ZstandardPlatformInterface.instance.compress(data);

  Future<Uint8List?> decompress(Uint8List data) =>
      ZstandardPlatformInterface.instance.decompress(data);
}
