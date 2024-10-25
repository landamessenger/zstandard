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

