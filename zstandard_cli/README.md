# zstandard_cli

Zstandard (zstd) is a fast, high-compression algorithm developed by Meta (formerly Facebook) designed for real-time compression scenarios. It provides a flexible range of compression levels, allowing both high-speed and high-ratio compression, making it ideal for applications with diverse performance needs. Zstandard is commonly used in data storage, transmission, and backup solutions.

`zstandard_cli` is a Dart package providing bindings to the high-performance Zstandard compression library, enabling both in-code and command-line compression and decompression. It leverages FFI for direct access to native Zstandard functionality, allowing efficient data processing in Dart applications, from compressing data in memory to handling files through the CLI.

> **Note:** Due to its reliance on native libraries, this package is only available on macOS, Windows, and Linux desktops. It is not compatible with mobile or web platforms.

## In-code Usage

```dart
void main() async {
  var cli = ZstandardCLI();

  final originalData = Uint8List.fromList([...]);

  final compressed = await cli.compress(originalData, compressionLevel: 3);

  final decompressed = await cli.decompress(compressed ?? Uint8List(0));
}
```

## CLI Usage

```bash
dart run zstandard_cli:compress analysis_options.yaml 3

dart run zstandard_cli:decompress analysis_options.yaml.zstd
```

## macOS compilation

```bash
cd zstd && make
```