import 'dart:js' as js;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:zstandard_web/zstandard_web.dart';

class MockJsContext extends Mock implements js.JsObject {}

void main() {
  group('ZstandardWeb', () {
    late ZstandardWeb zstandardWeb;

    setUp(() {
      zstandardWeb = ZstandardWeb();
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

    test('compress returns compressed data for valid input', () async {
      final data = Uint8List.fromList(List.generate(10, (index) => index));

      // Simulate JavaScript compression
      js.context['compressData'] = (Uint8List data) => List.from(data.reversed);

      final result = await zstandardWeb.compress(data);
      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
      expect(result, Uint8List.fromList(data.reversed.toList()));
    });

    test('compress throws an exception if compression fails', () async {
      final data = Uint8List.fromList(List.generate(10, (index) => index));

      // Simulate JavaScript compression failure
      js.context['compressData'] = (Uint8List data) => null;

      expect(() async => await zstandardWeb.compress(data), throwsException);
    });

    test('decompress returns the same data if length is less than 9 bytes',
        () async {
      final data = Uint8List.fromList([1, 2, 3, 4, 5]);
      final result = await zstandardWeb.decompress(data);
      expect(result, data);
    });

    test('decompress returns decompressed data for valid input', () async {
      final data = Uint8List.fromList(List.generate(10, (index) => index));

      // Simulate JavaScript decompression
      js.context['decompressData'] =
          (Uint8List data) => List.from(data.reversed);

      final result = await zstandardWeb.decompress(data);
      expect(result, isNotNull);
      expect(result, isA<Uint8List>());
      expect(result, Uint8List.fromList(data.reversed.toList()));
    });

    test('decompress throws an exception if decompression fails', () async {
      final data = Uint8List.fromList(List.generate(10, (index) => index));

      // Simulate JavaScript decompression failure
      js.context['decompressData'] = (Uint8List data) => null;

      expect(() async => await zstandardWeb.decompress(data), throwsException);
    });
  });
}
