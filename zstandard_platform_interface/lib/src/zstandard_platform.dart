import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'zstandard_platform_interface_method_channel.dart';

abstract class ZstandardPlatform extends PlatformInterface {
  /// Constructs a ZstandardPlatformInterfacePlatform.
  ZstandardPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZstandardPlatform _instance = MethodChannelZstandardPlatform();

  /// The default instance of [ZstandardPlatform] to use.
  ///
  /// Defaults to [MethodChannelZstandardPlatform].
  static ZstandardPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ZstandardPlatform] when
  /// they register themselves.
  static set instance(ZstandardPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Uint8List?> compress(Uint8List data, int compressionLevel) {
    throw UnimplementedError('compress() has not been implemented.');
  }

  Future<Uint8List?> decompress(Uint8List data) {
    throw UnimplementedError('decompress() has not been implemented.');
  }
}
