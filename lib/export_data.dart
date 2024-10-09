class ExportData {
  final List<ExportedVideo> exportedVideos;
  final Watermark? watermark;

  const ExportData({required this.exportedVideos, this.watermark});
}

enum VideoResolution {
  vga360p,
  vga480p,
  qhd540p,
  hd720p,
  fhd1080p,
  qhd1440p,
  uhd2160p,
  auto,
  original
}

class ExportedVideo {
  final String fileName;
  final VideoResolution videoResolution;
  final bool? useHevcIfPossible;

  const ExportedVideo(
      {required this.fileName,
      required this.videoResolution,
      this.useHevcIfPossible});
}

enum WatermarkAlignment { topLeft, topRight, bottomLeft, bottomRight }

class Watermark {
  final String imagePath;
  final WatermarkAlignment? alignment;

  const Watermark({required this.imagePath, this.alignment});
}
