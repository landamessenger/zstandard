import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:zstandard_platform_interface/src/zstandard_platform_interface_method_channel.dart';
import 'package:zstandard_platform_interface/zstandard_platform_interface.dart';

class MockZstandardPlatformInterfacePlatform
    with MockPlatformInterfaceMixin
    implements ZstandardPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<Uint8List?> compress(Uint8List data) async {
    return null;
  }

  @override
  Future<Uint8List?> decompress(Uint8List data) async {
    return null;
  }
}

void main() {
  final ZstandardPlatform initialPlatform =
      ZstandardPlatform.instance;

  test('$MethodChannelZstandardPlatform is the default instance', () {
    expect(initialPlatform,
        isInstanceOf<MethodChannelZstandardPlatform>());
  });

  test('getPlatformVersion', () async {
    // ZstandardPlatformInterface zstandardPlatformInterfacePlugin = ZstandardPlatformInterface();
    MockZstandardPlatformInterfacePlatform fakePlatform =
        MockZstandardPlatformInterfacePlatform();
    ZstandardPlatform.instance = fakePlatform;

    // expect(await zstandardPlatformInterfacePlugin.getPlatformVersion(), '42');
  });
}
