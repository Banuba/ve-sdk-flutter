/// Represents data exported with Video Editor SDK. Contains a number of exported video files,
/// preview file and meta.
class ExportResult {
  List<String> videoSources;
  String? previewFilePath;
  String? metaFilePath;

  ExportResult(
      {required this.videoSources, required this.previewFilePath, required this.metaFilePath});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExportResult &&
          runtimeType == other.runtimeType &&
          videoSources == other.videoSources &&
          previewFilePath == other.previewFilePath &&
          metaFilePath == other.metaFilePath;

  @override
  int get hashCode => videoSources.hashCode ^ previewFilePath.hashCode ^ metaFilePath.hashCode;

  @override
  String toString() {
    return 'ExportResult{videoSources: $videoSources, previewFilePath: $previewFilePath, metaFilePath: $metaFilePath}';
  }
}
