[![pub package](https://img.shields.io/pub/v/zstandard_android.svg)](https://pub.dev/packages/zstandard_android)

# zstandard_android

The Android implementation of [`zstandard`](https://pub.dev/packages/zstandard).

## Usage

```dart
void act() async {
  final zstandard = ZstandardAndroid();

  Uint8List original = Uint8List.fromList([...]);

  Uint8List? compressed = await zstandard.compress(original);
  
  Uint8List? decompressed = await zstandard.decompress(compressed ?? Uint8List(0));
}
```

<p align="center"><img width="50%" vspace="10" src="https://github.com/landamessenger/zstandard/raw/master/zstandard_android/images/sample.png"></p>
