import 'dart:ffi';
import 'dart:io';

DynamicLibrary openZstdLibrary() {
  if (Platform.isWindows) return DynamicLibrary.open('bin/zstd.dll');
  if (Platform.isMacOS) return DynamicLibrary.open('bin/libzstd.dylib');
  if (Platform.isLinux) return DynamicLibrary.open('bin/libzstd.so');
  throw UnsupportedError('Unsupported platform');
}
