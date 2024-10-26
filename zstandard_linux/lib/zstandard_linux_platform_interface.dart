import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'zstandard_linux_method_channel.dart';

abstract class ZstandardLinuxPlatform extends PlatformInterface {
  /// Constructs a ZstandardLinuxPlatform.
  ZstandardLinuxPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZstandardLinuxPlatform _instance = MethodChannelZstandardLinux();

  /// The default instance of [ZstandardLinuxPlatform] to use.
  ///
  /// Defaults to [MethodChannelZstandardLinux].
  static ZstandardLinuxPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ZstandardLinuxPlatform] when
  /// they register themselves.
  static set instance(ZstandardLinuxPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
