import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zstandard_platform_interface/src/zstandard_platform_interface_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelZstandardPlatform platform = MethodChannelZstandardPlatform();
  const MethodChannel channel = MethodChannel('zstandard_platform_interface');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion throws an Exception', () async {
    await expectLater(
      () async => await platform.getPlatformVersion(),
      throwsA(isA<MissingPluginException>()),
    );
  });
}
