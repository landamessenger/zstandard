import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zstandard_platform_web_example/main.dart';
import 'package:zstandard_web/zstandard_web.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ZstandardWeb with zstd.js and zstd.wasm', () {

    late ZstandardWeb zstandardWeb;

    setUp(() {
      zstandardWeb = ZstandardWeb();
    });

    testWidgets('Verify Platform version', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that platform version is retrieved.
      expect(
        find.byWidgetPredicate(
              (Widget widget) => widget is Text &&
              widget.data!.startsWith('Running on:'),
        ),
        findsOneWidget,
      );
    });

    test('getPlatformVersion returns a non-null userAgent string', () async {
      final version = await zstandardWeb.getPlatformVersion();
      expect(version, isNotNull);
    });

    test('compress returns the same data if length is less than 9 bytes', () async {
      final data = Uint8List.fromList([1, 2, 3, 4, 5]);
      final result = await zstandardWeb.compress(data, 3);
      expect(result, data);
    });

    test('compress with zstd.js returns compressed data for valid input', () async {
      final data = Uint8List.fromList(List.generate(10, (index) => index));

      final compressed = await zstandardWeb.compress(data, 4);
      final decompressed = await zstandardWeb.decompress(compressed ?? Uint8List(0));
      expect(compressed, isNotNull);
      expect(decompressed, isNotNull);
      expect(compressed, isA<Uint8List>());
      expect(decompressed, isA<Uint8List>());
      expect(decompressed, data);
    });

    test('compress throws an exception if compression fails', () async {
      final data = Uint8List.fromList(List.generate(10, (index) => index));

      // Simula un fallo en compresión
      js.context['compressData'] = (Uint8List data) => null;

      expect(() async => await zstandardWeb.compress(data, 5), throwsException);
    });

    test('decompress returns the same data if length is less than 9 bytes', () async {
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

