import 'dart:convert';

import 'package:flutter/material.dart';

enum AudioType { track, voice }

class AudioMetadata {
  final String title;
  final String audioUrl;
  final AudioType type;

  AudioMetadata({required this.title, required this.audioUrl, required this.type});

  static List<AudioMetadata> parseAudioMetadata(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(jsonString);

      if (decoded is! List) {
        return [];
      }

      return decoded.map((item) {
        if (item is! Map) {
          return null;
        }

        AudioType type = AudioType.track;
        if (item.containsKey("isAudioRecord")) {
          type = (item["isAudioRecord"] == true)
              ? AudioType.voice
              : AudioType.track;
        } else if (item.containsKey("type")) {
          type = (item["type"] == "VOICE")
              ? AudioType.voice
              : AudioType.track;
        }

        return AudioMetadata(
          title: item["title"] ?? "",
          audioUrl: item["url"] ?? "",
          type: type,
        );
      }).whereType<AudioMetadata>().toList();
    } catch (e) {
      debugPrint("Failed to parse audio metadata: $e");
      return [];
    }
  }
}
