import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'zstandard_macos_ffi_bindings_generated.dart'; // Binding generado

const String _libName = 'zstandard_macos_ffi';

/// La librería dinámica que contiene los símbolos de Zstd.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError(
      'Plataforma no soportada: ${Platform.operatingSystem}');
}();

/// Las bindings a las funciones nativas de Zstd en [_dylib].
final ZstandardMacosFfiBindings _bindings = ZstandardMacosFfiBindings(_dylib);

class ZstandardPlugin {
  /// Implementación de la compresión utilizando Zstd.
  Future<Uint8List?> compress(Uint8List data, {int compressionLevel = 3}) async {
    // Preparar los datos de entrada
    final int srcSize = data.lengthInBytes;
    final Pointer<Uint8> src = malloc.allocate<Uint8>(srcSize);
    src.asTypedList(srcSize).setAll(0, data);

    // Estimación del tamaño de la compresión
    final int dstCapacity = _bindings.ZSTD_compressBound(srcSize);
    final Pointer<Uint8> dst = malloc.allocate<Uint8>(dstCapacity);

    try {
      // Ejecutar la compresión
      final int compressedSize = _bindings.ZSTD_compress(
        dst.cast(),
        dstCapacity,
        src.cast(),
        srcSize,
        compressionLevel,
      );

      if (compressedSize > 0) {
        // Obtener los datos comprimidos como Uint8List
        return Uint8List.fromList(dst.asTypedList(compressedSize));
      } else {
        return null; // Si la compresión falló
      }
    } finally {
      // Liberar memoria
      malloc.free(src);
      malloc.free(dst);
    }
  }

  /// Implementación de la descompresión utilizando Zstd.
  Future<Uint8List?> decompress(Uint8List compressedData) async {
    // Preparar los datos de entrada
    final int compressedSize = compressedData.lengthInBytes;
    final Pointer<Uint8> src = malloc.allocate<Uint8>(compressedSize);
    src.asTypedList(compressedSize).setAll(0, compressedData);

    // Definir capacidad de salida estimada
    final int dstCapacity = compressedSize * 4; // Estimación de capacidad
    final Pointer<Uint8> dst = malloc.allocate<Uint8>(dstCapacity);

    try {
      // Ejecutar la descompresión
      final int decompressedSize = _bindings.ZSTD_decompress(
        dst.cast(),
        dstCapacity,
        src.cast(),
        compressedSize,
      );

      if (decompressedSize > 0) {
        // Obtener los datos descomprimidos como Uint8List
        return Uint8List.fromList(dst.asTypedList(decompressedSize));
      } else {
        return null; // Si la descompresión falló
      }
    } finally {
      // Liberar memoria
      malloc.free(src);
      malloc.free(dst);
    }
  }
}

/// Función para compresión sincrónica utilizando Zstd.
///
/// Esta función ejecuta la compresión directamente en el hilo principal.
int compress(Pointer<Void> dst, int dstCapacity, Pointer<Void> src, int srcSize,
    int compressionLevel) {
  return _bindings.ZSTD_compress(
      dst, dstCapacity, src, srcSize, compressionLevel);
}

/// Función para descompresión sincrónica utilizando Zstd.
int decompress(
    Pointer<Void> dst, int dstCapacity, Pointer<Void> src, int compressedSize) {
  return _bindings.ZSTD_decompress(dst, dstCapacity, src, compressedSize);
}

/// Compresión asíncrona utilizando un isolate para evitar bloquear el hilo principal.
Future<int> compressAsync(Pointer<Void> dst, int dstCapacity, Pointer<Void> src,
    int srcSize, int compressionLevel) async {
  final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
  final int requestId = _nextCompressRequestId++;
  final _CompressRequest request = _CompressRequest(
      requestId, dst, dstCapacity, src, srcSize, compressionLevel);
  final Completer<int> completer = Completer<int>();
  _compressRequests[requestId] = completer;
  helperIsolateSendPort.send(request);
  return completer.future;
}

/// Descompresión asíncrona utilizando un isolate.
Future<int> decompressAsync(Pointer<Void> dst, int dstCapacity,
    Pointer<Void> src, int compressedSize) async {
  final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
  final int requestId = _nextDecompressRequestId++;
  final _DecompressRequest request =
      _DecompressRequest(requestId, dst, dstCapacity, src, compressedSize);
  final Completer<int> completer = Completer<int>();
  _decompressRequests[requestId] = completer;
  helperIsolateSendPort.send(request);
  return completer.future;
}

// ==== Comunicación entre isolates para compresión y descompresión asincrónica ==== //

/// Solicitud para compresión.
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

/// Respuesta con el resultado de la compresión.
class _CompressResponse {
  final int id;
  final int result;

  const _CompressResponse(this.id, this.result);
}

/// Solicitud para descompresión.
class _DecompressRequest {
  final int id;
  final Pointer<Void> dst;
  final int dstCapacity;
  final Pointer<Void> src;
  final int compressedSize;

  const _DecompressRequest(
      this.id, this.dst, this.dstCapacity, this.src, this.compressedSize);
}

/// Respuesta con el resultado de la descompresión.
class _DecompressResponse {
  final int id;
  final int result;

  const _DecompressResponse(this.id, this.result);
}

/// Contadores para identificar las solicitudes de compresión y descompresión.
int _nextCompressRequestId = 0;
int _nextDecompressRequestId = 0;

/// Mapeo de solicitudes a los completers para compresión y descompresión.
final Map<int, Completer<int>> _compressRequests = <int, Completer<int>>{};
final Map<int, Completer<int>> _decompressRequests = <int, Completer<int>>{};

/// Puerto para enviar las solicitudes al isolate auxiliar.
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
      throw UnsupportedError(
          'Tipo de mensaje no soportado: ${data.runtimeType}');
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
            'Tipo de mensaje no soportado: ${data.runtimeType}');
      });

    sendPort.send(helperReceivePort.sendPort);
  }, receivePort.sendPort);

  return completer.future;
}();
