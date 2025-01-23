import 'package:flutter/material.dart';

class FeaturesConfig {
  final AiClipping? aiClipping;
  final AiCaptions? aiCaptions;
  final AudioBrowser audioBrowser;
  final EditorConfig editorConfig;
  final DraftsConfig draftsConfig;
  final GifPickerConfig? gifPickerConfig;
  final VideoDurationConfig videoDurationConfig;
  final bool enableEditorV2;
  final bool processPictureExternally;

  FeaturesConfig._builder(FeaturesConfigBuilder builder)
      : aiClipping = builder._aiClipping,
        aiCaptions = builder._aiCaptions,
        audioBrowser = builder._audioBrowser,
        editorConfig = builder._editorConfig,
        draftsConfig = builder._draftsConfig,
        gifPickerConfig = builder._gifPickerConfig,
        videoDurationConfig = builder._videoDurationConfig,
        enableEditorV2 = builder._enableEditorV2,
        processPictureExternally = builder._processPictureExternally;
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
  bool _enableEditorV2 = false;
  VideoDurationConfig _videoDurationConfig = VideoDurationConfig();
  bool _processPictureExternally = false;

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

  FeaturesConfigBuilder setVideoDurationConfig(videoDurationConfig) {
    _videoDurationConfig = videoDurationConfig;
    return this;
  }

  FeaturesConfigBuilder enableEditorV2(enableEditorV2) {
    _enableEditorV2 = enableEditorV2;
    return this;
  }

  FeaturesConfigBuilder setProcessPictureExternally(processPictureExternally) {
    _processPictureExternally = processPictureExternally;
    return this;
  }

  FeaturesConfig build() {
    return FeaturesConfig._builder(this);
  }
}

enum AudioBrowserSource { soundstripe, local, mubert, banubaMusic, disabled }

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

@immutable
class VideoDurationConfig {
  /// Max Total Video Duration for Camera and Editor Screens
  final double? maxTotalVideoDuration;
  /// The video maximum durations
  /// Default list is [maxTotalVideoDuration, 60.0, 30.0, 15.0]
  /// If the list contains only one value the selector will not be displayed
  final List<double>? videoDurations;

  const VideoDurationConfig({
    this.maxTotalVideoDuration = 120.0,
    this.videoDurations = const [60.0, 30.0, 15.0]
  });
}