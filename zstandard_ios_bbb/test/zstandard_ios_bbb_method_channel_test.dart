import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zstandard_ios_bbb/zstandard_ios_bbb_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelZstandardIosBbb platform = MethodChannelZstandardIosBbb();
  const MethodChannel channel = MethodChannel('zstandard_ios_bbb');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
