import 'dart:typed_data';

import 'package:zstandard/src/zstandard_impl_web.dart'
    if (dart.library.io) 'package:zstandard/src/zstandard_impl_native.dart';
import 'package:zstandard_platform_interface/zstandard_platform_interface.dart';

export 'src/zstandard_ext.dart';

class Zstandard {
  static Zstandard? _instance;

  Zstandard._internal();

  factory Zstandard() {
    _instance ??= Zstandard._internal();
    return _instance!;
  }

  ZstandardPlatform get instance => ZstandardImpl().instance;

  Future<String?> getPlatformVersion() => instance.getPlatformVersion();

  Future<Uint8List?> compress(Uint8List data, int compressionLevel) =>
      instance.compress(data, compressionLevel);

  Future<Uint8List?> decompress(Uint8List data) => instance.decompress(data);
}
