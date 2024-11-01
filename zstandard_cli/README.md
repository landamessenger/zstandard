[![pub package](https://img.shields.io/pub/v/zstandard_cli.svg)](https://pub.dev/packages/zstandard_cli)

# zstandard_cli

The CLI implementation of [`zstandard`](https://pub.dev/packages/zstandard). **Only available on macOS, Windows, and Linux desktops**.

Zstandard (zstd) is a fast, high-compression algorithm developed by Meta (formerly Facebook) designed for real-time compression scenarios. It provides a flexible range of compression levels, allowing both high-speed and high-ratio compression, making it ideal for applications with diverse performance needs. Zstandard is commonly used in data storage, transmission, and backup solutions.

`zstandard_cli` is a Dart package which provides bindings to the high-performance Zstandard compression library, enabling both in-code and command-line compression and decompression. It leverages FFI for direct access to native Zstandard functionality, allowing efficient data processing in Dart applications, from compressing data in memory to handling files through the CLI.

## Basic Usage

```dart
void main() async {
  var cli = ZstandardCLI();

  final originalData = Uint8List.fromList([...]);

  final compressed = await cli.compress(originalData, compressionLevel: 3);

  final decompressed = await cli.decompress(compressed ?? Uint8List(0));
}
```

With extensions:

```dart
void main() async {
  final originalData = Uint8List.fromList([...]);

  final compressed = await originalData.compress(compressionLevel: 3);

  final decompressed = await compressed.decompress();
}
```

## CLI Usage

```bash
dart run zstandard_cli:compress any_file 3

dart run zstandard_cli:decompress any_file.zstd
```


## Unix Compilation

```bash
cd zstd && make
```

## Windows Compilation

```bash
cd zstd
 
build_zstd.bat
```