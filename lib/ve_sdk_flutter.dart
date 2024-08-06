import 'package:ve_sdk_flutter/export_result.dart';
import 'package:ve_sdk_flutter/features_config.dart';

import 've_sdk_flutter_platform_interface.dart';

class VeSdkFlutter {
  Future<ExportResult?> openCameraScreen(String token, {FeaturesConfig? config}) =>
      VeSdkFlutterPlatform.instance.openCameraScreen(token, config: config);

  Future<ExportResult?> openPipScreen(String token, String sourceVideoPath, {FeaturesConfig? config}) =>
      VeSdkFlutterPlatform.instance.openPipScreen(token, config: config, sourceVideoPath);

  Future<ExportResult?> openTrimmerScreen(String token, List<String> sourceVideoPathList, {FeaturesConfig? config}) =>
      VeSdkFlutterPlatform.instance.openTrimmerScreen(token, config: config, sourceVideoPathList);
}
