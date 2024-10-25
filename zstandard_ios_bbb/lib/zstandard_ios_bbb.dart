
import 'zstandard_ios_bbb_platform_interface.dart';

class ZstandardIosBbb {
  Future<String?> getPlatformVersion() {
    return ZstandardIosBbbPlatform.instance.getPlatformVersion();
  }
}
