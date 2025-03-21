import 'package:ve_sdk_flutter/export_data.dart';
import 'package:ve_sdk_flutter/export_result.dart';
import 'package:ve_sdk_flutter/features_config.dart';
import 've_sdk_flutter_platform_interface.dart';

class VeSdkFlutter {
  Future<ExportResult?> openCameraScreen(
      String token,
      FeaturesConfig featuresConfig,
      {ExportData? exportData}
  ) => VeSdkFlutterPlatform.instance.openCameraScreen(
      token,
      featuresConfig,
      exportData: exportData
  );

  Future<ExportResult?> openPipScreen(
      String token,
      FeaturesConfig featuresConfig,
      String sourceVideoPath,
      {ExportData? exportData}
  ) => VeSdkFlutterPlatform.instance.openPipScreen(
      token,
      featuresConfig,
      sourceVideoPath,
      exportData: exportData
  );

  Future<ExportResult?> openTrimmerScreen(
      String token,
      FeaturesConfig featuresConfig,
      List<String> sourceVideoPathList,
      {ExportData? exportData}
  ) => VeSdkFlutterPlatform.instance.openTrimmerScreen(
      token,
      featuresConfig,
      sourceVideoPathList,
      exportData: exportData
  );

  Future<ExportResult?> openAiClippingScreen(
      String token,
      FeaturesConfig featuresConfig,
      {ExportData? exportData}
      ) => VeSdkFlutterPlatform.instance.openAiClippingScreen(
      token,
      featuresConfig,
      exportData: exportData
  );
}
