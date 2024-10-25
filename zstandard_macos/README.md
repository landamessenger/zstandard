[![pub package](https://img.shields.io/pub/v/zstandard_macos.svg)](https://pub.dev/packages/zstandard_macos)

# zstandard_macos

The macOS implementation of [`zstandard`](https://pub.dev/packages/zstandard).

## Usage

```dart
void act() async {
  final zstandard = ZstandardMacOS();

  Uint8List original = Uint8List.fromList([...]);

  Uint8List? compressed = await zstandard.compress(original);
  
  Uint8List? decompressed = await zstandard.decompress(compressed ?? Uint8List(0));
}
```

<p align="center"><img width="90%" vspace="10" src="https://github.com/landamessenger/zstandard/blob/master/zstandard_macos/images/sample.png"></p>
