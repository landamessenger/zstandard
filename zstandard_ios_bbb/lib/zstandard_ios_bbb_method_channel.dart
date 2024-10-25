import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'zstandard_ios_bbb_platform_interface.dart';

/// An implementation of [ZstandardIosBbbPlatform] that uses method channels.
class MethodChannelZstandardIosBbb extends ZstandardIosBbbPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('zstandard_ios_bbb');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
