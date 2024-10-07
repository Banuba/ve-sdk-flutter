import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:ve_sdk_flutter/export_data.dart';
import 'package:ve_sdk_flutter/export_result.dart';
import 've_sdk_flutter_method_channel.dart';
import 'package:ve_sdk_flutter/features_config.dart';

abstract class VeSdkFlutterPlatform extends PlatformInterface {
  /// Constructs a VeSdkFlutterPlatform.
  VeSdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static VeSdkFlutterPlatform _instance = MethodChannelVeSdkFlutter();

  /// The default instance of [VeSdkFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelVeSdkFlutter].
  static VeSdkFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VeSdkFlutterPlatform] when
  /// they register themselves.
  static set instance(VeSdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<ExportResult?> openCameraScreen(
      String token,
      FeaturesConfig featuresConfig,
      {ExportData? exportData}
  ) {
      throw UnimplementedError('openCameraScreen() has not been implemented.');
  }

  Future<ExportResult?> openPipScreen(
      String token,
      FeaturesConfig featuresConfig,
      String sourceVideoPath,
      {ExportData? exportData}
  ) {
      throw UnimplementedError('openPipScreen() has not been implemented.');
  }

  Future<ExportResult?> openTrimmerScreen(
      String token,
      FeaturesConfig featuresConfig,
      List<String> sourceVideoPathList,
      {ExportData? exportData}
  ) {
      throw UnimplementedError('openTrimmerScreen() has not been implemented.');
  }
}
