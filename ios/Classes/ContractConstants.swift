//
//  ContractConstants.swift
//  ve_sdk_flutter
//
//  Created by Rostyslav Dovhaliuk on 27.05.2024.
//

import Foundation

extension VeSdkFlutterPlugin {
    static let channel = "ve_sdk_flutter"
    static let methodStart = "startVideoEditor"
    
    static let errInvalidParams = "ERR_INVALID_PARAMS"
    static let errSdkNotInitialized = "ERR_SDK_NOT_INITIALIZED"
    static let errLicenseRevoked = "ERR_SDK_LICENSE_REVOKED"
    static let errMissingHost = "ERR_MISSING_HOST"
    static let errMissingExportResult = "ERR_MISSING_EXPORT_RESULT"
    
    static let keyToken = "token"
    static let keyScreen = "screen"
    static let keyVideoSources = "videoSources"
    
    static let screenCamera = "camera"
    static let screenPip = "pip"
    static let screenTrimmer = "trimmer"
    
    static let argExportedVideoSources = "exportedVideoSources"
    static let argExportedPreview = "exportedPreview"
    static let argExportedMeta = "exportedMeta"
    
    static let errMessageInvalidParams = "Method started with invalid params!"
    static let errMessageMissingToken = "Missing license token"
    static let errMessageMissingScreen = "Missing screen value"
    static let errMessageUnknownMethod = "Unknown method name"
    static let errMessageInvalidPiPVideo = "Invalid pip video source"
    static let errMessageInvalidTrimmerVideo = "Invalid trimmer video sources"
    static let errMessageUnknownScreen = "Unknown screen value"
}
