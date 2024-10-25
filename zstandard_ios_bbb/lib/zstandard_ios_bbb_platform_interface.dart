import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'zstandard_ios_bbb_method_channel.dart';

abstract class ZstandardIosBbbPlatform extends PlatformInterface {
  /// Constructs a ZstandardIosBbbPlatform.
  ZstandardIosBbbPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZstandardIosBbbPlatform _instance = MethodChannelZstandardIosBbb();

  /// The default instance of [ZstandardIosBbbPlatform] to use.
  ///
  /// Defaults to [MethodChannelZstandardIosBbb].
  static ZstandardIosBbbPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ZstandardIosBbbPlatform] when
  /// they register themselves.
  static set instance(ZstandardIosBbbPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
