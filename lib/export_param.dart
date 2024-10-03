class ExportParam {
  final List<ExportedVideo> exportedVideos;
  final Watermark? watermark;

  const ExportParam({required this.exportedVideos, this.watermark});
}

enum VideoResolution {
  vga_360p,
  vga_480p,
  qhd_540p,
  hd_720p,
  fhd_1080p,
  qhd_1440p,
  uhd_2160p,
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
  final WatermarkAlignment? watermarkAlignment;

  const Watermark({required this.imagePath, this.watermarkAlignment});
}
