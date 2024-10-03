import 'dart:convert';
import 'package:ve_sdk_flutter/export_param.dart';

extension ExportParamListSerializer on ExportParam {
  String serialize() {
    final Map<String, dynamic> configMap = {
      'exportedVideos': exportedVideos.map((e) => e._serialize()).toList(),
      'watermark': watermark?._serialize()
    };

    return jsonEncode(configMap);
  }
}

extension ExportedVideoSerializer on ExportedVideo {
  Map<String, dynamic> _serialize() {
    final Map<String, dynamic> configMap = {
      'fileName': fileName,
      'videoResolution': videoResolution.name,
      'useHevcIfPossible': useHevcIfPossible
    };

    configMap.removeWhere((key, value) => value == null);

    return configMap;
  }
}

extension WatermarkSerializer on Watermark {
  Map<String, dynamic> _serialize() {
    final Map<String, dynamic> configMap = {
      'imagePath': imagePath,
      'watermarkAlignment': watermarkAlignment?.name
    };

    configMap.removeWhere((key, value) => value == null);

    return configMap;
  }
}
