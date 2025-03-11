import 'dart:convert';

class AudioMetadata {
  final String title;
  final String audioUrl;

  AudioMetadata({required this.title, required this.audioUrl});

  static List<AudioMetadata>? parseAudioMetadata(String? jsonString) {
    if (jsonString == null) {
      return null;
    }
    List<dynamic> jsonData = jsonDecode(jsonString);

    return jsonData.map((item) {
      return AudioMetadata(
        title: item["title"] ?? "Unknown",
        audioUrl: item["url"] ?? "No URL",
      );
    }).toList();
  }
}
