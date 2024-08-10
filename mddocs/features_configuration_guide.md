# Features Configuration

The ```Features Configuration``` allows to customize and add several Video Editor features. Next configuration options available: 

1. [AI Captions](ai_captions_guide.md)
2. [AI Clipping](ai_clipping_guide.md)
3. [Audio Browser](audio_browser_guide.md). Available options included: 
    - Soundstipe
    - Mubert
    - Local storage
4. Editor screen. Available options included: 
    - Video Aspect Fill (on/off) 
5. Draft
    - Ask to save
    - Save by default
    - Close on save
    - Disable

# Integration

Set up the [features configuration](example/lib/main.dart#L44) before starting the Video Editor:

```dart
final _config = FeatureConfigBuilder()
    .setAudioBrowser(AudioBrowser.fromSource(AudioBrowserSource.local))
    .setDraftConfig(DraftConfig.fromOption(DraftOption.auto))
    .setEditorConfig(EditorConfig(isVideoAspectFillEnabled: false))
    .setAiClipping(AiClipping(audioDataUrl: "audioDataUrl", audioTracksUrl: "audioTracksUrl"))
    .setAiCaptions(AiCaptions(uploadUrl: "uploadUrl", transcribeUrl: "transcribeUrl", apiKey: "apiKey"))
    .build();
```

Pass the features configuration to the Video Editor [start method](example/lib/main.dart#L54):

```dart
Future<void> _startVideoEditorInCameraMode() async {
    try {
      dynamic exportResult =
          await _veSdkFlutterPlugin.openCameraScreen(_licenseToken, _config);
      _handleExportResult(exportResult);
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    }
}
```