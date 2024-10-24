import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zstandard_platform_interface/zstandard_platform_interface.dart';

import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

final String dylibPath = '${Directory.current.path}/libzstd.dylib';
final ffi.DynamicLibrary zstd = ffi.DynamicLibrary.open(dylibPath);

typedef ZstdCompressNative = ffi.IntPtr Function(
    ffi.Pointer<ffi.Uint8> dst, ffi.Size dstCapacity,
    ffi.Pointer<ffi.Uint8> src, ffi.Size srcSize);

typedef ZstdCompressDart = int Function(
    ffi.Pointer<ffi.Uint8> dst, int dstCapacity,
    ffi.Pointer<ffi.Uint8> src, int srcSize);

final ZstdCompressDart zstdCompress = zstd
    .lookup<ffi.NativeFunction<ZstdCompressNative>>('ZSTD_compress')
    .asFunction<ZstdCompressDart>();

typedef ZstdDecompressNative = ffi.IntPtr Function(
    ffi.Pointer<ffi.Uint8> dst, ffi.Size dstCapacity,
    ffi.Pointer<ffi.Uint8> src, ffi.Size compressedSize);

typedef ZstdDecompressDart = int Function(
    ffi.Pointer<ffi.Uint8> dst, int dstCapacity,
    ffi.Pointer<ffi.Uint8> src, int compressedSize);

final ZstdDecompressDart zstdDecompress = zstd
    .lookup<ffi.NativeFunction<ZstdDecompressNative>>('ZSTD_decompress')
    .asFunction<ZstdDecompressDart>();

/// An implementation of [ZstandardPlatformInterface] that uses method channels.
class MethodChannelZstandardMacos extends ZstandardPlatformInterface {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('zstandard_macos');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Uint8List?> compress(Uint8List data) async {
    final src = malloc<ffi.Uint8>(data.length);
    final dst = malloc<ffi.Uint8>(data.length); // ajusta el tamaño del destino según sea necesario

    // Copia los datos de Dart a FFI
    for (int i = 0; i < data.length; i++) {
      src[i] = data[i];
    }

    // Llama a la función de compresión
    final compressedSize = zstdCompress(dst, data.length, src, data.length);

    // Lee los datos comprimidos
    final compressedData = Uint8List(compressedSize);
    for (int i = 0; i < compressedSize; i++) {
      compressedData[i] = dst[i];
    }

    // Libera la memoria
    malloc.free(src);
    malloc.free(dst);

    return compressedData;
  }

  @override
  Future<Uint8List?> decompress(Uint8List data) async {
    return data;
  }
}
