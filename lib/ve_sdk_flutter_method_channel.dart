import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 've_sdk_flutter_platform_interface.dart';

/// An implementation of [VeSdkFlutterPlatform] that uses method channels.
class MethodChannelVeSdkFlutter extends VeSdkFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ve_sdk_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
