//
//  ContractConstants.swift
//  ve_sdk_flutter
//
//  Created by Rostyslav Dovhaliuk on 27.05.2024.
//

import Foundation
import BanubaVideoEditorSDK

extension VeSdkFlutterPlugin {
    static let channel = "ve_sdk_flutter"
    static let methodStart = "startVideoEditor"
    
    static let errInvalidParams = "ERR_INVALID_PARAMS"
    static let errSdkNotInitialized = "ERR_SDK_NOT_INITIALIZED"
    static let errLicenseRevoked = "ERR_SDK_LICENSE_REVOKED"
    static let errMissingHost = "ERR_MISSING_HOST"
    static let errMissingExportResult = "ERR_MISSING_EXPORT_RESULT"
    
    static let inputParamToken = "token"
    static let inputParamFeaturesConfig = "featuresConfig"
    static let inputParamScreen = "screen"
    static let inputParamVideoSources = "videoSources"
    
    static let screenCamera = "camera"
    static let screenPip = "pip"
    static let screenTrimmer = "trimmer"
    
    static let argExportedVideoSources = "exportedVideoSources"
    static let argExportedPreview = "exportedPreview"
    static let argExportedMeta = "exportedMeta"
    
    static let errMessageSdkNotInitialized = """
        Failed to initialize SDK!!!
        The license token is incorrect: empty or truncated.
        Please check the license token and try again.
    """
    static let errMessageLicenseRevoked = """
        WARNING!!!
        YOUR LICENSE TOKEN EITHER EXPIRED OR REVOKED!
        Please contact Banuba
    """
    
    static let errMessageInvalidParams = "Method started with invalid params!"
    static let errMessageMissingToken = "Missing license token: set correct value to \(inputParamToken) input params"
    static let errMessageMissingScreen = "Missing screen: set correct value to \(inputParamScreen) input params"
    static let errMessageUnknownMethod = "Unknown method name"
    static let errMessageInvalidPiPVideo = "Missing pip video source: set correct value to \(inputParamVideoSources) input params"
    static let errMessageInvalidTrimmerVideo = "Missing trimmer video sources: set correct value to \(inputParamVideoSources) input params"
    static let errMessageUnknownScreen = "Invalid inputParams value: available values(\(screenCamera), \(screenPip), \(screenTrimmer))"
    
    static let errMessageMissingExportResult =
    "Missing export result: video export has not been completed successfully. Please try again"
    static let errMessageMissingConfigParams =
    "❌ Missing or invalid config: \(inputParamFeaturesConfig)"
    
    static let errMessageMissingHost = "Missing host ViewController to start video editor"
    
    //Empty feature config
    var emptyFeaturesConfig : FeaturesConfig {
        return FeaturesConfig(aiCaptions: nil, aiClipping: nil, audioBrowser: AudioBrowser(source: "local", params: nil), editorConfig: nil, draftConfig: DraftConfig(option: "enable"))
    }
}

extension VideoEditorConfig {
    // Tag
    static let featuresConfigTag = "Features Config"
    
    // Features config params
    static let featuresConfigAudioBrowserSourceSoundstripe = "soundstripe"
    static let featuresConfigAudioBrowserSourceMubert = "mubert"
    static let featuresConfigAudioBrowserSourceLocal = "local"

    // Draft Configs
    static let featuresConfigDraftConfigOptionAskToSave = "askToSave"
    static let featuresConfigDraftConfigOptionСloseOnSave = "closeOnSave"
    static let featuresConfigDraftConfigOptionAuto = "auto"
    static let featuresConfigDraftConfigOptionDisabled = "disabled"
    
    //Editor Configs
    static let featuresConfigIsVideoAspectFillEnabled = "isVideoAspectFillEnabled"
    
    // Unknown params
    static let featuresConfigUnknownParams = "Undefined"
}

public protocol ReflectedStringConvertible: CustomStringConvertible {}

extension ReflectedStringConvertible {
    public var description: String {
        let mirror = Mirror(reflecting: self)
        
        var str = "\(mirror.subjectType)("
        var first = true
        for (label, value) in mirror.children {
            if let label = label {
                if first {
                    first = false
                } else {
                    str += ", "
                }
                str += "\(label): "
                
                if let optionalValue = value as? OptionalProtocol {
                    str += "\(optionalValue.logable)"
                } else {
                    str += "\(value)"
                }
            }
        }
        str += ")"
        
        return str
    }
}

protocol OptionalProtocol {
    var logable: Any { get }
}

extension Optional: OptionalProtocol {
    var logable: Any {
        switch self {
        case .none:
            return VideoEditorConfig.featuresConfigUnknownParams
        case let .some(value):
            return value
        }
    }
}
