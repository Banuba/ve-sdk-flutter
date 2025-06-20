# Banuba Video Editor Flutter plugin

## Overview
[Banuba Video Editor SDK](https://www.banuba.com/video-editor-sdk) allows you to quickly add short video functionality and possibly AR filters and effects into your mobile app.

## Usage
### License
Before you commit to a license, you are free to test all the features of the SDK for free.  
The trial period lasts 14 days. To start it, [send us a message](https://www.banuba.com/video-editor-sdk#form).  
We will get back to you with the trial token.

Feel free to [contact us](https://www.banuba.com/faq/kb-tickets/new) if you have any questions.

## Installation

Run in Terminal to install Video Editor Flutter plugin
```
$ flutter pub add ve_sdk_flutter
```
or specify the package in your ```pubspec.yaml``` file
```
dependencies:
    ve_sdk_flutter: ^0.20.0
```

## Integration guide
Please follow our [Integration Guide](mddocs/integration_guide.md) to complete full integration.

## Launch
Set Banuba license token [within the app](example/lib/main.dart#L9)

### Android
Run ```flutter run``` in terminal to launch the app on a device or use IDE i.e. Intellij, VC, etc. to launch the app.

### iOS
1. Install CocoaPods dependencies. Open **ios** directory and run ```pod install``` in terminal.
2. Open **Signing & Capabilities** tab in Target settings and select your Development Team.
3. Run ```flutter run``` in terminal to launch the app on a device or launch the app in IDE i.e. XCode, Intellij, VC, etc.

## Dependencies
|       | Version | 
| --------- |:-------:| 
| Dart      |  3.3.0  | 
| Flutter   | 3.19.2  |
| Android      |  8.0+   |
| iOS          |  15.0+  |