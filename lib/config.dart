import 'dart:convert';
import 'package:flutter/material.dart';

class Config{

  final AiClipping? _aiClipping;
  final AiCaptions? _aiCaptions;

  Config._builder(ConfigBuilder builder)
      : _aiClipping = builder._aiClipping,
        _aiCaptions = builder._aiCaptions;

  String serialize() {
    final Map<String, dynamic> configMap = {
      'aiClipping': _aiClipping?._toJson(),
      'aiCaptions': _aiCaptions?._toJson(),
    };
    return jsonEncode(configMap);
  }
}

class ConfigBuilder {
  AiClipping? _aiClipping;
  AiCaptions? _aiCaptions;

  ConfigBuilder setAiClipping(aiClipping) {
    _aiClipping = aiClipping;
    return this;
  }

  ConfigBuilder setAiCaptions(aiCaptions) {
    _aiCaptions = aiCaptions;
    return this;
  }

  Config build() {
    if (_isEmpty()) {
      throw Exception("At least one of the Config must be provided");
    }
    return Config._builder(this);
  }

  bool _isEmpty() {
    return _aiClipping == null && _aiCaptions == null;
  }
}

@immutable
class AiClipping{
  final String audioDataUrl;
  final String audioTracksUrl;

  const AiClipping({required this.audioDataUrl, required this.audioTracksUrl});

  Map<String, dynamic> _toJson(){
    return {
      'audioDataUrl': audioDataUrl,
      'audioTracksUrl': audioTracksUrl,
    };
  }
}

@immutable
class AiCaptions{
  final String uploadUrl;
  final String transcribeUrl;
  final String apiKey;

  const AiCaptions({required this.uploadUrl, required this.transcribeUrl, required this.apiKey});

  Map<String, dynamic> _toJson(){
    return {
      'uploadUrl': uploadUrl,
      'transcribeUrl': transcribeUrl,
      'apiKey': apiKey,
    };
  }
}

// TODO: Add AudioBrowser with enum and map<K, V>