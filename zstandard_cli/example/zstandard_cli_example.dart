import 'dart:typed_data';

import 'package:zstandard_cli/zstandard_cli.dart';

void main() async {
  var cli = ZstandardCLI();

  final originalData = Uint8List.fromList([10, 20, 30]);
  print('originalData: ${originalData.length}');

  final compressed = await cli.compress(originalData, compressionLevel: 3);
  print('compressed: ${compressed?.length}');

  final decompressed = await cli.decompress(compressed ?? Uint8List(0));
  print('decompressed: ${decompressed?.length}');
}
