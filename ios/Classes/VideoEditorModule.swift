//
//  VideoEditorModule.swift
//  ve_sdk_flutter
//
//  Created by Gleb Prischepa on 5/4/24.
//

import Foundation
import BanubaVideoEditorSDK
import BanubaAudioBrowserSDK
import VideoEditor
import VEExportSDK
import Flutter

protocol VideoEditor {
    func initVideoEditor(token: String, featuresConfigString: String?) -> Bool
    
    func openVideoEditorDefault(fromViewController controller: FlutterViewController, flutterResult: @escaping FlutterResult)
    
    func openVideoEditorPIP(fromViewController controller: FlutterViewController, videoURL: URL, flutterResult: @escaping FlutterResult)
    
    func openVideoEditorTrimmer(fromViewController controller: FlutterViewController, videoSources: Array<URL>, flutterResult: @escaping FlutterResult)
}

class VideoEditorModule: VideoEditor {
    
    private var videoEditorSDK: BanubaVideoEditor?
    private var flutterResult: FlutterResult?
    private var featuresConfig: FeaturesConfig?

    // Use “true” if you want users could restore the last video editing session.
    private let restoreLastVideoEditingSession: Bool = false

    func initVideoEditor(token: String, featuresConfigString: String?) -> Bool {
        guard videoEditorSDK == nil else {
            debugPrint("Video Editor SDK is already initialized")
            return true
        }
        
        featuresConfig = parseFeatureConfig(featuresConfigString: featuresConfigString)
        
        var config = VideoEditorConfig()
        
        config.applyFeatureConfig(featuresConfig ?? emptyFeaturesConfig)

        let lutsPath = Bundle(for: VideoEditorModule.self).bundleURL.appendingPathComponent("luts", isDirectory: true)
        config.filterConfiguration.colorEffectsURL = lutsPath

        // Make customization here

        videoEditorSDK = BanubaVideoEditor(
            token: token,
            configuration: config,
            externalViewControllerFactory: provideCustomViewFactory(featuresConfig: featuresConfig)
        )

        if videoEditorSDK == nil {
            return false
        }

        videoEditorSDK?.delegate = self
        return true
    }
    
    func provideCustomViewFactory(featuresConfig: FeaturesConfig?) -> FlutterCustomViewFactory? {
        let factory: FlutterCustomViewFactory?
        
        if featuresConfig?.audioBrowser?.source == "soundstripe"{
            return nil
        }

        // Set your Mubert Api key here
        let mubertApiLicense = ""
        let mubertApiKey = ""
        AudioBrowserConfig.shared.musicSource = .allSources
        BanubaAudioBrowser.setMubertKeys(
            license: mubertApiLicense,
            token: mubertApiKey
        )
        factory = nil
        
        return factory
    }

    func openVideoEditorDefault(
        fromViewController controller: FlutterViewController,
        flutterResult: @escaping FlutterResult
    ) {
        self.flutterResult = flutterResult
        
        let config = VideoEditorLaunchConfig(
            entryPoint: .camera,
            hostController: controller,
            animated: true
        )
        checkLicenseAndStartVideoEditor(with: config, flutterResult: flutterResult)
    }
    
    func openVideoEditorPIP(
        fromViewController controller: FlutterViewController,
        videoURL: URL,
        flutterResult: @escaping FlutterResult
    ) {
        self.flutterResult = flutterResult
        
        let pipLaunchConfig = VideoEditorLaunchConfig(
            entryPoint: .pip,
            hostController: controller,
            pipVideoItem: videoURL,
            musicTrack: nil,
            animated: true
        )
        
        checkLicenseAndStartVideoEditor(with: pipLaunchConfig, flutterResult: flutterResult)
    }
    
    func openVideoEditorTrimmer(
        fromViewController controller: FlutterViewController,
        videoSources: Array<URL>,
        flutterResult: @escaping FlutterResult
    ) {
        self.flutterResult = flutterResult
        
        let trimmerLaunchConfig = VideoEditorLaunchConfig(
            entryPoint: .trimmer,
            hostController: controller,
            videoItems: videoSources,
            musicTrack: nil,
            animated: true
        )
        
        checkLicenseAndStartVideoEditor(with: trimmerLaunchConfig, flutterResult: flutterResult)
    }
    
