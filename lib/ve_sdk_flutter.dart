import 'package:ve_sdk_flutter/export_param.dart';
import 'package:ve_sdk_flutter/export_result.dart';
import 'package:ve_sdk_flutter/features_config.dart';
import 've_sdk_flutter_platform_interface.dart';

class VeSdkFlutter {
  Future<ExportResult?> openCameraScreen(
      String token,
      FeaturesConfig featuresConfig,
      {ExportParam? exportParam}
  ) => VeSdkFlutterPlatform.instance.openCameraScreen(
      token,
      featuresConfig,
      exportParam: exportParam
  );

  Future<ExportResult?> openPipScreen(
      String token,
      FeaturesConfig featuresConfig,
      String sourceVideoPath,
      {ExportParam? exportParam}
  ) => VeSdkFlutterPlatform.instance.openPipScreen(
      token,
      featuresConfig,
      sourceVideoPath,
      exportParam: exportParam
  );

  Future<ExportResult?> openTrimmerScreen(
      String token,
      FeaturesConfig featuresConfig,
      List<String> sourceVideoPathList,
      {ExportParam? exportParam}
  ) => VeSdkFlutterPlatform.instance.openTrimmerScreen(
      token,
      featuresConfig,
      sourceVideoPathList,
      exportParam: exportParam
  );
}
