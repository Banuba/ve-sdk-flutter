import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ve_sdk_flutter/audio_meta_adapter.dart';
import 'package:ve_sdk_flutter/export_data.dart';
import 'package:ve_sdk_flutter/export_data_serializer.dart';
import 'package:ve_sdk_flutter/features_config.dart';
import 'package:ve_sdk_flutter/features_config_serializer.dart';
import 'package:ve_sdk_flutter/export_result.dart';
import 've_sdk_flutter_platform_interface.dart';

/// An implementation of [VeSdkFlutterPlatform] that uses method channels.
class MethodChannelVeSdkFlutter extends VeSdkFlutterPlatform {
  // Channel and method
  static const String _channelName = 've_sdk_flutter';
  static const String _methodStart = 'startVideoEditor';

  // Screens
  static const String _screenCamera = 'camera';
  static const String _screenPip = 'pip';
  static const String _screenTrimmer = 'trimmer';
  static const String _screenAiClipping = 'aiClipping';

  // Input params
  static const String _inputParamToken = 'token';
  static const String _inputParamFeaturesConfig = 'featuresConfig';
  static const String _inputParamExportData = 'exportData';
  static const String _inputParamScreen = 'screen';
  static const String _inputParamVideoSources = 'videoSources';

  // Exported params
  static const String _exportedVideoSources = 'exportedVideoSources';
  static const String _exportedPreview = 'exportedPreview';
  static const String _exportedMeta = 'exportedMeta';
  static const String _exportedAudioMeta = 'exportedAudioMeta';

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(_channelName);

  @override
  Future<ExportResult?> openCameraScreen(
      String token,
      FeaturesConfig featuresConfig,
      {ExportData? exportData}
      ) => _open(
      token,
      featuresConfig,
      _screenCamera,
      [],
      exportData: exportData
  );

  @override
  Future<ExportResult?> openPipScreen(
      String token,
      FeaturesConfig featuresConfig,
      String sourceVideoPath,
      {ExportData? exportData}
      ) => _open(
      token,
      featuresConfig,
      _screenPip,
      [sourceVideoPath],
      exportData: exportData
  );

  @override
  Future<ExportResult?> openTrimmerScreen(
      String token,
      FeaturesConfig featuresConfig,
      List<String> sourceVideoPathList,
      {ExportData? exportData}
      ) => _open(
      token,
      featuresConfig,
      _screenTrimmer,
      sourceVideoPathList,
      exportData: exportData
  );

  @override
  Future<ExportResult?> openAiClippingScreen(
      String token,
      FeaturesConfig featuresConfig,
      {ExportData? exportData}
      ) => _open(
      token,
      featuresConfig,
      _screenAiClipping,
      [],
      exportData: exportData
  );

  Future<ExportResult?> _open(
      String token,
      FeaturesConfig featuresConfig,
      String screen,
      List<String> sourceVideoPathList,
      {ExportData? exportData}
  ) async {
    if (featuresConfig.enableEditorV2 && screen == _screenTrimmer){
      debugPrint("New UI is not available from Trimmer screen");
      return null;
    }
    final inputParams = {
      _inputParamToken: token,
      _inputParamFeaturesConfig: featuresConfig.serialize(),
      _inputParamScreen: screen,
      _inputParamVideoSources: sourceVideoPathList,
      _inputParamExportData: exportData?.serialize()
    };

    debugPrint('Start video editor with params = $inputParams');

    dynamic exportedData =
        await methodChannel.invokeMethod(_methodStart, inputParams);

    if (exportedData == null) {
      return null;
    } else {
      List<Object?> sources =
          exportedData[_exportedVideoSources] as List<Object?>;
      List<String> videoSources = sources
          .where((element) => element != null)
          .map((e) => e.toString())
          .toList();

      String? metaFilePath = exportedData[_exportedMeta];
      String? previewFilePath = exportedData[_exportedPreview];
      String? audioMetaJson = exportedData[_exportedAudioMeta];
      return ExportResult(
          videoSources: videoSources,
          previewFilePath: previewFilePath,
          metaFilePath: metaFilePath,
          audioMeta: AudioMetadata.parseAudioMetadata(audioMetaJson));
    }
  }
}
