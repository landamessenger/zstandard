import 'package:zstandard_platform_interface/zstandard_platform_interface.dart';

class ZstandardImpl {
  static ZstandardImpl? _instance;

  ZstandardImpl._internal();

  factory ZstandardImpl() {
    _instance ??= ZstandardImpl._internal();
    return _instance!;
  }

  ZstandardPlatform get instance => ZstandardPlatform.instance;
}
