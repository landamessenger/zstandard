import 'dart:typed_data';

import 'package:zstandard/src/platform_manager.dart';
import 'package:zstandard_macos/zstandard_macos.dart';
import 'package:zstandard_platform_interface/zstandard_platform_interface.dart';

class Zstandard {
  static Zstandard? _instance;

  Zstandard._internal();

  factory Zstandard() {
    _instance ??= Zstandard._internal();
    return _instance!;
  }

  PlatformManager get platformManager => PlatformManager();

  bool init = false;

  ZstandardPlatform get instance {
    if (!init && platformManager.isMacOS) {
      ZstandardMacOS.registerWith();
    }
    init = true;
    return ZstandardPlatform.instance;
  }

  Future<String?> getPlatformVersion() => instance.getPlatformVersion();

  Future<Uint8List?> compress(Uint8List data) => instance.compress(data);

  Future<Uint8List?> decompress(Uint8List data) => instance.decompress(data);
}
