import 'package:ve_sdk_flutter/export_result.dart';
import 'package:ve_sdk_flutter/config.dart';

import 've_sdk_flutter_platform_interface.dart';

class VeSdkFlutter {
  Future<ExportResult?> openCameraScreen(String token, {Config? config}) =>
      VeSdkFlutterPlatform.instance.openCameraScreen(token, config: config);

  Future<ExportResult?> openPipScreen(String token, String sourceVideoPath, {Config? config}) =>
      VeSdkFlutterPlatform.instance.openPipScreen(token, config: config, sourceVideoPath);

  Future<ExportResult?> openTrimmerScreen(String token, List<String> sourceVideoPathList, {Config? config}) =>
      VeSdkFlutterPlatform.instance.openTrimmerScreen(token, config: config, sourceVideoPathList);
}
