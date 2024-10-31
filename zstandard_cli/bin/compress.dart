
import 'dart:typed_data';

import 'package:zstandard_platform_interface/zstandard_platform_interface.dart';

class ZstandardCLICompress implements ZstandardInterface {
  @override
  Future<Uint8List?> compress(Uint8List data) {
    // TODO: implement compress
    throw UnimplementedError();
  }

  @override
  Future<Uint8List?> decompress(Uint8List data) {
    // TODO: implement decompress
    throw UnimplementedError();
  }

  @override
  Future<String?> getPlatformVersion() {
    // TODO: implement getPlatformVersion
    throw UnimplementedError();
  }
  
}