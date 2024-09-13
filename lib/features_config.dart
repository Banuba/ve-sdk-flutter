import 'package:flutter/material.dart';

class FeaturesConfig {
  final AiClipping? aiClipping;
  final AiCaptions? aiCaptions;
  final AudioBrowser audioBrowser;
  final EditorConfig editorConfig;
  final DraftsConfig draftsConfig;
  final GifPickerConfig? gifPickerConfig;

  FeaturesConfig._builder(FeaturesConfigBuilder builder)
      : aiClipping = builder._aiClipping,
        aiCaptions = builder._aiCaptions,
        audioBrowser = builder._audioBrowser,
        editorConfig = builder._editorConfig,
        draftsConfig = builder._draftsConfig,
        gifPickerConfig = builder._gifPickerConfig;
}

class FeaturesConfigBuilder {
  AiClipping? _aiClipping;
  AiCaptions? _aiCaptions;
  AudioBrowser _audioBrowser =
      AudioBrowser.fromSource(AudioBrowserSource.local);
  EditorConfig _editorConfig =
      EditorConfig(enableVideoAspectFill: true);
  DraftsConfig _draftsConfig =
      DraftsConfig.fromOption(DraftsOption.askToSave);
  GifPickerConfig? _gifPickerConfig;

  FeaturesConfigBuilder setAiClipping(aiClipping) {
    _aiClipping = aiClipping;
    return this;
  }

  FeaturesConfigBuilder setAiCaptions(aiCaptions) {
    _aiCaptions = aiCaptions;
    return this;
  }

  FeaturesConfigBuilder setAudioBrowser(audioBrowser) {
    _audioBrowser = audioBrowser;
    return this;
  }

  FeaturesConfigBuilder setEditorConfig(editorConfig) {
    _editorConfig = editorConfig;
    return this;
  }

  FeaturesConfigBuilder setDraftsConfig(draftsConfig) {
    _draftsConfig = draftsConfig;
    return this;
  }

  FeaturesConfigBuilder setGifPickerConfig(gifPickerConfig) {
    _gifPickerConfig = gifPickerConfig;
    return this;
  }

  FeaturesConfig build() {
    return FeaturesConfig._builder(this);
  }
}

enum AudioBrowserSource { soundstripe, local, mubert, banubaFm }

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
  final bool? enableVideoAspectFill;

  const EditorConfig({
        this.enableVideoAspectFill
  });
}

enum DraftsOption { askToSave, closeOnSave, auto, disabled }

@immutable
class DraftsConfig {
  final DraftsOption option;

  const DraftsConfig._({required this.option});

  factory DraftsConfig.fromOption(DraftsOption option) {
    return DraftsConfig._(option: option);
  }
}

@immutable
class GifPickerConfig {
  final String giphyApiKey;

  const GifPickerConfig({required this.giphyApiKey});
}