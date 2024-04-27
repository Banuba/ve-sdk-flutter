import 'package:ve_sdk_flutter/export_result.dart';

import 've_sdk_flutter_platform_interface.dart';

class VeSdkFlutter {
  Future<ExportResult?> openCameraScreen(String token) =>
      VeSdkFlutterPlatform.instance.openCameraScreen(token);

  Future<ExportResult?> openPipScreen(String token, String sourceVideoPath) =>
      VeSdkFlutterPlatform.instance.openPipScreen(token, sourceVideoPath);

  Future<ExportResult?> openTrimmerScreen(String token, List<String> sourceVideoPathList) =>
      VeSdkFlutterPlatform.instance.openTrimmerScreen(token, sourceVideoPathList);
}
