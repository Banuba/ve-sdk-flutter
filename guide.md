# Integration Guide

## Add dependency

Run this command via terminal in the root of your project:
```
$ flutter pub add ve_sdk_flutter
```
This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):
```
dependencies:
ve_sdk_flutter: ^0.0.3
```
Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

## Add AR effects
[Banuba Face AR SDK](https://www.banuba.com/facear-sdk/face-filters) product is used on camera and editor screens for applying various AR effects while making video content.

:exclamation: IMPORTANT  
Add beautification effect to your project. 

1. Android - copy [Beauty](example/android/app/src/main/assets/bnb-resources/effects/Beauty) effect from example project and paste it to ```assets/bnb-resources/effects``` in your project.
1. iOS - add the effect to resource folder ```bundleEffects```. You can drag and drop the [BeautyEffects](example/ios/bundleEffects/BeautyEffects) from [bundleEffects](example/ios/bundleEffects) folder from example project to your project's sidebar in Xcode. Make sure to select the "Copy items if needed" and "Create folder references" checkboxes. When done correctly, the ```bundleEffects``` folder's icon will be blue and the folder itself will be present in Copy bundle resources build phase.

## Add Color filters
Color filter previews are images(```.png``` files) used to represent texture.

:exclamation: IMPORTANT  
Previews files are not part of plugin by default since these resources add extra MBs to your app.

### Android

Add the following code to your [project gradle](example/android/build.gradle): 
```
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

Update your [settings.gradle](example/android/settings.gradle) according changes that you made in the [project gradle](example/android/build.gradle)

Preview files are in [drawable-xhdpi](example/android/app/src/main/res/drawable-xhdpi),
[drawable-xxhdpi](example/android/app/src/main/res/drawable-xxhdpi), [drawable-xxxhdpi](example/android/app/src/main/res/drawable-xxxhdpi) folders.  
Keep in mind that ```drawable-xxxhdpi``` contains files with the highest resolution. Additionally, you can copy paste just one set of previews if it meets your requirements.

### iOS

Add the following code at the top of your [Podfile](example/ios/Podfile)

```
platform :ios, '15.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Banuba/specs.git'
source 'https://github.com/sdk-banuba/banuba-sdk-podspecs.git'
```

Copy the ```ColorEffectsPreview``` folder from [example's asset catalog](example/ios/Runner/Assets.xcassets) to your app's asset catalog.

Add the following keys to your [Info.plist](example/ios/Runner/Info.plist)
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