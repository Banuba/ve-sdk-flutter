import 'package:flutter/material.dart';

class FeaturesConfig {
  final AiClipping? aiClipping;
  final Captions? captions;
  final AudioBrowser audioBrowser;
  final CameraConfig cameraConfig;
  final EditorConfig editorConfig;
  final CoverConfig coverConfig;
  final DraftsConfig draftsConfig;
  final GifPickerConfig? gifPickerConfig;
  final VideoDurationConfig videoDurationConfig;
  final bool enableEditorV2;
  final bool processPictureExternally;

  FeaturesConfig._builder(FeaturesConfigBuilder builder)
      : aiClipping = builder._aiClipping,
        captions = builder._captions,
        audioBrowser = builder._audioBrowser,
        cameraConfig = builder._cameraConfig,
        editorConfig = builder._editorConfig,
        coverConfig = builder._coverConfig,
        draftsConfig = builder._draftsConfig,
        gifPickerConfig = builder._gifPickerConfig,
        videoDurationConfig = builder._videoDurationConfig,
        enableEditorV2 = builder._enableEditorV2,
        processPictureExternally = builder._processPictureExternally;
}

class FeaturesConfigBuilder {
  AiClipping? _aiClipping;
  Captions? _captions;
  AudioBrowser _audioBrowser =
      AudioBrowser.fromSource(AudioBrowserSource.local);
  CameraConfig _cameraConfig = CameraConfig(
    supportsBeauty: true,
    supportsColorEffects: true,
    supportsMasks: true,
    autoStartLocalMask: null
  );
  EditorConfig _editorConfig = EditorConfig(
    enableVideoAspectFill: true,
    supportsVisualEffects: true,
    supportsColorEffects: true
  );
  CoverConfig _coverConfig = CoverConfig(
      supportsCoverScreen: true
  );
  DraftsConfig _draftsConfig =
      DraftsConfig.fromOption(DraftsOption.askToSave);
  GifPickerConfig? _gifPickerConfig;
  bool _enableEditorV2 = true;
  VideoDurationConfig _videoDurationConfig = VideoDurationConfig();
  bool _processPictureExternally = false;

  FeaturesConfigBuilder setAiClipping(aiClipping) {
    _aiClipping = aiClipping;
    return this;
  }

  FeaturesConfigBuilder setCaptions(captions) {
    _captions = captions;
    return this;
  }

  FeaturesConfigBuilder setAudioBrowser(audioBrowser) {
    _audioBrowser = audioBrowser;
    return this;
  }

  FeaturesConfigBuilder setCameraConfig(cameraConfig) {
    _cameraConfig = cameraConfig;
    return this;
  }

  FeaturesConfigBuilder setEditorConfig(editorConfig) {
    _editorConfig = editorConfig;
    return this;
  }

  FeaturesConfigBuilder setCoverConfig(coverConfig) {
    _coverConfig = coverConfig;
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
class Captions {
  final String? uploadUrl;
  final String? transcribeUrl;
  final String? apiKey;
  final String? apiV2Key;

  const Captions({
      this.uploadUrl,
      this.transcribeUrl,
      this.apiKey,
      this.apiV2Key,
  });
}

enum RecordMode { video, photo }

@immutable
class CameraConfig {
  final bool supportsBeauty;
  final bool supportsColorEffects;
  final bool supportsMasks;
  final List<RecordMode> recordModes;
  final String? autoStartLocalMask;

  const CameraConfig({
    this.supportsBeauty = true,
    this.supportsColorEffects = true,
    this.supportsMasks = true,
    this.recordModes = const [RecordMode.video, RecordMode.photo],
    this.autoStartLocalMask = null,
  });
}

@immutable
class EditorConfig {
  final bool enableVideoAspectFill;
  final bool supportsVisualEffects;
  final bool supportsColorEffects;
  final bool supportsVoiceOver;
  final bool supportsAudioEditing;

  const EditorConfig({
    this.enableVideoAspectFill = true,
    this.supportsVisualEffects = true,
    this.supportsColorEffects = true,
    this.supportsVoiceOver = true,
    this.supportsAudioEditing = true
  });
}

@immutable
class CoverConfig {
  final bool supportsCoverScreen;

  const CoverConfig({
    this.supportsCoverScreen = true
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