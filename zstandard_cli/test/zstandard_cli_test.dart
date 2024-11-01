import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:zstandard_cli/zstandard_cli.dart';

void main() {
  group('Zstandard CLI tests', () {
    test('Compress and decompress small Uint8List', () async {
      final Uint8List sample = Uint8List.fromList([1, 2, 3, 4, 5]);
      final compressed = await sample.compress(compressionLevel: 3);
      final decompressed = await compressed.decompress();
      expect(sample, isNot(equals(compressed)));
      expect(sample.length, isNot(equals(compressed?.length)));
      expect(decompressed, equals(sample));
    });

    test('Compress and decompress large Uint8List', () async {
      final Uint8List sample =
          Uint8List.fromList(List<int>.generate(100000, (i) => i % 256));
      final compressed = await sample.compress(compressionLevel: 3);
      final decompressed = await compressed.decompress();
      expect(sample, isNot(equals(compressed)));
      expect(sample.length, isNot(equals(compressed?.length)));
      expect(decompressed, equals(sample));
    });

    test('Compress and decompress empty Uint8List', () async {
      final Uint8List sample = Uint8List(0);
      final compressed = await sample.compress(compressionLevel: 3);
      final decompressed = await compressed.decompress();
      expect(sample, equals(compressed));
      expect(sample.length, equals(compressed?.length));
      expect(decompressed, equals(sample));
    });

    test('Compress and decompress Uint8List with repeated values', () async {
      final Uint8List sample = Uint8List.fromList(List.filled(1000, 42));
      final compressed = await sample.compress(compressionLevel: 3);
      final decompressed = await compressed.decompress();
      expect(sample, isNot(equals(compressed)));
      expect(sample.length, isNot(equals(compressed?.length)));
      expect(decompressed, equals(sample));
    });

    test('Compress and decompress with maximum compression level', () async {
      final Uint8List sample =
          Uint8List.fromList([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      final compressed = await sample.compress(compressionLevel: 22);
      final decompressed = await compressed.decompress();
      expect(sample, isNot(equals(compressed)));
      expect(sample.length, isNot(equals(compressed?.length)));
      expect(decompressed, equals(sample));
    });

    test('Compress and decompress with minimal compression level', () async {
      final Uint8List sample =
          Uint8List.fromList([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      final compressed = await sample.compress(compressionLevel: 1);
      final decompressed = await compressed.decompress();
      expect(sample, isNot(equals(compressed)));
      expect(sample.length, isNot(equals(compressed?.length)));
      expect(decompressed, equals(sample));
    });
  });
}
