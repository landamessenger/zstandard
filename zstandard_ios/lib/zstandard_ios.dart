import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:zstandard_platform_interface/zstandard_platform_interface.dart';

import 'zstandard_ios_bindings_generated.dart'; // Binding generated

export 'zstandard_ext.dart';

const String _libName = 'zstandard_ios';

final DynamicLibrary _dylib = () {
  if (Platform.isIOS) {
    print(
        '🔍 [ZSTD] Attempting to load library: $_libName.framework/$_libName');
    try {
      final lib = DynamicLibrary.open('$_libName.framework/$_libName');
      print('✅ [ZSTD] Library loaded successfully');

      // Test if we can find some basic symbols
      try {
        lib.lookup<NativeFunction>('ZSTD_compressBound');
        print('✅ [ZSTD] ZSTD_compressBound symbol found');
      } catch (e) {
        print('❌ [ZSTD] ZSTD_compressBound symbol NOT found: $e');
      }

      try {
        lib.lookup<NativeFunction>('ZSTD_compress');
        print('✅ [ZSTD] ZSTD_compress symbol found');
      } catch (e) {
        print('❌ [ZSTD] ZSTD_compress symbol NOT found: $e');
      }

      try {
        lib.lookup<NativeFunction>('ZSTD_decompress');
        print('✅ [ZSTD] ZSTD_decompress symbol found');
      } catch (e) {
        print('❌ [ZSTD] ZSTD_decompress symbol NOT found: $e');
      }

      return lib;
    } catch (e) {
      print('❌ [ZSTD] Failed to load library: $e');
      rethrow;
    }
  }
  throw UnsupportedError('Platform not supported: ${Platform.operatingSystem}');
}();

final ZstandardIosBindings _bindings = ZstandardIosBindings(_dylib);

// Test function to verify symbols are available
void _testZstdSymbols() {
  print('🧪 [ZSTD] Testing symbol availability...');

  // List all available symbols
  _listAvailableSymbols();

  try {
    // Try to get the function directly from the library
    final compressBoundFunc =
        _dylib.lookupFunction<Int32 Function(Uint32), int Function(int)>(
            'ZSTD_compressBound');
    final result = compressBoundFunc(1024);
    print('✅ [ZSTD] ZSTD_compressBound test successful: $result');
  } catch (e) {
    print('❌ [ZSTD] ZSTD_compressBound test failed: $e');
  }

  try {
    // Try to get the compress function
    _dylib.lookupFunction<
        Int32 Function(Pointer<Void>, Int32, Pointer<Void>, Int32, Int32),
        int Function(
            Pointer<Void>, int, Pointer<Void>, int, int)>('ZSTD_compress');
    print('✅ [ZSTD] ZSTD_compress function found');
  } catch (e) {
    print('❌ [ZSTD] ZSTD_compress function not found: $e');
  }

  try {
    // Try to get the decompress function
    _dylib.lookupFunction<
        Int32 Function(Pointer<Void>, Int32, Pointer<Void>, Int32),
        int Function(
            Pointer<Void>, int, Pointer<Void>, int)>('ZSTD_decompress');
    print('✅ [ZSTD] ZSTD_decompress function found');
  } catch (e) {
    print('❌ [ZSTD] ZSTD_decompress function not found: $e');
  }
}

// Function to list available symbols in the library
void _listAvailableSymbols() {
  print('🔍 [ZSTD] Listing available symbols...');

  // Common ZSTD symbols to test
  final List<String> zstdSymbols = [
    'sum',
    'sum_long_running',
    'ZDICT_finalizeDictionary',
    'ZSTD_getDecompressedSize',
    'ZSTD_compressBound',
    'ZSTD_compress',
    'ZSTD_decompress',
    'ZSTD_getDecompressedSize',
    'ZSTD_versionNumber',
    'ZSTD_versionString',
    'ZSTD_isError',
    'ZSTD_getErrorName',
    'ZSTD_compress_usingDict',
    'ZSTD_decompress_usingDict',
    'ZSTD_createCCtx',
    'ZSTD_freeCCtx',
    'ZSTD_createDCtx',
    'ZSTD_freeDCtx',
  ];

  int foundCount = 0;
  for (final symbol in zstdSymbols) {
    try {
      _dylib.lookup<NativeFunction>(symbol);
      print('✅ [ZSTD] Found symbol: $symbol');
      foundCount++;
    } catch (e) {
      print('❌ [ZSTD] Missing symbol: $symbol');
    }
  }

  print('📊 [ZSTD] Summary: $foundCount/${zstdSymbols.length} symbols found');
}

class ZstandardIOS extends ZstandardPlatform {
  /// A constructor that allows tests to override the window object used by the plugin.
  ZstandardIOS() {
    // Test symbols when the class is instantiated
    _testZstdSymbols();
  }

  final methodChannel = const MethodChannel('plugins.flutter.io/zstandard');

