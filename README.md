[![pub package](https://img.shields.io/pub/v/zstandard.svg)](https://pub.dev/packages/zstandard)

# Zstandard

Zstandard (zstd) is a fast, high-compression algorithm developed by Meta (formerly Facebook) designed for real-time compression scenarios. It provides a flexible range of compression levels, allowing both high-speed and high-ratio compression, making it ideal for applications with diverse performance needs. Zstandard is commonly used in data storage, transmission, and backup solutions.

This is a Flutter plugin that provides a pure implementation of the zstd compression algorithm, developed by Meta. It integrates the zstd library in C through FFI for native platforms, ensuring efficient compression and decompression. For web platforms, it leverages WebAssembly to deliver the same robust compression capabilities. This plugin enables seamless, cross-platform data compression, making it ideal for applications requiring high-speed and efficient data processing.

|             |      Android       |        iOS         | [Web](https://flutter.dev/web) | [macOS](https://flutter.dev/desktop) | [Windows](https://flutter.dev/desktop) | [Linux](https://flutter.dev/desktop) | [Fuchsia](https://fuchsia.dev/) |
|:-----------:|:------------------:|:------------------:|:------------------------------:|:------------------------------------:|:--------------------------------------:|:------------------------------------:|:-------------------------------:|
|   Status    | :heavy_check_mark: | :heavy_check_mark: |       :heavy_check_mark:       |          :heavy_check_mark:          |           :heavy_check_mark:           |          :heavy_check_mark:          |                ❌                |
|   Native    |        FFI         |        FFI         |          WebAssembly           |                 FFI                  |                  FFI                   |                 FFI                  |                ❌                |
| Precompiled |         No         |         No         |           Yes (wasm)           |                  No                  |                   No                   |                  No                  |                ❌                 |


> The C files to build the compression library come from the original [facebook/zstd](https://github.com/facebook/zstd/tree/dev/lib) repository.

## Usage

```dart
void act() async {
  final zstandard = Zstandard();

  Uint8List original = Uint8List.fromList([...]);

  Uint8List? compressed = await zstandard.compress(original);
  
  Uint8List? decompressed = await zstandard.decompress(compressed ?? Uint8List(0));
}
```

With extension functions:

```dart
void act() async {
  Uint8List original = Uint8List.fromList([...]);

  Uint8List? compressed = await original.compress();
  
  Uint8List? decompressed = await compressed.decompress();
}
```

<p align="center"><img width="50%" vspace="10" src="https://github.com/landamessenger/zstandard/raw/master/zstandard_android/images/sample.png"></p>

<p align="center"><img width="50%" vspace="10" src="https://github.com/landamessenger/zstandard/raw/master/zstandard_ios/images/sample.png"></p>

<p align="center"><img width="90%" vspace="10" src="https://github.com/landamessenger/zstandard/raw/master/zstandard_macos/images/sample.png"></p>

<p align="center"><img width="90%" vspace="10" src="https://github.com/landamessenger/zstandard/raw/master/zstandard_web/images/sample.png"></p>

<p align="center"><img width="90%" vspace="10" src="https://github.com/landamessenger/zstandard/raw/master/zstandard_windows/images/sample.png"></p>

<p align="center"><img width="90%" vspace="10" src="https://github.com/landamessenger/zstandard/raw/master/zstandard_linux/images/sample.png"></p>
