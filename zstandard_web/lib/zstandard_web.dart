import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter_web_plugins/flutter_web_plugins.dart' show Registrar;
import 'package:web/web.dart' as html;
import 'package:zstandard_platform_interface/zstandard_platform_interface.dart';

export 'zstandard_ext.dart';

/// The web implementation of [ZstandardPlatform].
///
/// This class implements the `package:zstandard` functionality for the web.
class ZstandardWeb extends ZstandardPlatform {
  /// A constructor that allows tests to override the window object used by the plugin.
  ZstandardWeb({@visibleForTesting html.Window? debugWindow});

  /// Registers this class as the default instance of [ZstandardPlatformInterface].
  static void registerWith(Registrar registrar) {
    ZstandardPlatform.instance = ZstandardWeb();
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  @override
  Future<Uint8List?> compress(Uint8List data, int compressionLevel) async {
    if (data.length < 9) return data;
    var compressedData = html.window.callMethodVarArgs('compressData'.toJS, [
      data.toJS,
      compressionLevel.toJS,
    ]) as JSUint8Array?;
    if (compressedData != null) {
      return compressedData.toDart;
    } else {
      throw Exception("Error compressing.");
    }
  }

  @override
  Future<Uint8List?> decompress(Uint8List data) async {
    if (data.length < 9) return data;
    var decompressedData =
        html.window.callMethodVarArgs('decompressData'.toJS, [
      data.toJS,
    ]) as JSUint8Array?;
    if (decompressedData != null) {
      return decompressedData.toDart;
    } else {
      throw Exception("Error decompressing.");
    }
  }
}
