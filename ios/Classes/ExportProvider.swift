import Foundation
import BanubaVideoEditorSDK
import VideoEditor
import VEExportSDK
import Flutter

struct ExportProvider {
    
    let exportParam: ExportParam
    let controller: FlutterViewController
    private var fileUrls: [String: URL]
    
    init(exportParam: ExportParam, controller: FlutterViewController) {
        self.exportParam = exportParam
        self.controller = controller
        self.fileUrls = Dictionary(uniqueKeysWithValues: exportParam.exportedVideos.map { ($0.fileName, ExportProvider.createFileUrl(exportedVideo: $0)) })
    }
    
    public func createExportConfiguration() -> ExportConfiguration {
        let exportVideoConfigurations = exportParam.exportedVideos.map {
            guard let fileUrl = fileUrls[$0.fileName] else {
                fatalError("URL not found for file: \($0.fileName)")
            }
            return ExportVideoConfiguration(
                fileURL: fileUrl,
                quality: $0.qualityValue(),
                useHEVCCodecIfPossible: $0.useHevcIfPossible ?? true,
                watermarkConfiguration: exportParam.watermark?.watermarkConfigurationValue(controller: controller)
            )
        }
        
        return ExportConfiguration(
            videoConfigurations: exportVideoConfigurations,
            isCoverEnabled: true,
            gifSettings: nil
        )
    }
    
    public func collectVideoUrls() -> [URL] {
        return Array(fileUrls.values)
    }
    
    public func createPreviewURL() -> URL{
        return FileManager.default.temporaryDirectory.appendingPathComponent("export_preview.png")
    }
    
    private static func createFileUrl(exportedVideo: ExportedVideo) -> URL {
        let manager = FileManager.default
        let fileUrl = manager.temporaryDirectory.appendingPathComponent(
            "\(exportedVideo.fileName).mov"
        )
        if manager.fileExists(atPath: fileUrl.path) {
            try? manager.removeItem(at: fileUrl)
        }
        return fileUrl
    }
}