    func checkLicenseAndStartVideoEditor(with config: VideoEditorLaunchConfig, flutterResult: @escaping FlutterResult) {
        if videoEditorSDK == nil {
            flutterResult(FlutterError(code: VeSdkFlutterPlugin.errSdkNotInitialized, message: VeSdkFlutterPlugin.errMessageSdkNotInitialized, details: nil))
            return
        }
        
        // Checking the license might take around 1 sec in the worst case.
        // Please optimize use if this method in your application for the best user experience
        videoEditorSDK?.getLicenseState(completion: { [weak self] isValid in
            guard let self else { return }
            if isValid {
                print("✅ The license is active")
                DispatchQueue.main.async {
                    self.videoEditorSDK?.presentVideoEditor(
                        withLaunchConfiguration: config,
                        completion: nil
                    )
                }
            } else {
                if self.restoreLastVideoEditingSession == false {
                    self.videoEditorSDK?.clearSessionData()
                }
                self.videoEditorSDK = nil
                print("❌ Use of SDK is restricted: the license is revoked or expired")
                flutterResult(FlutterError(code: VeSdkFlutterPlugin.errLicenseRevoked, message: VeSdkFlutterPlugin.errMessageLicenseRevoked, details: nil))
            }
        })
    }
}


// MARK: - Export flow
extension VideoEditorModule {
    func exportVideo() {
        let progressView = ProgressViewController.makeViewController()
        
        progressView.cancelHandler = { [weak self] in
            self?.videoEditorSDK?.stopExport()
        }
        
        getTopViewController()?.present(progressView, animated: true)
        
        let manager = FileManager.default
        // File name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH-mm-ss.SSS"
        
        let previewURL = manager.temporaryDirectory.appendingPathComponent("export_preview.png")
        
        // TODO handle multiple exported video files
        let firstFileURL = manager.temporaryDirectory.appendingPathComponent("export_\(dateFormatter.string(from: Date())).mov")
        if manager.fileExists(atPath: firstFileURL.path) {
            try? manager.removeItem(at: firstFileURL)
        }
        
        // Video configuration
        let exportVideoConfigurations: [ExportVideoConfiguration] = [
            ExportVideoConfiguration(
                fileURL: firstFileURL,
                quality: .auto,
                useHEVCCodecIfPossible: true,
                watermarkConfiguration: nil
            )
        ]
        
        // Set up export
        let exportConfiguration = ExportConfiguration(
            videoConfigurations: exportVideoConfigurations,
            isCoverEnabled: true,
            gifSettings: nil
        )
        
        videoEditorSDK?.export(
            using: exportConfiguration,
            exportProgress: { [weak progressView] progress in progressView?.updateProgressView(with: Float(progress)) }
        ) { [weak self] (error, coverImage) in
            // Export Callback
            DispatchQueue.main.async {
                progressView.dismiss(animated: true) {
                    // if export cancelled just hide progress view
                    if let error, error as NSError == exportCancelledError {
                        return
                    }
                    var metadataUrl: URL?
                    if let analytics = self?.videoEditorSDK?.metadata?.analyticsMetadataJSON {
                        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString)_metadata.json")
                        do {
                            try analytics.write(to: url, atomically: true, encoding: .utf8)
                            metadataUrl = url
                        } catch {
                            print("Error during metadata saving: \(error)")
                        }
                    }
                    
                    // TODO 1. simplify method
                    self?.completeExport(videoUrls: [firstFileURL], metaUrl: metadataUrl, previewUrl: previewURL, error: error, previewImage: coverImage?.coverImage)
                }
            }
        }
    }
    
    private func completeExport(videoUrls: [URL], metaUrl: URL?, previewUrl: URL, error: Error?, previewImage: UIImage?) {
        videoEditorSDK?.dismissVideoEditor(animated: true) {
            let success = error == nil
            if success {
                print("Video exported successfully: video sources = \(videoUrls)), meta = \(metaUrl)), preview = \(previewUrl))")
                
                let previewImageData = previewImage?.pngData()
                
                // TODO handle preview is not taken
                try? previewImageData?.write(to: previewUrl)
                
                let data = [
                    VeSdkFlutterPlugin.argExportedVideoSources: videoUrls.compactMap { $0.path },
                    VeSdkFlutterPlugin.argExportedPreview: previewUrl.path,
                    VeSdkFlutterPlugin.argExportedMeta: metaUrl?.path
                ]
                self.flutterResult?(data)
            } else {
                print("Error while exporting video = \(String(describing: error))")
                self.flutterResult?(FlutterError(code: VeSdkFlutterPlugin.errMissingExportResult, message: VeSdkFlutterPlugin.errMessageMissingExportResult, details: nil))
            }
            
            // Remove strong reference to video editor sdk instance
            if self.restoreLastVideoEditingSession == false {
                self.videoEditorSDK?.clearSessionData()
            }
            self.videoEditorSDK = nil
        }
    }
    
    func getTopViewController() -> UIViewController? {
        let keyWindow = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }
        
        var topController = keyWindow?.rootViewController
        
        while let newTopController = topController?.presentedViewController {
            topController = newTopController
        }
        
        return topController
    }
}

