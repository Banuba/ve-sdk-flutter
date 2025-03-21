import Flutter
import UIKit
import AVKit
import BanubaAudioBrowserSDK

public class VeSdkFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: VeSdkFlutterPlugin.channel, binaryMessenger: registrar.messenger())
        let instance = VeSdkFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    let videoEditor = VideoEditorModule()
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError.init(code: VeSdkFlutterPlugin.errInvalidParams, message: VeSdkFlutterPlugin.errMessageInvalidParams, details: nil))
            return
        }
        guard let licenseToken = args[VeSdkFlutterPlugin.inputParamToken] as? String else {
            result(FlutterError(code: VeSdkFlutterPlugin.errInvalidParams, message: VeSdkFlutterPlugin.errMessageMissingToken, details: nil))
            return
        }
        
        let featuresConfig = parseFeatureConfig(args[VeSdkFlutterPlugin.inputParamFeaturesConfig] as? String)

        let exportData = parseExportData(args[VeSdkFlutterPlugin.inputParamExportData] as? String)
        
        guard let screen = args[VeSdkFlutterPlugin.inputParamScreen] as? String else {
            result(FlutterError(code: VeSdkFlutterPlugin.errInvalidParams, message: VeSdkFlutterPlugin.errMessageMissingScreen, details: nil))
            return
        }
        
        if (!videoEditor.initVideoEditor(token: licenseToken, featuresConfig: featuresConfig, exportData: exportData)) {
            result(FlutterError(code: VeSdkFlutterPlugin.errSdkNotInitialized, message: VeSdkFlutterPlugin.errMessageSdkNotInitialized, details: nil))
            return
        }
        
        guard let controller = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController else {
            result(FlutterError(code: VeSdkFlutterPlugin.errMissingHost, message: VeSdkFlutterPlugin.errMessageMissingHost, details: nil))
            return
        }
        
        guard call.method == VeSdkFlutterPlugin.methodStart else {
            result(FlutterError(code: VeSdkFlutterPlugin.errInvalidParams, message: VeSdkFlutterPlugin.errMessageUnknownMethod, details: nil))
            return
        }
        switch screen {
            case VeSdkFlutterPlugin.screenCamera:
                videoEditor.openVideoEditorDefault(fromViewController: controller, flutterResult: result)
            
            case VeSdkFlutterPlugin.screenPip:
                let videoSources = args[VeSdkFlutterPlugin.inputParamVideoSources] as? Array<String>
                if (videoSources == nil || videoSources!.isEmpty) {
                    result(FlutterError(code: VeSdkFlutterPlugin.errInvalidParams, message: VeSdkFlutterPlugin.errMessageInvalidPiPVideo, details: nil))
                    return
                }
                videoEditor.openVideoEditorPIP(fromViewController: controller, videoURL: URL(fileURLWithPath: videoSources!.first!), flutterResult: result)
            
            case VeSdkFlutterPlugin.screenTrimmer:
                let videoSources = args[VeSdkFlutterPlugin.inputParamVideoSources] as? Array<String>
                if (videoSources == nil || videoSources!.isEmpty) {
                    result(FlutterError(code: VeSdkFlutterPlugin.errInvalidParams, message: VeSdkFlutterPlugin.errMessageInvalidTrimmerVideo, details: nil))
                    return
                }
                let videoURLs = videoSources!.compactMap { URL(string: $0) }
            
                videoEditor.openVideoEditorTrimmer(fromViewController: controller, videoSources: videoURLs, flutterResult: result)
            case VeSdkFlutterPlugin.screenAiClipping:
                videoEditor.openVideoEditorAiClipping(fromViewController: controller, flutterResult: result)
            default:
                debugPrint("Unknown screen value = \(screen)")
                result(FlutterError(code: VeSdkFlutterPlugin.errInvalidParams, message: VeSdkFlutterPlugin.errMessageUnknownScreen, details: nil))
                return
        }
    }
}
