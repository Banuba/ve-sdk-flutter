import Flutter
import UIKit
import AVKit
import BanubaAudioBrowserSDK

public class VeSdkFlutterPlugin: NSObject, FlutterPlugin {
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
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "ve_sdk_flutter", binaryMessenger: registrar.messenger())
        let instance = VeSdkFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    let videoEditor = VideoEditorModule()
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any> {
            let licenseToken = args[VeSdkFlutterPlugin.keyToken] as? String
            if (licenseToken == nil) {
                result(FlutterError(code: VeSdkFlutterPlugin.errInvalidParams, message: "Missing license token", details: nil))
                return
            }
            
            let screen = args[VeSdkFlutterPlugin.keyScreen] as? String
            if (screen == nil) {
                result(FlutterError(code: VeSdkFlutterPlugin.errInvalidParams, message: "Missing screen value", details: nil))
                return
            }
            
            if (!videoEditor.initVideoEditor(token: licenseToken!)) {
                result(FlutterError(code: VeSdkFlutterPlugin.errSdkNotInitialized, message: "", details: nil))
                return
            }
            
            let controller = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController
            if (controller == nil) {
                result(FlutterError(code: VeSdkFlutterPlugin.errMissingHost, message: "", details: nil))
                return
            }
            
            if (call.method == VeSdkFlutterPlugin.methodStart) {
                switch screen {
                case VeSdkFlutterPlugin.screenCamera:
                    videoEditor.openVideoEditorDefault(fromViewController: controller!, flutterResult: result)
                    
                case VeSdkFlutterPlugin.screenPip:
                    let videoSources = args[VeSdkFlutterPlugin.keyVideoSources] as? Array<String>
                    if (videoSources == nil || videoSources!.isEmpty) {
                        result(FlutterError(code: VeSdkFlutterPlugin.errInvalidParams, message: "Invalid pip video source", details: nil))
                        return
                    }
                    videoEditor.openVideoEditorPIP(fromViewController: controller!, videoURL: URL(fileURLWithPath: videoSources!.first!), flutterResult: result)
                    
                case VeSdkFlutterPlugin.screenTrimmer:
                    let videoSources = args[VeSdkFlutterPlugin.keyVideoSources] as? Array<String>
                    if (videoSources == nil || videoSources!.isEmpty) {
                        result(FlutterError(code: VeSdkFlutterPlugin.errInvalidParams, message: "Invalid trimmer video sources", details: nil))
                        return
                    }
                    let videoURLs = videoSources!.compactMap { URL(string: $0) }
                    
                    videoEditor.openVideoEditorTrimmer(fromViewController: controller!, videoSources: videoURLs, flutterResult: result)
                default:
                    debugPrint("Unknown screen value = \(screen)")
                    result(FlutterError(code: VeSdkFlutterPlugin.errInvalidParams, message: "Unknown screen value", details: nil))
                    return
                    
                }
            }
        } else {
            result(FlutterError.init(code: VeSdkFlutterPlugin.errInvalidParams, message: "Method started with invalid params!", details: nil))
        }
    }
}
