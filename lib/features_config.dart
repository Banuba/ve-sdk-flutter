import 'package:flutter/material.dart';

class FeaturesConfig {
  final AiClipping? aiClipping;
  final AiCaptions? aiCaptions;
  final AudioBrowser audioBrowser;
  final EditorConfig editorConfig;
  final DraftConfig draftConfig;

  FeaturesConfig._builder(FeaturesConfigBuilder builder)
      : aiClipping = builder._aiClipping,
        aiCaptions = builder._aiCaptions,
        audioBrowser = builder._audioBrowser,
        editorConfig = builder._editorConfig,
        draftConfig = builder._draftConfig;
}

class FeaturesConfigBuilder {
  AiClipping? _aiClipping;
  AiCaptions? _aiCaptions;
  AudioBrowser _audioBrowser =
      AudioBrowser.fromSource(AudioBrowserSource.local);
  EditorConfig _editorConfig = EditorConfig(enableVideoAspectFill: true);
  DraftConfig _draftConfig =
      DraftConfig.fromOption(DraftOption.askToSave);

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

  FeaturesConfigBuilder setDraftConfig(draftConfig) {
    _draftConfig = draftConfig;
    return this;
  }

  FeaturesConfig build() {
    return FeaturesConfig._builder(this);
  }
}

enum AudioBrowserSource { soundstripe, local, mubert }

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

enum DraftOption { askToSave, closeOnSave, auto, disabled }

@immutable
class DraftConfig {
  final DraftOption option;

  const DraftConfig._({required this.option});

  factory DraftConfig.fromOption(DraftOption option) {
    return DraftConfig._(option: option);
  }
}