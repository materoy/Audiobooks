import 'dart:async';

import 'package:flutter/services.dart';

class MediaScanner {
  static const MethodChannel _channel = const MethodChannel('media_scanner');

  static Future scanFile(String fileUri) async {
    final result = await _channel.invokeMethod('scan', <String, dynamic>{
      'fileUri': fileUri,
    });
    return result;
  }
}
