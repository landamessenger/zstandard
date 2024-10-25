# zstandard

Zstandard is a high-performance Flutter plugin that provides a pure implementation of the zstd compression algorithm, developed by Meta. It integrates the zstd library in C through FFI for native platforms, ensuring efficient compression and decompression. For web platforms, it leverages WebAssembly to deliver the same robust compression capabilities. This plugin enables seamless, cross-platform data compression, making it ideal for applications requiring high-speed and efficient data processing.

## Usage

```dart
void act() async {
  final zstandard = ZstandardMacOS();

  Uint8List original = Uint8List.fromList([...]);

  Uint8List? compressed = await zstandard.compress(original);
  
  Uint8List? decompressed = await zstandard.decompress(compressed ?? Uint8List(0));
}
```

<p align="center"><img width="90%" vspace="10" src="https://github.com/landamessenger/zstandard/blob/master/zstandard_web/images/sample.png"></p>

<p align="center"><img width="90%" vspace="10" src="https://github.com/landamessenger/zstandard/blob/master/zstandard_macos/images/sample.png"></p>
