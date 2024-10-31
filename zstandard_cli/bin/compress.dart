import 'dart:typed_data';

import 'package:zstandard_cli/src/zstandard_interface.dart';
import 'package:zstandard_cli/zstandard_cli.dart';

class ZstandardCLICompress implements ZstandardInterface {
  final instance = ZstandardCLI();

  @override
  Future<Uint8List?> compress(Uint8List data) => instance.compress(data);

  @override
  Future<Uint8List?> decompress(Uint8List data) => instance.decompress(data);

  @override
  Future<String?> getPlatformVersion() => instance.getPlatformVersion();
}