// MARK: - BanubaVideoEditorSDKDelegate
extension VideoEditorModule: BanubaVideoEditorDelegate {
    func videoEditorDidCancel(_ videoEditor: BanubaVideoEditor) {
        videoEditor.dismissVideoEditor(animated: true) {
            // remove strong reference to video editor sdk instance
            if self.restoreLastVideoEditingSession == false {
                self.videoEditorSDK?.clearSessionData()
            }
            self.videoEditorSDK = nil
        }
    }
    
    func videoEditorDone(_ videoEditor: BanubaVideoEditor) {
        exportVideo()
    }
}

extension VideoEditorModule{
    var emptyFeaturesConfig : FeaturesConfig {
        return FeaturesConfig(aiCaptions: nil, aiClipping: nil, audioBrowser: AudioBrowser(source: "local", params: nil))
    }
    
    private func parseFeatureConfig(featuresConfigString: String?) -> FeaturesConfig{
        do {
            guard let featuresConfigString = featuresConfigString?.data(using: .utf8) else {return emptyFeaturesConfig}
            var decodedFeatureConfig = try JSONDecoder().decode(FeaturesConfig.self, from: featuresConfigString)
            if decodedFeatureConfig.audioBrowser == nil{
                decodedFeatureConfig.audioBrowser = AudioBrowser(source: "local")
            }
            return decodedFeatureConfig
        } catch {
            print("❌ Invalid input params of config")
            return emptyFeaturesConfig
        }
    }
}

extension VideoEditorConfig{
    mutating func applyFeatureConfig(_ featuresConfig: FeaturesConfig){
        
        AudioBrowserConfig.shared.musicSource = .allSources
        
        let source = featuresConfig.audioBrowser?.source
        
        switch source {
            case "soundstripe":
                AudioBrowserConfig.shared.musicSource = .soundstripe
            default:
                break
        }
        
        if let aiCaptions = featuresConfig.aiCaptions{
            self.captionsConfiguration.captionsUploadUrl = aiCaptions.uploadUrl
            self.captionsConfiguration.captionsTranscribeUrl = aiCaptions.transcribeUrl
            self.captionsConfiguration.apiKey = aiCaptions.apiKey
        }
            
            
        if let aiClipping = featuresConfig.aiClipping{
            self.autoCutConfiguration.embeddingsDownloadUrl = aiClipping.audioDataUrl
            self.autoCutConfiguration.musicApiSelectedTracksUrl = aiClipping.audioTracksUrl
        }
        
        BanubaAudioBrowser.setMubertKeys(
            license: "SET MUBERT API LICENSE",
            token: "SET MUBERT API TOKEN"
        )
        
        AudioBrowserConfig.shared.setPrimaryColor(#colorLiteral(red: 0.2350233793, green: 0.7372031212, blue: 0.7565478683, alpha: 1))
        
        var featureConfiguration = self.featureConfiguration
        featureConfiguration.supportsTrimRecordedVideo = true
        featureConfiguration.isMuteCameraAudioEnabled = true
        self.updateFeatureConfiguration(featureConfiguration: featureConfiguration)
    }
}
