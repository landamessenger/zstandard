// TODO: Put public facing types in this file.

import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'lib_loader.dart';
import 'zstandard_cli_bindings_generated.dart';
import 'zstandard_interface.dart';

class ZstandardCLI implements ZstandardInterface {
  final ZstandardCLIBindings _bindings =
      ZstandardCLIBindings(openZstdLibrary());

  @override
  @override
  Future<Uint8List?> compress(
    Uint8List data, {
    int compressionLevel = 3,
  }) async {
    final int srcSize = data.lengthInBytes;
    final Pointer<Uint8> src = malloc.allocate<Uint8>(srcSize);
    src.asTypedList(srcSize).setAll(0, data);

    final int dstCapacity = _bindings.ZSTD_compressBound(srcSize);
    final Pointer<Uint8> dst = malloc.allocate<Uint8>(dstCapacity);

    try {
      final int compressedSize = _bindings.ZSTD_compress(
        dst.cast(),
        dstCapacity,
        src.cast(),
        srcSize,
        compressionLevel,
      );

      if (compressedSize > 0) {
        return Uint8List.fromList(dst.asTypedList(compressedSize));
      } else {
        return null;
      }
    } finally {
      malloc.free(src);
      malloc.free(dst);
    }
  }

  @override
  Future<Uint8List?> decompress(Uint8List data) async {
    final int compressedSize = data.lengthInBytes;
    final Pointer<Uint8> src = malloc.allocate<Uint8>(compressedSize);
    src.asTypedList(compressedSize).setAll(0, data);

    final int dstCapacity = compressedSize * 4;
    final Pointer<Uint8> dst = malloc.allocate<Uint8>(dstCapacity);

    try {
      final int decompressedSize = _bindings.ZSTD_decompress(
        dst.cast(),
        dstCapacity,
        src.cast(),
        compressedSize,
      );

      if (decompressedSize > 0) {
        return Uint8List.fromList(dst.asTypedList(decompressedSize));
      } else {
        return null;
      }
    } finally {
      malloc.free(src);
      malloc.free(dst);
    }
  }

  @override
  Future<String?> getPlatformVersion() {
    return Future.value("");
  }
}
