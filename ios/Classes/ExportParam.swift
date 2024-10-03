import Foundation
import VEExportSDK
import VideoEditor
import Flutter

struct ExportParam: Codable {
    let exportedVideos: [ExportedVideo]
    let watermark: Watermark? 
}

struct ExportedVideo: Codable {
    let fileName: String
    let videoResolution: String
    let useHevcIfPossible: Bool?
    
    public func qualityValue() -> ExportQuality {
        switch videoResolution {
            case ExportParam.exportedVideoVideoResolutionsVGA360p:
                return .videoConfiguration(.init(resolution: .ld360, useHEVCCodecIfPossible: useHevcIfPossible ?? true))
            case ExportParam.exportedVideoVideoResolutionsVGA480p:
                return .videoConfiguration(.init(resolution: .md480, useHEVCCodecIfPossible: useHevcIfPossible ?? true))
            case ExportParam.exportedVideoVideoResolutionsQHD540p:
                return .videoConfiguration(.init(resolution: .md540, useHEVCCodecIfPossible: useHevcIfPossible ?? true))
            case ExportParam.exportedVideoVideoResolutionsHD720p:
                return .videoConfiguration(.init(resolution: .hd720, useHEVCCodecIfPossible: useHevcIfPossible ?? true))
            case ExportParam.exportedVideoVideoResolutionsFHD1080p:
                return .videoConfiguration(.init(resolution: .fullHd1080, useHEVCCodecIfPossible: useHevcIfPossible ?? true))
            case ExportParam.exportedVideoVideoResolutionsQHD1440p:
                return .videoConfiguration(.init(resolution: .qhd1440, useHEVCCodecIfPossible: useHevcIfPossible ?? true))
            case ExportParam.exportedVideoVideoResolutionsUHD2160p:
                return .videoConfiguration(.init(resolution: .ultraHd2160, useHEVCCodecIfPossible: useHevcIfPossible ?? true))
            case ExportParam.exportedVideoVideoResolutionsOriginal:
                return .videoConfiguration(.init(resolution: .original, useHEVCCodecIfPossible: useHevcIfPossible ?? true))
            default:
                return .auto
        }
    }
}

struct Watermark: Codable {
    let imagePath: String?
    let watermarkAlignment: String?
    
    public func watermarkConfigurationValue(controller: FlutterViewController) -> WatermarkConfiguration? {
        guard let imagePath = imagePath else {return nil}
        
        let key = controller.lookupKey(forAsset: imagePath)
        let mainBundle = Bundle.main
        let path = mainBundle.path(forResource: key, ofType: nil)
        
        guard let path, let watermarkImage = UIImage(contentsOfFile: path) else {return nil}
        
        return WatermarkConfiguration(
            watermark: ImageConfiguration(image: watermarkImage),
            size: CGSize(width: 72, height: 72),
            sharedOffset: 20,
            position: watermarkAligmentValue()
        )
    }
    
    private func watermarkAligmentValue() -> WatermarkConfiguration.WatermarkPosition{
        switch watermarkAlignment {
            case ExportParam.exportParamWatermarkAlignmentTopLeft:
                return .leftTop
            case ExportParam.exportParamWatermarkAlignmentTopRight:
                return .rightTop
            case ExportParam.exportParamWatermarkAlignmentBottomLeft:
                return .leftBottom
            default:
                return .rightBottom
        }
    }
}
