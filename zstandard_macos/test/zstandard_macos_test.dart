import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:zstandard_macos/zstandard_macos.dart';
import 'package:zstandard_macos/zstandard_macos_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockZstandardMacosPlatform
    with MockPlatformInterfaceMixin
    implements ZstandardMacos {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<Uint8List?> compress(Uint8List data) {
    // TODO: implement compress
    throw UnimplementedError();
  }

  @override
  Future<Uint8List?> decompress(Uint8List data) {
    // TODO: implement decompress
    throw UnimplementedError();
  }
}

void main() {
  final ZstandardMacos initialPlatform = ZstandardMacos();

  test('$MethodChannelZstandardMacos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelZstandardMacos>());
  });

  test('getPlatformVersion', () async {
    ZstandardMacos zstandardMacosPlugin = ZstandardMacos();
    MockZstandardMacosPlatform fakePlatform = MockZstandardMacosPlatform();
    //ZstandardMacos.instance = fakePlatform;

    expect(await fakePlatform.getPlatformVersion(), '42');
  });
}
