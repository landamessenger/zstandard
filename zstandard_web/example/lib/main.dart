import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zstandard_web/zstandard_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Uint8List _originalData = Uint8List.fromList(
    [
      10,
      20,
      30,
      4,
      3,
      3,
      10,
      20,
      30,
      10,
      20,
      30,
      4,
      3,
      3,
      10,
      20,
      30,
      10,
      20,
      30,
      4,
      3,
      3,
      10,
      20,
      30,
      10,
      20,
      30,
      4,
      3,
      3,
      10,
      20,
      30,
      10,
      20,
      30,
      4,
      3,
      3,
      10,
      20,
      30
    ],
  );

  Uint8List? _compressedData;

  Uint8List? _decompressedData;

  String _platformVersion = 'Unknown';

  final _zstandardPlatformWebPlugin = ZstandardWeb();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    checkCompression();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _zstandardPlatformWebPlugin.getPlatformVersion() ??
              'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> checkCompression() async {
    Uint8List? compressed;
    Uint8List? decompressed;

    try {
      compressed = await _zstandardPlatformWebPlugin.compress(_originalData);
      decompressed = await _zstandardPlatformWebPlugin
          .decompress(compressed ?? Uint8List(0));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    print(compressed);
    if (!mounted) return;

    setState(() {
      _compressedData = compressed;
      _decompressedData = decompressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Running on: $_platformVersion\n'),
              Text('Original: ${_originalData.join(',')}\n'),
              Text('Compressed: ${_compressedData?.join(',')}\n'),
              Text('Decompressed: ${_decompressedData?.join(',')}\n'),
            ],
          ),
        ),
      ),
    );
  }
}
