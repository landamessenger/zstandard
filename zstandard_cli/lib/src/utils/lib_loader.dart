import 'dart:ffi';
import 'dart:io';

import 'package:path/path.dart' as path;

DynamicLibrary openZstdLibrary() {
  if (Platform.isWindows) {
    final String arch = Platform.version.contains('ARM64') ? "arm64" : "x64";
    final libPath = path.join(Directory.current.path, 'lib', 'src', 'bin',
        'zstandard_windows_$arch.dll');
    return DynamicLibrary.open(libPath);
  } else if (Platform.isMacOS) {
    final libPath = path.join(Directory.current.path, 'lib', 'src', 'bin',
        'libzstandard_macos.dylib');
    return DynamicLibrary.open(libPath);
  } else if (Platform.isLinux) {
    final String arch =
        Platform.operatingSystemVersion.contains("aarch64") ? "arm64" : "x64";
    final libPath = path.join(Directory.current.path, 'lib', 'src', 'bin',
        'libzstandard_linux_$arch.so');
    return DynamicLibrary.open(libPath);
  }
  throw UnsupportedError('Unsupported platform');
}
