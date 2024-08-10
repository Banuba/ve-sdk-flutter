# Audio Browser 

```Audio Browser``` - a specific module and set of screens that include the built-in support of browsing and applying audio content within the Video Editor. The user does not leave the SDK while using audio.

> [!IMPORTANT]
> Banuba does not deliver audio content for the Video Editor SDK.
The Video Editor can apply audio files stored on the device. The SDK is not responsible for downloading audio content except for [Soundstripe](https://www.soundstripe.com/) and [Mubert](https://mubert.com/).

Audio Browser is a specific module that allows to browse, play and apply audio content within video editor.
It supports 3 sources for audio content:

1. My Library - includes audio content available on the user's device

2. Soundstripe - includes built in integration with Soundstripe API.

3. Mubert - includes built in integration with Mubert API.

## Integration

### My Library 

```My Library``` is a default implementation in AudioBrowser . It allows the user to apply audio that is available on a device.

Set Audio Browser in ```Features Config``` builder with local source: 

```dart
final _config = FeatureConfigBuilder()
    .setAudioBrowser(AudioBrowser.fromSource(AudioBrowserSource.local))
    .build();
```

### Soundstripe

[Soundstripe](https://www.soundstripe.com/) is a service for providing the best audio tracks for creating video content. Your users will be able to add audio tracks while recording or editing video content.

> [!INFO]
> The feature is not activated by default.
> Please contact Banuba representatives to know more about using this feature.

Set Audio Browser in ```Features Config``` builder with Soundstripe source:

```dart
final _config = FeatureConfigBuilder()
    .setAudioBrowser(AudioBrowser.fromSource(AudioBrowserSource.soundstripe))
    .build();
```

### Mubert

[Mubert](https://mubert.com/) is a service that delivers Generative AI Music. Your users will be able to add audio tracks while recording or editing video content.

> [!INFO]
> Please contact Mubert representatives to request keys.

Set Audio Browser in ```Features Config``` builder with Mubert source and params:

```dart
final _config = FeatureConfigBuilder()
    .setAudioBrowser(AudioBrowser.fromSource(
        AudioBrowserSource.mubert, 
        params: {
            'mubertLicence':'yourMubertLicence', 
            'mubertToken':'yourMubertToken'
            }
        )
    )
    .build();
```