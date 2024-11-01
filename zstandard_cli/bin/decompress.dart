import 'dart:io';

import 'package:zstandard_cli/src/utils/constants.dart';
import 'package:zstandard_cli/src/utils/size_utils.dart';
import 'package:zstandard_cli/zstandard_cli.dart';

void main(List<String> args) async {
  print('===================== 📦 zstandard_cli =====================\n');

  final cli = ZstandardCLI();
  print('Running on: ${await cli.getPlatformVersion()}\n');

  final filePath = args.firstOrNull;

  if (filePath == null) {
    print('Path not found: $filePath');
    return;
  }
  final file = File(filePath);
  if (!file.existsSync()) {
    print('File not found: $filePath');
    return;
  }

  print('Decompressing ${file.path} ${await getFileSize(file)}');

  final compressed = await cli.decompress(
    file.readAsBytesSync(),
  );
  if (compressed == null) {
    print('Error decompressing: $filePath');
    return;
  }

  final decompressedFilePath = filePath.endsWith(extension)
      ? filePath.substring(0, filePath.length - extension.length)
      : filePath;

  final decompressedFile = File(decompressedFilePath);
  decompressedFile.writeAsBytesSync(compressed);
  if (!decompressedFile.existsSync()) {
    print('Decompressed file not found: $decompressedFilePath');
    return;
  }

  print(
      'Decompressed ${decompressedFile.path} ${await getFileSize(decompressedFile)} \n');
}
