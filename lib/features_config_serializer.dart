import 'dart:convert';
import 'package:ve_sdk_flutter/features_config.dart';

extension FeatureConfigSerializer on FeaturesConfig {
  String serialize() {
    final Map<String, dynamic> configMap = {
      'aiClipping': aiClipping?._serialize(),
      'aiCaptions': aiCaptions?._serialize(),
      'audioBrowser': audioBrowser._serialize(),
      'editorConfig': editorConfig._serialize(),
      'draftConfig': draftConfig._serialize()
    };
    return jsonEncode(configMap);
  }
}

extension AiClippingSerializer on AiClipping {
  Map<String, dynamic> _serialize() {
    return {
      'audioDataUrl': audioDataUrl,
      'audioTracksUrl': audioTracksUrl,
    };
  }
}

extension AiCaptionsSerializer on AiCaptions {
  Map<String, dynamic> _serialize() {
    return {
      'uploadUrl': uploadUrl,
      'transcribeUrl': transcribeUrl,
      'apiKey': apiKey,
    };
  }
}

extension AudioBrowserSerializer on AudioBrowser {
  Map<String, dynamic> _serialize() {
    return {
      'source': source.name,
      'params': params,
    };
  }
}

extension EditorConfigSerializer on EditorConfig {
  Map<String, dynamic> _serialize() {
    return {
      'enableVideoAspectFill': enableVideoAspectFill
    };
  }
}

extension DraftConfigSerializer on DraftConfig {
  Map<String, dynamic> _serialize() {
    return {
      'option': option.name,
    };
  }
}