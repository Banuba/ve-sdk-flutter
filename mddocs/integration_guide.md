# Integration Guide

This guide helps to complete full Video Editor SDK integration.

## Import it
Use in your Dart code

``` dart
import 'package:ve_sdk_flutter/ve_sdk_flutter.dart';
```

## Configuration

### Android

#### Update gradle files

> [!IMPORTANT]
> if your project supports [Flutter Gradle plugin](https://docs.flutter.dev/release/breaking-changes/flutter-gradle-plugin-apply#androidsettings-gradle).

Update your [project gradle](../example/android/build.gradle#L1) with the following code:

```groovy
buildscript {
    ext.kotlin_version = '1.8.22'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.2'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}
```

### IOS

#### Add specs to Podfile

Add the following specs at the top of your [Podfile](../example/ios/Podfile)

```
platform :ios, '15.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Banuba/specs.git'
source 'https://github.com/sdk-banuba/banuba-sdk-podspecs.git'
```

#### Add permissions

Specify the required iOS permissions used by the SDK in your [Info.plist](../example/ios/Runner/Info.plist)
```
<key>NSAppleMusicUsageDescription</key>
<string>This app requires access to the media library</string>
<key>NSCameraUsageDescription</key>
<string>This app requires access to the camera.</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app requires access to the microphone.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires access to the photo library.</string>
```

## Add AR effects
[Banuba Face AR SDK](https://www.banuba.com/facear-sdk/face-filters) product is used on camera and editor screens for applying various AR effects while making video content.

1. Android - add effects to the project by the path [android/app/src/main/assets/bnb-resources/effects](../example/android/app/src/main/).
2. iOS - add the effect to resource folder ```bundleEffects```. Make sure to select the "Copy items if needed" and "Create folder references" checkboxes while adding effects to the ```bundleEffects``` folder.

### Android

Preview files are in [drawable-xhdpi](../example/android/app/src/main/res/drawable-xhdpi), [drawable-xxhdpi](../example/android/app/src/main/res/drawable-xxhdpi), [drawable-xxxhdpi](../example/android/app/src/main/res/drawable-xxxhdpi) folders.  
Keep in mind that ```drawable-xxxhdpi``` contains files with the highest resolution. Additionally, you can copy paste just one set of previews if it meets your requirements.

### iOS

Copy the ```ColorEffectsPreview``` folder from [example's asset catalog](../example/ios/Runner/Assets.xcassets) to your app's asset catalog.

## Limit processor architectures on Android
Banuba Video Editor on Android supports the following processor architectures - ```arm64-v8a```, ```armeabi-v7a```, ```x86-64```.
Please keep in mind that each architecture adds extra MBs to your app.
To reduce the app size you can filter architectures in your ```app/build.gradle file```.

```groovy
...
defaultConfig {
    ...
    // Use only ARM processors
    ndk {
        abiFilters 'armeabi-v7a', 'arm64-v8a'
    }
}
```