import 'dart:js' as js;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:zstandard_web/zstandard_web.dart';

void main() {
  group('ZstandardWeb with zstd.js and zstd.wasm', () {
    late ZstandardWeb zstandardWeb;

    setUp(() {
      zstandardWeb = ZstandardWeb();

      // Cargar zstd.js y zstd.wasm en el entorno de pruebas
      js.context.callMethod('eval', [
        """
        var zstdModule;
        fetch('wasm/zstd.wasm').then(response =>
          response.arrayBuffer()
        ).then(bytes =>
          WebAssembly.instantiate(bytes, {})
        ).then(results => {
          zstdModule = results.instance;
        });

        function compressData(data) {
          // Usa zstdModule aquí para realizar compresión.
          // Implementación de compresión usando zstdModule
          return data.reverse(); // Simulación para ejemplo
        }

        function decompressData(data) {
          // Usa zstdModule aquí para realizar descompresión.
          // Implementación de descompresión usando zstdModule
          return data.reverse(); // Simulación para ejemplo
        }
      """
      ]);
    });

    test('getPlatformVersion returns a non-null userAgent string', () async {
      final version = await zstandardWeb.getPlatformVersion();
      expect(version, isNotNull);
    });

    test('compress returns the same data if length is less than 9 bytes',
        () async {
      final data = Uint8List.fromList([1, 2, 3, 4, 5]);
      final result = await zstandardWeb.compress(data);
      expect(result, data);
    });

    test('compress with zstd.js returns compressed data for valid input',
        () async {
      final data = Uint8List.fromList(List.generate(10, (index) => index));

      // Prueba con el método de JavaScript usando zstd.js
      final compressed = await zstandardWeb.compress(data);
      final decompressed =
          await zstandardWeb.decompress(compressed ?? Uint8List(0));
      expect(compressed, isNotNull);
      expect(decompressed, isNotNull);
      expect(compressed, isA<Uint8List>());
      expect(decompressed, isA<Uint8List>());
      expect(decompressed, compressed);
    });

    test('compress throws an exception if compression fails', () async {
      final data = Uint8List.fromList(List.generate(10, (index) => index));

      // Simula un fallo en compresión
      js.context['compressData'] = (Uint8List data) => null;

      expect(() async => await zstandardWeb.compress(data), throwsException);
    });

    test('decompress returns the same data if length is less than 9 bytes',
        () async {
      final data = Uint8List.fromList([1, 2, 3, 4, 5]);
      final result = await zstandardWeb.decompress(data);
      expect(result, data);
    });

    test('decompress throws an exception if decompression fails', () async {
      final data = Uint8List.fromList(List.generate(10, (index) => index));

      // Simula un fallo en descompresión
      js.context['decompressData'] = (Uint8List data) => null;

      expect(() async => await zstandardWeb.decompress(data), throwsException);
    });
  });
}
