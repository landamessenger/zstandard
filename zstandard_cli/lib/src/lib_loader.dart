import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;

DynamicLibrary openZstdLibrary() {
  // if (Platform.isWindows) return DynamicLibrary.open('bin/zstd.dll');
  if (Platform.isMacOS) {
    final libPath = path.join(
        Directory.current.path, 'lib', 'src', 'bin', 'libzstd.dylib');
    return DynamicLibrary.open(libPath);
    // return DynamicLibrary.open('bin/libzstd.dylib');
  }
  // if (Platform.isLinux) return DynamicLibrary.open('bin/libzstd.so');
  throw UnsupportedError('Unsupported platform');
}
