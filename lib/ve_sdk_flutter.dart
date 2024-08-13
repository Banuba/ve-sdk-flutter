import 'package:ve_sdk_flutter/export_result.dart';
import 'package:ve_sdk_flutter/features_config.dart';
import 've_sdk_flutter_platform_interface.dart';

class VeSdkFlutter {
  Future<ExportResult?> openCameraScreen(
      String token,
      FeaturesConfig featuresConfig
  ) => VeSdkFlutterPlatform.instance.openCameraScreen(
      token,
      featuresConfig
  );

  Future<ExportResult?> openPipScreen(
      String token,
      FeaturesConfig featuresConfig,
      String sourceVideoPath
  ) => VeSdkFlutterPlatform.instance.openPipScreen(
      token,
      featuresConfig,
      sourceVideoPath
  );

  Future<ExportResult?> openTrimmerScreen(
      String token,
      FeaturesConfig featuresConfig,
      List<String> sourceVideoPathList
  ) => VeSdkFlutterPlatform.instance.openTrimmerScreen(
      token,
      featuresConfig,
      sourceVideoPathList
  );
}
