import 'dart:typed_data';

import 'package:zstandard_platform_interface/zstandard_platform_interface.dart';

class ZstandardCompress implements ZstandardInterface {
  final instance = ZstandardCompress();

  @override
  Future<Uint8List?> compress(Uint8List data) => instance.compress(data);

  @override
  Future<Uint8List?> decompress(Uint8List data) => instance.decompress(data);

  @override
  Future<String?> getPlatformVersion() => instance.getPlatformVersion();
}
