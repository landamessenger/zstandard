import 'package:zstandard_ios/zstandard_ios.dart';
import 'package:zstandard_macos/zstandard_macos.dart';
import 'package:zstandard_platform_interface/zstandard_platform_interface.dart';

import 'platform_manager.dart';

class ZstandardImpl {
  static ZstandardImpl? _instance;

  ZstandardImpl._internal();

  factory ZstandardImpl() {
    _instance ??= ZstandardImpl._internal();
    return _instance!;
  }

  PlatformManager get platformManager => PlatformManager();

  bool init = false;

  ZstandardPlatform get instance {
    if (!init) {
      if (platformManager.isIOS) {
        ZstandardIOS.registerWith();
      } else if (platformManager.isMacOS) {
        ZstandardMacOS.registerWith();
      }
    }
    init = true;
    return ZstandardPlatform.instance;
  }
}
