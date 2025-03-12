import 'dart:convert';

enum AudioType { track, voice }

class AudioMetadata {
  final String title;
  final String audioUrl;
  final AudioType? type;

  AudioMetadata({required this.title, required this.audioUrl, required this.type});

  static List<AudioMetadata> parseAudioMetadata(String? jsonString) {
    if (jsonString == null) {
      return [];
    }
    List<dynamic> jsonData = jsonDecode(jsonString);

    return jsonData.map((item) {
      AudioType? type;
      if (item.containsKey("isAudioRecord")) {
        type = (item["isAudioRecord"] == true) ? AudioType.voice : AudioType.track;
      } else if (item.containsKey("type")) {
        type = (item["type"] == "VOICE") ? AudioType.voice : AudioType.track;
      }

      return AudioMetadata(
        title: item["title"] ?? "",
        audioUrl: item["url"] ?? "",
        type: type
      );
    }).toList();
  }
}