  /// Registers this class as the default instance of [ZstandardPlatform].
  static void registerWith() {
    ZstandardPlatform.instance = ZstandardIOS();
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Uint8List?> compress(Uint8List data, int compressionLevel) async {
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

    final int decompressedSizeExpected =
        _bindings.ZSTD_getDecompressedSize(src.cast(), compressedSize);
    final int dstCapacity = decompressedSizeExpected > 0
        ? decompressedSizeExpected
        : compressedSize * 20;
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
}

int compress(
  Pointer<Void> dst,
  int dstCapacity,
  Pointer<Void> src,
  int srcSize,
  int compressionLevel,
) =>
    _bindings.ZSTD_compress(
      dst,
      dstCapacity,
      src,
      srcSize,
      compressionLevel,
    );

int decompress(
  Pointer<Void> dst,
  int dstCapacity,
  Pointer<Void> src,
  int compressedSize,
) =>
    _bindings.ZSTD_decompress(
      dst,
      dstCapacity,
      src,
      compressedSize,
    );

Future<int> compressAsync(
  Pointer<Void> dst,
  int dstCapacity,
  Pointer<Void> src,
  int srcSize,
  int compressionLevel,
) async {
  final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
  final int requestId = _nextCompressRequestId++;
  final _CompressRequest request = _CompressRequest(
      requestId, dst, dstCapacity, src, srcSize, compressionLevel);
  final Completer<int> completer = Completer<int>();
  _compressRequests[requestId] = completer;
  helperIsolateSendPort.send(request);
  return completer.future;
}

Future<int> decompressAsync(
  Pointer<Void> dst,
  int dstCapacity,
  Pointer<Void> src,
  int compressedSize,
) async {
  final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
  final int requestId = _nextDecompressRequestId++;
  final _DecompressRequest request =
      _DecompressRequest(requestId, dst, dstCapacity, src, compressedSize);
  final Completer<int> completer = Completer<int>();
  _decompressRequests[requestId] = completer;
  helperIsolateSendPort.send(request);
  return completer.future;
}

// ==== Communication between isolates for asynchronous compression and decompression ==== //

/// Application for compression.
class _CompressRequest {
  final int id;
  final Pointer<Void> dst;
  final int dstCapacity;
  final Pointer<Void> src;
  final int srcSize;
  final int compressionLevel;

  const _CompressRequest(this.id, this.dst, this.dstCapacity, this.src,
      this.srcSize, this.compressionLevel);
}

/// Response with the compression result.
class _CompressResponse {
  final int id;
  final int result;

  const _CompressResponse(this.id, this.result);
}

/// Request for decompression.
class _DecompressRequest {
  final int id;
  final Pointer<Void> dst;
  final int dstCapacity;
  final Pointer<Void> src;
  final int compressedSize;

  const _DecompressRequest(
      this.id, this.dst, this.dstCapacity, this.src, this.compressedSize);
}

/// Response with the result of the decompression.
class _DecompressResponse {
  final int id;
  final int result;

  const _DecompressResponse(this.id, this.result);
}

/// Counters to identify compression and decompression requests.
int _nextCompressRequestId = 0;
int _nextDecompressRequestId = 0;

/// Mapping of requests to completers for compression and decompression.
final Map<int, Completer<int>> _compressRequests = <int, Completer<int>>{};
final Map<int, Completer<int>> _decompressRequests = <int, Completer<int>>{};

/// Port for sending requests to the auxiliary isolate.
Future<SendPort> _helperIsolateSendPort = () async {
  final Completer<SendPort> completer = Completer<SendPort>();
  final ReceivePort receivePort = ReceivePort()
    ..listen((dynamic data) {
      if (data is SendPort) {
        completer.complete(data);
        return;
      }
      if (data is _CompressResponse) {
        final Completer<int> completer = _compressRequests[data.id]!;
        _compressRequests.remove(data.id);
        completer.complete(data.result);
        return;
      }
      if (data is _DecompressResponse) {
        final Completer<int> completer = _decompressRequests[data.id]!;
        _decompressRequests.remove(data.id);
        completer.complete(data.result);
        return;
      }
      throw UnsupportedError('Message type not supported: ${data.runtimeType}');
    });

  await Isolate.spawn((SendPort sendPort) async {
    final ReceivePort helperReceivePort = ReceivePort()
      ..listen((dynamic data) {
        if (data is _CompressRequest) {
          final int result = _bindings.ZSTD_compress(data.dst, data.dstCapacity,
              data.src, data.srcSize, data.compressionLevel);
          final _CompressResponse response = _CompressResponse(data.id, result);
          sendPort.send(response);
          return;
        }
        if (data is _DecompressRequest) {
          final int result = _bindings.ZSTD_decompress(
              data.dst, data.dstCapacity, data.src, data.compressedSize);
          final _DecompressResponse response =
              _DecompressResponse(data.id, result);
          sendPort.send(response);
          return;
        }
        throw UnsupportedError(
            'Message type not supported: ${data.runtimeType}');
      });

    sendPort.send(helperReceivePort.sendPort);
  }, receivePort.sendPort);

  return completer.future;
}();
