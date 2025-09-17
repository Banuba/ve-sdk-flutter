import AVFoundation
import BanubaUtilities

extension VeSdkFlutterPlugin {

    func parseFeatureConfig(_ rawConfigParams: String?) -> FeaturesConfig {
        guard let featuresConfigData = rawConfigParams?.data(using: .utf8) else {return defaultFeaturesConfig}
        do {
            let decodedFeatureConfig = try JSONDecoder().decode(FeaturesConfig.self, from: featuresConfigData)
            return decodedFeatureConfig
        } catch {
            print(VeSdkFlutterPlugin.errMessageMissingConfigParams)
            return defaultFeaturesConfig
        }
    }
    
    func parseExportData(_ rawExportParams: String?) -> ExportData {
        guard let exportParamsData = rawExportParams?.data(using: .utf8) else {return defaultExportData}
        do {
            let decodedExportParams = try JSONDecoder().decode(ExportData.self, from: exportParamsData)
            return decodedExportParams
        } catch {
            print(VeSdkFlutterPlugin.errMessageMissingExportData)
            return defaultExportData
        }
    }

    func obtainTrackData(_ trackDataJSON: String?) -> MediaTrack? {
        guard let trackData = trackDataJSON?.data(using: .utf8) else {return nil}

        struct TrackData: Codable {
            let id: String
            let title: String
            let subtitle: String
            let localUrl: URL
        }

        do {
            let decodedTrackData = try JSONDecoder().decode(TrackData.self, from: trackData)

            let urlAsset = AVURLAsset(url: decodedTrackData.localUrl)
            let urlAssetTimeRange = CMTimeRange(start: .zero, duration: urlAsset.duration)
            let mediaTrackTimeRange = MediaTrackTimeRange(startTime: .zero, playingTimeRange: urlAssetTimeRange)

            return  MediaTrack(
                uuid: UUID(uuidString: decodedTrackData.id) ?? UUID(),
                id: nil,
                url: decodedTrackData.localUrl,
                coverURL: nil,
                timeRange: mediaTrackTimeRange,
                isEditable: true,
                title: decodedTrackData.title
            )
        } catch {
            print(VeSdkFlutterPlugin.errMessageMissingTrackData)
            return nil
        }
    }
}
