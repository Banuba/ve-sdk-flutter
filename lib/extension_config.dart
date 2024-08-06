import 'dart:convert';
import 'package:ve_sdk_flutter/features_config.dart';

extension ConfigExtension on FeaturesConfig{
  String serialize() {
    final Map<String, dynamic> configMap = {
      'aiClipping': aiClipping?.toJson(),
      'aiCaptions': aiCaptions?.toJson(),
      'audioBrowser': audioBrowser?.toJson(),
    };
    return jsonEncode(configMap);
  }
}

extension AudioBrowserExtensions on AudioBrowser {
  Map<String, dynamic> toJson(){
    return {
      'source' : source.name,
      'params' : params,
    };
  }
}

extension AiClippingExtension on AiClipping {
  Map<String, dynamic> toJson(){
    return {
      'audioDataUrl': audioDataUrl,
      'audioTracksUrl': audioTracksUrl,
    };
  }
}

extension AiCaptionsExtension on AiCaptions {
  Map<String, dynamic> toJson(){
    return {
      'uploadUrl': uploadUrl,
      'transcribeUrl': transcribeUrl,
      'apiKey': apiKey,
    };
  }
}