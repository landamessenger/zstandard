[![pub package](https://img.shields.io/pub/v/zstandard_cli.svg)](https://pub.dev/packages/zstandard_cli)

# zstandard_cli

The command-line implementation of [`zstandard`](https://pub.dev/packages/zstandard).

Zstandard (zstd) is a fast compression algorithm developed by Meta (formerly Facebook) for real-time scenarios. It provides a flexible range of compression levels, enabling both high-speed and high-compression-ratio options. This makes it ideal for applications needing efficient data storage, transmission, and backup solutions.

`zstandard_cli` is a Dart package that binds to the high-performance Zstandard compression library, enabling both in-code and command-line compression and decompression. It leverages FFI to directly access native Zstandard functionality, allowing efficient data processing in Dart applications, from in-memory data compression to file handling via the CLI.

**Available on macOS, Windows, and Linux desktops only**.

|             | [macOS](https://flutter.dev/desktop) | [Windows](https://flutter.dev/desktop) | [Linux](https://flutter.dev/desktop) |
|:-----------:|:------------------------------------:|:--------------------------------------:|:------------------------------------:|
|     x64     |          :heavy_check_mark:          |           :heavy_check_mark:           |          :heavy_check_mark:          |
|    arm64    |          :heavy_check_mark:          |           :heavy_check_mark:           |          :heavy_check_mark:          |  
| Precompiled |                 Yes                  |                  Yes                   |                 Yes                  |  

> **Note:** This is a pure Dart package for desktop usage. For Flutter, please see the [zstandard](https://pub.dev/packages/zstandard) plugin.

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

---

The images provided below illustrate how to use `zstandard_cli` for compression and decompression on different platforms.

<p align="center"><img width="90%" vspace="10" src="https://github.com/landamessenger/zstandard/raw/master/zstandard_cli/images/macos_compression_sample.png"></p>
<p align="center"><img width="90%" vspace="10" src="https://github.com/landamessenger/zstandard/raw/master/zstandard_cli/images/macos_decompression_sample.png"></p>
<p align="center"><img width="90%" vspace="10" src="https://github.com/landamessenger/zstandard/raw/master/zstandard_cli/images/windows_compression_sample.png"></p>
<p align="center"><img width="90%" vspace="10" src="https://github.com/landamessenger/zstandard/raw/master/zstandard_cli/images/windows_decompression_sample.png"></p>
<p align="center"><img width="90%" vspace="10" src="https://github.com/landamessenger/zstandard/raw/master/zstandard_cli/images/linux_compression_sample.png"></p>
<p align="center"><img width="90%" vspace="10" src="https://github.com/landamessenger/zstandard/raw/master/zstandard_cli/images/linux_decompression_sample.png"></p>
