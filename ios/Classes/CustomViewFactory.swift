//
//  CustomViewFactory.swift
//  ve_sdk_flutter
//
//  Created by Gleb Prischepa on 5/4/24.
//

import BanubaVideoEditorSDK
import BanubaUtilities
import Flutter

class FlutterCustomViewFactory: ExternalViewControllerFactory {
    // Set nil to use BanubaAudioBrowser
    var musicEditorFactory: MusicEditorExternalViewControllerFactory? = nil
    
    var countdownTimerViewFactory: CountdownTimerViewFactory?
    
    var exposureViewFactory: AnimatableViewFactory?
}


private class FlutterTrackSelectionViewController: FlutterViewController, TrackSelectionViewController {
    
    let channelAudioBrowser = "audioBrowserChannel"
    let methodApplyAudioTrack = "applyAudioTrack"
    let methodDiscardAudioTrack = "discardAudioTrack"
    let methodClose = "close"
    
    // MARK: - TrackSelectionViewController
    var trackSelectionDelegate: BanubaUtilities.TrackSelectionViewControllerDelegate?
    
    private var channel: FlutterMethodChannel?
    
    func listenFlutterCalls() {
        channel = FlutterMethodChannel(
            name: channelAudioBrowser,
            binaryMessenger: binaryMessenger
        )
        channel?.setMethodCallHandler { [weak self] methodCall, resultHandler in
            guard let self = self else {
                resultHandler(FlutterMethodNotImplemented)
                return
            }
            
            switch methodCall.method {
            case self.methodApplyAudioTrack:
                self.handleApplyAudioTrack(args: methodCall.arguments, resultHandler: resultHandler)
                
            case self.methodDiscardAudioTrack:
              self.trackSelectionDelegate?.trackSelectionViewControllerDiscardCurrentTrack(
                viewController: self
              )
              self.trackSelectionDelegate?.trackSelectionViewControllerDidCancel(
                  viewController: self
              )
              resultHandler(nil)
                
            case self.methodClose:
                self.trackSelectionDelegate?.trackSelectionViewControllerDidCancel(viewController: self)
                resultHandler(nil)
                
            default: resultHandler(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func handleApplyAudioTrack(args: Any?, resultHandler: (Any?) -> Void) {
        struct Track: Codable {
            let url: URL
            let id: UUID
            let title: String
        }
        guard let string = args as? String,
              let data = string.data(using: .utf8),
              let track = try? JSONDecoder().decode(Track.self, from: data) else {
            resultHandler(FlutterMethodNotImplemented)
            return
        }
        trackSelectionDelegate?.trackSelectionViewController(
            viewController: self,
            didSelectFile: track.url,
            remoteURL: nil,
            isEditable: true,
            title: track.title,
            additionalTitle: nil,
            uuid: track.id
        )
        resultHandler(nil)
    }
}
