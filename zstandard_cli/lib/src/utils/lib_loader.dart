import 'dart:ffi';
import 'dart:io';

import 'package:path/path.dart' as path;

DynamicLibrary openZstdLibrary() {
  if (Platform.isWindows) {
    final libPath =
        path.join(Directory.current.path, 'lib', 'src', 'bin', 'zstandard_windows.dll');
    return DynamicLibrary.open(libPath);
  } else if (Platform.isMacOS) {
    final libPath =
        path.join(Directory.current.path, 'lib', 'src', 'bin', 'libzstandard_macos.dylib');
    return DynamicLibrary.open(libPath);
  } else if (Platform.isLinux) {
    final libPath =
        path.join(Directory.current.path, 'lib', 'src', 'bin', 'libzstd.so');
    return DynamicLibrary.open(libPath);
  }
  throw UnsupportedError('Unsupported platform');
}
