class TrackData {
  final String id;
  final String title;
  final String subtitle;
  final String localUrl;

  TrackData({required this.id, required this.title, required this.subtitle, required this.localUrl});
}

extension TrackDataSerializer on TrackData {
  Map<String, dynamic> serialize() {
    final Map<String, dynamic> configMap = {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'localUrl': localUrl
    };

    configMap.removeWhere((key, value) => value == null);

    return configMap;
  }
}