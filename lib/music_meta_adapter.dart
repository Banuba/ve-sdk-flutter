import 'dart:convert';

class MusicMetadata {
  final String title;
  final String audioUrl;

  MusicMetadata({required this.title, required this.audioUrl});

  static List<MusicMetadata>? parseAudioMetadata(String? jsonString) {
    if (jsonString == null) {
      return null;
    }
    List<dynamic> jsonData = jsonDecode(jsonString);

    return jsonData.map((item) {
      return MusicMetadata(
        title: item["title"] ?? "Unknown",
        audioUrl: item["url"] ?? "No URL",
      );
    }).toList();
  }
}
