import 'package:flutter/material.dart';

class FeaturesConfig{

  final AiClipping? aiClipping;
  final AiCaptions? aiCaptions;
  final AudioBrowser? audioBrowser;

  FeaturesConfig._builder(ConfigBuilder builder)
      : aiClipping = builder._aiClipping,
        aiCaptions = builder._aiCaptions,
        audioBrowser = builder._audioBrowser;
}

class ConfigBuilder {
  AiClipping? _aiClipping;
  AiCaptions?  _aiCaptions;
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

  FeaturesConfig build() {
    if (_isEmpty()) {
      throw Exception("At least one of the Config must be provided");
    }
    return FeaturesConfig._builder(this);
  }

  bool _isEmpty() {
    return _aiClipping == null && _aiCaptions == null && _audioBrowser == null;
  }
}

enum Source {soundstripe, local, disable}

@immutable
class AudioBrowser {
  final Source source;
  final Map<String, dynamic>? params;

  const AudioBrowser._({required this.source, this.params});

  factory AudioBrowser.fromSource(Source source, {Map<String, dynamic>? params}) {
    return AudioBrowser._(source: source, params: params);
  }
}

@immutable
class AiClipping{
  final String audioDataUrl;
  final String audioTracksUrl;

  const AiClipping({required this.audioDataUrl, required this.audioTracksUrl});
}

@immutable
class AiCaptions{
  final String uploadUrl;
  final String transcribeUrl;
  final String apiKey;

  const AiCaptions({required this.uploadUrl, required this.transcribeUrl, required this.apiKey});
}