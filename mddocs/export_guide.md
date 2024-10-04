# Export Media

## Overview

Video Editor SDK allows to export a number of video files with various resolutions and other configurations. Video is exported as ```.mp4``` for Android and ```.mov``` for IOS file.

> [!INFO]
> Export is a very heavy computational task that takes time and the user has to wait.
> Execution time depends on:
> 1. Video duration - the longer video the longer execution time.
> 2. Number of video sources - the many sources the longer execution time.
> 3. Number of effects and their usage in video - the more effects and their usage the longer execution time.
> 4. Number of exported video - the more video and audio you want to export the longer execution time.
> 5. Device hardware - the most powerful devices can execute export much quicker and with higher resolution.

## Video quality

Video Editor supports video codec options:

1. ```HEVC``` - H265 codec. **Default**
2. ```AVC_PROFILES``` - H264 codec with profiles

The following table presents list of video resolution and bitrate values for codec ```H264(AVC_PROFILES)```:

> [!INFO]
> Video Editor includes built-in feature for detecting device performance capabilities and finding ```auto``` video quality for exported video.

### Android

| 240p(240x426) | 360p(360x640) | 480p(480x854) | QHD540(540x960) | HD(720x1280) | FHD(1080x1920) | QHD(1440x2560) | UHD(2160x3840) |
|---------------|------------|---------------|-----------------|--------------|----------------|----------------|----------------|
| 1000   kb/s   | 1200  kb/s     | 2000 kb/s         | 2400  kb/s          | 3600   kb/s  | 5800 kb/s      | 10000    kb/s      | 20000  kb/s        |

### IOS

| 360p(360x640) | 480p(480x854) | QHD540(540x960) | HD(720x1280) | FHD(1080x1920) | QHD(1440x2560) | UHD(2160x3840) |
|----|---------------|-----------------|--------------|----------------|----------------|----------------|
| 1000  kb/s    | 2500 kb/s     | 3000  kb/s      | 5000   kb/s  | 8000 kb/s      | 16000    kb/s  | 36000  kb/s    |

## Implement export flow

> [!INFO]
> Default implementation exports single video file with auto quality(based on device hardware capabilities).

You can create your own export flow to meet your requirements.

Create a new instance of ```ExportParam``` to export single video with ```HD``` and ```auto``` quality: 

```dart
const exportParam = ExportParam(exportedVideos: [
  ExportedVideo(
      fileName: "export_hd_720p",
      videoResolution: VideoResolution.hd_720p
  ),
  ExportedVideo(
      fileName: "export_auto",
      videoResolution: VideoResolution.auto
  )]
);
```

Next, specify it in the [start method](../example/lib/main.dart#53) of the Video Editor:

```diff
try {
      dynamic exportResult = await _veSdkFlutterPlugin.openCameraScreen(
            _licenseToken, 
            config, 
+           exportParam: exportParam
        );
      _handleExportResult(exportResult);
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    }
```

> [!IMPORTANT]
> Please keep in mind that low level devices might not be able to export video with high quality.
> Our recommendations is to use  ```hd_720p```, ```vga_480p``` or ```auto``` resolutions with codec ```H264(AVC_PROFILES)``

## Use AVC codec

The SDK prefers ```H265(HEVC)``` codec by default for exporting video file.
You can specify ```H264(AVC_PROFILES)``` by setting ```false``` to ```useHevcIfPossible```.

> [!INFO]
> ```H264(AVC_PROFILES)``` is recommended for low level devices

```diff
const exportParam = ExportParam(exportedVideos: [
  ExportedVideo(
      fileName: "export_hd",
      videoResolution: VideoResolution.hd_720p,
+     useHevcIfPossible: false
  )]
);
```

## Add watermark

Watermark is not added to exported video by default.

Specify your watermark in the [pubspec.yaml](../example/pubspec.yaml#50) and provide it to the ```ExportParam``` instance:

```diff
const exportParam = ExportParam(exportedVideos: [
  ExportedVideo(
      fileName: "export_hd",
      videoResolution: VideoResolution.hd_720p
  )],
+   watermark: Watermark(
+       imagePath: "assets/watermark.png",
+       watermarkAlignment: WatermarkAlignment.bottomRight
+  )
);
```
