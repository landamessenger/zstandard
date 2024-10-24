import 'dart:typed_data';

import 'package:zstandard_platform_interface/zstandard_platform_interface.dart';

import 'zstandard_macos_method_channel.dart';

class ZstandardMacos extends ZstandardPlatformInterface {
  /// Constructs a ZstandardMacosPlatform.
  ZstandardMacos() : _hostApi = MethodChannelZstandardMacos();

  final MethodChannelZstandardMacos _hostApi;

  static void registerWith() {
    ZstandardPlatformInterface.instance = ZstandardMacos();
  }

  @override
  Future<String?> getPlatformVersion() => _hostApi.getPlatformVersion();

  @override
  Future<Uint8List?> compress(Uint8List data) => _hostApi.compress(data);

  @override
  Future<Uint8List?> decompress(Uint8List data) => _hostApi.decompress(data);
}
