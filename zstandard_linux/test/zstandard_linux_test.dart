/*
import 'package:flutter_test/flutter_test.dart';
import 'package:zstandard_linux/zstandard_linux.dart';
import 'package:zstandard_linux/zstandard_linux_platform_interface.dart';
import 'package:zstandard_linux/zstandard_linux_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockZstandardLinuxPlatform
    with MockPlatformInterfaceMixin
    implements ZstandardLinuxPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ZstandardLinuxPlatform initialPlatform = ZstandardLinuxPlatform.instance;

  test('$MethodChannelZstandardLinux is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelZstandardLinux>());
  });

  test('getPlatformVersion', () async {
    ZstandardLinux zstandardLinuxPlugin = ZstandardLinux();
    MockZstandardLinuxPlatform fakePlatform = MockZstandardLinuxPlatform();
    ZstandardLinuxPlatform.instance = fakePlatform;

    expect(await zstandardLinuxPlugin.getPlatformVersion(), '42');
  });
}*/
