import 'package:flutter/material.dart';

class FeaturesConfig {
  final AiClipping? aiClipping;
  final AiCaptions? aiCaptions;
  final AudioBrowser audioBrowser;
  final EditorConfig? editorConfig;

  FeaturesConfig._builder(FeatureConfigBuilder builder)
      : aiClipping = builder._aiClipping,
        aiCaptions = builder._aiCaptions,
        audioBrowser = builder._audioBrowser,
        editorConfig = builder._editorConfig;
}

class FeatureConfigBuilder {
  AiClipping? _aiClipping;
  AiCaptions? _aiCaptions;
  AudioBrowser _audioBrowser =
      AudioBrowser.fromSource(AudioBrowserSource.local);
  EditorConfig? _editorConfig;

  FeatureConfigBuilder setAiClipping(aiClipping) {
    _aiClipping = aiClipping;
    return this;
  }

  FeatureConfigBuilder setAiCaptions(aiCaptions) {
    _aiCaptions = aiCaptions;
    return this;
  }

  FeatureConfigBuilder setAudioBrowser(audioBrowser) {
    _audioBrowser = audioBrowser;
    return this;
  }

  FeatureConfigBuilder setEditorConfig(editorConfig) {
    _editorConfig = editorConfig;
    return this;
  }

  FeaturesConfig build() {
    return FeaturesConfig._builder(this);
  }
}

enum AudioBrowserSource { soundstripe, local }

@immutable
class AudioBrowser {
  final AudioBrowserSource source;
  final Map<String, dynamic>? params;

  const AudioBrowser._({required this.source, this.params});

  factory AudioBrowser.fromSource(AudioBrowserSource source,
      {Map<String, dynamic>? params}) {
    return AudioBrowser._(source: source, params: params);
  }
}

@immutable
class AiClipping {
  final String audioDataUrl;
  final String audioTracksUrl;

  const AiClipping({
      required this.audioDataUrl,
      required this.audioTracksUrl
  });
}

@immutable
class AiCaptions {
  final String uploadUrl;
  final String transcribeUrl;
  final String apiKey;

  const AiCaptions({
      required this.uploadUrl,
      required this.transcribeUrl,
      required this.apiKey
  });
}

@immutable
class EditorConfig {
  final bool? isVideoAspectFillEnabled;

  const EditorConfig({
        this.isVideoAspectFillEnabled
  });
}