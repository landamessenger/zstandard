/*
import 'package:flutter_test/flutter_test.dart';
import 'package:zstandard_windows/zstandard_windows.dart';
import 'package:zstandard_windows/zstandard_windows_platform_interface.dart';
import 'package:zstandard_windows/zstandard_windows_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockZstandardWindowsPlatform
    with MockPlatformInterfaceMixin
    implements ZstandardWindowsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ZstandardWindowsPlatform initialPlatform = ZstandardWindowsPlatform.instance;

  test('$MethodChannelZstandardWindows is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelZstandardWindows>());
  });

  test('getPlatformVersion', () async {
    ZstandardWindows zstandardWindowsPlugin = ZstandardWindows();
    MockZstandardWindowsPlatform fakePlatform = MockZstandardWindowsPlatform();
    ZstandardWindowsPlatform.instance = fakePlatform;

    expect(await zstandardWindowsPlugin.getPlatformVersion(), '42');
  });
}
*/