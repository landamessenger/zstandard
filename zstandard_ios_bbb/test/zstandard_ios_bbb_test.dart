import 'package:flutter_test/flutter_test.dart';
import 'package:zstandard_ios_bbb/zstandard_ios_bbb.dart';
import 'package:zstandard_ios_bbb/zstandard_ios_bbb_platform_interface.dart';
import 'package:zstandard_ios_bbb/zstandard_ios_bbb_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockZstandardIosBbbPlatform
    with MockPlatformInterfaceMixin
    implements ZstandardIosBbbPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ZstandardIosBbbPlatform initialPlatform = ZstandardIosBbbPlatform.instance;

  test('$MethodChannelZstandardIosBbb is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelZstandardIosBbb>());
  });

  test('getPlatformVersion', () async {
    ZstandardIosBbb zstandardIosBbbPlugin = ZstandardIosBbb();
    MockZstandardIosBbbPlatform fakePlatform = MockZstandardIosBbbPlatform();
    ZstandardIosBbbPlatform.instance = fakePlatform;

    expect(await zstandardIosBbbPlugin.getPlatformVersion(), '42');
  });
}
