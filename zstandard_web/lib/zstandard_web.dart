import 'dart:js' as js;
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
    var compressedData = js.context.callMethod('compressData', [data, compressionLevel]);
    if (compressedData != null) {
      return Uint8List.fromList(List<int>.from(compressedData));
    } else {
      throw Exception("Error compressing.");
    }
  }

  @override
  Future<Uint8List?> decompress(Uint8List data) async {
    if (data.length < 9) return data;
    var decompressedData = js.context.callMethod('decompressData', [data]);
    if (decompressedData != null) {
      return Uint8List.fromList(List<int>.from(decompressedData));
    } else {
      throw Exception("Error decompressing.");
    }
  }
}
