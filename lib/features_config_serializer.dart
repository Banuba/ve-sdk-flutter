import 'dart:convert';
import 'package:ve_sdk_flutter/features_config.dart';

extension FeatureConfigSerializer on FeaturesConfig {
  String serialize() {
    final Map<String, dynamic> configMap = {
      'aiClipping': aiClipping?._serialize(),
      'captions': captions?._serialize(),
      'audioBrowser': audioBrowser._serialize(),
      'cameraConfig': cameraConfig._serialize(),
      'editorConfig': editorConfig._serialize(),
      'coverConfig': coverConfig._serialize(),
      'draftsConfig': draftsConfig._serialize(),
      'gifPickerConfig': gifPickerConfig?._serialize(),
      'videoDurationConfig': videoDurationConfig._serialize(),
      'enableEditorV2': enableEditorV2,
      'processPictureExternally': processPictureExternally
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

extension CaptionsSerializer on Captions {
  Map<String, dynamic> _serialize() {
    return {
      'uploadUrl': uploadUrl,
      'transcribeUrl': transcribeUrl,
      'apiKey': apiKey,
      'apiV2Key': apiV2Key
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

extension CameraConfigSerializer on CameraConfig {
  Map<String, dynamic> _serialize() {
    return {
      'supportsBeauty': supportsBeauty,
      'supportsColorEffects': supportsColorEffects,
      'supportsMasks': supportsMasks,
      'recordModes': recordModes
        .map((e) => e.name)
        .toList(),
      'autoStartLocalMask': autoStartLocalMask
    };
  }
}

extension EditorConfigSerializer on EditorConfig {
  Map<String, dynamic> _serialize() {
    return {
      'enableVideoAspectFill': enableVideoAspectFill,
      'supportsVisualEffects': supportsVisualEffects,
      'supportsColorEffects': supportsColorEffects,
      'supportsVoiceOver' : supportsVoiceOver,
      'supportsAudioEditing' : supportsAudioEditing
    };
  }
}

extension CoverConfigSerializer on CoverConfig {
  Map<String, dynamic> _serialize() {
    return {
      'supportsCoverScreen': supportsCoverScreen
    };
  }
}

extension DraftConfigSerializer on DraftsConfig {
  Map<String, dynamic> _serialize() {
    return {
      'option': option.name,
    };
  }
}

extension GifPickerConfigSerializer on GifPickerConfig {
  Map<String, dynamic> _serialize() {
    return {
      'giphyApiKey': giphyApiKey
    };
  }
}

extension VideoDurationConfigSerializer on VideoDurationConfig {
  Map<String, dynamic> _serialize() {
    return {
      'maxTotalVideoDuration': maxTotalVideoDuration,
      'videoDurations': videoDurations
    };
  }
}
