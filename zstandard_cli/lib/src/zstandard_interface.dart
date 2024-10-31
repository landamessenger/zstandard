import 'dart:typed_data';

abstract class ZstandardInterface {
  Future<String?> getPlatformVersion();

  Future<Uint8List?> compress(Uint8List data);

  Future<Uint8List?> decompress(Uint8List data);
}
