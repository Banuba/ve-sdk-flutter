import 'dart:convert';
import 'package:ve_sdk_flutter/aiCaptionsConfig.dart';
import 'package:ve_sdk_flutter/aiClippingConfig.dart';
import 'package:ve_sdk_flutter/audioBrowserConfig.dart';

class Config{

  final AiClipping? _aiClipping;
  final AiCaptions? _aiCaptions;
  final AudioBrowser? _audioBrowser;

  Config._builder(ConfigBuilder builder)
      : _aiClipping = builder._aiClipping,
        _aiCaptions = builder._aiCaptions,
        _audioBrowser = builder._audioBrowser;

  String serialize() {
    final Map<String, dynamic> configMap = {
      'aiClipping': _aiClipping?.toJson(),
      'aiCaptions': _aiCaptions?.toJson(),
      'audioBrowser': _audioBrowser?.toJson(),
    };
    return jsonEncode(configMap);
  }
}

class ConfigBuilder {
  AiClipping? _aiClipping;
  AiCaptions? _aiCaptions;
  AudioBrowser? _audioBrowser;

  ConfigBuilder setAiClipping(aiClipping) {
    _aiClipping = aiClipping;
    return this;
  }

  ConfigBuilder setAiCaptions(aiCaptions) {
    _aiCaptions = aiCaptions;
    return this;
  }

  ConfigBuilder setAudioBrowser(audioBrowser){
    _audioBrowser = audioBrowser;
    return this;
  }

  Config build() {
    if (_isEmpty()) {
      throw Exception("At least one of the Config must be provided");
    }
    return Config._builder(this);
  }

  bool _isEmpty() {
    return _aiClipping == null && _aiCaptions == null && _audioBrowser == null;
  }
}