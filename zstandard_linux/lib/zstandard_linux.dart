
import 'zstandard_linux_platform_interface.dart';

class ZstandardLinux {
  Future<String?> getPlatformVersion() {
    return ZstandardLinuxPlatform.instance.getPlatformVersion();
  }
}
