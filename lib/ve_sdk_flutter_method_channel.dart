import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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

  // Input params
  static const String _inputParamToken = 'token';
  static const String _inputParamScreen = 'screen';
  static const String _inputParamVideoSources = 'videoSources';

  // Exported params
  static const String _exportedVideoSources = 'exportedVideoSources';
  static const String _exportedPreview = 'exportedPreview';
  static const String _exportedMeta = 'exportedMeta';

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(_channelName);

  @override
  Future<ExportResult?> openCameraScreen(String token) => _open(token, _screenCamera, []);

  @override
  Future<ExportResult?> openPipScreen(String token, String sourceVideoPath) =>
      _open(token, _screenPip, [sourceVideoPath]);

  @override
  Future<ExportResult?> openTrimmerScreen(String token, List<String> sourceVideoPathList) =>
      _open(token, _screenTrimmer, sourceVideoPathList);

  Future<ExportResult?> _open(String token, String screen, List<String> sourceVideoPathList) async {
    final inputParams = {
      _inputParamToken: token,
      _inputParamScreen: screen,
      _inputParamVideoSources: sourceVideoPathList
    };

    debugPrint('Start video editor with params = $inputParams');

    dynamic exportedData = await methodChannel.invokeMethod(_methodStart, inputParams);

    if (exportedData == null) {
      return null;
    } else {
      List<Object?> sources = exportedData[_exportedVideoSources] as List<Object?>;
      List<String> videoSources =
          sources.where((element) => element != null).map((e) => e.toString()).toList();

      String? metaFilePath = exportedData[_exportedMeta];
      String? previewFilePath = exportedData[_exportedPreview];
      return ExportResult(
          videoSources: videoSources, previewFilePath: previewFilePath, metaFilePath: metaFilePath);
    }
  }
}
